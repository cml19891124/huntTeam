//
//  WMCompanyMessage.h
//  LIEBANG
//
//  Created by  YIQI on 2019/1/11.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
//#import <RongIMLib/RCMessageContentView.h>
#import "CompanyModel.h"

NS_ASSUME_NONNULL_BEGIN
#define RCLocalCompanyMessageTypeIdentifier @"APP:SimpleMsgR"
@interface WMCompanyMessage : RCMessageContent<NSCoding,RCMessageContentView>

//@property(nonatomic,strong)NSString *content;//公司名称
@property(nonatomic,strong)NSString *id;//机构ID
@property (nonatomic,strong)NSString *userUid;//用户唯一id
@property (nonatomic,strong)NSString *userName;//用户姓名
@property (nonatomic,strong)NSString *isBasic;//基本信息认证（0：未认证 1：已认证）
@property (nonatomic,strong)NSString *isOccupation;//职业精力认证（0 未认证 1已认证）
@property (nonatomic,strong)NSString *userHead;//用户头像
@property (nonatomic,strong)NSString *position;//用户职位

@property (nonatomic,strong)NSString *companyLogo;
@property (nonatomic,strong)NSString *officialWebsite;//官网
@property (nonatomic,strong)NSString *companyAbbreviation;//公司名称
@property (nonatomic,strong)NSString *fullName;//公司全称
@property (nonatomic,strong)NSString *city;//所在城市
@property (nonatomic,strong)NSString *region;//所在地区
@property (nonatomic,strong)NSString *financingStatus;//融资状态
@property (nonatomic,strong)NSString *industry;//所处行业
@property (nonatomic,strong)NSString *contactsPhone;//联系人手机
@property (nonatomic,strong)NSString *personnelScale;//人员规模
@property (nonatomic,strong)NSString *email;
@property(nonatomic, strong) NSString* extra;
+(instancetype)messageWithContent:(CompanyModel *)content;
@end

NS_ASSUME_NONNULL_END
