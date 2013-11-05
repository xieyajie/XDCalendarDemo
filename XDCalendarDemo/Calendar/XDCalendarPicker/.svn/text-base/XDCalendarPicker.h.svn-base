//
//  XDCalendarPicker.h
//  XDCalendarDome
//
//  Created by xieyajie on 13-7-15.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XDRefreshTableView.h"

typedef enum
{
    XDCalendarStyleOneWeek = 0,
    XDCalendarStyleDays
}XDCalendarStyle;

@protocol XDCalendarPickerDelegate;

@class XDCalendarPickerController;
@interface XDCalendarPicker : UIView
{
    XDCalendarPickerController *_controller;
    XDCalendarStyle _style;
    
    UIView *_weekSignView;
    UILabel *_ymLable; //滚动时显示年月的标签
    
    NSArray *_chineseMonths;
    NSArray *_weekSigns;
    
    UISwipeGestureRecognizer *_leftRecognizer;
    UISwipeGestureRecognizer *_rightRecognizer;
    UISwipeGestureRecognizer *_downRecognizer;
}

@property (nonatomic, unsafe_unretained) id<UITableViewDataSource, UITableViewDelegate, XDRefreshTableViewDelegate> delegate;
@property (nonatomic, unsafe_unretained) id<XDCalendarPickerDelegate> pickerDelegate;
@property (nonatomic, strong) XDRefreshTableView *tableView;
//@property (nonatomic, strong) UILabel *ymLable;
@property (nonatomic, unsafe_unretained, setter = setStyle:) XDCalendarStyle style;

#pragma mark - 外部 调用
- (id)initWithMaxFrame:(CGRect)frame calendarStyle:(XDCalendarStyle)style;
//返回当前选中的时间
- (NSDate *)selectedDate;
//设置当前选中的时间
- (void)setSelectedDate:(NSDate *)date;
//刷新当前显示区域
- (void)reloadVisibleCells;
//滚动到某个时间
- (void)scrollToDate:(NSDate *)date;
//设置不同类型的时间点的颜色
//- (void)dotsColorForType:(NSInteger)type;
//刷新事件点
- (void)refreshDots;

//清楚kvo
- (void)clearObserver;

#pragma mark - pickerController 调用
//设置划动状态下显示的提示标签的内容
- (void)setTagLabelTextWithDate:(NSDate *)date;
//显示划动状态下显示的提示标签
- (void)showTagLabel;
//隐藏划动状态下显示的提示标签
- (void)hideTagLabel;
//正在划动时切换到其他页面，calendar停止划动
- (void)stopScrolling;

@end

#pragma mark - XDCalendarPickerControllerDelegate

@protocol XDCalendarPickerControllerDelegate <NSObject>

@required

- (void)tableView:(UITableView *)tableView scrollToDate:(NSDate *)date;

- (void)tableViewReloadVisibleCells:(UITableView *)tableView;

@end


#pragma mark - XDCalendarPickerDelegate

@protocol XDCalendarPickerDelegate <NSObject>

@required

- (void)calendarPickerChangeToDaysStyle:(XDCalendarPicker *)calendarPicker;

- (void)calendarPicker:(XDCalendarPicker *)calendarPicker selectedDate:(NSDate *)date;


@end
