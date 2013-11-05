//
//  XDCalendarPickerController.m
//  XDCalendarDome
//
//  Created by xieyajie on 13-7-15.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import "XDCalendarPickerController.h"
#import "XDCalendarPicker.h"
#import "XDWeekCell.h"
#import "XDDay.h"

#import "NSDate+Convenience.h"

#import "XDCalendarDefine.h"

static XDCalendarPickerController *cpController = nil;

@interface XDCalendarPickerController ()<XDCalendarPickerControllerDelegate>
{
    NSInteger _highlightRow;
    
    NSMutableDictionary *_ownerCalendarDots;
    NSMutableDictionary *_friendCalendarDots;
    
    BOOL _isOwnerDots;
    
    BOOL _needSelectedDay;
    NSIndexPath *_scrollToIndex;
    CGPoint _previousOffSet; //tableView上一次开始滑动的偏移量，用以判断是上划还是下划
}

@property (nonatomic, strong) XDCalendarPicker *calendarView;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) NSDate *mondayForOneWeekStyle;

@property (strong) NSMutableDictionary *ownerCalendarDots;
@property (strong) NSMutableDictionary *friendCalendarDots;

@end

@implementation XDCalendarPickerController

@synthesize calendarView = _calendarView;

@synthesize startDate = _startDate;
@synthesize endDate = _endDate;

@synthesize selectedDate = _selectedDate;
@synthesize highlightDate = _highlightDate;
@synthesize highlightDay = _highlightDay;

@synthesize mondayForOneWeekStyle = _mondayForOneWeekStyle;

@synthesize dotsDictionary = _dotsDictionary;
@synthesize dotColor = _dotColor;
@synthesize ownerCalendarDots = _ownerCalendarDots;
@synthesize friendCalendarDots = _friendCalendarDots;

- (id)initWithView:(XDCalendarPicker *)aView
{
    cpController = [super init];
    if (self) {
        // Custom initialization
        
        NSDate *today = [NSDate date];
        self.highlightDate = today;
        [self calculateStartDate:today];
        [self calculateEndDate:today];
        _needSelectedDay = NO;
        
        self.calendarView = aView;
        self.calendarView.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedFromBlock:) name:kNotificationDateSelectedFromBlock object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedFromExterior:) name:kNotificationDateSelectedFromExterior object:nil];
        
        _dotColor = [UIColor blackColor];
        _ownerCalendarDots = [[NSMutableDictionary alloc] init];
        _friendCalendarDots = [[NSMutableDictionary alloc] init];
        [self requestCalendarDots];
    }
    return cpController;
}

+ (id)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (cpController == nil) {
            cpController = [[XDCalendarPickerController alloc] init];
        }
    });
    
    return cpController;
}

//- (void)setSelectedDate:(NSDate *)selectedDate
//{
//    _selectedDate = [selectedDate retain];
//}

- (NSDate *)mondayForOneWeekStyle
{
    if (_mondayForOneWeekStyle == nil) {
        _mondayForOneWeekStyle = [self mondayFromDate:_highlightDate];
    }
    
    return _mondayForOneWeekStyle;
}


#pragma mark - TableView Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSTimeInterval interval = [self.endDate timeIntervalSinceDate: self.startDate];
    long dayCount = interval / 86400;
    if(fmod(interval, 7) != 0)
    {
        return (dayCount / 7) + 1;
    }
    else{
        return dayCount / 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CalendarPickerCell";
    XDWeekCell *cell = (XDWeekCell *)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[XDWeekCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int row = indexPath.row;
    cell.tag = row;
    [cell setMondayDate:[self.startDate offsetDay:(7 * row)]];
    cell.editing = tableView.editing;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView.editing) {
        NSArray *cellArray = [tableView visibleCells];
        if (cellArray.count != 0) {
            XDWeekCell *tmpCell = [cellArray objectAtIndex:(cellArray.count / 2)];
            if (tmpCell != nil) {
                [self.calendarView setTagLabelTextWithDate:tmpCell.mondayDate];
            }
        }
    }
    
    if (_needSelectedDay && [indexPath section] == [_scrollToIndex section] && [indexPath row] == [_scrollToIndex row]) {
        XDDay *day = [cell dayBlockForDate:self.highlightDate];
        if (day) {
            day.selected = YES;
            self.highlightDay = day;
        }
        
        _needSelectedDay = NO;
        _scrollToIndex = nil;
    }
    
    return cell;
}

