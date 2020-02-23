//
//  AccountThemeCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/23.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountThemeCell.h"

@interface AccountThemeCell ()

@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *priceLabel;

@end

@implementation AccountThemeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(44)-0.5, kDeviceWidth, 0.5)];
        _lineView.backgroundColor = kSepparteLineColor;
        [self.contentView addSubview:_lineView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0.5, kDeviceWidth-kCurrentWidth(100), kCurrentWidth(44)-1)];
        _titleLabel.textColor = kLBSixColor;
        _titleLabel.font = kSystem(14);
        [self.contentView addSubview:_titleLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(92), _titleLabel.top, kCurrentWidth(80), kCurrentWidth(44)-1)];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.textColor = kLBSixColor;
        _priceLabel.font = kSystem(14);
        _priceLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_priceLabel];
    }
    return self;
}

- (void)setThemeModel:(ThemeClassModel *)themeModel {
    _themeModel = themeModel;
    
    _titleLabel.text = themeModel.topicName;
    _priceLabel.text = [NSString stringWithFormat:@"%.2f猎帮币/次",themeModel.topicPrice.doubleValue];
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
