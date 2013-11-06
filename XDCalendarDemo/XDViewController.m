//
//  XDViewController.m
//  XDCalendarDemo
//
//  Created by xieyajie on 13-11-5.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import "XDViewController.h"

#import "XDCalendarPickerDemo.h"

@interface XDViewController ()

@property (strong, nonatomic) XDCalendarPickerDemo *calendarPicker;

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

- (XDCalendarPickerDemo *)calendarPicker
{
    if (_calendarPicker == nil) {
        _calendarPicker = [[XDCalendarPickerDemo alloc] initWithPoint:CGPointMake(0, 20) calendarStyle:XDCalendarStyleDays selectedDate:[NSDate date]];
    }
    
    return _calendarPicker;
}

@end