#pragma mark - scroll delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.contentSize.height < scrollView.frame.size.height ? scrollView.frame.size.height : scrollView.contentSize.height;
    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= height - scrollView.frame.size.height) {
        self.calendarView.tableView.editing = YES;
        NSArray *visibles = [self.calendarView.tableView visibleCells];
        for (UITableViewCell *cell in visibles) {
            cell.editing = YES;
        }
        
        [self.calendarView showTagLabel];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.calendarView.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    CGFloat height = scrollView.contentSize.height < scrollView.frame.size.height ? scrollView.frame.size.height : scrollView.contentSize.height;
//    BOOL refrsh = NO;
//    if (scrollView.contentOffset.y < 0 || scrollView.contentOffset.y + scrollView.frame.size.height > height) {
//        refrsh = YES;
//    }
    if (!decelerate) {
        [self stopScrollingAtOffset:scrollView.contentOffset];
    }
    
    [self.calendarView.tableView tableViewDidEndDragging:scrollView];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!scrollView.decelerating && !scrollView.dragging) {
        [self stopScrollingAtOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self.calendarView hideTagLabel];
}

#pragma mark - XDCalendarPickerControllerDelegate

- (void)tableView:(UITableView *)tableView scrollToDate:(NSDate *)date
{
    NSDate *scrollDate = [date convertToZeroInMorning];
    if ([scrollDate compare:self.highlightDate] != NSOrderedSame) {
        self.highlightDay.selected = NO;
        self.highlightDate = scrollDate;
    }
    
    BOOL isCanScroll = tableView.scrollEnabled;
    if(!isCanScroll)
    {
        tableView.scrollEnabled = YES;
    }
    
    [self judgmentDate:scrollDate inTimeRangeOfTableView:tableView];
    int toRow = [scrollDate weekFromDate:self.startDate] - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:toRow inSection:0];
    
    if ([self judgmentVisibledAtIndexPath:indexPath inTableView:tableView]) {
        XDWeekCell *cell = (XDWeekCell *)[tableView cellForRowAtIndexPath:indexPath];
        XDDay *day = [cell dayBlockForDate:self.highlightDate];
        if (day) {
            day.selected = YES;
            self.highlightDay = day;
        }
        
        _needSelectedDay = NO;
        _scrollToIndex = nil;
    }
    else{
        _needSelectedDay = YES;
        _scrollToIndex = indexPath;
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    tableView.scrollEnabled = isCanScroll;
}

- (void)tableViewReloadVisibleCells:(UITableView *)tableView
{
    NSArray *cells = [tableView visibleCells];
    for (XDWeekCell *cell in cells) {
        NSArray *array = [cell daysArray];
        for (XDDay *day in array) {
            [day setDot];
        }
    }
}

#pragma mark - Refresh Delegate
//下拉加载上一天
- (void)pullingTableViewDidStartRefreshing:(XDRefreshTableView *)tableView
{
//    [MBProgressHUD showHUDAddedTo:self.calendarView animated:YES];
    [self performSelector:@selector(loadPrevYearData) withObject:nil afterDelay:1.0f];
}

//上拉加载
- (void)pullingTableViewDidStartLoading:(XDRefreshTableView *)tableView
{
//    [MBProgressHUD showHUDAddedTo:self.calendarView animated:YES];
    [self performSelector:@selector(loadNextYearData) withObject:nil afterDelay:1.0f];
}


