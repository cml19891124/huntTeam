//
//  InterestFriendCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "InterestFriendCell.h"
#import "NSString+Time.h"

@interface InterestFriendCell ()

@property (nonatomic,strong)UIImageView *headIcon;
@property (nonatomic,strong)NameLabel *nameLabel;
@property (nonatomic,strong)PostionLabel *messageLabel;
@property (nonatomic,strong)UIButton *sureButton;

@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIButton *closeButton;
@property (nonatomic,strong)UIButton *confimButton;
@property (nonatomic,strong)UIButton *selectButton;

@end

@implementation InterestFriendCell

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
        [self.contentView addSubview:self.selectButton];
    }
    return self;
}

- (void)setStallTwoModel:(StaffModel *)stallTwoModel {
    _stallTwoModel = stallTwoModel;//系统消息进来时的cell布局和数据处理
    
    self.messageLabel.userUid = stallTwoModel.userUid;
    self.nameLabel.userUid = stallTwoModel.userUid;
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:stallTwoModel.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    [self.nameLabel setNameString:stallTwoModel.userName showIcon:stallTwoModel.isBasic];
    self.messageLabel.labelWidth = kDeviceWidth-self.headIcon.right-kCurrentWidth(60);
    NSString *name = [NSString stringWithFormat:@"%@%@",stallTwoModel.company?:@"",stallTwoModel.position?:@""];
    [self.messageLabel setCompany:nil postion:name.length > 0?name:@"未完善公司职位和信息" showIcon:stallTwoModel.isOccupation];

    self.sureButton.hidden = YES;
}

- (void)setStallModel:(PersonnelModel *)stallModel {//所有员工的布局
    _stallModel = stallModel;
    
    self.messageLabel.userUid = stallModel.userUid;
    self.nameLabel.userUid = stallModel.userUid;
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:stallModel.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    [self.nameLabel setNameString:stallModel.userName showIcon:stallModel.isBasic];
    [self.messageLabel setCompany:@"" postion:[NSString stringWithFormat:@"%@%@",stallModel.company,stallModel.position] showIcon:stallModel.isOccupation];
    
    NSString *name = [NSString stringWithFormat:@"%@%@",stallModel.company?:@"",stallModel.position?:@""];
    [self.messageLabel setCompany:nil postion:name.length > 0?name:@"未完善公司职位和信息" showIcon:stallModel.isOccupation];
    

    
    if ([stallModel.isApplyStatus isEqualToString:@"0"])
    {
        self.sureButton.hidden = NO;
        self.sureButtonState = SureButtonStateVisitorDisabled;
    }
    else if ([stallModel.isApplyStatus isEqualToString:@"1"])
    {
        self.sureButton.hidden = YES;
    }
    else
    {//是好友不显示按钮
        self.sureButton.hidden = NO;
        self.sureButtonState = SureButtonStateVisitorNormal;
    }
    LoginModel *account = [SDUserTool account];
    if ([account.userUid isEqualToString:stallModel.userUid]) {
        self.sureButton.hidden = YES;
        self.messageLabel.width = kDeviceWidth-self.headIcon.right;

    }else{
        self.sureButton.hidden = NO;
        self.messageLabel.width = stallModel.isOccupation.intValue == 1?kDeviceWidth-self.headIcon.right-kCurrentWidth(90):kDeviceWidth-self.headIcon.right-kCurrentWidth(60);
//        self.messageLabel.labelWidth = kDeviceWidth-self.headIcon.right-kCurrentWidth(60);

    }
}

- (void)setUserFriendModel:(FriendModel *)userFriendModel {
    _userFriendModel = userFriendModel;
    
    self.messageLabel.userUid = userFriendModel.userUid;
    self.nameLabel.userUid = userFriendModel.userUid;
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:userFriendModel.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    [self.nameLabel setNameString:userFriendModel.userName showIcon:userFriendModel.isBasic];
    
    self.messageLabel.labelWidth = kDeviceWidth-self.nameLabel.left-kCurrentWidth(12);
//    [self.messageLabel setCompany:@"" postion:[NSString stringWithFormat:@"%@%@",userFriendModel.company,userFriendModel.position] showIcon:userFriendModel.isOccupation];
    NSString *name = [NSString stringWithFormat:@"%@%@",userFriendModel.company,userFriendModel.position];
    [self.messageLabel setCompany:@"" postion:name.length >0?name:@"未完善公司和职位信息" showIcon:userFriendModel.isOccupation];
}

