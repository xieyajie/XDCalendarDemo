//
//  XDCalendarPickerDemo.m
//  XDCalendarDemo
//
//  Created by xieyajie on 13-11-5.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDCalendarPickerDemo.h"

#import "NSDate+Convenience.h"
#import "XDCalendarCenter.h"
#import "XDCalendarDefine.h"

#import "XDDay.h"
#import "XDWeekCell.h"
#import "XDRefreshTableView.h"

#define kSignViewHeight 25
#define kCalendarPickerOneWeekHeight 69
#define kCalendarPickerDaysMaxHeight 245
#define kCalendarDayBlockWidth 46
#define kCalendarDayBlockHeight 44

CGFloat g_pickerDayWidth_ = kCalendarDayBlockWidth;

@interface XDCalendarPickerDemo ()<UITableViewDataSource, UITableViewDelegate, XDRefreshTableViewDelegate>
{
    CGPoint _previousOffSet; //tableView上一次开始滑动的偏移量，用以判断是上划还是下划
    
    XDCalendarCenter *_calendarCenter;
}

@property (strong, nonatomic) UIView *shadowView;//背景阴影层
@property (strong, nonatomic) UIView *weekSignView;
@property (strong, nonatomic) XDRefreshTableView *tableView;
@property (strong, nonatomic) UILabel *ymLable; //滚动时显示年月的标签

@property (strong, nonatomic) XDDay *activityDay;//处于选中状态的日期button

@end

@implementation XDCalendarPickerDemo

- (id)initWithPoint:(CGPoint)point calendarStyle:(XDCalendarStyle)style selectedDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        // Initialization code
        _style = -1;
        _isScrolling = NO;
        
        if (date == nil) {
            date = [NSDate date];
        }
        self.selectedDate = date;
        
        self.view.frame = CGRectMake(point.x, point.y, 320, kCalendarPickerOneWeekHeight);
        
        _chineseMonths = [[NSArray alloc] initWithObjects: @"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月", nil];
        _weekSigns = [[NSArray alloc] initWithObjects: @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日", nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedFromBlock:) name:kNotificationDateSelectedFromBlock object:nil];
        
        [self setStyle:style];
        [self configationDate];
        [self configurationViews];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - notification

//XDDay 触发UIControlStateSelected
- (void)selectedFromBlock:(NSNotification *)notification
{
    id object = [notification object];
    
    if ([object isKindOfClass:[XDDay class]])
    {
        XDDay *selectedDay = (XDDay *)object;
        self.selectedDate = selectedDay.blockDate;
        self.activityDay = selectedDay;
    }
}

#pragma mark - setting

- (void)setStyle:(XDCalendarStyle)style
{
    if (_style != style) {
        _style = style;
        CGFloat height;
        switch (_style) {
            case XDCalendarStyleDays:
            {
                height = kCalendarPickerDaysMaxHeight;
            }
                break;
            case XDCalendarStyleOneWeek:
            {
                height = kCalendarPickerOneWeekHeight;
            }
                break;
                
            default:
                break;
        }
        
        [UIView animateWithDuration:.1f animations:^{
            CGRect rect = self.view.frame;
            self.view.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
            self.tableView.frame = CGRectMake(0, kSignViewHeight, self.view.frame.size.width, self.view.frame.size.height - kSignViewHeight);
        } completion:^(BOOL finish){
            [self activityDate:_selectedDate withRequest:YES];//滚动到选中项所在的行
        }];
    }
}

- (void)setShowBackgroundShadow:(BOOL)showBackgroundShadow
{
    
}

- (void)setActivityDay:(XDDay *)day
{
    if (_activityDay != day) {
        if (_activityDay != nil) {
            _activityDay.selected = NO;
        }
        
        _activityDay = day;
    }
}

- (void)setSelectedDate:(NSDate *)date
{
    if (![_selectedDate isEqualToDate:[date convertToZeroInMorning]]) {
        _selectedDate = date;
        
        if (_delegate && [_delegate respondsToSelector:@selector(calendarPicker:selectedDate:)]) {
            [_delegate calendarPicker:self selectedDate:_activityDay.blockDate];
        }
    }
}

#pragma mark - getting

- (UIView *)shadowView
{
    if (_shadowView == nil) {
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    }
    
    return _shadowView;
}

- (UIView *)weekSignView
{
    if (_weekSignView == nil) {
        _weekSignView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kSignViewHeight)];
        _weekSignView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"calendar_signBg.png"]];
        
        CGFloat width = _weekSignView.frame.size.width / 7;
        for (int i = 0; i < _weekSigns.count; i++)
        {
            NSString *daySymbol = (NSString *)[_weekSigns objectAtIndex: i];
            UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(width * i, 0, width, kSignViewHeight)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize: 12.0];;
            label.text = daySymbol;
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [_weekSignView addSubview: label];
        }
    }
    
    return _weekSignView;
}

