//
//  XDDay.h
//  XDCalendarDome
//
//  Created by xieyajie on 13-7-15.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDDay : UIButton

@property (nonatomic, strong, setter = setBlockDate:) NSDate *blockDate;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *ownDotLabel;

@property (nonatomic, strong) UILabel *friendDotLabel;

@property (nonatomic, assign) BOOL scrolling;

//@property (nonatomic, assign, setter = setState:) XDDayBlockState state;

- (void)setDot;

@end
