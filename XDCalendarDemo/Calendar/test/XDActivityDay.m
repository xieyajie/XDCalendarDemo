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
        _day = nil;
    }
    
    return self;
}

- (void)setDay:(XDDay *)activity
{
    if (_day != activity) {
        if (_day != nil) {
            //????
        }
        
        _day = activity;
    }
}

@end
