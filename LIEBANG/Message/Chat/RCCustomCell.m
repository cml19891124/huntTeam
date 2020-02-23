
//
//  RCCustomCell.m
//  RCIM
//
//  Created by 郑文明 on 15/12/30.
//  Copyright © 2015年 郑文明. All rights reserved.
//

#import "RCCustomCell.h"
#import "RCUserInfo+Addition.h"
#import "RCDataManager.h"
#import "NSString+Time.h"

@interface RCCustomCell ()

@property (nonatomic,assign)NSInteger unreadCount;

@end

@implementation RCCustomCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        WeakSelf;
        
        //头像
        self.avatarIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 40, 40)];
        self.avatarIV.clipsToBounds = YES;
        self.avatarIV.layer.cornerRadius = 20;
        self.avatarIV.userInteractionEnabled = YES;
        [self.avatarIV setContentScaleFactor:[[UIScreen mainScreen]scale]];
        self.avatarIV.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarIV.autoresizingMask = UIViewAutoresizingNone;
        [self.contentView addSubview:self.avatarIV];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterAccountEvent)];
        [self.avatarIV addGestureRecognizer:tap];
        
        //realName
        self.nameLabel = [[NameLabel alloc] initWithFrame:CGRectMake(self.avatarIV.right+kCurrentWidth(10), 20, kDeviceWidth-kCurrentWidth(150), 20)];
        [self.nameLabel setNameString:@"猎帮" showIcon:@"0"];
        self.nameLabel.GetBasicCertiImageViewBlock = ^(NSString *imageUrl) {
            if (weakSelf.GetBasicSourceBlock) {
                weakSelf.GetBasicSourceBlock(imageUrl);
            }
        };
        [self.contentView addSubview:self.nameLabel];
   
        self.jobLabel = [[PostionLabel alloc] initWithFrame:CGRectMake(self.nameLabel.right+kCurrentWidth(10), 20, kDeviceWidth-kCurrentWidth(150), 20)];
        self.jobLabel.font = kSystem(12);
        self.jobLabel.color = kLBSixColor;
        [self.jobLabel setCompany:nil postion:nil showIcon:@"0"];
        self.jobLabel.GetWorkCertiImageViewBlock = ^(NSString *imageUrl) {
            if (weakSelf.GetWorkSourceBlock) {
                weakSelf.GetWorkSourceBlock(imageUrl);
            }
        };
        [self.contentView addSubview:self.jobLabel];
        
        //时间
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(113), 20, kCurrentWidth(100), 20)];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textColor = kLBNineColor;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLabel];
        
        //内容
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarIV.right+kCurrentWidth(10), self.nameLabel.bottom, kDeviceWidth-kCurrentWidth(150), 20)];
        self.contentLabel.textColor = kLBSixColor;
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.contentLabel];
        
        //角标
//        self.ppBadgeView = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-14-kCurrentWidth(13), self.contentLabel.top+3, 14, 14)];
        self.ppBadgeView = [[UILabel alloc] initWithFrame:CGRectMake(44, 16, 14, 14)];
        self.ppBadgeView.textColor = kWhiteColor;
        self.ppBadgeView.backgroundColor = kRedColor;
        self.ppBadgeView.font = kSystem(11);
        self.ppBadgeView.textAlignment = NSTextAlignmentCenter;
        self.ppBadgeView.layer.cornerRadius = 7;
        self.ppBadgeView.layer.masksToBounds = YES;
        [self addSubview:self.ppBadgeView];
    }
    return self;
}

- (void)enterAccountEvent {
    if (_accountButtonBlock) {
        _accountButtonBlock();
    }
}

- (void)setUnreadCount:(NSInteger)unreadCount {
    _unreadCount = unreadCount;
    
    if (unreadCount==0) {
        self.ppBadgeView.text = @"";
        self.ppBadgeView.hidden = YES;
    }else{
        self.ppBadgeView.hidden = NO;
        if (unreadCount>=100) {
            self.ppBadgeView.text = @"99+";
        }else{
            self.ppBadgeView.text = [NSString stringWithFormat:@"%li",(long)unreadCount];
        }
    }
}

