//
//  XDDay.m
//  XDCalendarDome
//
//  Created by xieyajie on 13-7-15.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import "XDDay.h"
#import "XDCalendarPickerController.h"
#import "NSDate+Convenience.h"
#import "UIColor+Category.h"
#import "XDCalendarDefine.h"

typedef enum
{
    XDDayBlockStateNoraml = 0,
    XDDayBlockStateMoving
}XDDayBlockState;

@implementation XDDay

@synthesize blockDate = _blockDate;
@synthesize dateLabel = _dateLabel;
@synthesize ownDotLabel = _ownDotLabel;
@synthesize friendDotLabel = _friendDotLabel;
@synthesize editing = _editing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.dateLabel];
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//        self.titleLabel.backgroundColor = [UIColor clearColor];
//        self.titleLabel.hidden = YES;
//        self.titleLabel.numberOfLines = 0;
//        self.titleLabel.textAlignment = KTextAlignmentCenter;
        
        [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
//        [self addObserver:self forKeyPath:@"editing" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - KOV

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"selected"]) {
        if(self.selected)
        {
            self.dateLabel.textColor = [UIColor whiteColor];
        }
        else
        {
            self.dateLabel.textColor = [UIColor blackColor];
        }
    }
}

#pragma mark - set

- (void)setEditing:(BOOL)isEditing
{
    _editing = isEditing;
    XDDayBlockState state = _editing ? XDDayBlockStateMoving : XDDayBlockStateNoraml;
    [self setState:state];
}

- (void)setBlockDate:(NSDate *)aDate
{
    _blockDate = aDate;
    BOOL prevSelected = self.selected;
    
    if ([self.blockDate day] == 1) {
//        self.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        self.dateLabel.font = [UIFont systemFontOfSize: 14.0];
        int month = [self.blockDate month] - 1;
        NSArray *chineseMonths = [NSArray arrayWithObjects: @"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月", nil];
        NSString *title = [NSString stringWithFormat:@"%@\n1", [chineseMonths objectAtIndex:month]];
//        [self setTitle:title forState:UIControlStateNormal];
        self.dateLabel.text = title;
    }
    else{
//        self.titleLabel.font = [UIFont systemFontOfSize: 18.0];
        self.dateLabel.font = [UIFont systemFontOfSize: 18.0];
        NSString *dayDate = [NSString stringWithFormat:@"%i", [self.blockDate day]];
//        [self setTitle:dayDate forState:UIControlStateNormal];
        self.dateLabel.text = dayDate;
    }

    [self setBasicStyle];
    
    //判断是否高亮状态
    NSDate *highlightDate = [[XDCalendarPickerController shareController] highlightDate];
    if ([aDate isEqualToDate:highlightDate]) {
        if (!prevSelected) {
            self.selected = YES;
//            [[[XDCalendarPickerController shareController] highlightDay] setSelected:NO];
            [[XDCalendarPickerController shareController] setHighlightDay:self];
        }
    }
}

- (void)setState:(XDDayBlockState)aState
{
    switch (aState) {
        case XDDayBlockStateMoving:
            [self setMovingStyle];
            break;
        case XDDayBlockStateNoraml:
            [self setNormalStyle];
            break;
            
        default:
            break;
    }
}

#pragma mark - get

- (UILabel *)ownDotLabel
{
    if (_ownDotLabel == nil) {
        _ownDotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 10, self.bounds.size.width, 10)];
        _ownDotLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _ownDotLabel.backgroundColor = [UIColor clearColor];
        _ownDotLabel.textAlignment = KTextAlignmentCenter;
//        _ownDotLabel.alpha = 0.6;
        _ownDotLabel.text = @"•";
        _ownDotLabel.textColor = [UIColor colorWithHexString:@"ff7f7f"];
    }
    
    return _ownDotLabel;
}

- (UILabel *)friendDotLabel
{
    if (_friendDotLabel == nil) {
        _friendDotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 10, self.bounds.size.width, 10)];
        _friendDotLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _friendDotLabel.backgroundColor = [UIColor clearColor];
        _friendDotLabel.textAlignment = KTextAlignmentCenter;
//        _friendDotLabel.alpha = 0.6;
        _friendDotLabel.text = @"•";
        _friendDotLabel.textColor = [UIColor colorWithHexString:@"1a90cc"];
    }
    
    return _friendDotLabel;
}

- (UILabel *)dateLabel
{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _dateLabel.numberOfLines = 0;
        _dateLabel.textAlignment = KTextAlignmentCenter;
        _dateLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _dateLabel;
}

#pragma mark - private

- (void)setTodayBasicInfo
{
    self.backgroundColor = [UIColor whiteColor];
    [self setContentMode:UIViewContentModeLeft];
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -self.bounds.size.width, 0.0, -10.0);
    
    NSDate *today = [NSDate date];
    int hour = [today hour];
    if (hour > 11) {
        hour -= 12;
    }
    NSString *imageName = [NSString stringWithFormat:@"calendar_today%i.png", hour];
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //    [self setBackgroundImage:[UIImage imageNamed:@"calendar_todayBg.png"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"calendar_blockSelectedBg.png"] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:@"calendar_blockSelectedBg.png"] forState:UIControlStateSelected];
}

