//
//  BlackFriendCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/11.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "BlackFriendCell.h"

@interface BlackFriendCell ()

@property (nonatomic,strong)UIImageView *headIcon;
@property (nonatomic,strong)NameLabel *nameLabel;
@property (nonatomic,strong)PostionLabel *messageLabel;
@property (nonatomic,strong)UIButton *sureButton;

@property (nonatomic,strong)UILabel *timeLabel;

@end

@implementation BlackFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.headIcon];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.sureButton];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)setModel:(VisitorModel *)model {
    _model = model;
    
    self.messageLabel.userUid = model.userUid;
    self.nameLabel.userUid = model.userUid;
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:model.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    [self.nameLabel setNameString:model.userName showIcon:model.isBasic];
    self.messageLabel.labelWidth = kDeviceWidth-self.headIcon.right-kCurrentWidth(125);
    [self.messageLabel setCompany:model.company postion:model.position showIcon:model.isOccupation];
    self.timeLabel.text = model.userIndustry;
}

- (void)enterAccountEvent {
    if (_accountButtonBlock) {
        _accountButtonBlock(self.model);
    }
}

#pragma mark 懒加载
- (UIImageView *)headIcon {
    if (!_headIcon) {
        _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(20), kCurrentWidth(40), kCurrentWidth(40))];
        _headIcon.image = [UIImage imageNamed:@"no_headIcon"];
        _headIcon.layer.cornerRadius = kCurrentWidth(20);
        _headIcon.layer.masksToBounds = YES;
        _headIcon.userInteractionEnabled = YES;
        [_headIcon setContentScaleFactor:[[UIScreen mainScreen]scale]];
        _headIcon.contentMode = UIViewContentModeScaleAspectFill;
        _headIcon.autoresizingMask = UIViewAutoresizingNone;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterAccountEvent)];
        [_headIcon addGestureRecognizer:tap];
    }
    return _headIcon;
}

- (NameLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[NameLabel alloc] initWithFrame:CGRectMake(self.headIcon.right+kCurrentWidth(10), kCurrentWidth(15), kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20))];
        
        WeakSelf;
        _nameLabel.GetBasicCertiImageViewBlock = ^(NSString *imageUrl) {
            if (weakSelf.GetBasicSourceBlock) {
                weakSelf.GetBasicSourceBlock(imageUrl);
            }
        };
    }
    return _nameLabel;
}

- (PostionLabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[PostionLabel alloc] initWithFrame:CGRectMake(self.headIcon.right+kCurrentWidth(10), self.nameLabel.bottom, kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20))];
        _messageLabel.font = kSystem(12);
        _messageLabel.color = kLBSixColor;
        
        WeakSelf;
        _messageLabel.GetWorkCertiImageViewBlock = ^(NSString *imageUrl) {
            if (weakSelf.GetWorkSourceBlock) {
                weakSelf.GetWorkSourceBlock(imageUrl);
            }
        };
    }
    return _messageLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headIcon.right+kCurrentWidth(10), self.messageLabel.bottom, kDeviceWidth-kCurrentWidth(150), kCurrentWidth(16))];
        _timeLabel.font = kSystem(12);
        _timeLabel.textColor = kLBSixColor;
        _timeLabel.text = @"IT互联网 | 运营编辑";
    }
    return _timeLabel;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(98), kCurrentWidth(25), kCurrentWidth(85), kCurrentWidth(30));
        [_sureButton setTitle:@"移除黑名单" forState:UIControlStateNormal];
        [_sureButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"ffffff"]] forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius = kCurrentWidth(15);
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.borderColor = kLBRedColor.CGColor;
        _sureButton.layer.borderWidth = 0.5;
        _sureButton.titleLabel.font = kSystemBold(13);
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

#pragma mark Event
- (void)sureButtonClick {
    
    if (_sureButtonBlock) {
        _sureButtonBlock(_model);
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
