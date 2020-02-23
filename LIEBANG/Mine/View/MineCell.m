//
//  MineCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "MineCell.h"

@interface MineCell ()

@property (nonatomic,strong)UIImageView *mineImageView;
@property (nonatomic,strong)UILabel *mineTitleLabel;

@end

@implementation MineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.mineImageView];
        [self.contentView addSubview:self.mineTitleLabel];
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    self.mineImageView.image = [UIImage imageNamed:[[[LBForProject currentProject].mineCellImageArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row]];
    self.mineTitleLabel.text = [[[LBForProject currentProject].mineCellTitleArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
}

#pragma mark 懒加载
- (UIImageView *)mineImageView {
    if (!_mineImageView) {
        _mineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(19)/2, kCurrentWidth(23), kCurrentWidth(23))];
    }
    return _mineImageView;
}

- (UILabel *)mineTitleLabel {
    if (!_mineTitleLabel) {
        _mineTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.mineImageView.right+kCurrentWidth(11), 0, kCurrentWidth(200), kCurrentWidth(42))];
        _mineTitleLabel.font = kSystem(15);
        _mineTitleLabel.textColor = kLBBlackColor;
    }
    return _mineTitleLabel;
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
