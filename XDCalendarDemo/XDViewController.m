//
//  XDViewController.m
//  XDCalendarDemo
//
//  Created by xieyajie on 13-11-5.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import "XDViewController.h"

#import "XDCalendarPicker.h"

@interface XDViewController ()<XDCalendarPickerDelegate>

@property (strong, nonatomic) XDCalendarPicker *calendarPicker;

@end

@implementation XDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    [self.calendarPicker showInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getting

- (XDCalendarPicker *)calendarPicker
{
    if (_calendarPicker == nil) {
        _calendarPicker = [[XDCalendarPicker alloc] initWithPoint:CGPointMake(0, 20) calendarStyle:XDCalendarStyleOneWeek selectedDate:[NSDate date]];
        _calendarPicker.delegate = self;
    }
    
    return _calendarPicker;
}

#pragma mark - XDCalendarPickerDelegate

- (void)calendarPicker:(XDCalendarPicker *)calendarPicker selectedDate:(NSDate *)date
{
    
}

- (void)calendarPickerSwipeDown:(XDCalendarPicker *)calendarPicker
{
    self.calendarPicker.style = XDCalendarStyleDays;
}

#pragma mark - data


@end
