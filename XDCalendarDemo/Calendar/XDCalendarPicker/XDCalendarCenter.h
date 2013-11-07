//
//  XDCalendarCenter.h
//  XDCalendarDemo
//
//  Created by xieyajie on 13-11-6.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XDDay;
@interface XDCalendarCenter : NSObject

+ (id)defaultCenter;

@property (nonatomic, strong) NSDate *activityDate;
@property (nonatomic, strong) XDDay *activityDay;
@property (nonatomic, strong) NSMutableDictionary *dotViews;

@end
