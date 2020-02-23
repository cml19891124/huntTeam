//
//  MechanismImageCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/11/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "MechanismImageCell.h"

@interface MechanismImageCell ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *iconButton;

@end

@implementation MechanismImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(100), kCurrentWidth(44))];
        _titleLabel.font = kSystem(14);
        _titleLabel.textColor = kLBBlackColor;
        [self.contentView addSubview:_titleLabel];

        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.frame = CGRectMake(kCurrentWidth(40), kCurrentWidth(44), kDeviceWidth-kCurrentWidth(80), kCurrentWidth(193));
        [_iconButton setBackgroundImage:[UIImage imageNamed:@"icon_yingyezhizhao"] forState:UIControlStateNormal];
        [_iconButton addTarget:self action:@selector(iconButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _iconButton.tag = 100;
        [self.contentView addSubview:_iconButton];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    if (!IsNilOrNull(image)) {
        _image = image;
        [_iconButton setBackgroundImage:image forState:UIControlStateNormal];
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    NSString *selectGameText = @"*";
    NSString *allSelectGameText = [[LBForProject currentProject].ORCertiCellTitleArray safeObjectAtIndex:indexPath.row];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectGameText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithHexString:@"FB3F3F"]
                 range:[allSelectGameText rangeOfString:selectGameText]];
    _titleLabel.attributedText = attr;
    
}

#pragma mark Event
- (void)iconButtonClick {
    if (_editSourceBlock) {
        _editSourceBlock();
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