- (XDRefreshTableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[XDRefreshTableView alloc] initWithFrame:CGRectMake(0, kSignViewHeight, 320, kCalendarDayBlockHeight) style:UITableViewStylePlain pullDelegate: self];
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kCalendarDayBlockHeight;
        _tableView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
    }
    
    return _tableView;
}

- (UILabel *)ymLable
{
    if (_ymLable == nil) {
        _ymLable = [[UILabel alloc] init];
        _ymLable.backgroundColor = [UIColor colorWithRed:135/ 255.0 green:206 / 255.0 blue:250 / 255.0 alpha:1.0];
        _ymLable.font = [UIFont boldSystemFontOfSize:13.0];
        _ymLable.numberOfLines = 0;
        _ymLable.textAlignment = NSTextAlignmentCenter;
        _ymLable.layer.masksToBounds = YES;
        _ymLable.layer.cornerRadius = 4.0;
        _ymLable.alpha = 0.6;
        
        _ymLable.hidden = YES;
    }
    
    return _ymLable;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSTimeInterval interval = [_endShowDate timeIntervalSinceDate: _startShowDate];
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
    XDWeekCell *cell = (XDWeekCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[XDWeekCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    int row = indexPath.row;
    cell.tag = row;
    [cell setMondayDate:[_startShowDate offsetDay:(7 * row)]];
    cell.scrolling = _isScrolling;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_isScrolling) {
        NSArray *cellArray = [tableView visibleCells];
        if (cellArray.count != 0) {
            XDWeekCell *tmpCell = [cellArray objectAtIndex:(cellArray.count / 2)];
            if (tmpCell != nil) {
                [self setTagLabelTextWithDate:tmpCell.mondayDate];
            }
        }
    }
    
    return cell;
}

#pragma mark - scroll delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.contentSize.height < scrollView.frame.size.height ? scrollView.frame.size.height : scrollView.contentSize.height;
    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= height - scrollView.frame.size.height) {
        _isScrolling = YES;
        NSArray *visibles = [self.tableView visibleCells];
        for (XDWeekCell *cell in visibles) {
            cell.scrolling = YES;
        }
        
        [self showTagLabel];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stopScrollingAtOffset:scrollView.contentOffset];
    }
    
    [self.tableView tableViewDidEndDragging:scrollView];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!scrollView.decelerating && !scrollView.dragging) {
        [self stopScrollingAtOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self hideTagLabel];
}

#pragma mark - Refresh Delegate
//下拉加载上一年
- (void)pullingTableViewDidStartRefreshing:(XDRefreshTableView *)tableView
{
    [self performSelector:@selector(loadPrevYear) withObject:nil afterDelay:0.5f];
}

//上拉加载下一年
- (void)pullingTableViewDidStartLoading:(XDRefreshTableView *)tableView
{
    [self performSelector:@selector(loadNextYear) withObject:nil afterDelay:0.5f];
}

#pragma mark - layout subviews

- (void)configurationViews
{
    self.view.clipsToBounds = YES;
    self.view.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.view.layer.shadowOpacity = 1.0;
    self.view.layer.shadowRadius = 5.0;
    self.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.view.layer.masksToBounds = NO;
    self.view.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
    
    [self.view addSubview:self.weekSignView];
    [self.view addSubview:self.tableView];
}

- (void)showTagLabel
{
    self.ymLable.frame = CGRectMake((320 - 50) / 2, self.tableView.frame.origin.y + (self.tableView.frame.size.height - 50) / 2, 50, 50);
    [self.view addSubview:self.ymLable];
    self.ymLable.hidden = NO;
}

- (void)hideTagLabel
{
    self.ymLable.hidden = YES;
    [self.ymLable removeFromSuperview];
}

#pragma mark - self data

- (void)configationDate
{
    [self calculateStartDate:_selectedDate];
    [self calculateEndDate:_selectedDate];
}

