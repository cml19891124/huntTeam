//
//  LBBFootView.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/29.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "LBBFootView.h"

static NSString *const kLBBReceiptData = @"1.猎帮币充值，仅限苹果手机设备应用内使用；\n2.猎帮币可用于直接购买猎帮应用内所有虚拟商品；\n3.预约话题、在线问答、行家未在时效内确认相关服务，系统自动退回至猎帮币账户，不能退款；\n4.猎帮币为虚拟货币，仅限iOS系统消费，不支持跨系统使用，充值成功后不会过期，不能退款、提现或转赠他人；\n5.虚拟商品原则不予退款，参见使用帮助和猎帮用户协议。";
static NSString *const kLBUseHelp = @"使用帮助";
static NSString *const kLBUseProtocol = @"猎帮用户协议";

@interface LBBFootView ()

@property (nonatomic,strong)ConfimButton *nextButton;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)YYLabel *detailLabel;

@end

@implementation LBBFootView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(30))];
        self.titleLabel.textColor = kLBThreeColor;
        self.titleLabel.font = kSystem(13);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"温馨提示";
        [self addSubview:self.titleLabel];
        
        CGSize size = [kLBBReceiptData sizeWithFont:kSystem(12) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), MAXFLOAT)];
        
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:kLBBReceiptData attributes:nil]];
        text.yy_font = [UIFont systemFontOfSize:12];
        text.yy_color = kLBNineColor;
        [text yy_setColor:kLBRedColor range:[kLBBReceiptData rangeOfString:kLBUseProtocol]];
        [text yy_setTextHighlightRange:[kLBBReceiptData rangeOfString:kLBUseProtocol] color:kLBRedColor backgroundColor:kLBRedColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (_useProtocolBlock) {
                _useProtocolBlock();
            }
        }];
        
        [text yy_setColor:kLBRedColor range:[kLBBReceiptData rangeOfString:kLBUseHelp]];
        [text yy_setTextHighlightRange:[kLBBReceiptData rangeOfString:kLBUseHelp] color:kLBRedColor backgroundColor:kLBRedColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (_useHelpBlock) {
                _useHelpBlock();
            }
        }];
        
        self.detailLabel = [[YYLabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), self.titleLabel.bottom, kDeviceWidth-kCurrentWidth(24), size.height)];
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        self.detailLabel.attributedText = text;
        [self addSubview:self.detailLabel];
        
        self.nextButton = [[ConfimButton alloc] initWithTop:self.detailLabel.bottom+kCurrentWidth(15) title:@"确认充值"];
        [self.nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nextButton];
        
        self.frame = CGRectMake(0, 0, kDeviceWidth, self.nextButton.bottom+kCurrentWidth(15));
    }
    return self;
}

- (void)nextButtonClick {
    if (_LBBConfimBlock) {
        _LBBConfimBlock();
    }
}

@end