- (void)setBasicStyle
{
    self.selected = NO;
    self.backgroundColor = [UIColor clearColor];
    [self setImage:nil forState:UIControlStateNormal];
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    
//    if ([self.blockDate day] == 1) {
//        self.titleLabel.font = [UIFont systemFontOfSize: 14.0];
//        int month = [self.blockDate month] - 1;
//        NSArray *chineseMonths = [NSArray arrayWithObjects: @"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月", nil];
//        NSString *title = [NSString stringWithFormat:@"%@\n1", [chineseMonths objectAtIndex:month]];
//        [self setTitle:title forState:UIControlStateNormal];
//    }
//    else{
//        self.titleLabel.font = [UIFont systemFontOfSize: 18.0];
//        NSString *dayDate = [NSString stringWithFormat:@"%i", [self.blockDate day]];
//        [self setTitle:dayDate forState:UIControlStateNormal];
//    }
    
    NSDate *today = [[NSDate date] convertToZeroInMorning];
    switch ([self.blockDate compare:today]) {
        case NSOrderedAscending:
            [self setBackgroundImage:[UIImage imageNamed:@"calendar_blockPastBg.png"] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageNamed:@"calendar_blockSelectedBg.png"] forState:UIControlStateHighlighted];
            [self setBackgroundImage:[UIImage imageNamed:@"calendar_blockSelectedBg.png"] forState:UIControlStateSelected];
            break;
        case NSOrderedSame:
            [self setTodayBasicInfo];
            break;
        case NSOrderedDescending:
            [self setBackgroundImage:[UIImage imageNamed:@"calendar_blockFutureBg.png"] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageNamed:@"calendar_blockSelectedBg.png"] forState:UIControlStateHighlighted];
            [self setBackgroundImage:[UIImage imageNamed:@"calendar_blockSelectedBg.png"] forState:UIControlStateSelected];
            break;
            
        default:
            break;
    }
    
    [self setDot];
}

- (void)setMovingStyle
{
    self.enabled = NO;
    
//    UIColor *color = [UIColor grayColor];
//    [self setTitleColor:color forState:UIControlStateNormal];
//    [self setTitleColor:color forState:UIControlStateSelected];
//    self.titleLabel.alpha = 0.4;
    
    self.dateLabel.textColor = [UIColor grayColor];
    self.dateLabel.alpha = 0.4;
}

- (void)setNormalStyle
{
    self.enabled = YES;

//    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    self.titleLabel.alpha = 1.0;
    
    self.dateLabel.textColor = [UIColor blackColor];
    self.dateLabel.alpha = 1.0;
}

- (void)setDot
{
    NSString *key = [self.blockDate stringFromDateByYMD];
    BOOL isOwner = [[XDCalendarPickerController shareController] isHaveOwnerEventWithKey:key];
    BOOL isFriend = [[XDCalendarPickerController shareController] isHaveFriendEventWithKey:key];
    
    _ownDotLabel.textAlignment = KTextAlignmentCenter;
    _friendDotLabel.textAlignment = KTextAlignmentCenter;
    if (isFriend && !isOwner) {
        [self addSubview:self.friendDotLabel];
        self.friendDotLabel.frame = CGRectMake(0, self.bounds.size.height - 10, self.bounds.size.width, 10);
        [_ownDotLabel removeFromSuperview];
        return;
    }
    if(!isFriend && isOwner)
    {
        [self addSubview:self.ownDotLabel];
        self.ownDotLabel.frame = CGRectMake(0, self.bounds.size.height - 10, self.bounds.size.width, 10);
        [_friendDotLabel removeFromSuperview];
        return;
    }
    if (isFriend && isOwner) {
        [self addSubview:self.friendDotLabel];
        [self addSubview:self.ownDotLabel];
        _ownDotLabel.textAlignment = KTextAlignmentRight;
        _friendDotLabel.textAlignment = KTextAlignmentLeft;
        self.friendDotLabel.frame = CGRectMake(self.bounds.size.width / 2, self.bounds.size.height - 10, self.bounds.size.width / 2, 10);
        self.ownDotLabel.frame = CGRectMake(0, self.bounds.size.height - 10, self.bounds.size.width / 2, 10);
        return;
    }
    if (!isOwner && !isFriend) {
        [_ownDotLabel removeFromSuperview];
        [_friendDotLabel removeFromSuperview];
        return;
    }
}

#pragma mark - click

- (void)click:(id)sender
{
    if (!self.selected) {
        self.selected = YES;
        NSLog(@"kNotificationDateSelectedFromBlock");
        [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationDateSelectedFromBlock object:self userInfo:nil];
    }
}

@end
