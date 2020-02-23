//
//  PayView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/8.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PayHeadView.h"

@interface PayHeadView ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UILabel *typeLabel;
@property (nonatomic,strong)UIView *lineView;

@end

@implementation PayHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(90));
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(45), kDeviceWidth, 0.5)];
        _lineView.backgroundColor = kSepparteLineColor;
        [self addSubview:_lineView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(100), _lineView.top)];
        _titleLabel.font = kSystem(14);
        [self addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(112), 0, kCurrentWidth(100), _lineView.top)];
        _priceLabel.text = @"0.00猎帮币";
        _priceLabel.textColor = kLBFiveColor;
        _priceLabel.font = kSystem(13);
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_priceLabel];
        
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), _lineView.bottom, kCurrentWidth(100), self.height-_lineView.bottom)];
        _typeLabel.text = @"支付方式";
        _typeLabel.textColor = kLBNineColor;
        _typeLabel.font = kSystem(12);
        [self addSubview:_typeLabel];
    }
    return self;
}

- (void)setPrice:(NSString *)price {
    _price = price;
    
    _priceLabel.text = [NSString stringWithFormat:@"%.2f猎帮币",[price floatValue]];
}

- (void)setServiceType:(NSString *)serviceType {
    _serviceType = serviceType;
    
    //0:线下约见 1：全国通话
    if ([serviceType isEqualToString:@"0"])
    {
        _titleLabel.text = @"线下约见";
    }
    else if ([serviceType isEqualToString:@"1"])
    {
        _titleLabel.text = @"全国通话";
    }
    else if ([serviceType isEqualToString:@"1猎帮币查看"])
    {
        _titleLabel.text = @"1猎帮币查看";
    }
    else if ([serviceType isEqualToString:@"企业名片"])
    {
        _titleLabel.text = @"企业名片";
    }
    else
    {
        _titleLabel.text = @"在线问答";
    }
}

@end
