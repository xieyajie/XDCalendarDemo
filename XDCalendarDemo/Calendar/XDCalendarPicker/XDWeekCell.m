//
//  XDWeekCell.m
//  XDCalendarDome
//
//  Created by xieyajie on 13-7-15.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import "XDWeekCell.h"
#import "XDDay.h"

#import "NSDate+Convenience.h"
#import "XDCalendarDefine.h"

@implementation XDWeekCell

@synthesize daysArray = _daysArray;

@synthesize mondayDate = _mondayDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _daysArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 7; i++) {
            XDDay *block = [[XDDay alloc] initWithFrame:CGRectMake(kCalendarDayBlockWidth * i, 0, kCalendarDayBlockWidth - 0.5, kCalendarDayBlockHeight)];
            [self.contentView addSubview:block];
            [_daysArray addObject:block];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setScrolling:(BOOL)scrolling
{
    [self setDaysScrolling:scrolling];
}

#pragma mark - private

- (void)setDaysScrolling:(BOOL)isScrolling
{
    for (int i = 0; i < 7; i++) {
        XDDay *block = [_daysArray objectAtIndex:i];
        block.scrolling = isScrolling;
    }
}

#pragma mark - public

- (void)setMondayDate:(NSDate *)date
{
    _mondayDate = date;
    
    for (int i = 0; i < 7; i++) {
        XDDay *block = [_daysArray objectAtIndex:i];
        NSDate *date = [_mondayDate offsetDay:i];
        block.tag = [date convertToInt];
        block.blockDate = date;
    }
}

//- (void)setMonday:(NSDate *)monday
//{
//    for (int i = 0; i < 7; i++) {
//        XDDay *block = [_daysArray objectAtIndex:i];
//        NSDate *date = [monday offsetDay:i];
//        block.tag = [date convertToInt];
//        block.blockDate = date;
//    }
//}

- (XDDay *)dayBlockForDate:(NSDate *)date
{
    return (XDDay *)[self.contentView viewWithTag:[date convertToInt]];
}

@end
