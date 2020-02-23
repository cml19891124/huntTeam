//
//  ConfimButton.m
//  Lottery
//
//  Created by  YIQI on 2018/4/8.
//  Copyright © 2018年 zhong. All rights reserved.
//

#import "ConfimButton.h"

@implementation ConfimButton

- (instancetype)initWithTop:(CGFloat)top title:(NSString *)title {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(kCurrentWidth(20), top, kDeviceWidth-kCurrentWidth(40), kCurrentWidth(40));
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:kWhiteColor forState:UIControlStateNormal];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = kSystemBold(15);
        [self setBackgroundImage:[UIImage createImageWithColor:kLBRedColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"90D5F0"]] forState:UIControlStateDisabled];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    [self setTitle:title forState:UIControlStateNormal];
}

@end
