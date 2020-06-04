//
//  WalletHeadCell.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/30.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "WalletHeadCell.h"

@interface WalletHeadCell ()

@property (nonatomic,strong)UIImageView *markImageView;
@property (nonatomic,strong)UIButton *sureButton;
@property (nonatomic,strong)UILabel *balanceLabel;

@end

@implementation WalletHeadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(10), kCurrentWidth(17.5), kCurrentWidth(25), kCurrentWidth(25))];
        [self.contentView addSubview:self.markImageView];
        
        self.balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.markImageView.right+kCurrentWidth(10), 0, kCurrentWidth(200), kCurrentWidth(60))];
        self.balanceLabel.numberOfLines = 0;
        self.balanceLabel.textColor = kLBThreeColor;
        self.balanceLabel.font = kSystem(15);
        [self.contentView addSubview:self.balanceLabel];
        
        self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(76), kCurrentWidth(15), kCurrentWidth(64), kCurrentWidth(30));
        self.sureButton.layer.cornerRadius = 2;
        self.sureButton.layer.masksToBounds = YES;
        self.sureButton.backgroundColor = kLBRedColor;
        [self.sureButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        self.sureButton.titleLabel.font = kSystem(12);
        [self.sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.sureButton];
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    if (indexPath.section == 0) {
        NSString *allString = [NSString stringWithFormat:@"猎帮币余额 %.2f\n此余额只能在iOS客户端使用，不可提现",[[Config currentConfig].liebangCurrency floatValue]];
        
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:allString attributes:nil]];
        text.yy_color = kLBThreeColor;
        text.yy_font = kSystemBold(16);
        [text yy_setFont:kSystem(10) range:[allString rangeOfString:@"此余额只能在iOS客户端使用，不可提现"]];
        [text yy_setFont:kSystem(15) range:[allString rangeOfString:@"猎帮币余额"]];
        [text yy_setColor:kBlackColor range:[allString rangeOfString:@"猎帮币余额"]];
        [text yy_setColor:kLBNineColor range:[allString rangeOfString:@"此余额只能在IOS客户端使用，不可提现"]];
        self.balanceLabel.attributedText = text;
        [self.sureButton setTitle:@"充值" forState:UIControlStateNormal];
        self.markImageView.image = [UIImage imageNamed:@"logo_liebangbi"];
    }
}

- (void)sureButtonClick {
    if (self.indexPath.section == 0) {
        if (_rechargeButtonBlock) {
            _rechargeButtonBlock();
        }
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
