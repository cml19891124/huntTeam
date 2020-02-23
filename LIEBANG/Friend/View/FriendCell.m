//
//  FriendCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "FriendCell.h"

@interface FriendCell ()

@property (nonatomic,strong)UIImageView *headIcon;
@property (nonatomic,strong)NameLabel *nameLabel;
@property (nonatomic,strong)PostionLabel *messageLabel;

@end

@implementation FriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headIcon];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.messageLabel];
    }
    return self;
}

- (void)setFriendModel:(FriendModel *)friendModel {
    _friendModel = friendModel;
    
    self.messageLabel.userUid = friendModel.userUid;
    self.nameLabel.userUid = friendModel.userUid;
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:friendModel.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    [self.nameLabel setNameString:friendModel.userName showIcon:friendModel.isBasic];
    
    NSString *position = [NSString stringWithFormat:@"%@%@",friendModel.company?:@"",friendModel.position?:@""];
    if ([friendModel.isOccupation isEqualToString:@"0"]) {
        self.messageLabel.labelWidth = BoundWithSize(position, kDeviceWidth, 13).size.width + 15;

    }else{
        self.messageLabel.labelWidth = kDeviceWidth-self.nameLabel.left-kCurrentWidth(12);

    }
//    [self.messageLabel setCompany:friendModel.company postion:friendModel.position showIcon:friendModel.isOccupation];
    NSString *name = [NSString stringWithFormat:@"%@%@",friendModel.company?:@"",friendModel.position?:@""];
    [self.messageLabel setCompany:@"" postion:name.length >0?name:@"未完善公司和职位信息" showIcon:friendModel.isOccupation];
    WeakSelf;
    self.messageLabel.GetWorkCertiImageViewBlock = ^(NSString *imageUrl) {
        if (weakSelf.GetWorkSourceBlock) {
            weakSelf.GetWorkSourceBlock(imageUrl);
        }
    };
    self.nameLabel.GetBasicCertiImageViewBlock = ^(NSString *imageUrl) {
        if (weakSelf.GetBasicSourceBlock) {
            weakSelf.GetBasicSourceBlock(imageUrl);
        }
    };
}

#pragma mark 懒加载
- (UIImageView *)headIcon {
    if (!_headIcon) {
        _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(35)/2, kCurrentWidth(25), kCurrentWidth(25))];
        _headIcon.image = [UIImage imageNamed:@"no_headIcon"];
        _headIcon.layer.cornerRadius = kCurrentWidth(25)/2;
        _headIcon.layer.masksToBounds = YES;
        [_headIcon setContentScaleFactor:[[UIScreen mainScreen]scale]];
        _headIcon.contentMode = UIViewContentModeScaleAspectFill;
        _headIcon.autoresizingMask = UIViewAutoresizingNone;
    }
    return _headIcon;
}

- (NameLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[NameLabel alloc] initWithFrame:CGRectMake(self.headIcon.right+kCurrentWidth(10), kCurrentWidth(10), kDeviceWidth-kCurrentWidth(60), kCurrentWidth(25))];
    }
    return _nameLabel;
}

- (PostionLabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[PostionLabel alloc] initWithFrame:CGRectMake(self.headIcon.right+kCurrentWidth(10), self.nameLabel.bottom, kDeviceWidth-kCurrentWidth(60), kCurrentWidth(15))];
        _messageLabel.font = kSystem(12);
        _messageLabel.color = kLBSixColor;
    }
    return _messageLabel;
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