- (void)setPendModel:(PendFriendModel *)pendModel {
    _pendModel = pendModel;
    
    self.messageLabel.userUid = pendModel.userUid;
    self.nameLabel.userUid = pendModel.userUid;
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:pendModel.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    [self.nameLabel setNameString:[NSString stringWithFormat:@"好友请求：%@",pendModel.userName] showIcon:pendModel.isBasic];
    self.messageLabel.labelWidth = kDeviceWidth-self.nameLabel.left-kCurrentWidth(105);
//    [self.messageLabel setCompany:@"" postion:[NSString stringWithFormat:@"%@%@",pendModel.company,pendModel.position] showIcon:pendModel.isOccupation];
    
    NSString *name = [NSString stringWithFormat:@"%@%@",pendModel.company?:@"",pendModel.position?:@""];
    [self.messageLabel setCompany:@"" postion:name.length >0?name:@"未完善公司和职位信息" showIcon:pendModel.isOccupation];
    if ([pendModel.status intValue] == 0)
    {
        self.sureButtonState = SureButtonStateMsgPend;
    }
    else if ([pendModel.status intValue] == 1)
    {
        self.sureButtonState = SureButtonStateDisabled;
        [self.sureButton setTitle:@"已同意" forState:UIControlStateDisabled];
    }
    else if ([pendModel.status intValue] == 2)
    {
        self.sureButtonState = SureButtonStateDisabled;
        [self.sureButton setTitle:@"已拒绝" forState:UIControlStateDisabled];
    }
}

- (void)setUserModel:(VisitorModel *)userModel {//访客消息中心 时间和加好友的布局和状态
    _userModel = userModel;
    
    self.messageLabel.userUid = userModel.userUid;
    self.nameLabel.userUid = userModel.userUid;
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:userModel.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    [self.nameLabel setNameString:userModel.userName showIcon:userModel.isBasic];
    
    NSString *position = [NSString stringWithFormat:@"%@%@",userModel.company?:@"",userModel.position?:@""];
    if ([userModel.isBasic isEqualToString:@"0"]) {
        self.messageLabel.labelWidth = BoundWithSize(position, kDeviceWidth, 13).size.width + 15;

    }else{
        self.messageLabel.labelWidth = kDeviceWidth-self.nameLabel.left-kCurrentWidth(62);

    }
    [self.messageLabel setCompany:@"" postion:[NSString stringWithFormat:@"%@%@",userModel.company,userModel.position] showIcon:userModel.isOccupation];
    
    CGFloat timeW = BoundWithSize([NSString achieveDayFormatByTimeString:userModel.createTime], kDeviceWidth, 12).size.width;
    self.timeLabel.text = [NSString achieveDayFormatByTimeString:userModel.createTime];
    self.timeLabel.width = timeW;
    self.timeLabel.left = kDeviceWidth - timeW - 16;
    NSString *name = [NSString stringWithFormat:@"%@%@",userModel.company,userModel.position];
    [self.messageLabel setCompany:@"" postion:name.length >0?name:@"未完善公司和职位信息" showIcon:userModel.isOccupation];
    if (self.sureButtonState != SureButtonStateQuestion)
    {//（0:未通过  1：已同意  2：拒绝  3:未添加）
        if ([userModel.isApplyStatus isEqualToString:@"0"])
        {
            self.sureButton.hidden = NO;
            self.sureButtonState = SureButtonStateVisitorDisabled;
        }
        else if ([userModel.isApplyStatus isEqualToString:@"1"])
        {
            self.sureButton.hidden = YES;
        }
        else
        {
            self.sureButton.hidden = NO;
            self.sureButtonState = SureButtonStateVisitorNormal;
        }
    }
    else
    {
        if ([[Config currentConfig].answerid isEqualToString:userModel.userUid])
        {
            self.selectButton.selected = YES;
        }
        else
        {
            self.selectButton.selected = NO;
        }
    }
}

