//
//  XDCalendarCenter.m
//  XDCalendarDemo
//
//  Created by xieyajie on 13-11-6.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import "XDCalendarCenter.h"

#import "XDDay.h"

static XDCalendarCenter *calendarCenter = nil;

@implementation XDCalendarCenter

- (id)init
{
    self = [super init];
    if (self) {
        _dotViews = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+ (id)defaultCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (calendarCenter == nil) {
            calendarCenter = [[XDCalendarCenter alloc] init];
        }
    });
    
    return calendarCenter;
}

#pragma mark - setting

- (void)setActivityDay:(XDDay *)day
{
    if (_activityDay != day) {
        if (_activityDay != nil) {
            _activityDay.selected = NO;
        }
        
        _activityDay = day;
    }
}

- (void)setDotViews:(NSMutableDictionary *)views
{
    [_dotViews removeAllObjects];
    if (views != nil && views.count > 0) {
        [_dotViews addEntriesFromDictionary:views];
    }
}

@end
