//
//  LBBHeadView.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/29.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "LBBHeadView.h"
#import "LBButton.h"

@interface LBBHeadView ()

@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSArray *IDdataArray;
@property (nonatomic,assign)NSInteger selectIndex;

@property (nonatomic,strong)UIImageView *markImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *tipLabel;
@property (nonatomic,strong)YYLabel *yueLabel;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UILabel *messageLabel;

@end

@implementation LBBHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(315));
        self.dataArray = @[@"6",@"30",@"60",@"108",@"298",@"518",@"998",@"1998",@"2998"];
        self.IDdataArray = @[@"com.yiqi.LIEBANG.chongzhibi6",
                             @"com.yiqi.LIEBANG.chongzhibi30",
                             @"com.yiqi.LIEBANG.chongzhibi60",
                             @"com.yiqi.LIEBANG.chongzhibi108",
                             @"com.yiqi.LIEBANG.chongzhibi298",
                             @"com.yiqi.LIEBANG.chongzhibi518",
                             @"com.yiqi.LIEBANG.chongzhibi998",
                             @"com.yiqi.LIEBANG.chongzhibi1998",
                             @"com.yiqi.LIEBANG.chongzhibi2998"];
        [self addSubview:self.lineView];
        [self addSubview:self.markImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.tipLabel];
        [self addSubview:self.yueLabel];
        [self addSubview:self.messageLabel];
        self.selectIndex = 0;
    }
    return self;
}

- (void)senderButtonClick:(UIButton *)sender {
    self.selectIndex = sender.tag-100;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    for (int i = 0; i < dataArray.count; i ++) {
        LBButton *sender = [[LBButton alloc] initWithFrame:CGRectMake(kCurrentWidth(15)+kCurrentWidth(115)*(i%3), self.lineView.bottom+kCurrentWidth(32)+kCurrentWidth(71)*(i/3), kCurrentWidth(110), kCurrentWidth(66))];
        sender.titleString = [dataArray safeObjectAtIndex:i];
        sender.tag = 100+i;
        [sender addTarget:self action:@selector(senderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sender];
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    
    for (int i = 0; i < self.dataArray.count; i++) {
        LBButton *sender = [self viewWithTag:100+i];
        sender.selected = NO;
    }
    LBButton *button = [self viewWithTag:100+selectIndex];
    button.selected = YES;
    self.selectProduct = [self.IDdataArray safeObjectAtIndex:selectIndex];
    NSLog(@"充值的产品ID == %zd == %@",selectIndex,self.selectProduct);
}

- (void)refreshLiebangCurrency {
    NSString *allString = [NSString stringWithFormat:@"%.2f猎帮币",[[Config currentConfig].liebangCurrency floatValue]];
    NSString *selectString = [NSString stringWithFormat:@"%.2f",[[Config currentConfig].liebangCurrency floatValue]];
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:allString attributes:nil]];
    text.yy_color = kLBRedColor;
    [text yy_setFont:kSystemBold(20) range:[allString rangeOfString:selectString]];
    [text yy_setFont:kSystem(12) range:[allString rangeOfString:@"猎帮币"]];
    self.yueLabel.attributedText = text;
    self.yueLabel.textAlignment = NSTextAlignmentRight;
}

#pragma mark
#pragma mark UI
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(60), kDeviceWidth, 0.5)];
        _lineView.backgroundColor = kSepparteLineColor;
    }
    return _lineView;
}

- (UIImageView *)markImageView {
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(18), kCurrentWidth(25), kCurrentWidth(25))];
        _markImageView.image = [UIImage imageNamed:@"logo_liebangbi"];
    }
    return _markImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.markImageView.right+kCurrentWidth(10), kCurrentWidth(16), kCurrentWidth(180), kCurrentWidth(18))];
        _titleLabel.text = @"猎帮币余额";
//        _titleLabel.textColor = kLBThreeColor;
        _titleLabel.font = kSystem(15);
    }
    return _titleLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.markImageView.right+kCurrentWidth(10), self.titleLabel.bottom, 190, kCurrentWidth(7))];
        _tipLabel.text = @"此余额只能在iOS客户端使用，不可提现";
        _tipLabel.textColor = kLBNineColor;
        _tipLabel.font = kSystem(10);
    }
    return _tipLabel;
}

- (YYLabel *)yueLabel {
    if (!_yueLabel) {
        
        NSString *allString = [NSString stringWithFormat:@"%.2f猎帮币",[[Config currentConfig].liebangCurrency floatValue]];
        NSString *selectString = [NSString stringWithFormat:@"%.2f",[[Config currentConfig].liebangCurrency floatValue]];
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:allString attributes:nil]];
        text.yy_color = kLBRedColor;
        [text yy_setFont:kSystemBold(20) range:[allString rangeOfString:selectString]];
        [text yy_setFont:kSystem(12) range:[allString rangeOfString:@"猎帮币"]];
        
        _yueLabel = [[YYLabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(132), 0, kCurrentWidth(120), kCurrentWidth(60))];
        _yueLabel.textColor = kLBRedColor;
        _yueLabel.attributedText = text;
        _yueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _yueLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(10), self.lineView.bottom+kCurrentWidth(10), kDeviceWidth-kCurrentWidth(20), kCurrentWidth(18))];
        _messageLabel.textColor = kLBNineColor;
        _messageLabel.font = kSystem(12);
        _messageLabel.text = @"苹果应用内充值";
    }
    return _messageLabel;
}

@end