#pragma mark - 通知

- (void)selectedFromBlock:(NSNotification *)notification
{
    id object = [notification object];
    
    //XDDay 触发UIControlStateSelected
    if ([object isKindOfClass:[XDDay class]]) {
        XDDay *selectedDay = (XDDay *)object;
        if (selectedDay) {
            [self changeHighlightDayTo:selectedDay isSelected:YES];
        }
        return;
    }
}

- (void)selectedFromExterior:(NSNotification *)notification
{
    id object = [notification object];
    
    //首页列表上拉加载上一天
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDate *selectedDate = [[object objectForKey:@"date"] convertToZeroInMorning];
        UITableView *tableView = [object objectForKey:@"tableView"];
        
        if ([selectedDate compare:self.selectedDate] != NSOrderedSame) {
            self.selectedDate = selectedDate;
        }
        
        if ([selectedDate compare:self.highlightDate] != NSOrderedSame) {
            self.highlightDay.selected = NO;
            self.highlightDate = selectedDate;
        }
        
        BOOL isCanScroll = tableView.scrollEnabled;
        if(!isCanScroll)
        {
            tableView.scrollEnabled = YES;
        }
        [self judgmentDate:selectedDate inTimeRangeOfTableView:tableView];
        int toRow = [selectedDate weekFromDate:self.startDate] - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:toRow inSection:0];
        if ([self judgmentVisibledAtIndexPath:indexPath inTableView:tableView]) {
            XDWeekCell *cell = (XDWeekCell *)[tableView cellForRowAtIndexPath:indexPath];
            XDDay *day = [cell dayBlockForDate:self.highlightDate];
            if (day) {
                day.selected = YES;
                self.highlightDay = day;
            }
            
            _needSelectedDay = NO;
            _scrollToIndex = nil;
        }
        else{
            _needSelectedDay = YES;
            _scrollToIndex = indexPath;
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        tableView.scrollEnabled = isCanScroll;
    }
}

#pragma mark - private

//判断时间是否在当前时间范围内
- (void)judgmentDate:(NSDate *)date inTimeRangeOfTableView:(UITableView *)tableView
{
    if ([date compare:self.startDate] == NSOrderedAscending) {
        [self calculateStartDate:date];
    }
    else if ([date compare:self.endDate] == NSOrderedDescending)
    {
        [self calculateEndDate:date];
    }
    
    [tableView reloadData];
}

//判断要滚动到的行是否已在tableView上
- (BOOL)judgmentVisibledAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
    NSArray *indexPaths = [tableView indexPathsForVisibleRows];
    for (NSIndexPath *path in indexPaths) {
        if ([path section] == [indexPath section] && [path row] == [indexPath row]) {
            return YES;
        }
    }
    
    return NO;
}

//
- (void)changeHighlightDayTo:(XDDay *)aDay isSelected:(BOOL)isSelected
{
    if (isSelected) {
        self.selectedDate = aDay.blockDate;//KVO通知calendarPicker
    }
    self.highlightDate = aDay.blockDate;
    self.highlightDay.selected = NO;
    self.highlightDay = aDay;
}

//获取有事件的日期
- (void)requestCalendarDots
{
    [self requestOwnerCalendarDots];
    [self requestFriendCalendarDots];
}

- (void)requestOwnerCalendarDots
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimeInterval startInterval = [self.startDate timeIntervalSince1970] * 1000;
        NSTimeInterval endInterval = [self.endDate timeIntervalSince1970] * 1000;
        
