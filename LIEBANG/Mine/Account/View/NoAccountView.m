//
//  NoAccountView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/24.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "NoAccountView.h"

@interface NoAccountView ()

@property (nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)NoDataView *noView;

@end

@implementation NoAccountView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, kNavBarHeight, kDeviceWidth, kDeviceHeight-kNavBarHeight);
        self.backgroundColor = kBackgroundColor;
        
        self.noView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight];
        [self addSubview:self.noView];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
        [self.backButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
        self.backButton.titleLabel.font = kSystem(15);
        self.backButton.frame = CGRectMake((kDeviceWidth-kCurrentWidth(120))/2, kCurrentWidth(380)+kViewHeight, kCurrentWidth(120), kCurrentWidth(36));
        self.backButton.layer.masksToBounds = YES;
        self.backButton.layer.cornerRadius = kCurrentWidth(18);
        self.backButton.layer.borderColor = kLBRedColor.CGColor;
        self.backButton.layer.borderWidth = 0.5;
        [self.backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backButton];
    }
    return self;
}

- (void)setTitleString:(NSString *)titleString {
    self.noView.titleString = titleString;
}

- (void)backButtonClick {
    if (_backButtonBlock) {
        _backButtonBlock();
    }
}

@end
