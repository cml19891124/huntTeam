//
//  PayPriceCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PayPriceCell.h"

@interface PayPriceCell ()

@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UIView *lineView;

@end

@implementation PayPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-kCurrentWidth(13), kCurrentWidth(45))];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.textColor = kLBBlackColor;
        _priceLabel.text = @"小计 0.00猎帮币";
        _priceLabel.font = kSystem(13);
        [self.contentView addSubview:_priceLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(45), kDeviceWidth, kCurrentWidth(10))];
        _lineView.backgroundColor = kBackgroundColor;
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)setPrice:(NSString *)price {
    _price = price;
    
    NSString *selectText = [NSString stringWithFormat:@"%.2f",[price floatValue]];
    NSString *allSelectText = [NSString stringWithFormat:@"小计 %.2f猎帮币",[price floatValue]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
    [attr addAttribute:NSFontAttributeName
                 value:kSystemBold(18)
                 range:[allSelectText rangeOfString:selectText]];
    _priceLabel.attributedText = attr;
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