- (void)calculateStartDate:(NSDate *)date
{
    @synchronized(_startShowDate){
        int month = [date month];
        
        NSDate *tmpDate = [[[date offsetMonth:(1 - month)] firstDayOfMonth] convertToZeroInMorning];
        int dayWeek = [tmpDate firstWeekDayInMonth];
        if (dayWeek > 1) {
            _startShowDate = [tmpDate offsetDay:-(dayWeek - 1)];
        }
        else{
            _startShowDate = tmpDate;
        }
    };
}

- (void)calculateEndDate:(NSDate *)date
{
    @synchronized(_endShowDate){
        int month = [date month];
        _endShowDate = [[[[date offsetMonth:(13 - month)] firstDayOfMonth] offsetDay:-1] convertToZeroInMorning];
    };
}

- (void)loadPrevYear
{
    [self calculateStartDate:[_startShowDate offsetDay:-1]];
    [self.tableView reloadData];
    
    [self.tableView tableViewDidFinishedRefreshWithCompletion:^(BOOL finish){
        
//        [self requestCalendarDots];
    }];
}

- (void)loadNextYear
{
    
}

#pragma mark - tableView 

- (void)stopScrollingAtOffset:(CGPoint)offset
{
    CGFloat tmp = fmod(offset.y, kCalendarDayBlockHeight);
    CGFloat offsetY = offset.y;
    
    if (_previousOffSet.y < offsetY) {
        NSLog(@"上划");
        if (tmp != 0) {
            offsetY = offsetY - tmp + kCalendarDayBlockHeight;
        }
        [self.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    }
    
    else{
        NSLog(@"下划");
        if (tmp != 0) {
            offsetY = offsetY + tmp - kCalendarDayBlockHeight;
        }
        [self.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
    }
    
    _isScrolling = NO;
    NSArray *visibles = [self.tableView visibleCells];
    for (XDWeekCell *cell in visibles) {
        cell.scrolling = NO;
    }
    
    [self hideTagLabel];
}

- (void)setTagLabelTextWithDate:(NSDate *)date
{
    int month = [date month] - 1;
    self.ymLable.text = [NSString stringWithFormat:@"%i\n%@", [date year], [_chineseMonths objectAtIndex:month]];
}

#pragma mark - tools

//判断时间是否在当前时间范围内
- (void)judgmentDate:(NSDate *)date inTimeRangeOfTableView:(UITableView *)tableView
{
    if ([date compare:_startShowDate] == NSOrderedAscending) {
        [self calculateStartDate:date];
    }
    else if ([date compare:_endShowDate] == NSOrderedDescending)
    {
        [self calculateEndDate:date];
    }
    
    [self.tableView reloadData];
}

//判断要滚动到的行是否已在tableView上
- (BOOL)judgmentVisibledAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *path in indexPaths) {
        if ([path section] == [indexPath section] && [path row] == [indexPath row]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - public

- (CGFloat)heightForStyle:(XDCalendarStyle)style
{
    switch (style) {
        case XDCalendarStyleOneWeek:
            return kCalendarPickerOneWeekHeight;
            break;
        case XDCalendarStyleDays:
            return kCalendarPickerDaysMaxHeight;
            break;
            
        default:
            return 0;
            break;
    }
}

- (void)showInView:(UIView *)view
{
//    if (_showBackgroundShadow) {
//        self.shadowView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
//        [view addSubview:self.shadowView];
//    }
    
    [view addSubview:self.view];
}

- (void)removeFromSuperview
{
    [self.view removeFromSuperview];
}

- (void)activityDate:(NSDate *)date withRequest:(BOOL)isRequest
{
    BOOL isCanScroll = self.tableView.scrollEnabled;
    if(!isCanScroll)
    {
        self.tableView.scrollEnabled = YES;
    }
    
    NSDate *activityDate = [date convertToZeroInMorning];
    [self judgmentDate:activityDate inTimeRangeOfTableView:self.tableView];
    int toRow = [activityDate weekFromDate:_startShowDate] - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:toRow inSection:0];
    
    XDWeekCell *cell = (XDWeekCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    XDDay *day = [cell dayBlockForDate:activityDate];
    if (day) {
        self.activityDay = day;
        day.selected = YES;
    }
    
    if (![self judgmentVisibledAtIndexPath:indexPath inTableView:self.tableView]) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    self.tableView.scrollEnabled = isCanScroll;
    
    if (isRequest) {
        self.selectedDate = activityDate;
    }
}


@end