- (void)setFriendModel:(InterestFriendModel *)friendModel {
    _friendModel = friendModel;
    
    self.messageLabel.userUid = friendModel.userUid;
    self.nameLabel.userUid = friendModel.userUid;
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:friendModel.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    [self.nameLabel setNameString:friendModel.userName showIcon:friendModel.isBasic];
    if (friendModel.company.length == 0 && friendModel.position.length == 0) {
        [self.messageLabel setCompany:@"" postion:@"未完善公司和职位信息" showIcon:friendModel.isOccupation];
        self.messageLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), self.nameLabel.bottom, kDeviceWidth-kCurrentWidth(100), kCurrentWidth(20));

    }else{
        [self.messageLabel setCompany:@"" postion:[NSString stringWithFormat:@"%@%@",friendModel.company,friendModel.position] showIcon:friendModel.isOccupation];
        self.messageLabel.labelWidth = kDeviceWidth-self.nameLabel.left-kCurrentWidth(12)-kCurrentWidth(90);

    }
    NSString *name = [NSString stringWithFormat:@"%@%@",friendModel.company?:@"",friendModel.position?:@""];
    [self.messageLabel setCompany:@"" postion:name.length >0?name:@"未完善公司和职位信息" showIcon:friendModel.isOccupation];

    if ([friendModel.isApplyStatus isEqualToString:@"0"]) {
        self.sureButton.enabled = NO;
        self.sureButton.hidden = NO;
        self.sureButton.layer.borderColor = kSepparteLineColor.CGColor;
    }
    else if ([friendModel.isApplyStatus isEqualToString:@"1"]) {
        self.sureButton.hidden = YES;
    }
    else {
        self.sureButton.hidden = NO;
        self.sureButton.enabled = YES;
        self.sureButton.layer.borderColor = kLBRedColor.CGColor;
    }
    
    if ([[Config currentConfig].answerid isEqualToString:friendModel.userUid]) {
        self.selectButton.selected = YES;
    } else {
        self.selectButton.selected = NO;
    }
}

- (void)setSureButtonState:(SureButtonState)sureButtonState {
    _sureButtonState = sureButtonState;
    
    self.selectButton.hidden = YES;
    switch (sureButtonState) {//邀请加入企业的cell状态
        case SureButtonStateNormal:
        {
            self.timeLabel.hidden = YES;
//            self.nameLabel.font = kSystem(15);
            self.messageLabel.color = kLBSixColor;
            self.sureButton.enabled = YES;
            self.sureButton.layer.borderWidth = 1;
            self.sureButton.layer.borderColor = kLBRedColor.CGColor;
            self.closeButton.hidden = YES;
            self.confimButton.hidden = YES;
            self.sureButton.hidden = NO;
            self.headIcon.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(15), kCurrentWidth(40), kCurrentWidth(40));
            self.nameLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), kCurrentWidth(15), kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.messageLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), self.nameLabel.bottom, kDeviceWidth-kCurrentWidth(150+50), kCurrentWidth(20));
            self.sureButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(62), kCurrentWidth(45)/2, kCurrentWidth(50), kCurrentWidth(25));
        }
            break;
        case SureButtonStateDisabled:
        {
            self.timeLabel.hidden = YES;
//            self.nameLabel.font = kSystem(15);
            self.messageLabel.color = kLBSixColor;
            self.sureButton.enabled = NO;
            self.sureButton.layer.borderWidth = 1;
            self.sureButton.layer.borderColor = kSepparteLineColor.CGColor;
            self.closeButton.hidden = YES;
            self.confimButton.hidden = YES;
            self.sureButton.hidden = NO;
            self.headIcon.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(15), kCurrentWidth(40), kCurrentWidth(40));
            self.nameLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), kCurrentWidth(15), kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.messageLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), self.nameLabel.bottom, kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.sureButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(62), kCurrentWidth(45)/2, kCurrentWidth(50), kCurrentWidth(25));
        }
            break;
        case SureButtonStateMsgNormal:
        {
            self.timeLabel.hidden = YES;
//            self.nameLabel.font = kSystem(14);
            self.messageLabel.color = kLBNineColor;
            self.sureButton.enabled = YES;
            self.sureButton.layer.borderWidth = 1;
            self.sureButton.layer.borderColor = kLBRedColor.CGColor;
            self.headIcon.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(10), kCurrentWidth(40), kCurrentWidth(40));
            self.nameLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), kCurrentWidth(10), kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.messageLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), self.nameLabel.bottom, kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.sureButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(62), kCurrentWidth(35)/2, kCurrentWidth(50), kCurrentWidth(25));
            self.closeButton.hidden = YES;
            self.confimButton.hidden = YES;
            self.sureButton.hidden = NO;
        }
            break;
        case SureButtonStateMsgDisabled:
        {
            self.timeLabel.hidden = YES;
//            self.nameLabel.font = kSystem(14);
            self.messageLabel.color = kLBNineColor;
            self.sureButton.enabled = NO;
            self.sureButton.layer.borderWidth = 1;
            self.sureButton.layer.borderColor = kSepparteLineColor.CGColor;
            self.headIcon.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(10), kCurrentWidth(40), kCurrentWidth(40));
            self.nameLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), kCurrentWidth(10), kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.messageLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), self.nameLabel.bottom, kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.sureButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(62), kCurrentWidth(35)/2, kCurrentWidth(50), kCurrentWidth(25));
            self.closeButton.hidden = YES;
            self.confimButton.hidden = YES;
            self.sureButton.hidden = NO;
        }
            break;
        case SureButtonStateMsgPend:
        {
            self.timeLabel.hidden = YES;
//            self.nameLabel.font = kSystem(14);
            self.messageLabel.color = kLBNineColor;
            self.sureButton.hidden = YES;
            self.closeButton.hidden = NO;
            self.confimButton.hidden = NO;
            self.headIcon.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(15), kCurrentWidth(40), kCurrentWidth(40));
            self.nameLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), kCurrentWidth(15), kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.messageLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), self.nameLabel.bottom, kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
        }
            break;
        case SureButtonStateVisitorNormal:
        {//访客的时间和加好友的状态和布局要调整
            self.timeLabel.hidden = NO;
//            self.nameLabel.font = kSystem(15);
            self.messageLabel.color = kLBSixColor;
            self.sureButton.enabled = YES;
            self.sureButton.layer.borderWidth = 1;
            self.sureButton.layer.borderColor = kLBRedColor.CGColor;
            self.closeButton.hidden = YES;
            self.confimButton.hidden = YES;
            self.sureButton.hidden = NO;
            self.headIcon.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(15), kCurrentWidth(40), kCurrentWidth(40));
            self.nameLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), kCurrentWidth(15), kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.messageLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), self.nameLabel.bottom, kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
