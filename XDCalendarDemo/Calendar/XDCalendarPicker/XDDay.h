//
//  XDDay.h
//  XDCalendarDome
//
//  Created by xieyajie on 13-7-15.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDDay : UIButton
{
    UIView *_dotView;
}

@property (nonatomic, strong, setter = setBlockDate:) NSDate *blockDate;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, assign) BOOL scrolling;

//刷新标记view
- (void)refreshDotView;

@end
