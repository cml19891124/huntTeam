//
//  InterestFriendModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/1.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 感兴趣的好友Model
 */
@interface InterestFriendModel : NSObject

@property (nonatomic,strong)NSString *starLevel;
@property (nonatomic,strong)NSString *helpNum;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *isBasic;//基本信息认证（0：未认证 1：已认证）
@property (nonatomic,strong)NSString *isEducation;//教育经历认证（0 未认证 1已认证）
@property (nonatomic,strong)NSString *isOccupation;//职业精力认证（0 未认证 1已认证）
@property (nonatomic,strong)NSString *isRecommend;
@property (nonatomic,strong)NSString *likeNum;
@property (nonatomic,strong)NSString *userName;//用户姓名
@property (nonatomic,strong)NSString *userPhone;
@property (nonatomic,strong)NSString *userStatus;
@property (nonatomic,strong)NSString *userUid;//用户唯一id
@property (nonatomic,strong)NSString *effectSocre;

@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *registrationId;
@property (nonatomic,strong)NSString *userCom;//用户公司
@property (nonatomic,strong)NSString *userHead;//用户头像
@property (nonatomic,strong)NSString *userIndustry;
@property (nonatomic,strong)NSString *userPassword;
@property (nonatomic,strong)NSString *userPosition;//用户职位

@property (nonatomic,strong)NSString *isApplyStatus;//（0:已申请  其他都显示加好友）
@property (nonatomic,strong)NSString *position;
@property (nonatomic,strong)NSString *company;
@property (nonatomic,strong)NSString *signTime;
@property (nonatomic,strong)NSString *userBalance;
@property (nonatomic,strong)NSString *userBirth;

@property (nonatomic,strong)NSString *dataPrivacyType;

@end
