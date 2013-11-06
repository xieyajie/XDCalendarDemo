//
//  XDCalendarCenter.m
//  XDCalendarDemo
//
//  Created by xieyajie on 13-11-6.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import "XDCalendarCenter.h"

static XDCalendarCenter *calendarCenter = nil;

@implementation XDCalendarCenter

- (id)init
{
    self = [super init];
    if (self) {
        //
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

#pragma mark - 

@end
