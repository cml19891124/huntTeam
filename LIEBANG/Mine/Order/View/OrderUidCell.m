//
//  OrderUidCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/4.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "OrderUidCell.h"

@interface OrderUidCell ()

@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *questionLabel;
@property (nonatomic,strong)UIView *lineView;

@end

@implementation OrderUidCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self createSubViews];
    }
    return self;
}

- (void)setDetailModel:(ThemeOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
    _titleLabel.text = [NSString stringWithFormat:@"订单编号:%@",detailModel.orderUid];
    _questionLabel.text = [NSString stringWithFormat:@"发起时间:%@",[InsureValidate timeInStr:detailModel.createTime]];
}

- (void)createSubViews {
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(10))];
    _backView.backgroundColor = kBackgroundColor;
    [self.contentView addSubview:_backView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), _backView.bottom, kDeviceWidth-kCurrentWidth(24), kCurrentWidth(42))];
    _titleLabel.textColor = kLBBlackColor;
    _titleLabel.font = kSystem(15);
    [self.contentView addSubview:_titleLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom, kDeviceWidth, 0.5)];
    _lineView.backgroundColor = kSepparteLineColor;
    [self.contentView addSubview:_lineView];
    
    _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), _lineView.bottom, kDeviceWidth-kCurrentWidth(24), kCurrentWidth(42))];
    _questionLabel.textColor = kLBBlackColor;
    _questionLabel.font = kSystem(15);
    _questionLabel.numberOfLines = 0;
    [self.contentView addSubview:_questionLabel];
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
