//
//  XDActivityDay.m
//  XDCalendarDemo
//
//  Created by xieyajie on 13-11-5.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import "XDActivityDay.h"

#import "XDDay.h"

@implementation XDActivityDay

- (id)init
{
    self = [super init];
    if (self) {
        _activityDay = nil;
    }
    
    return self;
}

- (void)setActivityDay:(XDDay *)activity
{
    if (_activityDay != activity) {
        if (_activityDay != nil) {
            //????
        }
        
        _activityDay = activity;
    }
}

@end