//            _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(62), kCurrentWidth(10), kCurrentWidth(50), kCurrentWidth(16))];
            self.sureButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(62), kCurrentWidth(30), kCurrentWidth(50), kCurrentWidth(23));
            self.sureButton.layer.cornerRadius = kCurrentWidth(23)/2;
            self.sureButton.layer.masksToBounds = YES;
        }
            break;
        case SureButtonStateVisitorDisabled:
        {
            self.timeLabel.hidden = NO;
//            self.nameLabel.font = kSystem(15);
            self.messageLabel.color = kLBSixColor;
            self.sureButton.enabled = NO;
            self.sureButton.layer.borderWidth = 1;
            self.sureButton.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
            self.closeButton.hidden = YES;
            self.confimButton.hidden = YES;
            self.sureButton.hidden = NO;
            self.headIcon.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(15), kCurrentWidth(40), kCurrentWidth(40));
            self.nameLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), kCurrentWidth(15), kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.messageLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), self.nameLabel.bottom, kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.sureButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(62), kCurrentWidth(33), kCurrentWidth(50), kCurrentWidth(23));
            self.sureButton.layer.cornerRadius = kCurrentWidth(23)/2;
            self.sureButton.layer.masksToBounds = YES;
        }
            break;
        case SureButtonStateQuestion:
        {
            self.timeLabel.hidden = YES;
//            self.nameLabel.font = kSystem(15);
            self.messageLabel.color = kLBSixColor;
            self.closeButton.hidden = YES;
            self.confimButton.hidden = YES;
            self.sureButton.hidden = YES;
            self.selectButton.hidden = NO;
            self.headIcon.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(15), kCurrentWidth(45), kCurrentWidth(45));
            self.nameLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), kCurrentWidth(20), kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.messageLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), self.nameLabel.bottom, kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.headIcon.layer.cornerRadius = kCurrentWidth(45)/2;
        }
            break;
        case SureButtonStateSearchNormal:
        {
            self.timeLabel.hidden = YES;
//            self.nameLabel.font = kSystem(15);
            self.messageLabel.color = kLBSixColor;
            self.sureButton.enabled = YES;
            self.sureButton.layer.borderWidth = 1;
            self.sureButton.layer.borderColor = kLBRedColor.CGColor;
            self.closeButton.hidden = YES;
            self.confimButton.hidden = YES;
            self.sureButton.hidden = NO;
            self.headIcon.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(15), kCurrentWidth(45), kCurrentWidth(45));
            self.nameLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), kCurrentWidth(20), kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.messageLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), self.nameLabel.bottom, kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.sureButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(67), kCurrentWidth(25), kCurrentWidth(55), kCurrentWidth(25));
        }
            break;
        case SureButtonStateSearchDisabled:
        {
            self.timeLabel.hidden = YES;
//            self.nameLabel.font = kSystem(15);
            self.messageLabel.color = kLBSixColor;
            self.sureButton.enabled = NO;
            self.sureButton.layer.borderWidth = 1;
            self.sureButton.layer.borderColor = kSepparteLineColor.CGColor;
            self.closeButton.hidden = YES;
            self.confimButton.hidden = YES;
            self.sureButton.hidden = NO;
            self.headIcon.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(15), kCurrentWidth(45), kCurrentWidth(45));
            self.nameLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), kCurrentWidth(20), kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.messageLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), self.nameLabel.bottom, kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.sureButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(67), kCurrentWidth(25), kCurrentWidth(55), kCurrentWidth(25));
        }
            break;
        case SureButtonStateSearchNoButton:
        {
            self.timeLabel.hidden = YES;
//            self.nameLabel.font = kSystem(15);
            self.messageLabel.color = kLBSixColor;
            self.closeButton.hidden = YES;
            self.confimButton.hidden = YES;
            self.sureButton.hidden = YES;
            self.headIcon.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(15), kCurrentWidth(45), kCurrentWidth(45));
            self.nameLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), kCurrentWidth(20), kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
            self.messageLabel.frame = CGRectMake(self.headIcon.right+kCurrentWidth(10), self.nameLabel.bottom, kDeviceWidth-kCurrentWidth(150), kCurrentWidth(20));
        }
            break;
        default:
            break;
    }
}

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
        _nameLabel = [[NameLabel alloc] initWithFrame:CGRectMake(self.headIcon.right+kCurrentWidth(10), kCurrentWidth(15), kDeviceWidth-kCurrentWidth(150+30), kCurrentWidth(20))];
        
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
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(62), kCurrentWidth(13), kCurrentWidth(50), kCurrentWidth(16))];
        _timeLabel.font = kSystem(12);
        _timeLabel.textColor = kLBNineColor;