//        NSString *path = [NSString stringWithFormat:@"%@accountId=%@&minTime=%.0f&maxTime=%.0f", kSelfEventCountAddress, LOGIN_ACCOUNT_ID, startInterval, endInterval];
//        [[XDDataCenter sharedCenter] getEventCountByPath:path onComplete:^(NSDictionary *result){
//            if (result != nil) {
//                NSArray *array = [result objectForKey:kCalendarData];
//                if (array != nil) {
//                    [self.ownerCalendarDots removeAllObjects];
//                    for (NSDictionary *dic in array)
//                    {
//                        [self.ownerCalendarDots setObject:[dic objectForKey:kCalendarEventCount] forKey:[dic objectForKey:kCalendarEventDate]];
//                    }
//                    
//                    if (_isOwnerDots) {
//                        self.dotsDictionary = self.ownerCalendarDots;
//                    }
//                }
//            }
//        }onError:^(NSError *error){
//        }];
    });
}

- (void)requestFriendCalendarDots
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimeInterval startInterval = [self.startDate timeIntervalSince1970] * 1000;
        NSTimeInterval endInterval = [self.endDate timeIntervalSince1970] * 1000;
        
//        NSString *path = [NSString stringWithFormat:@"%@accountId=%@&minTime=%.0f&maxTime=%.0f", kFriendEventCountAddress, LOGIN_ACCOUNT_ID, startInterval, endInterval];
//        [[XDDataCenter sharedCenter] getEventCountByPath:path onComplete:^(NSDictionary *result){
//            if (result != nil) {
//                NSArray *array = [result objectForKey:kCalendarData];
//                if (array != nil) {
//                    [self.friendCalendarDots removeAllObjects];
//                    for (NSDictionary *dic in array)
//                    {
//                        [self.friendCalendarDots setObject:[dic objectForKey:kCalendarEventCount] forKey:[dic objectForKey:kCalendarEventDate]];
//                    }
//                    
//                    if (!_isOwnerDots) {
//                        self.dotsDictionary = self.friendCalendarDots;
//                    }
//                }
//            }
//        }onError:^(NSError *error){
//        }];
    });
}

#pragma mark - date

- (NSDate *)mondayFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekComps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:date];
    NSInteger weekday = [weekComps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    weekday -= 1;
    weekday =  weekday == 0 ? 7 : weekday;
    return [date offsetDay:(1 - weekday)];
}

#pragma mark - public

- (void)calculateStartDate:(NSDate *)date
{
    @synchronized(self.startDate){
        int month = [date month];
        
        NSDate *tmpDate = [[[date offsetMonth:(1 - month)] firstDayOfMonth] convertToZeroInMorning];
        int dayWeek = [tmpDate firstWeekDayInMonth];
        if (dayWeek > 1) {
            self.startDate = [tmpDate offsetDay:-(dayWeek - 1)];
        }
        else{
            self.startDate = tmpDate;
        }
    };
}

- (void)calculateEndDate:(NSDate *)date
{
    @synchronized(self.endDate){
        int month = [date month];
        self.endDate = [[[[date offsetMonth:(13 - month)] firstDayOfMonth] offsetDay:-1] convertToZeroInMorning];
    };
}

