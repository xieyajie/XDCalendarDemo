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
#import "XDWeekCell.h"

#define kSignViewHeight 25
#define kCalendarPickerOneWeekHeight 69
#define kCalendarPickerDaysMaxHeight 245
#define kCalendarDayBlockWidth 46
#define kCalendarDayBlockHeight 44

CGFloat g_pickerDayWidth_ = kCalendarDayBlockWidth;

@interface XDCalendarPickerDemo ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIView *shadowView;//背景阴影层
@property (strong, nonatomic) UIView *weekSignView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *ymLable; //滚动时显示年月的标签

@end

@implementation XDCalendarPickerDemo

- (id)initWithPoint:(CGPoint)point calendarStyle:(XDCalendarStyle)style selectedDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        // Initialization code
        _style = style;
        
        if (date == nil) {
            date = [NSDate date];
        }
        _selectedDate = date;
        _highlightDate = date;
        
        CGFloat height = 0;
        if (_style == XDCalendarStyleOneWeek) {
            height = kCalendarPickerOneWeekHeight;
        }
        else{
            height = kCalendarPickerDaysMaxHeight;
        }
        self.view.frame = CGRectMake(point.x, point.y, 320, height);
        
        _chineseMonths = [[NSArray alloc] initWithObjects: @"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月", nil];
        _weekSigns = [[NSArray alloc] initWithObjects: @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日", nil];
        
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
//            _tableView.frame = CGRectMake(0, kSignViewHeight, self.frame.size.width, self.frame.size.height - kSignViewHeight);
        } completion:^(BOOL finish){
            if (_style == XDCalendarStyleOneWeek) {
//                [self scrollToDate:_controller.selectedDate];//滚动到选中项所在的行
            }
        }];
    }
}

- (void)setShowBackgroundShadow:(BOOL)showBackgroundShadow
{
    
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

- (UITableView *)tableView
{
    if (_tableView == nil) {
//        _tableView = [[XDRefreshTableView alloc] initWithFrame:CGRectMake(0, kSignViewHeight, 320, kCalendarDayBlockHeight) style:UITableViewStylePlain pullDelegate: _controller];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.weekSignView.frame.origin.y + self.weekSignView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (self.weekSignView.frame.origin.y + self.weekSignView.frame.size.height)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kCalendarDayBlockHeight;
        _tableView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1.0];
//        _tableView.backgroundColor = [UIColor lightGrayColor];
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
    cell.editing = tableView.editing;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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


@end
