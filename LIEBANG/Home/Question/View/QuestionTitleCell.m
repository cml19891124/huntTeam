//
//  QuestionTitleCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "QuestionTitleCell.h"

@interface QuestionTitleCell ()

@property (nonatomic,strong)UIButton *typeLabel;
@property (nonatomic,strong)UILabel *messageLabel;

@property (nonatomic,strong)UIView *iconContenView;
@property (nonatomic,strong)UILabel *numberLabel;

@property (nonatomic,strong)UIButton *scanButton;

@end

@implementation QuestionTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _typeLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        _typeLabel.frame = CGRectMake(kDeviceWidth-kCurrentWidth(72), 0, kCurrentWidth(60), kCurrentWidth(19));
        [_typeLabel setBackgroundImage:[UIImage imageNamed:@"list_button_zaixianwenda"] forState:UIControlStateNormal];
        [_typeLabel setTitle:@"在线问答" forState:UIControlStateNormal];
        [_typeLabel setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _typeLabel.titleLabel.font = kSystem(12);
        _typeLabel.adjustsImageWhenHighlighted = NO;
        [self addSubview:_typeLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(30), kDeviceWidth-kCurrentWidth(24), kCurrentWidth(16))];
        _messageLabel.font = kSystem(15);
        _messageLabel.textColor = kBlackColor;
        _messageLabel.numberOfLines = 0;
        [self addSubview:_messageLabel];
        [self addSubview:self.numberLabel];
        [self addSubview:self.iconContenView];
        [self addSubview:self.scanButton];
    }
    return self;
}

- (void)setDetailModel:(QuestionOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
    _messageLabel.text = detailModel.quizcontent;
    
    CGSize size = [detailModel.quizcontent sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), MAXFLOAT)];
    
    if (size.height > 54) {
        if (self.isShowAllTitle)
        {
            _messageLabel.height = size.height;
        }
        else
        {
            _messageLabel.height = 54;
        }
        
        self.scanButton.top = _messageLabel.bottom+kCurrentWidth(10);
        self.scanButton.hidden = NO;
        self.height = self.scanButton.bottom+kCurrentWidth(15);
    }
    else {
        _messageLabel.height = size.height;
        self.scanButton.hidden = YES;
        self.height = _messageLabel.bottom+kCurrentWidth(15);
    }
    
    if ([detailModel.orderStates intValue] == 2 || [detailModel.orderStates intValue] == 3 || [detailModel.orderStates intValue] == 4) {
        self.isShowNum = YES;
    }
    else {
        self.isShowNum = NO;
    }
    
    if (self.isShowNum && [detailModel.viewNum integerValue] != 0) {
        
        self.numberLabel.text = [NSString stringWithFormat:@"%zd人查看：",[detailModel.viewNum integerValue]];
        CGSize numSize = [self.numberLabel.text sizeWithFont:kSystem(12) maxSize:CGSizeMake(MAXFLOAT, kCurrentWidth(23))];
        self.numberLabel.frame = CGRectMake(kCurrentWidth(12), _messageLabel.bottom+kCurrentWidth(10), numSize.width, kCurrentWidth(23));
        self.iconContenView.frame = CGRectMake(self.numberLabel.right, _messageLabel.bottom+kCurrentWidth(10), kDeviceWidth-self.numberLabel.right, kCurrentWidth(23));
        [self.iconContenView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.height = self.iconContenView.bottom+kCurrentWidth(15);
        
        NSInteger b = MIN(3, detailModel.viewUser.count);
        for (int i = 0; i < b; i ++) {
            NSDictionary *dict = [detailModel.viewUser safeObjectAtIndex:i];
            UIImageView *small = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(29)*i, 0, kCurrentWidth(23), kCurrentWidth(23))];
            [small sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"userHead"]] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
            small.layer.cornerRadius = kCurrentWidth(23)/2;
            small.layer.masksToBounds = YES;
            [self.iconContenView addSubview:small];
        }
    }
}

- (void)setModel:(QuestionDetailModel *)model {
    _model = model;
    
    _messageLabel.text = model.quizcontent;
    CGSize size = [model.quizcontent sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), MAXFLOAT)];
    
    
    if (size.height > 54) {
        if (self.isShowAllTitle)
        {
            _messageLabel.height = size.height;
        }
        else
        {
            _messageLabel.height = 54;
        }
        
        self.scanButton.top = _messageLabel.bottom+kCurrentWidth(10);
        self.scanButton.hidden = NO;
        self.height = self.scanButton.bottom+kCurrentWidth(15);
    }
    else {
        _messageLabel.height = size.height;
        self.scanButton.hidden = YES;
        self.height = _messageLabel.bottom+kCurrentWidth(15);
    }
    
    if (self.isShowNum && [model.viewNum integerValue] != 0) {
        
        self.numberLabel.text = [NSString stringWithFormat:@"%zd人查看：",[model.viewNum integerValue]];
        CGSize numSize = [self.numberLabel.text sizeWithFont:kSystem(12) maxSize:CGSizeMake(MAXFLOAT, kCurrentWidth(23))];
        self.numberLabel.frame = CGRectMake(kCurrentWidth(12), _messageLabel.bottom+kCurrentWidth(10), numSize.width, kCurrentWidth(23));
        self.iconContenView.frame = CGRectMake(self.numberLabel.right, _messageLabel.bottom+kCurrentWidth(10), kDeviceWidth-self.numberLabel.right, kCurrentWidth(23));
        [self.iconContenView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.height = self.iconContenView.bottom+kCurrentWidth(15);
        
        NSInteger b = MIN(3, model.viewUser.count);
        for (int i = 0; i < b; i ++) {
            NSDictionary *dict = [model.viewUser safeObjectAtIndex:i];
            UIImageView *small = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(29)*i, 0, kCurrentWidth(23), kCurrentWidth(23))];
            [small sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"userHead"]] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
            small.layer.cornerRadius = kCurrentWidth(23)/2;
            small.layer.masksToBounds = YES;
            [self.iconContenView addSubview:small];
        }
    }
}

- (UIView *)iconContenView {
    if (!_iconContenView) {
        _iconContenView = [[UIView alloc] initWithFrame:CGRectZero];
        _iconContenView.backgroundColor = kWhiteColor;
    }
    return _iconContenView;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLabel.font = kSystem(12);
        _numberLabel.textColor = kLBSixColor;
    }
    return _numberLabel;
}

- (UIButton *)scanButton {
    if (!_scanButton) {
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(82), 0, kCurrentWidth(70), kCurrentWidth(23));
        [_scanButton setTitle:@"展开全部" forState:UIControlStateNormal];
        [_scanButton setTitle:@"收起全部" forState:UIControlStateSelected];
        _scanButton.titleLabel.font = kSystem(14);
        [_scanButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
        _scanButton.layer.cornerRadius = kCurrentWidth(11.5);
        _scanButton.layer.masksToBounds = YES;
        _scanButton.layer.borderColor = kLBRedColor.CGColor;
        _scanButton.layer.borderWidth = 0.5;
        _scanButton.hidden = YES;
        [_scanButton addTarget:self action:@selector(scanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanButton;
}

- (void)scanButtonClick {
    self.scanButton.selected = !self.scanButton.selected;
    if (self.questionButtonBlock) {
        self.questionButtonBlock(self.scanButton.selected);
    }
}

- (CGFloat)cellHeight {
    return self.height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
