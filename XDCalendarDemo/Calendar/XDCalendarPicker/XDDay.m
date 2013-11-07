//
//  XDDay.m
//  XDCalendarDome
//
//  Created by xieyajie on 13-7-15.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import "XDDay.h"

#import "XDCalendarCenter.h"

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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.dateLabel];
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
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

- (void)setScrolling:(BOOL)isScrolling
{
    _scrolling = isScrolling;
    XDDayBlockState state = _scrolling ? XDDayBlockStateMoving : XDDayBlockStateNoraml;
    [self setState:state];
}

- (void)setBlockDate:(NSDate *)aDate
{
    _blockDate = aDate;
    BOOL prevSelected = self.selected;
    
    if ([self.blockDate day] == 1) {
        self.dateLabel.font = [UIFont systemFontOfSize: 14.0];
        int month = [self.blockDate month] - 1;
        NSArray *chineseMonths = [NSArray arrayWithObjects: @"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月", nil];
        NSString *title = [NSString stringWithFormat:@"%@\n1", [chineseMonths objectAtIndex:month]];
        self.dateLabel.text = title;
    }
    else{
        self.dateLabel.font = [UIFont systemFontOfSize: 18.0];
        NSString *dayDate = [NSString stringWithFormat:@"%i", [self.blockDate day]];
        self.dateLabel.text = dayDate;
    }

    [self setBasicStyle];
    
    //判断是否高亮状态
    NSDate *highlightDate = [[XDCalendarCenter defaultCenter] activityDate];
    if ([aDate isEqualToDate:highlightDate]) {
        if (!prevSelected) {
            self.selected = YES;
        }
        
        if ([[XDCalendarCenter defaultCenter] activityDay] == nil) {
            [[XDCalendarCenter defaultCenter] setActivityDay:self];
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
    [self setBackgroundImage:[UIImage imageNamed:@"calendar_blockSelectedBg.png"] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:@"calendar_blockSelectedBg.png"] forState:UIControlStateSelected];
}

- (void)setBasicStyle
{
    self.selected = NO;
    self.backgroundColor = [UIColor clearColor];
    [self setImage:nil forState:UIControlStateNormal];
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    
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
    
    [self refreshDotView];
}

- (void)setMovingStyle
{
    self.enabled = NO;
    
    self.dateLabel.textColor = [UIColor grayColor];
    self.dateLabel.alpha = 0.4;
}

- (void)setNormalStyle
{
    self.enabled = YES;
    
    self.dateLabel.textColor = [UIColor blackColor];
    self.dateLabel.alpha = 1.0;
}

- (void)refreshDotView
{
    NSString *key = [self.blockDate stringFromDateByYMD];
    
    XDCalendarCenter *center = [XDCalendarCenter defaultCenter];
    id obj = [center.dotViews objectForKey:key];
    if (obj != nil) {
        _dotView = (UIView *)obj;
        _dotView.frame = CGRectMake(0, self.bounds.size.height - 10, self.bounds.size.width, 10);
        [self addSubview:_dotView];
    }
    else{
        [_dotView removeFromSuperview];
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