- (void)stopScrollingAtOffset:(CGPoint)offset
{
    CGFloat tmp = fmod(offset.y, kCalendarDayBlockHeight);
    CGFloat offsetY = offset.y;
    
    if (_previousOffSet.y < offsetY) {
        NSLog(@"上划");
        if (tmp != 0) {
            offsetY = offsetY - tmp + kCalendarDayBlockHeight;
        }
        [self.calendarView.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    }
    
    else{
        NSLog(@"下划");
        if (tmp != 0) {
            offsetY = offsetY + tmp - kCalendarDayBlockHeight;
        }
        [self.calendarView.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    }
    
    self.calendarView.tableView.editing = NO;
    NSArray *visibles = [self.calendarView.tableView visibleCells];
    for (UITableViewCell *cell in visibles) {
        cell.editing = NO;
    }
    
    [self.calendarView hideTagLabel];
}

#pragma mark - private

- (void)loadPrevYearData
{
    [self.calendarView.tableView tableViewDidFinishedRefreshWithCompletion:^(BOOL finish){
        [self calculateStartDate:[self.startDate offsetDay:-1]];
        [self.calendarView.tableView reloadData];
//        [MBProgressHUD hideAllHUDsForView:self.calendarView animated:YES];
        
        [self requestCalendarDots];
    }];
}

- (void)loadNextYearData
{
    [self.calendarView.tableView tableViewDidFinishedLoadingWithCompletion:^(BOOL finish){
        [self calculateEndDate:[self.endDate offsetDay:1]];
        [self.calendarView.tableView reloadData];
//        [MBProgressHUD hideAllHUDsForView:self.calendarView animated:YES];
        
        [self requestCalendarDots];
    }];
}

#pragma mark - 只显示一周的状态下，左右滑动相关操作

- (void)clear
{
    _mondayForOneWeekStyle = nil;
}

- (void)tableView:(UITableView *)tableView scrollToNextIndexPath:(NSIndexPath *)indexPath
{
    CGRect rect = tableView.frame;
    
    if (indexPath.row != [tableView numberOfRowsInSection:0]) {
//        XDWeekCell *cell = (XDWeekCell *)[tableView cellForRowAtIndexPath:indexPath];
//        UIImageView *currentWeekImgView = [[UIImageView alloc] initWithImage: [XDManagerTool imageFromView:cell.contentView]];
//        currentWeekImgView.frame = CGRectMake(0, rect.origin.y, 320, rect.size.height);
//        [self.calendarView addSubview: currentWeekImgView];
//        
//        tableView.frame = CGRectMake(323, rect.origin.y, 320, rect.size.height);
//        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//        
//        [UIView animateWithDuration: .65
//                         animations:^{
//                             currentWeekImgView.frame = CGRectMake(-320, rect.origin.y, 320, rect.size.height);
//                             tableView.frame = CGRectMake(0, rect.origin.y, 320, rect.size.height);
//                         }
//                         completion:^(BOOL finished){
//                             [currentWeekImgView removeFromSuperview];
//                         }
//         ];
    }

}

- (void)tableView:(UITableView *)tableView ScrollToPervIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    
//    CGRect rect = tableView.frame;
//    XDWeekCell *cell = (XDWeekCell *)[tableView cellForRowAtIndexPath:indexPath];
//    UIImageView *currentWeekImgView = [[UIImageView alloc] initWithImage: [XDManagerTool imageFromView:cell.contentView]];
//    currentWeekImgView.frame = CGRectMake(0, rect.origin.y, 320, rect.size.height);
//    [self.calendarView addSubview: currentWeekImgView];
//    
//    tableView.frame = CGRectMake(-320, rect.origin.y, 320, rect.size.height);
//    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    
//    [UIView animateWithDuration: .65
//                     animations:^{
//                         currentWeekImgView.frame = CGRectMake(323, rect.origin.y, 320, rect.size.height);
//                         tableView.frame = CGRectMake(0, rect.origin.y, 320, rect.size.height);
//                     }
//                     completion:^(BOOL finished){
//                         [currentWeekImgView removeFromSuperview];
//                     }
//     ];

}

//- (void)changeDotsDataToOwner:(BOOL)isOwner
//{
//    _isOwnerDots = isOwner;
//    if (isOwner) {
//        self.dotsDictionary = self.ownerCalendarDots;
//    }
//    else{
//        self.dotsDictionary = self.friendCalendarDots;
//    }
//}

- (BOOL)isHaveOwnerEventWithKey:(NSString *)aKey
{
    if (!aKey) {
        return NO;
    }
    
    if ([self.ownerCalendarDots objectForKey:aKey]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isHaveFriendEventWithKey:(NSString *)aKey
{
    if (!aKey) {
        return NO;
    }
    
    if ([self.friendCalendarDots objectForKey:aKey]) {
        return YES;
    }
    
    return NO;
}

@end
