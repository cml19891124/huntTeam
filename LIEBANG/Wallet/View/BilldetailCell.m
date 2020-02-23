//
//  BilldetailCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/24.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "BilldetailCell.h"

@interface BilldetailCell ()

@property (nonatomic,strong)UILabel *typeLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *amountLabel;
@property (nonatomic,strong)UILabel *balanceLabel;
@property (nonatomic,strong)UIView *lineView;

@end

@implementation BilldetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)setWalletModel:(WalletModel *)walletModel {
    _walletModel = walletModel;
    
    _balanceLabel.text = [NSString stringWithFormat:@"余额:%.2f",[walletModel.balance floatValue]];
    _timeLabel.text = [[InsureValidate timeInStr:walletModel.createTime] substringToIndex:16];
    _typeLabel.text = walletModel.transactionStateName;
    
    if (IsNilOrNull(walletModel.transactionaMountNum) || IsStrEmpty(walletModel.transactionaMountNum)) {
        if ([walletModel.transactionstate isEqualToString:@"3"] || [walletModel.transactionstate isEqualToString:@"11"]) {//充值
            _amountLabel.text = [NSString stringWithFormat:@"+%.2f",[walletModel.transactionaMount floatValue]];
        }
        else {
            _amountLabel.text = [NSString stringWithFormat:@"-%.2f",[walletModel.transactionaMount floatValue]];
        }
    }
    else {
        _amountLabel.text = walletModel.transactionaMountNum;
    }
}

#pragma mark 界面布局
- (void)createSubViews {
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(12), kCurrentWidth(100), kCurrentWidth(20))];
    _typeLabel.textColor = [UIColor colorWithHexString:@"000000"];
    _typeLabel.font = kSystem(14);
    _typeLabel.text = @"交易付款";
    [self.contentView addSubview:_typeLabel];
    
    _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), _typeLabel.bottom, kCurrentWidth(100), kCurrentWidth(16))];
    _balanceLabel.textColor = kLBSixColor;
    _balanceLabel.font = kSystem(12);
    [self.contentView addSubview:_balanceLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(162), kCurrentWidth(12), kCurrentWidth(150), kCurrentWidth(20))];
    _timeLabel.textColor = kLBNineColor;
    _timeLabel.font = kSystem(12);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    
    _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(112), _timeLabel.bottom, kCurrentWidth(100), kCurrentWidth(20))];
    _amountLabel.textColor = [UIColor colorWithHexString:@"000000"];
    _amountLabel.font = kSystemBold(14);
    _amountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_amountLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(60)-0.5, kDeviceWidth, 0.5)];
    _lineView.backgroundColor = kSepparteLineColor;
    [self.contentView addSubview:_lineView];
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
