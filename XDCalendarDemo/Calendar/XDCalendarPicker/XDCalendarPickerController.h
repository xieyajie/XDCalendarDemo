//
//  XDCalendarPickerController.h
//  XDCalendarDome
//
//  Created by xieyajie on 13-7-15.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XDRefreshTableView.h"

@class XDCalendarPicker;
@class XDDay;
@interface XDCalendarPickerController : NSObject<UITableViewDelegate, UITableViewDataSource, XDRefreshTableViewDelegate>

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *highlightDate;
@property (nonatomic, strong) XDDay *highlightDay;

//用于XDDay.h
@property (nonatomic, strong) NSDictionary *dotsDictionary;
@property (nonatomic, strong) UIColor *dotColor;

- (id)initWithView:(XDCalendarPicker *)aView;
+ (id)shareController;

- (void)calculateStartDate:(NSDate *)date;
- (void)calculateEndDate:(NSDate *)date;

- (void)stopScrollingAtOffset:(CGPoint)offset;

//只显示一周的状态下，左右滑动相关操作
- (void)clear;
- (void)tableView:(UITableView *)tableView scrollToNextIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView ScrollToPervIndexPath:(NSIndexPath *)indexPath;

//事件点相关
//- (void)changeDotsDataToOwner:(BOOL)isOwner;
- (void)requestCalendarDots;

- (BOOL)isHaveOwnerEventWithKey:(NSString *)aKey;
- (BOOL)isHaveFriendEventWithKey:(NSString *)aKey;

@end
