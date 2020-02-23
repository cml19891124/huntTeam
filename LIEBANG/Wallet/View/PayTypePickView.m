//
//  PayTypePickView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/11.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PayTypePickView.h"

@interface PayTypePickView ()

@property (nonatomic,strong)UIButton *windowButton;
@property (nonatomic,strong)UIView *borderView;
@property (nonatomic,strong)UIView *contentView;

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIView *lineView1;
@property (nonatomic,strong)UIView *lineView2;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *closeButton;

@property (nonatomic,strong)UIButton *aliButton;
@property (nonatomic,strong)UIButton *wxButton;

@property (nonatomic,strong)UIImageView *aliMark;
@property (nonatomic,strong)UIImageView *wxMark;

@end

@implementation PayTypePickView

+ (void)showTypePickViewWithAnimation:(BOOL)bAnimation
                           isRecharge:(BOOL)isRecharge
                              payType:(NSString *)payType
                            pickBlock:(void(^)(NSString *string))pickBlock
{
    PayTypePickView *pickerView = [[PayTypePickView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    pickerView.pickBlock = ^(NSString *string) {
        if (pickBlock) {
            pickBlock(string);
        }
    };
    pickerView.payType = payType;
    pickerView.isRecharge = isRecharge;
    [pickerView showWithAnimation:YES];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createContentView];
    }
    return self;
}

- (void)setPayType:(NSString *)payType {//0 支付宝  1：微信
    _payType = payType;
    
    if ([payType intValue] == 0)
    {
        _aliMark.hidden = NO;
        _wxMark.hidden = YES;
    }
    else
    {
        _aliMark.hidden = YES;
        _wxMark.hidden = NO;
    }
}

- (void)setIsRecharge:(BOOL)isRecharge {
    _isRecharge = isRecharge;
    
    if (isRecharge)
    {
        [_closeButton setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    }
    else
    {
        [_closeButton setImage:[UIImage imageNamed:@"bar_button_close"] forState:UIControlStateNormal];
    }
}

#pragma mark 响应事件
- (void)closePickerView {
    WeakSelf;
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         weakSelf.contentView.top = weakSelf.borderView.bottom;
                     }
                     completion:^(BOOL finished) {
                         
                         [weakSelf removeFromSuperview];
                     }];
    
    if (_pickBlock) {
        _pickBlock(self.payType);
    }
}

- (void)showWithAnimation:(BOOL)bAnimation {
    UIView *window = [UIApplication sharedApplication].keyWindow;
    
    if (bAnimation)
    {
        WeakSelf;
        self.contentView.top = self.borderView.bottom;
        [window addSubview:self];
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.contentView.top = 0;
        }];
    }
    else
    {
        [window addSubview:self];
    }
}

- (void)createContentView {
    
    _windowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _windowButton.backgroundColor = kBlackColor;
    _windowButton.alpha = 0.5;
    _windowButton.frame = self.bounds;
//    [_windowButton addTarget:self action:@selector(closePickerView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.windowButton];
    
    _borderView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(198), kDeviceWidth, kDeviceHeight-kCurrentWidth(198))];
    _borderView.clipsToBounds = YES;
    [self addSubview:_borderView];
    
    _contentView = [[UIView alloc] initWithFrame:self.borderView.bounds];
    _contentView.backgroundColor = kWhiteColor;
    [_borderView addSubview:_contentView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(100))/2, 0, kCurrentWidth(100), kCurrentWidth(55))];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"选择提现方式";
    _titleLabel.font = kSystemBold(15);
    _titleLabel.textColor = kLBBlackColor;
    [_contentView addSubview:_titleLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom, kDeviceWidth, 0.5)];
    _lineView.backgroundColor = kSepparteLineColor;
    [_contentView addSubview:_lineView];
    
    _lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _lineView.bottom+kCurrentWidth(46), kDeviceWidth, 0.5)];
    _lineView1.backgroundColor = kSepparteLineColor;
    [_contentView addSubview:_lineView1];
    
    _lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _lineView1.bottom+kCurrentWidth(46), kDeviceWidth, 0.5)];
    _lineView2.backgroundColor = kSepparteLineColor;
    [_contentView addSubview:_lineView2];

    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(0, 0, kCurrentWidth(37), kCurrentWidth(55));
    [_closeButton setImage:[UIImage imageNamed:@"bar_button_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closePickerView) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_closeButton];
    
    _aliButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _aliButton.frame = CGRectMake(kCurrentWidth(13), _lineView1.top-kCurrentWidth(46), kDeviceWidth-kCurrentWidth(13), kCurrentWidth(46));
    [_aliButton setTitle:@"支付宝" forState:UIControlStateNormal];
    [_aliButton setTitleColor:kLBBlackColor forState:UIControlStateNormal];
    _aliButton.titleLabel.font = kSystem(15);
    [_aliButton setImage:[UIImage imageNamed:@"list_icon_zhifubao"] forState:UIControlStateNormal];
    _aliButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _aliButton.titleEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(15), 0, 0);
    [_aliButton addTarget:self action:@selector(aliButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_aliButton];
    
    _wxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _wxButton.frame = CGRectMake(kCurrentWidth(13), _lineView2.top-kCurrentWidth(46), kDeviceWidth-kCurrentWidth(13), kCurrentWidth(46));
    [_wxButton setTitle:@"微信" forState:UIControlStateNormal];
    [_wxButton setTitleColor:kLBBlackColor forState:UIControlStateNormal];
     _wxButton.titleLabel.font = kSystem(15);
    [_wxButton setImage:[UIImage imageNamed:@"list_icon_weixinzhifu"] forState:UIControlStateNormal];
    _wxButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _wxButton.titleEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(15), 0, 0);
    [_wxButton addTarget:self action:@selector(wxButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_wxButton];
    
    _aliMark = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(33)-kCurrentWidth(13), kCurrentWidth(33)/2, kCurrentWidth(20), kCurrentWidth(13))];
    _aliMark.image = [UIImage imageNamed:@"list_button_xuanze"];
    [_aliButton addSubview:_aliMark];
    
    _wxMark = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(33)-kCurrentWidth(13), kCurrentWidth(33)/2, kCurrentWidth(20), kCurrentWidth(13))];
    _wxMark.image = [UIImage imageNamed:@"list_button_xuanze"];
    [_wxButton addSubview:_wxMark];
}

- (void)aliButtonClick {
    _aliMark.hidden = NO;
    _wxMark.hidden = YES;
    self.payType = @"0";
    
//    if (!self.isRecharge) {
        [self closePickerView];
//    }
}

- (void)wxButtonClick {
    _aliMark.hidden = YES;
    _wxMark.hidden = NO;
    self.payType = @"1";
    
//    if (!self.isRecharge) {
        [self closePickerView];
//    }
}

@end
