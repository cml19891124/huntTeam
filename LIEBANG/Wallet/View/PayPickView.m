//
//  PayPickView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PayPickView.h"
#import "PayTypePickView.h"

@interface PayPickView ()

@property (nonatomic,strong)UIButton *windowButton;
@property (nonatomic,strong)UIView *borderView;
@property (nonatomic,strong)UIView *contentView;

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIView *lineView1;
@property (nonatomic,strong)UIView *lineView2;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *closeButton;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UIButton *payButton;

@property (nonatomic,strong)UILabel *orderLabel;
@property (nonatomic,strong)UILabel *typeLabel;
@property (nonatomic,strong)UILabel *payTypeLabel;
@property (nonatomic,strong)UIButton *payTypeButton;
@property (nonatomic,strong)UIButton *hidenButton;
@property (nonatomic,strong)UIImageView *markImageView;

@end

@implementation PayPickView

+ (void)showTypePickViewWithAnimation:(BOOL)bAnimation
                             betPrice:(CGFloat)betPrice
                            pickBlock:(void(^)(NSString *string))pickBlock {
    PayPickView *pickerView = [[PayPickView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    pickerView.betPrice = betPrice;
    pickerView.pickBlock = ^(NSString *string) {
        if (pickBlock) {
            pickBlock(string);
        }
    };
    pickerView.payType = @"0";
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

#pragma mark 响应事件
- (void)payButtonClick {
    
    [self closePickerView];
    if (_pickBlock) {
        _pickBlock(self.payType);
    }
}

- (void)payTypeButtonClick {
    
    [PayTypePickView showTypePickViewWithAnimation:YES isRecharge:YES payType:self.payType pickBlock:^(NSString *string) {
        
        self.payType = string;
        if ([string intValue] == 0)
        {
            [_payTypeButton setTitle:@"支付宝" forState:UIControlStateNormal];
        }
        else
        {
            [_payTypeButton setTitle:@"微信" forState:UIControlStateNormal];
        }
    }];
}

- (void)closePickerView {
    WeakSelf;
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         weakSelf.contentView.top = weakSelf.borderView.bottom;
                     }
                     completion:^(BOOL finished) {
                         
                         [weakSelf removeFromSuperview];
                     }];
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

- (void)setBetPrice:(CGFloat)betPrice {
    _betPrice = betPrice;
    
    _priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",betPrice];
}

- (void)createContentView {
    
    _windowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _windowButton.backgroundColor = kBlackColor;
    _windowButton.alpha = 0.5;
    _windowButton.frame = self.bounds;
    [_windowButton addTarget:self action:@selector(closePickerView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.windowButton];
    
    _borderView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(198), kDeviceWidth, kDeviceHeight-kCurrentWidth(198))];
    _borderView.clipsToBounds = YES;
    [self addSubview:_borderView];
    
    _contentView = [[UIView alloc] initWithFrame:self.borderView.bounds];
    _contentView.backgroundColor = kWhiteColor;
    [_borderView addSubview:_contentView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(100))/2, 0, kCurrentWidth(100), kCurrentWidth(55))];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"确认付款";
    _titleLabel.font = kSystemBold(15);
    _titleLabel.textColor = kLBBlackColor;
    [_contentView addSubview:_titleLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom, kDeviceWidth, 0.5)];
    _lineView.backgroundColor = kSepparteLineColor;
    [_contentView addSubview:_lineView];
    
    _lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _lineView.bottom+kCurrentWidth(103), kDeviceWidth, 0.5)];
    _lineView1.backgroundColor = kSepparteLineColor;
    [_contentView addSubview:_lineView1];
    
    _lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _lineView1.bottom+kCurrentWidth(50), kDeviceWidth, 0.5)];
    _lineView2.backgroundColor = kSepparteLineColor;
    [_contentView addSubview:_lineView2];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _lineView.bottom, kDeviceWidth, kCurrentWidth(63))];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.text = @"¥ 0.00";
    _priceLabel.font = kSystemBold(30);
    _priceLabel.textColor = kLBBlackColor;
    [_contentView addSubview:_priceLabel];
    
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _payButton.frame = CGRectMake(kCurrentWidth(12), _contentView.height-kCurrentWidth(79), kDeviceWidth-kCurrentWidth(24), kCurrentWidth(44));
    _payButton.backgroundColor = kLBRedColor;
    [_payButton setTitle:@"立即付款" forState:UIControlStateNormal];
    [_payButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _payButton.titleLabel.font = kSystemBold(16);
    _payButton.layer.cornerRadius = 3.f;
    _payButton.layer.masksToBounds = YES;
    [_payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_payButton];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(0, 0, kCurrentWidth(37), kCurrentWidth(55));
    [_closeButton setImage:[UIImage imageNamed:@"bar_button_close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closePickerView) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_closeButton];
    
    _orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), _lineView1.top-kCurrentWidth(46), kCurrentWidth(100), kCurrentWidth(46))];
    _orderLabel.text = @"订单信息";
    _orderLabel.font = kSystem(15);
    _orderLabel.textColor = kLBNineColor;
    [_contentView addSubview:_orderLabel];
    
    _hidenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _hidenButton.backgroundColor = kWhiteColor;
    _hidenButton.frame = CGRectMake(0, _lineView2.top-kCurrentWidth(46), kDeviceWidth, kCurrentWidth(46));
    [_hidenButton addTarget:self action:@selector(payTypeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_hidenButton];
    
    _payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), _lineView2.top-kCurrentWidth(46), kCurrentWidth(100), kCurrentWidth(46))];
    _payTypeLabel.text = @"付款方式";
    _payTypeLabel.font = kSystem(15);
    _payTypeLabel.textColor = kLBNineColor;
    [_contentView addSubview:_payTypeLabel];
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(113), _lineView1.top-kCurrentWidth(46), kCurrentWidth(100), kCurrentWidth(46))];
    _typeLabel.text = @"充值";
    _typeLabel.font = kSystem(15);
    _typeLabel.textColor = kLBBlackColor;
    _typeLabel.textAlignment = NSTextAlignmentRight;
    [_contentView addSubview:_typeLabel];
    
    _payTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _payTypeButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(125), _lineView2.top-kCurrentWidth(46), kCurrentWidth(100), kCurrentWidth(46));
    [_payTypeButton setTitleColor:kLBBlackColor forState:UIControlStateNormal];
    [_payTypeButton setTitle:@"支付宝" forState:UIControlStateNormal];
    _payTypeButton.titleLabel.font = kSystemBold(15);
    _payTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_payTypeButton addTarget:self action:@selector(payTypeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_payTypeButton];
    
    _markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(20), _lineView2.top-kCurrentWidth(46)+kCurrentWidth(16.5), kCurrentWidth(7), kCurrentWidth(13))];
    _markImageView.image = [UIImage imageNamed:@"list_btn_enter.png"];
    [_contentView addSubview:_markImageView];

}

@end