- (void)setConversationModel:(RCConversationModel *)model {
    self.unreadCount = model.unreadMessageCount;
    self.timeLabel.text = [NSString achieveDayFormatByTimeString:@(model.receivedTime).stringValue];
    self.jobLabel.userUid = model.targetId;
    self.nameLabel.userUid = model.targetId;
    
    if (IsArrEmpty([AppDelegate currentAppDelegate].friendsArray))
    {
        [self setNoNameMessage:model];
    }
    else
    {
        for (RCUserInfo *userInfo in [AppDelegate currentAppDelegate].friendsArray) {
            
            if ([model.targetId isEqualToString:userInfo.userId]) {
                
                [self.nameLabel setNameString:userInfo.name showIcon:userInfo.isBasic];
                self.name = userInfo.name;
                
                if (!IsNilOrNull(userInfo.job) && !IsStrEmpty(userInfo.job)) {
                    self.jobLabel.hidden = NO;
                    self.jobLabel.labelWidth = kDeviceWidth-self.nameLabel.right-kCurrentWidth(64);
                    [self.jobLabel setCompany:@"· " postion:userInfo.job showIcon:userInfo.isOccupation];
                    if ([userInfo.isOccupation isEqualToString:@"0"]) {
                        self.jobLabel.left = self.nameLabel.right+kCurrentWidth(30);
                    }else{
                        self.jobLabel.left = self.nameLabel.right+kCurrentWidth(25);
                    }
                                        
                    CGFloat nameW = BoundWithSize(userInfo.name, kDeviceWidth, 13).size.width;
                    if ([userInfo.isBasic isEqualToString:@"0"]) {
                        _nameLabel.width = nameW - 20;
                    }else{
                        _nameLabel.width = nameW - 8;
                    }
                    CGFloat pW = BoundWithSize(userInfo.job, kDeviceWidth, 13).size.width;

                    if (pW > kDeviceWidth-_nameLabel.width - _avatarIV.width -kCurrentWidth(12)) {
                        _jobLabel.width = kDeviceWidth-_nameLabel.width - _avatarIV.width - kCurrentWidth(30);
                    }else{
                        if ([userInfo.isOccupation isEqualToString:@"0"]) {
                            _jobLabel.width = pW + 30;

                        }else{
                            _jobLabel.width = pW + 44;
                        }
                    }

                        self.jobLabel.left = self.nameLabel.right+kCurrentWidth(28);
                    
                }
                else {
                    self.jobLabel.hidden = YES;
                }
                
                if ([userInfo.portraitUri isEqualToString:@""]||userInfo.portraitUri==nil)
                {
                    self.avatarIV.image = [UIImage imageNamed:@"no_headIcon"];
                    [self.contentView bringSubviewToFront:self.avatarIV];
                }
                else
                {
                    [self.avatarIV sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
                }
                
                if ([model.lastestMessage isKindOfClass:[RCTextMessage class]])
                {
                    self.contentLabel.text = [model.lastestMessage valueForKey:@"content"];
                }
                else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]])
                {
                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId])
                    {
                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
                        self.contentLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",myselfInfo.name];
                    }
                    else
                    {
                        self.contentLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",userInfo.name] ;
                    }
                }
                else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]])
                {
                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId])
                    {
                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
                        self.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",myselfInfo.name];
                    }
                    else
                    {
                        self.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",userInfo.name];
                    }
                }
                else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]])
                {
                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId])
                    {
                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
                        self.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",myselfInfo.name];
                    }
                    else
                    {
                        self.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",userInfo.name];
                    }
                }
                else if ([model.lastestMessage isKindOfClass:[WMCardMessage class]])
                {
                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId])
                    {
                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
                        self.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的名片消息，点击查看",myselfInfo.name];
                    }
                    else
                    {
                        self.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的名片消息，点击查看",userInfo.name];
                    }
                }
                else if ([model.lastestMessage isKindOfClass:[WMContent class]])
                {
                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId])
                    {
                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
                        self.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的分享消息，点击查看",myselfInfo.name];
                    }
                    else
                    {
                        self.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的分享消息，点击查看",userInfo.name];
                    }
                }
                else if ([model.lastestMessage isKindOfClass:[WMCompanyMessage class]])
                {
                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId])
                    {
                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
                        self.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的分享消息，点击查看",myselfInfo.name];
                    }
                    else
                    {
                        self.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的分享消息，点击查看",userInfo.name];
                    }
                }
                break;
            }
            else
            {
                [self setNoNameMessage:model];
            }
        }
    }
}

- (void)setNoNameMessage:(RCConversationModel *)model {
    
    NSMutableArray *list = (NSMutableArray *)[NSObject readObjforKey:kRCUSERINFO];
    
    if (IsArrEmpty(list)) {
        RCUserInfo *user = model.lastestMessage.senderUserInfo;
        if (IsStrEmpty(user.name) || IsNilOrNull(user.name)) {
            [self.nameLabel setNameString:@"未知好友" showIcon:@"0"];
            self.name = @"未知好友";
        }
        else {
            [[RCDataManager shareManager] addRCUserInfo:user];
            [self.nameLabel setNameString:user.name showIcon:@"0"];
            self.name = user.name;
        }
        [self.avatarIV sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    }
    else {
        for (RCUserInfo *user in list) {
            if ([user.userId isEqualToString:model.targetId]) {
                [self.nameLabel setNameString:user.name showIcon:@"0"];
                self.name = user.name;
                [self.avatarIV sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
                break;
            }
            else
            {
                RCUserInfo *user = model.lastestMessage.senderUserInfo;
                
                if (IsStrEmpty(user.name) || IsNilOrNull(user.name)) {
                    [self.nameLabel setNameString:@"未知好友" showIcon:@"0"];
                    self.name = @"未知好友";
                }
                else {
                    [[RCDataManager shareManager] addRCUserInfo:user];
                    [self.nameLabel setNameString:user.name showIcon:@"0"];
                    self.name = user.name;
                }
                [self.avatarIV sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
            }
        }
    }

    [self.contentView bringSubviewToFront:self.avatarIV];
//    self.jobLabel.hidden = YES;
    if ([model.lastestMessage isKindOfClass:[RCTextMessage class]])
    {
        self.contentLabel.text = [model.lastestMessage valueForKey:@"content"];
    }
    else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]])
    {
        self.contentLabel.text = @"图片消息，点击查看";
    }
    else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]])
    {
        self.contentLabel.text = @"语音消息，点击查看";
    }
    else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]])
    {
        self.contentLabel.text = @"位置消息，点击查看";
    }
    else if ([model.lastestMessage isKindOfClass:[WMCardMessage class]])
    {
        self.contentLabel.text = @"名片消息，点击查看";
    }
    else if ([model.lastestMessage isKindOfClass:[WMContent class]])
    {
        self.contentLabel.text = @"分享消息，点击查看";
    }
    else if ([model.lastestMessage isKindOfClass:[WMCompanyMessage class]])
    {
        self.contentLabel.text = @"分享消息，点击查看";
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
