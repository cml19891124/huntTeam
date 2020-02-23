//
//  SafeCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "SafeCell.h"

@interface SafeCell ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *phoneLabel;

@end

@implementation SafeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.phoneLabel];
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    self.titleLabel.text = [[LBForProject currentProject].safeCellTitleArray safeObjectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        self.phoneLabel.hidden = NO;
        self.phoneLabel.text = [InsureValidate phonenum:[Config currentConfig].mobile];
    } else {
        self.phoneLabel.hidden = YES;
    }
}

#pragma mark 界面布局
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), 0, kCurrentWidth(100), kCurrentWidth(48))];
        _titleLabel.textColor = kLBBlackColor;
        _titleLabel.font = kSystem(15);
    }
    return _titleLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(130), 0, kCurrentWidth(100), kCurrentWidth(48))];
        _phoneLabel.textColor = kLBSixColor;
        _phoneLabel.font = kSystem(14);
        _phoneLabel.textAlignment = NSTextAlignmentRight;
    }
    return _phoneLabel;
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
