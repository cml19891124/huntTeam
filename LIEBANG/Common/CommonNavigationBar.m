//
//  CommonNavigationBar.m
//  Storm
//
//  Created by 朱攀峰 on 15/11/26.
//  Copyright (c) 2015年 MCDS. All rights reserved.
//

#import "CommonNavigationBar.h"

@implementation CommonNavigationBar

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageWithColor:[UIColor redColor] frame:CGRectMake(0, 0, kDeviceWidth, 44)];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        [view setExclusiveTouch:YES];
    }
}
@end
