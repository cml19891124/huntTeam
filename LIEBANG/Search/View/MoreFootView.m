//
//  MoreFootView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/22.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "MoreFootView.h"

@interface MoreFootView ()

@property (nonatomic,strong)UIButton *moreButton;

@end

@implementation MoreFootView

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(43));
        [_moreButton setTitleColor:[UIColor colorWithHexString:@"3066A9"] forState:UIControlStateNormal];
        [_moreButton setTitle:title forState:UIControlStateNormal];
        _moreButton.titleLabel.font = kSystem(14);
        [_moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreButton];
    }
    return self;
}

- (void)moreButtonClick {
    if (_moreButtonBlock) {
        _moreButtonBlock();
    }
}

@end
