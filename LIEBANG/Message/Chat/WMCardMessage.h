//
//  WMCardMessage.h
//  RCIM
//
//  Created by 郑文明 on 16/4/20.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
//#import <RongIMLib/RCMessageContentView.h>
#import "FriendModel.h"
#import "AccountInfo.h"

#define RCLocalMessageTypeIdentifier @"RC:SimpleMsg"
@interface WMCardMessage : RCMessageContent<NSCoding,RCMessageContentView>
@property(nonatomic,strong)NSString *content;

@property (nonatomic,strong)NSString *isEducation;//教育经历认证（0 未认证 1已认证）
@property (nonatomic,strong)NSString *userUid;//用户唯一id
@property (nonatomic,strong)NSString *userName;//用户姓名
@property (nonatomic,strong)NSString *isBasic;//基本信息认证（0：未认证 1：已认证）
@property (nonatomic,strong)NSString *userNamePY;
@property (nonatomic,strong)NSString *isOccupation;//职业精力认证（0 未认证 1已认证）
@property (nonatomic,strong)NSString *userHead;//用户头像
@property (nonatomic,strong)NSString *position;//用户职位
@property (nonatomic,strong)NSString *mechanism;//机构信息认证（0：未认证 1：已认证）

@property (nonatomic,strong)NSString *comLogo;
@property (nonatomic,strong)NSString *company;
@property (nonatomic,strong)NSString *userClassify;
@property (nonatomic,strong)NSString *userEmail;
@property (nonatomic,strong)NSString *userWorkAddress;
@property (nonatomic,strong)NSString *effectSocre;
@property (nonatomic,strong)NSString *phonePrivacy;
@property (nonatomic,strong)NSString *userPhone;

@property(nonatomic, strong) NSString* extra;
+(instancetype)messageWithContent:(FriendModel *)content;
+(instancetype)messageWithAccContent:(AccountInfo *)content;

@end