//        _timeLabel.backgroundColor = kLBRedColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"16:00";
    }
    return _timeLabel;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(62), kCurrentWidth(13), kCurrentWidth(50), kCurrentWidth(25));
        [_sureButton setTitle:@"+好友" forState:UIControlStateNormal];
        [_sureButton setTitle:@"已申请" forState:UIControlStateDisabled];
        [_sureButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
        [_sureButton setTitleColor:kLBSixColor forState:UIControlStateDisabled];
        [_sureButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"ffffff"]] forState:UIControlStateNormal];
        [_sureButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"dddddd"]] forState:UIControlStateDisabled];
        _sureButton.layer.cornerRadius = kCurrentWidth(25)/2;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.titleLabel.font = kSystem(kCurrentWidth(13));
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)confimButton {
    if (!_confimButton) {
        _confimButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confimButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(40), kCurrentWidth(21), kCurrentWidth(28), kCurrentWidth(28));
        [_confimButton setBackgroundImage:[UIImage imageNamed:@"company_sure"] forState:UIControlStateNormal];
        [_confimButton addTarget:self action:@selector(confimButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confimButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(83), kCurrentWidth(21), kCurrentWidth(28), kCurrentWidth(28));
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"company_cancel"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(42), 0, kCurrentWidth(42), kCurrentWidth(75));
        [_selectButton setImage:[UIImage imageNamed:@"list_btn_normal"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"list_button_select"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

#pragma mark Event
- (void)selectButtonClick {
    _selectButton.selected = !_selectButton.selected;
    if (_selectButton.selected) {
        [Config currentConfig].answerid = _userModel.userUid;
        
        if (_selectButtonBlock) {
            _selectButtonBlock(_userModel);
        }
    }
    else {
        if ([[Config currentConfig].answerid isEqualToString:_userModel.userUid]) {
            [Config currentConfig].answerid = nil;
        }
    }
    
}

- (void)closeButtonClick {
    if (_closeButtonBlock) {
        _closeButtonBlock(_pendModel);
    }
}

- (void)confimButtonClick {
    if (_confimButtonBlock) {
        _confimButtonBlock(_pendModel);
    }
}

- (void)sureButtonClick {
    if (_sureButtonBlock) {
        
        if (IsNilOrNull(_friendModel))
        {
            if (!IsNilOrNull(_stallModel)) {
                _sureButtonBlock(_stallModel);
            }
            else {
                if (IsNilOrNull(_stallTwoModel)) {
                    _sureButtonBlock(_userModel);
                }
                else {
                    _sureButtonBlock(_stallTwoModel);
                }
            }
        }
        else
        {
            if (!IsNilOrNull(_stallModel)) {
                _sureButtonBlock(_stallModel);
            }
            else {
                if (IsNilOrNull(_stallTwoModel)) {
                    _sureButtonBlock(_friendModel);
                }
                else {
                    _sureButtonBlock(_stallTwoModel);
                }
            }
        }
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
