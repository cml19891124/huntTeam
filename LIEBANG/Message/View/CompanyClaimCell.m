//
//  CompanyClaimCell.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/3.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "CompanyClaimCell.h"

@interface CompanyClaimCell ()

@property (nonatomic,strong)UIImageView *headIcon;
@property (nonatomic,strong)NameLabel *nameLabel;
@property (nonatomic,strong)PostionLabel *messageLabel;
@property (nonatomic,strong)UIButton *sureButton;

@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIButton *closeButton;
@property (nonatomic,strong)UIButton *confimButton;

@end

@implementation CompanyClaimCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headIcon];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.sureButton];
        [self.contentView addSubview:self.closeButton];
        [self.contentView addSubview:self.confimButton];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)setStallModel:(PendStallModel *)stallModel {
    _stallModel = stallModel;
    
    self.messageLabel.userUid = stallModel.userUid;
    self.nameLabel.userUid = stallModel.userUid;
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:stallModel.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    [self.nameLabel setNameString:[NSString stringWithFormat:@"认领请求：%@",stallModel.userName] showIcon:stallModel.isBasic];
    self.messageLabel.labelWidth = kDeviceWidth-self.nameLabel.left-kCurrentWidth(105);
    [self.messageLabel setCompany:nil postion:stallModel.position showIcon:stallModel.isOccupation];
    self.timeLabel.text = [NSString stringWithFormat:@"申请企业：%@",stallModel.companyAbbreviation];
    
    if ([stallModel.status intValue] == 0)
    {
        [self allButtonHidden:NO];
    }
    else if ([stallModel.status intValue] == 1)
    {
        [self allButtonHidden:YES];
        self.sureButton.enabled = NO;
        [self.sureButton setTitle:@"已同意" forState:UIControlStateDisabled];
    }
    else if ([stallModel.status intValue] == 2)
    {
        [self allButtonHidden:YES];
        self.sureButton.enabled = NO;
        [self.sureButton setTitle:@"已拒绝" forState:UIControlStateDisabled];
    }
}

- (void)allButtonHidden:(BOOL)disabled {
    self.closeButton.hidden = disabled;
    self.confimButton.hidden = disabled;
    self.sureButton.hidden = !disabled;
}

#pragma mark Events
- (void)closeButtonClick {
    if (_closeButtonBlock) {
        _closeButtonBlock(_stallModel);
    }
}

- (void)confimButtonClick {
    if (_confimButtonBlock) {
        _confimButtonBlock(_stallModel);
    }
}

//- (void)sureButtonClick {
//    if (_sureButtonBlock) {
//        _sureButtonBlock(_friendModel);
//    }
//}

#pragma mark 懒加载
- (UIImageView *)headIcon {
    if (!_headIcon) {
        _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(15), kCurrentWidth(40), kCurrentWidth(40))];
        _headIcon.image = [UIImage imageNamed:@"no_headIcon"];
        _headIcon.layer.cornerRadius = kCurrentWidth(20);
        _headIcon.layer.masksToBounds = YES;
        [_headIcon setContentScaleFactor:[[UIScreen mainScreen]scale]];
        _headIcon.contentMode = UIViewContentModeScaleAspectFill;
        _headIcon.autoresizingMask = UIViewAutoresizingNone;
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
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headIcon.right+kCurrentWidth(10), self.messageLabel.bottom, kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20))];
        _timeLabel.font = kSystem(12);
        _timeLabel.textColor = kLBBlackColor;
    }
    return _timeLabel;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(62), kCurrentWidth(29), kCurrentWidth(50), kCurrentWidth(25));
        [_sureButton setTitle:@"+好友" forState:UIControlStateNormal];
        [_sureButton setTitle:@"已申请" forState:UIControlStateDisabled];
        [_sureButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
        [_sureButton setTitleColor:kLBSixColor forState:UIControlStateDisabled];
        [_sureButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"ffffff"]] forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"dddddd"]] forState:UIControlStateDisabled];
        _sureButton.layer.cornerRadius = kCurrentWidth(25)/2;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.titleLabel.font = kSystem(13);
//        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)confimButton {
    if (!_confimButton) {
        _confimButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confimButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(40), kCurrentWidth(55)/2, kCurrentWidth(28), kCurrentWidth(28));
        [_confimButton setBackgroundImage:[UIImage imageNamed:@"company_sure"] forState:UIControlStateNormal];
        [_confimButton addTarget:self action:@selector(confimButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confimButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(83), kCurrentWidth(55)/2, kCurrentWidth(28), kCurrentWidth(28));
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"company_cancel"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
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
