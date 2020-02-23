//
//  VisitorRecordModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/2.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 访客记录------（或-根据标签获取用户model）
 */
@interface VisitorRecordModel : NSObject

@property (nonatomic,strong)NSArray *data;

@end

@interface VisitorModel : NSObject

@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *company;
@property (nonatomic,strong)NSString *effectScore;
@property (nonatomic,strong)NSString *userWorkAddress;//用户工作地区
@property (nonatomic,strong)NSString *registrationId;//极光推送设备id
@property (nonatomic,strong)NSString *userPassword;//用户登录密码
@property (nonatomic,strong)NSString *userIndustry;//用户行业
@property (nonatomic,strong)NSString *mechanism;//机构信息认证（0：未认证 1：已认证）
@property (nonatomic,strong)NSString *userCom;//用户公司
@property (nonatomic,strong)NSString *userEmail;//用户邮箱
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *userDetailAddress;//用户详细地址
@property (nonatomic,strong)NSString *effectSocre;//影响力分数
@property (nonatomic,strong)NSString *userLogo;//用户公司logo
@property (nonatomic,strong)NSString *isEducation;//教育经历认证（0 未认证 1已认证）
@property (nonatomic,strong)NSString *userName;//用户姓名
@property (nonatomic,strong)NSString *userPhone;//用户手机号
@property (nonatomic,strong)NSString *userHead;//用户头像
@property (nonatomic,strong)NSString *isRecommend;//0 不推荐 1：推荐
@property (nonatomic,strong)NSString *helpNum;//帮助人数
@property (nonatomic,strong)NSString *status;//（0:未通过  1：已同意  2：拒绝  3:未添加）
@property (nonatomic,strong)NSString *isBasic;//基本信息认证（0：未认证 1：已认证）
@property (nonatomic,strong)NSString *isOccupation;//职业精力认证（0 未认证 1已认证）
@property (nonatomic,strong)NSString *starLevel;//用户星级
@property (nonatomic,strong)NSString *likeNum;//喜欢人数
@property (nonatomic,strong)NSString *userBirth;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *userIntroduce;//自我介绍
@property (nonatomic,strong)NSString *userStatus;//0 正常 1停用
@property (nonatomic,strong)NSString *userHometown;//家乡
@property (nonatomic,strong)NSString *userPosition;//用户职位

@property (nonatomic,strong)NSString *recordTime;//
@property (nonatomic,strong)NSString *isApplyStatus;////（0:未通过  1：已同意  2：拒绝  3:未添加）

#pragma mark 根据标签获取用户model
@property (nonatomic,strong)NSString *position;//用户职位

#pragma mark 黑名单用户model
@property (nonatomic,strong)NSString *signTime;//
@property (nonatomic,strong)NSString *updateTime;//
@property (nonatomic,strong)NSString *userBalance;//
@property (nonatomic,strong)NSString *userOpenid;//
@end
