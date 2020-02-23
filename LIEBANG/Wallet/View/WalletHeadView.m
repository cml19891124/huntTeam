//
//  WalletHeadView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/24.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "WalletHeadView.h"

@interface WalletHeadView ()

@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *balanceLabel;
@property (nonatomic,strong)UILabel *typeLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UIView *detailView;

@property (nonatomic,strong)UIButton *withdrawButton;
@property (nonatomic,strong)UIButton *rechargeButton;
@end

@implementation WalletHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self createSubViews];
    }
    return self;
}

- (void)setBalance:(NSString *)balance {
    _balance = balance;
    
//    _balanceLabel.text = [NSString stringWithFormat:@"%.2f",[balance floatValue]];
    _balanceLabel.text = balance;
}

#pragma mark Event
- (void)backButtonClick {
    if (_backButtonBlock) {
        _backButtonBlock();
    }
}

- (void)rechargeButtonClick {
    if (_rechargeButtonBlock) {
        _rechargeButtonBlock();
    }
}

- (void)withdrawButtonClick {
    if (_forwardButtonBlock) {
        _forwardButtonBlock();
    }
}

#pragma mark 界面布局
- (void)createSubViews {
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(171))];
    _backImageView.image = [UIImage imageNamed:@"background_blue.png"];
    [self addSubview:_backImageView];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, kStatusBarViewHeight, 34, 44);
    [_backButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-100)/2, kStatusBarViewHeight, 100, 44)];
    _titleLabel.text = @"我的钱包";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = kSystemBold(16);
    _titleLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    [self addSubview:_titleLabel];
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCurrentWidth(55)+kStatusBarViewHeight, kDeviceWidth, kCurrentWidth(20))];
    _typeLabel.text = @"账户余额 (元)";
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    _typeLabel.font = kSystem(15);
    _typeLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    [self addSubview:_typeLabel];
    
    _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _typeLabel.bottom+kCurrentWidth(10), kDeviceWidth, kCurrentWidth(37))];
    _balanceLabel.textAlignment = NSTextAlignmentCenter;
    _balanceLabel.font = kSystemBold(30);
    _balanceLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    [self addSubview:_balanceLabel];
    
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(250), kDeviceWidth, kCurrentWidth(40))];
    _detailView.backgroundColor = kBackgroundColor;
    [self addSubview:_detailView];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kDeviceWidth-kCurrentWidth(24), kCurrentWidth(40))];
    _detailLabel.text = @"收支明细";
    _detailLabel.font = kSystemBold(14);
    _detailLabel.textColor = [UIColor colorWithHexString:@"000000"];
    [_detailView addSubview:_detailLabel];
    
    
    _rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rechargeButton.frame = CGRectMake(kDeviceWidth/2-kCurrentWidth(128), kCurrentWidth(171), kCurrentWidth(128), kCurrentWidth(79));
    [_rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    [_rechargeButton setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
    _rechargeButton.titleLabel.font = kSystem(14);
    [_rechargeButton setImage:[UIImage imageNamed:@"btn_chongzhi.png"] forState:UIControlStateNormal];
    [_rechargeButton setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(28, 21) space:10];
    [_rechargeButton addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rechargeButton];
    
    _withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _withdrawButton.frame = CGRectMake(kDeviceWidth/2, kCurrentWidth(171), kCurrentWidth(128), kCurrentWidth(79));
    [_withdrawButton setTitle:@"提现" forState:UIControlStateNormal];
    [_withdrawButton setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
    _withdrawButton.titleLabel.font = kSystem(14);
    [_withdrawButton setImage:[UIImage imageNamed:@"btn_tixian.png"] forState:UIControlStateNormal];
    [_withdrawButton setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(28, 21) space:10];
    [_withdrawButton addTarget:self action:@selector(withdrawButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_withdrawButton];
}

@end
