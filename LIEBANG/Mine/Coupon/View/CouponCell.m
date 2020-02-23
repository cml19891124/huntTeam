//
//  CouponCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/11.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CouponCell.h"

@interface CouponCell ()

@property (nonatomic,strong)UIView *backImageView;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UILabel *msgLabel;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UILabel *typeLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIButton *sureButton;

@end

@implementation CouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)setCouponModel:(CouponListModel *)couponModel {
    _couponModel = couponModel;
    
    _typeLabel.text = couponModel.classify;
    _timeLabel.text = [NSString stringWithFormat:@"%@-%@",[[InsureValidate timeInStr2:couponModel.beginTime] substringToIndex:10],[[InsureValidate timeInStr2:couponModel.endTime] substringToIndex:10]];
    
    if ([couponModel.couponType intValue] == 1) {
        _priceLabel.text = @"免单";
        _priceLabel.font = kSystem(21);
        _messageLabel.text = [NSString stringWithFormat:@"低于%.2f猎帮币使用",couponModel.fullMoney.floatValue];
        _priceLabel.frame = CGRectMake(0, kCurrentWidth(5), kCurrentWidth(110), kCurrentWidth(29));
        _msgLabel.frame = CGRectMake(0, _priceLabel.bottom, kCurrentWidth(110), kCurrentWidth(12));
    }
    else {
        _priceLabel.font = kSystemBold(30);
        _priceLabel.text = [NSString stringWithFormat:@"%.2f",[couponModel.offMoney floatValue]];
        _messageLabel.text = [NSString stringWithFormat:@"满%.2f猎帮币使用",couponModel.fullMoney.floatValue];
        _priceLabel.frame = CGRectMake(0, kCurrentWidth(10), kCurrentWidth(110), kCurrentWidth(29));
        _msgLabel.frame = CGRectMake(0, _priceLabel.bottom, kCurrentWidth(110), 0);
    }
    _messageLabel.top = _msgLabel.bottom;
}

- (void)setCouponState:(CouponCellState)couponState {
    _couponState = couponState;
    
    if (couponState == SureButtonStateNormal)
    {
        self.sureButton.hidden = NO;
        self.backImageView.backgroundColor = [UIColor colorWithHexString:@"EAF2F8"];
    }
    else if (couponState == SureButtonStateDisabled)
    {
        self.sureButton.hidden = YES;
        self.backImageView.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    }
}

- (void)sureButtonClick {
    if (_sureButtonBlock) {
        _sureButtonBlock(_couponModel);
    }
}

#pragma mark 界面布局
- (void)createSubViews {
    
    _backImageView = [[UIView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kDeviceWidth-kCurrentWidth(24), kCurrentWidth(70))];
    _backImageView.backgroundColor = [UIColor colorWithHexString:@"EAF2F8"];
    _backImageView.layer.cornerRadius = 2;
    _backImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_backImageView];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCurrentWidth(10), kCurrentWidth(110), kCurrentWidth(29))];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.text = @"0";
    _priceLabel.textColor = kLBBlackColor;
    _priceLabel.font = kSystemBold(30);
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    [self.backImageView addSubview:_priceLabel];
    
    _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _priceLabel.bottom, kCurrentWidth(110), 0)];
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    _msgLabel.text = @"(需支付0.01猎帮币)";
    _msgLabel.textColor = kLBBlackColor;
    _msgLabel.font = kSystem(10);
    _msgLabel.adjustsFontSizeToFitWidth = YES;
    [self.backImageView addSubview:_msgLabel];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _msgLabel.bottom, kCurrentWidth(110), kCurrentWidth(20))];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.text = @"满0猎帮币使用";
    _messageLabel.textColor = kLBBlackColor;
    _messageLabel.font = kSystem(12);
    _messageLabel.adjustsFontSizeToFitWidth = YES;
    [self.backImageView addSubview:_messageLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(kCurrentWidth(117), kCurrentWidth(9), 0.5, kCurrentWidth(50))];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"C6DCEC"];
    [self.backImageView addSubview:_lineView];
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_lineView.right+kCurrentWidth(14), kCurrentWidth(10), kCurrentWidth(150), kCurrentWidth(20))];
    _typeLabel.textColor = kLBSixColor;
    _typeLabel.font = kSystem(14);
    [self.backImageView addSubview:_typeLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_lineView.right+kCurrentWidth(14), _typeLabel.bottom+kCurrentWidth(5), kCurrentWidth(150), kCurrentWidth(13))];
    _timeLabel.textColor = kLBSixColor;
    _timeLabel.font = kSystem(11);
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    [self.backImageView addSubview:_timeLabel];
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = CGRectMake(_backImageView.width-kCurrentWidth(67), kCurrentWidth(15), kCurrentWidth(57), kCurrentWidth(21));
    _sureButton.backgroundColor = kLBRedColor;
    [_sureButton setTitle:@"立即使用" forState:UIControlStateNormal];
    [_sureButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _sureButton.titleLabel.font = kSystem(11);
    _sureButton.layer.cornerRadius = kCurrentWidth(21)/2;
    _sureButton.layer.masksToBounds = YES;
    [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backImageView addSubview:_sureButton];
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
