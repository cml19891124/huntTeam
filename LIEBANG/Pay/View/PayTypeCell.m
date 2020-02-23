//
//  PayTypeCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PayTypeCell.h"

@interface PayTypeCell ()

@property (nonatomic,strong)UIImageView *titleIcon;
@property (nonatomic,strong)YYLabel *titleLabel;
@property (nonatomic,strong)UIButton *selectButton;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIButton *sureButton;

@end

@implementation PayTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
        _lineView.backgroundColor = kSepparteLineColor;
        [self.contentView addSubview:_lineView];
        
        _titleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(13), kCurrentWidth(16), kCurrentWidth(23), kCurrentWidth(23))];
        [self.contentView addSubview:_titleIcon];
        
        _titleLabel = [[YYLabel alloc] initWithFrame:CGRectMake(_titleIcon.right+kCurrentWidth(10), _lineView.bottom, kDeviceWidth-kCurrentWidth(130), kCurrentWidth(54.5))];
        _titleLabel.textColor = kLBSixColor;
        _titleLabel.font = kSystemBold(15);
        _titleLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(42), kCurrentWidth(10), kCurrentWidth(42), kCurrentWidth(35));
        [_selectButton setImage:[UIImage imageNamed:@"list_btn_normal"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"list_button_select"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_selectButton];
        
        self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(76), kCurrentWidth(12), kCurrentWidth(64), kCurrentWidth(30));
        self.sureButton.layer.cornerRadius = 3;
        self.sureButton.layer.masksToBounds = YES;
        self.sureButton.backgroundColor = kLBRedColor;
        [self.sureButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        self.sureButton.titleLabel.font = kSystem(15);
        [self.sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.sureButton setTitle:@"充值" forState:UIControlStateNormal];
        self.sureButton.hidden = YES;
        [self.contentView addSubview:self.sureButton];
    }
    return self;
}

- (void)sureButtonClick {
    if (_rechargeButtonBlock) {
        _rechargeButtonBlock();
    }
}

- (void)selectButtonClick {
    _selectButton.selected = !_selectButton.selected;
    if (_usePayTypeBlock) {
        _usePayTypeBlock();
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    
    if (_indexPath.row == selectIndex) {
        _selectButton.selected = YES;
    }
    else {
        _selectButton.selected = NO;
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    if (indexPath.row == 0)
    {
        _titleLabel.hidden = YES;
        _titleIcon.hidden = YES;
        _selectButton.hidden = YES;
        _titleLabel.text = @"支付宝";
        _titleIcon.image = [UIImage imageNamed:@"list_icon_zhifubao"];
    }
    else if (indexPath.row == 1)
    {
//        _titleLabel.hidden = ![WXApi isWXAppInstalled];
//        _titleIcon.hidden = ![WXApi isWXAppInstalled];
//        _selectButton.hidden = ![WXApi isWXAppInstalled];
        _titleLabel.hidden = YES;
        _titleIcon.hidden = YES;
        _selectButton.hidden = YES;
        _titleLabel.text = @"微信支付";
        _titleIcon.image = [UIImage imageNamed:@"list_icon_weixinzhifu"];
        
    }
    else if (indexPath.row == 2)
    {
        if ([[Config currentConfig].liebangCurrency floatValue] >= [self.payPrice floatValue])
        {
            NSString *allString = [NSString stringWithFormat:@"余额 %.2f猎帮币",[[Config currentConfig].liebangCurrency floatValue]];
            NSMutableAttributedString *text = [NSMutableAttributedString new];
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:allString attributes:nil]];
            text.yy_color = kRedColor;
            text.yy_font = kSystemBold(18);
            [text yy_setColor:kLBNineColor range:[allString rangeOfString:@"余额"]];
            [text yy_setFont:kSystemBold(15) range:[allString rangeOfString:@"余额"]];
            [text yy_setFont:kSystem(12) range:[allString rangeOfString:@"猎帮币"]];
            self.sureButton.hidden = YES;
            self.selectButton.hidden = NO;
            _titleLabel.attributedText = text;
        }
        else
        {
            NSString *allString = [NSString stringWithFormat:@"余额 %.2f猎帮币（余额不足，请充值）",[[Config currentConfig].liebangCurrency floatValue]];
            NSMutableAttributedString *text = [NSMutableAttributedString new];
            [text appendAttributedString:[[NSAttributedString alloc] initWithString:allString attributes:nil]];
            text.yy_color = kRedColor;
            text.yy_font = kSystemBold(18);
            [text yy_setColor:kLBNineColor range:[allString rangeOfString:@"余额"]];
            [text yy_setFont:kSystemBold(15) range:[allString rangeOfString:@"余额"]];
            [text yy_setFont:kSystem(12) range:[allString rangeOfString:@"猎帮币（余额不足，请充值）"]];
            self.sureButton.hidden = NO;
            self.selectButton.hidden = YES;
            _titleLabel.attributedText = text;
        }
        
        _titleIcon.image = [UIImage imageNamed:@"logo_liebangbi"];
    }
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
