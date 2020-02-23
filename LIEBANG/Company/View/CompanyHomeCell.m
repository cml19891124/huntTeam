//
//  CompanyHomeCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CompanyHomeCell.h"

@interface CompanyHomeCell ()

@property (nonatomic,strong)UIImageView *icon;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UILabel *numberLabel;

@end

@implementation CompanyHomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.numberLabel];
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    self.icon.image = [UIImage imageNamed:[[[LBForProject currentProject].companyCellImageArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row]];
    self.contentLabel.text = [[[LBForProject currentProject].companyCellTitleArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    
    if ((indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 1 && indexPath.row == 3)) {
        self.numberLabel.hidden = NO;
    }
    else {
        self.numberLabel.hidden = YES;
    }
}

- (void)setDic:(NSDictionary *)dic {
    
    if (IsNilOrNull(dic) || ![dic isKindOfClass:[NSDictionary class]]) {
        self.numberLabel.text = @"0";
    }
    else {
        if (self.indexPath.section == 0 && self.indexPath.row == 0) {
            self.numberLabel.text = [NSString stringWithFormat:@"%d",[dic[@"enterpriseNum"] intValue]];
        }
        if (self.indexPath.section == 1 && self.indexPath.row == 3) {
            self.numberLabel.text = [NSString stringWithFormat:@"%d",[dic[@"collectionNum"] intValue]];
        }
    }
}

#pragma mark
#pragma mark UI
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(10), kCurrentWidth(10), kCurrentWidth(24), kCurrentWidth(24))];
    }
    return _icon;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right+kCurrentWidth(10), 0, kDeviceWidth-kCurrentWidth(150), kCurrentWidth(44))];
        _contentLabel.textColor = kLBBlackColor;
        _contentLabel.font = kSystem(14);
    }
    return _contentLabel;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(77), 0, kCurrentWidth(48), kCurrentWidth(44))];
        _numberLabel.textColor = kLBNineColor;
        _numberLabel.font = kSystem(14);
        _numberLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numberLabel;
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
