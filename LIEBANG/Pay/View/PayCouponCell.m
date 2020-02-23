//
//  PayCouponCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PayCouponCell.h"

@interface PayCouponCell ()

@property (nonatomic,strong)UIImageView *titleIcon;
@property (nonatomic,strong)UIImageView *markIcon;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIView *markView;

@end

@implementation PayCouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(10))];
        _markView.backgroundColor = kBackgroundColor;
        [self.contentView addSubview:_markView];
        
        _titleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(10), kCurrentWidth(14), kCurrentWidth(45))];
        _titleIcon.image = [UIImage imageNamed:@"list_icon_youhuiquan"];
        _titleIcon.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_titleIcon];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleIcon.right+kCurrentWidth(10), kCurrentWidth(10), kCurrentWidth(100), kCurrentWidth(45))];
        _titleLabel.text = @"优惠券";
        _titleLabel.textColor = kLBBlackColor;
        _titleLabel.font = kSystem(13);
        [self.contentView addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(174), kCurrentWidth(10), kCurrentWidth(150), kCurrentWidth(45))];
        _priceLabel.text = @"未选择优惠券";
        _priceLabel.textColor = kLBSixColor;
        _priceLabel.font = kSystem(13);
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_priceLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(55)-0.5, kDeviceWidth, 0.5)];
        _lineView.backgroundColor = kSepparteLineColor;
        [self.contentView addSubview:_lineView];
        
        _markIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(19), kCurrentWidth(10), kCurrentWidth(6), kCurrentWidth(45))];
        _markIcon.image = [UIImage imageNamed:@"list_btn_enter"];
        _markIcon.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_markIcon];
    }
    return self;
}

- (void)setModel:(CouponListModel *)model {
    _model = model;
    
    if (IsNilOrNull(model)) {
        _priceLabel.text = @"未选择优惠券";
    }
    else {
        
        if ([model.couponType intValue] == 1) {
            _priceLabel.text = @"免单(需支付0.01猎帮币)";
        }
        else {
            _priceLabel.text = [NSString stringWithFormat:@"-%.2f猎帮币",[model.offMoney floatValue]];
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
