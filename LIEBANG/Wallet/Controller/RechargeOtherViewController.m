//
//  RechargeOtherViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/31.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "RechargeOtherViewController.h"

#define kProtolColor   [UIColor colorWithHexString:@"0084FD"]

@interface RechargeOtherViewController ()

@property (nonatomic,strong)UIButton *sureButton;
@property (nonatomic,assign)BOOL isAppleType;//NO 支付宝  YES 微信

@property (nonatomic,strong)UIButton *loginNavButton;
@property (nonatomic,strong)UIButton *registerNavButton;
@property (nonatomic,strong)UIView *buttonView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIImageView *contentView;

@end

@implementation RechargeOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    self.navigationItem.title = @"收银台";
    [self setRightNaviBtnTitle:@"充值说明"];
    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonView];
    [self.buttonView addSubview:self.registerNavButton];
    [self.buttonView addSubview:self.loginNavButton];
    [self.view addSubview:self.sureButton];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    self.isAppleType = NO;
}

- (void)setIsAppleType:(BOOL)isAppleType {
    _isAppleType = isAppleType;
    
    if (isAppleType)
    {
        _registerNavButton.selected = NO;
        _loginNavButton.selected = YES;
        self.contentView.image = [UIImage imageNamed:@"apple_weixin"];
        self.contentView.height = kCurrentWidth(1935);
        [_sureButton setTitle:@"去绑定微信支付" forState:UIControlStateNormal];
    }
    else
    {
        _registerNavButton.selected = YES;
        _loginNavButton.selected = NO;
        self.contentView.image = [UIImage imageNamed:@"apple_alipay"];
        self.contentView.height = kCurrentWidth(1919);
        [_sureButton setTitle:@"去绑定支付宝" forState:UIControlStateNormal];
    }
}

#pragma mark Event
- (void)rightNaviBtnClick {
    RechargeProtrolViewController *nextCtr = [[RechargeProtrolViewController alloc] init];
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)sureButtonClick {
    
    NSURL *accountUrl = [NSURL URLWithString:@"https://finance-app.itunes.apple.com/account/edit?mt=8"];
    if ([[UIApplication sharedApplication] canOpenURL:accountUrl]) {
        if (([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)) {
            [[UIApplication sharedApplication] openURL:accountUrl options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:accountUrl];
        }
    }
}

- (void)loginNavButtonClick {
    self.isAppleType = YES;
}

- (void)registerNavButtonClick {
    self.isAppleType = NO;
}

#pragma mark UI
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(40), kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight-kCurrentWidth(49)-kCurrentWidth(40))];
        _scrollView.bounces = YES;
        _scrollView.contentSize = CGSizeMake(0, kCurrentWidth(1935));
    }
    return _scrollView;
}

- (UIImageView *)contentView {
    if (!_contentView) {
        _contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(1935))];
    }
    return _contentView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(0, kDeviceHeight-kNavBarHeight-kViewHeight-kCurrentWidth(49), kDeviceWidth, kCurrentWidth(49));
        _sureButton.backgroundColor = kProtolColor;
        [_sureButton setTitle:@"去绑定微信支付" forState:UIControlStateNormal];
        [_sureButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = kSystemBold(16);
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)loginNavButton {
    if (!_loginNavButton) {
        _loginNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginNavButton.frame = CGRectMake(self.buttonView.width/2, 0, self.buttonView.width/2, kCurrentWidth(30));
        [_loginNavButton setTitle:@"微信支付" forState:UIControlStateNormal];
        [_loginNavButton setTitleColor:kProtolColor forState:UIControlStateNormal];
        [_loginNavButton setTitleColor:kWhiteColor forState:UIControlStateSelected];
        [_loginNavButton setBackgroundImage:[UIImage createImageWithColor:kWhiteColor] forState:UIControlStateNormal];
        [_loginNavButton setBackgroundImage:[UIImage createImageWithColor:kProtolColor] forState:UIControlStateSelected];
        _loginNavButton.titleLabel.font = kSystem(14);
        [_loginNavButton addTarget:self action:@selector(loginNavButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginNavButton;
}

- (UIButton *)registerNavButton {
    if (!_registerNavButton) {
        _registerNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerNavButton.frame = CGRectMake(0, 0, self.buttonView.width/2, kCurrentWidth(30));
        [_registerNavButton setTitle:@"支付宝" forState:UIControlStateNormal];
        [_registerNavButton setTitleColor:kProtolColor forState:UIControlStateNormal];
        [_registerNavButton setTitleColor:kWhiteColor forState:UIControlStateSelected];
        [_registerNavButton setBackgroundImage:[UIImage createImageWithColor:kWhiteColor] forState:UIControlStateNormal];
        [_registerNavButton setBackgroundImage:[UIImage createImageWithColor:kProtolColor] forState:UIControlStateSelected];
        _registerNavButton.titleLabel.font = kSystem(14);
        _registerNavButton.selected = YES;
        [_registerNavButton addTarget:self action:@selector(registerNavButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerNavButton;
}

- (UIView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(kCurrentWidth(80), kCurrentWidth(10), kDeviceWidth-kCurrentWidth(160), kCurrentWidth(30))];
        _buttonView.layer.cornerRadius = 4;
        _buttonView.layer.masksToBounds = YES;
        _buttonView.layer.borderColor = kProtolColor.CGColor;
        _buttonView.layer.borderWidth = 1.f;
    }
    return _buttonView;
}

@end
