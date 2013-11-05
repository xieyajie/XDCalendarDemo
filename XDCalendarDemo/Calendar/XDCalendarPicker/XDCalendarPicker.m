//
//  XDCalendarPicker.m
//  XDCalendarDome
//
//  Created by xieyajie on 13-7-15.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDCalendarPicker.h"
#import "XDCalendarPickerController.h"

#import "XDCalendarDefine.h"
#import "NSDate+Convenience.h"
#import "UIColor+Category.h"

CGFloat g_pickerDaysHeight_ = 0.0;

@interface XDCalendarPicker()

@end

@implementation XDCalendarPicker

@synthesize delegate = _delegate;
@synthesize pickerDelegate = _pickerDelegate;

@synthesize tableView = _tableView;
//@synthesize ymLable = ymLable;

- (id)initWithMaxFrame:(CGRect)frame calendarStyle:(XDCalendarStyle)style
{
    if (frame.size.height > kCalendarPickerOneWeekHeight) {
        g_pickerDaysHeight_ = frame.size.height < kCalendarPickerDaysMaxHeight ? frame.size.height : kCalendarPickerDaysMaxHeight;
    }
    else{
        g_pickerDaysHeight_ = kCalendarPickerOneWeekHeight;
    }
    
    CGFloat height;
    if (_style == XDCalendarStyleOneWeek) {
        height = kCalendarPickerOneWeekHeight;
    }
    else{
        height = g_pickerDaysHeight_;
    }
    
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height)];
    if (self) {
        // Initialization code
        _controller = [[XDCalendarPickerController alloc] initWithView:self];
        [_controller addObserver:self forKeyPath:kKVODotsDataChange options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [_controller addObserver:self forKeyPath:kKVOSelectedDateChange options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

        [self configuration];
        [self setStyle:style];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
//    [self scrollToDate:_controller.selectedDate];
    _controller.selectedDate = [[NSDate date] convertToZeroInMorning];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setStyle:(XDCalendarStyle)style
{
    _style = style;
    CGFloat height;
    switch (_style) {
        case XDCalendarStyleDays:
        {
            [self removeGestureRecognizerForDaysStyle];
            height = g_pickerDaysHeight_;
            _tableView.scrollEnabled = YES;
        }
            break;
        case XDCalendarStyleOneWeek:
        {
            [self hideTagLabel];
            [_controller clear];
            height = kCalendarPickerOneWeekHeight;
            _tableView.scrollEnabled = NO;
            [self addGestureRecognizerForOneWeekStyle];
        }
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:.1f animations:^{
        CGRect rect = self.frame;
        self.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
        _tableView.frame = CGRectMake(0, kSignViewHeight, self.frame.size.width, self.frame.size.height - kSignViewHeight);
    } completion:^(BOOL finish){
        if (_style == XDCalendarStyleOneWeek) {
            [self scrollToDate:_controller.selectedDate];//滚动到选中项所在的行
        }
    }];
}

#pragma mark - layout subviews

- (void)configuration
{
    self.clipsToBounds = YES;
    self.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.layer.masksToBounds = NO;
    self.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
    
    _chineseMonths = [[NSArray alloc] initWithObjects: @"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月", nil];
    _weekSigns = [[NSArray alloc] initWithObjects: @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日", nil];
    
    _leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [_leftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    _rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [_rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
    _downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    [_downRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [self configurationSubview];
}

- (void)configurationSubview
{
    [self layoutWeekSignView];
    [self layoutDateTableView];
    
    _ymLable = [[UILabel alloc] init];
    _ymLable.backgroundColor = [UIColor colorWithRed:135/ 255.0 green:206 / 255.0 blue:250 / 255.0 alpha:1.0];
    _ymLable.font = [UIFont boldSystemFontOfSize:13.0];
    _ymLable.numberOfLines = 0;
    _ymLable.textAlignment = KTextAlignmentCenter;
    _ymLable.layer.masksToBounds = YES;
    _ymLable.layer.cornerRadius = 4.0;
    _ymLable.alpha = 0.6;
    _ymLable.hidden = YES;
}

- (void)layoutWeekSignView
{
    _weekSignView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kSignViewHeight)];
    _weekSignView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"calendar_signBg.png"]];
    
    for (int i = 0; i < _weekSigns.count; i++)
    {
        NSString *daySymbol = (NSString *)[_weekSigns objectAtIndex: i];
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(kCalendarDayBlockWidth * i, 0, (kCalendarDayBlockWidth - 1), kSignViewHeight)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize: 12.0];;
        label.text = daySymbol;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = KTextAlignmentCenter;
        [_weekSignView addSubview: label];
    }
    [self addSubview:_weekSignView];
}

- (void)layoutDateTableView
{
    _tableView = [[XDRefreshTableView alloc] initWithFrame:CGRectMake(0, kSignViewHeight, 320, kCalendarDayBlockHeight) style:UITableViewStylePlain pullDelegate: _controller];
    _tableView.delegate = _controller;
    _tableView.dataSource = _controller;
    _tableView.rowHeight = kCalendarDayBlockHeight;
    _tableView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
    [self addSubview:_tableView];
    
    _tableView.showFooterPulling = YES;
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:kKVODotsDataChange])
    {
        [self reloadVisibleCells];
    }
    else if ([keyPath isEqualToString:kKVOSelectedDateChange])
    {
        if (_pickerDelegate && [_pickerDelegate respondsToSelector:@selector(calendarPicker:selectedDate:)]) {
            [_pickerDelegate performSelector:@selector(calendarPicker:selectedDate:) withObject:self withObject:_controller.selectedDate];
        }
    }
}

