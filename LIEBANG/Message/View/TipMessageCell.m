//
//  TipMessageCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "TipMessageCell.h"

@interface TipMessageCell ()

@property (nonatomic,strong)UIImageView *mineImageView;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UILabel *numberLabel;

@end

@implementation TipMessageCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(60));
        self.backgroundColor = kBackgroundColor;
        [self addSubview:self.mineImageView];
        [self addSubview:self.messageLabel];
        [self addSubview:self.numberLabel];
    }
    return self;
}

- (void)setReadCount:(NSInteger)readCount {
    _readCount = readCount;
    
    NSString *selectText = [NSString stringWithFormat:@"%zd",readCount];
    NSString *allSelectText = [NSString stringWithFormat:@"%zd个请求待处理事项",readCount];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:kLBRedColor
                 range:[allSelectText rangeOfString:selectText]];
    self.numberLabel.attributedText = attr;
}

#pragma mark 界面布局
- (UIImageView *)mineImageView {
    if (!_mineImageView) {
        _mineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(11), kCurrentWidth(38), kCurrentWidth(38))];
        _mineImageView.image = [UIImage imageNamed:@"list_button_shixiang.png"];
    }
    return _mineImageView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.mineImageView.right+kCurrentWidth(10), kCurrentWidth(14), kCurrentWidth(150), kCurrentWidth(18))];
        _messageLabel.font = kSystem(14);
        _messageLabel.textColor = kLBBlackColor;
        _messageLabel.text = @"待处理事项";
    }
    return _messageLabel;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        
        NSString *selectText = @"0";
        NSString *allSelectText = @"0个请求待处理事项";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
        [attr addAttribute:NSForegroundColorAttributeName
                     value:kLBRedColor
                     range:[allSelectText rangeOfString:selectText]];
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.mineImageView.right+kCurrentWidth(10), self.messageLabel.bottom, kCurrentWidth(150), kCurrentWidth(14))];
        _numberLabel.font = kSystem(11);
        _numberLabel.textColor = kLBNineColor;
        _numberLabel.attributedText = attr;
    }
    return _numberLabel;
}

@end
