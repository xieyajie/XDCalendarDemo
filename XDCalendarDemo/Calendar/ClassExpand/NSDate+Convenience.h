//
//  NSDate+Convenience.h
//  XDCalendar
//
//  Created by xieyajie on 13-3-19.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    XDDateCompareSmaller = -1,
    XDDateCompareEqual = 0,
    XDDateComparePlurality
}XDDateCompare;


@interface NSDate (Convenience)

- (int)year;

- (int)month;

- (int)day;

- (int)week;

- (int)hour;

- (int)countOfDaysInMonth;

- (int)countOfWeeksInMonth;

- (NSDate *)firstDayOfMonth;
- (NSDate *)endDayOfMonth;

- (int)firstWeekDayInMonth;

- (int)weekInMonth;

- (int)weekInYear;

- (int)weekFromDate:(NSDate *)date;

- (NSDate *)offsetMonth:(int)numMonths;

- (NSDate *)offsetDay:(int)numDays;

- (BOOL)isEqualToDate: (NSDate *)aDate;

- (NSInteger)compareWithDate: (NSDate *)aDate;

- (NSDate *)fristDateOfYear;

- (NSDate *)endDateOfYear;

/*
 *将aDate转为该天零点
 */
- (NSDate *)convertToZeroInMorning;

- (NSString *)stringFromDateByYMD;

//将date转为年月日的int型
- (NSInteger)convertToInt;

@end