#pragma mark - GestureRecognizer

- (void)addGestureRecognizerForOneWeekStyle
{
    [self addGestureRecognizer:_leftRecognizer];
    [self addGestureRecognizer:_rightRecognizer];
    [self addGestureRecognizer:_downRecognizer];
}

- (void)removeGestureRecognizerForDaysStyle
{
    [self removeGestureRecognizer:_leftRecognizer];
    [self removeGestureRecognizer:_rightRecognizer];
    [self removeGestureRecognizer:_downRecognizer];
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    NSLog(@"left");
    CGPoint location = [gestureRecognizer locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    
    [_controller tableView:self.tableView scrollToNextIndexPath:indexPath];
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    NSLog(@"right");
    CGPoint location = [gestureRecognizer locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    
    [_controller tableView:self.tableView ScrollToPervIndexPath:indexPath];
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)gestureRecognizer
{
    NSLog(@"down");
    if ([_pickerDelegate respondsToSelector:@selector(calendarPickerChangeToDaysStyle:)]) {
        [_pickerDelegate performSelector:@selector(calendarPickerChangeToDaysStyle:) withObject:self];
    }
}


#pragma mark - public pickerController call

- (void)setTagLabelTextWithDate:(NSDate *)date
{
    int month = [date month] - 1;
    _ymLable.text = [NSString stringWithFormat:@"%i\n%@", [date year], [_chineseMonths objectAtIndex:month]];
}

- (void)showTagLabel
{
    _ymLable.frame = CGRectMake((320 - 50) / 2, self.tableView.frame.origin.y + (self.tableView.frame.size.height - 50) / 2, 50, 50);
    [self addSubview:_ymLable];
    _ymLable.hidden = NO;
}

- (void)hideTagLabel
{
    _ymLable.hidden = YES;
    [_ymLable removeFromSuperview];
}

#pragma mark - public 外部调用

- (NSDate *)selectedDate
{
    return _controller.selectedDate;
}

- (void)setSelectedDate:(NSDate *)date
{
    [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationDateSelectedFromExterior object:@{@"date": date, @"tableView": self.tableView} userInfo:nil];
}

- (void)reloadVisibleCells
{
    if ([_delegate respondsToSelector:@selector(tableViewReloadVisibleCells:)]) {
        [_delegate performSelector:@selector(tableViewReloadVisibleCells:) withObject:self.tableView];
    }
}

- (void)scrollToDate:(NSDate *)date
{
    if([_delegate respondsToSelector:@selector(tableView:scrollToDate:)])
    {
        [_delegate performSelector:@selector(tableView:scrollToDate:) withObject:self.tableView withObject:date];
    }
}

//- (void)dotsColorForType:(NSInteger)type
//{
//    BOOL isOwner = YES;
//    switch (type) {
//        case 0:
//            _controller.dotColor = [UIColor colorWithHexString:@"ff7f7f"];
//            isOwner = YES;
//            break;
//        case 1:
//            _controller.dotColor = [UIColor colorWithHexString:@"60affb"];
//            isOwner = NO;
//            break;
//            
//        default:
//            break;
//    }
//    
//    [_controller changeDotsDataToOwner:isOwner];
//}

- (void)refreshDots
{
    [_controller requestCalendarDots];
}

- (void)clearObserver
{
    [_controller removeObserver:self forKeyPath:kKVODotsDataChange];
    [_controller removeObserver:self forKeyPath:kKVOSelectedDateChange];
    [[NSNotificationCenter defaultCenter] removeObserver:_controller];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//正在划动时切换到其他页面，calendar停止划动
- (void)stopScrolling
{
    if (self.tableView.editing == YES) {
        [_controller stopScrollingAtOffset:self.tableView.contentOffset];
    }
}


@end
