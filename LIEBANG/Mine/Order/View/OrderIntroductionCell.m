//
//  OrderIntroductionCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/4.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "OrderIntroductionCell.h"

@interface OrderIntroductionCell ()

@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *questionLabel;
@property (nonatomic,strong)UIView *lineView;

@end

@implementation OrderIntroductionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self createSubViews];
    }
    return self;
}

- (void)setDetailType:(QuestionDetailType)detailType {
    _detailType = detailType;
    
    if (detailType == QuestionDetailTypeStudent)
    {
        _titleLabel.text = @"我的个人简介";
    }
    else if (detailType == QuestionDetailTypeExpert)
    {
        _titleLabel.text = @"他的个人简介";
    }
}

- (void)setDetailModel:(ThemeOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
    CGSize size = [detailModel.askIntroduction sizeWithFont:kSystem(14) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), MAXFLOAT)];
    _questionLabel.text = detailModel.askIntroduction;
    _questionLabel.frame = CGRectMake(kCurrentWidth(12), _lineView.bottom+kCurrentWidth(15), kDeviceWidth-kCurrentWidth(24), size.height);
    self.height = _questionLabel.bottom+kCurrentWidth(15);
}

- (CGFloat)getCellHeight {
    return self.height;
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
    
    _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), _lineView.bottom+kCurrentWidth(9), kDeviceWidth-kCurrentWidth(24), kCurrentWidth(37))];
    _questionLabel.textColor = kLBNineColor;
    _questionLabel.font = kSystem(14);
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
