//
//  XDCalendarPickerDemo.h
//  XDCalendarDemo
//
//  Created by xieyajie on 13-11-5.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    XDCalendarStyleOneWeek = 0,
    XDCalendarStyleDays
}XDCalendarStyle;

@protocol XDCalendarPickerDelegate;
@interface XDCalendarPickerDemo : UIViewController
{
    XDCalendarStyle _style;//显示样式
    BOOL _isScrolling;//是否正在滚动
    
    NSArray *_chineseMonths;//中文月份
    NSArray *_weekSigns;//中文星期
}

@property (nonatomic) id<XDCalendarPickerDelegate> delegate;

@property (nonatomic) XDCalendarStyle style;
//是否显示背景阴影层
@property (nonatomic) BOOL showBackgroundShadow;

@property (readonly, nonatomic) NSDate *startShowDate;
@property (readonly, nonatomic) NSDate *endShowDate;

@property (readonly, nonatomic) NSDate *selectedDate;

//view的宽度和最大、最小高度不能修改

#pragma mark - 外部 调用
//初始化  显示的起始点和样式
- (id)initWithPoint:(CGPoint)point calendarStyle:(XDCalendarStyle)style selectedDate:(NSDate *)date;
//不同样式的高度
- (CGFloat)heightForStyle:(XDCalendarStyle)style;
//使date处于高亮状态，是否申请数据
- (void)activityDate:(NSDate *)date withRequest:(BOOL)isRequest;

- (void)showInView:(UIView *)view;
- (void)removeFromSuperview;

@end

@protocol XDCalendarPickerDelegate <NSObject>

@required
- (void)calendarPicker:(XDCalendarPickerDemo *)calendarPicker selectedDate:(NSDate *)date;

@end
