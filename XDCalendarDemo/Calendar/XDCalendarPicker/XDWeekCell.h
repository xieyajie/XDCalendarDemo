//
//  XDWeekCell.h
//  XDCalendarDome
//
//  Created by xieyajie on 13-7-15.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDDay;
@interface XDWeekCell : UITableViewCell
{
    NSMutableArray *_daysArray;
}

@property (nonatomic, strong) NSMutableArray *daysArray;
@property (nonatomic, strong, setter = setMondayDate:) NSDate *mondayDate;
@property (nonatomic) BOOL scrolling;

- (XDDay *)dayBlockForDate:(NSDate *)date;

@end
