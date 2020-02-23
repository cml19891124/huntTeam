//
//  AccountNavView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountNavView.h"

@interface AccountNavView ()

@property (nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)UIButton *detailButton;
@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation AccountNavView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kDeviceWidth, kNavBarHeight);
        self.backgroundColor = kLBRedColor;
        [self createSubViews];
    }
    return self;
}

- (void)setAccountState:(AccountState)accountState {
    _accountState = accountState;
    
    if (accountState == AccountStateEdit)
    {
        _detailButton.titleLabel.font = kSystem(16);
        [_detailButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    else
    {
        [_detailButton setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
    }
}

- (void)backButtonClick {
    if (_backButtonBlock) {
        _backButtonBlock();
    }
}

- (void)detailButtonClick {
    if (_detailButtonBlock) {
        _detailButtonBlock(_detailButton);
    }
}

- (void)setIsHidden:(BOOL)isHidden {
    _detailButton.hidden = isHidden;
}

- (void)createSubViews {
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, kStatusBarViewHeight, 34, 44);
    [_backButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backButton];
    
    _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _detailButton.frame = CGRectMake(kDeviceWidth-46, kStatusBarViewHeight, 46, 44);
//    [_detailButton setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
    [_detailButton addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_detailButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _detailButton.titleLabel.font = kSystem(16);
    [self addSubview:_detailButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-100)/2, kStatusBarViewHeight, 100, 44)];
    _titleLabel.text = @"人脉和知识";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = kSystemBold(16);
    _titleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    [self addSubview:_titleLabel];
}

@end
