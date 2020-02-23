//
//  QuestionClassModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/21.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserAccountFormMapModel;

//qusetion
@interface QuestionClassModel : NSObject

@property (nonatomic,strong)NSString *id;

/**
 显示的问答内容
 */
@property (nonatomic,strong)NSString *quizcontent;

@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *starLevel;//用户工星级

/**
 职业精力认证（0 未认证  1已认证）
 */
@property (nonatomic,strong)NSString *isOccupation;

@property (nonatomic,strong)NSString *isOccupationOne;

/**
 教育经历认证（0 未认证  1已认证）
 */
@property (nonatomic,strong)NSString *isEducation;

/**
 基本信息认证（0：未认证    1：已认证）
 */
@property (nonatomic,strong)NSString *isBasic;
@property (nonatomic,strong)NSString *helpNum;
@property (nonatomic, copy) NSString *company;
@property (nonatomic,strong)NSString *position;//用户职位

@property (nonatomic,strong)NSString *userHead;

@property (nonatomic,strong)NSString *chargeState;

@property (nonatomic,strong)NSString *startLevel;

#pragma mark --
@property (nonatomic,strong)NSString *userPhone;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *answerContent;
@property (nonatomic,strong)NSString *isRecommend;
@property (nonatomic,strong)NSString *isSensitive;

@property (nonatomic,strong)NSString *answer;//是否失效

@property (nonatomic,strong)NSString *dataPrivacyType;

/**
 极光推送设备id
 */
@property (nonatomic,strong)NSString *registrationId;

//@property (strong, nonatomic) UserAccountFormMapModel *UserAccountFormMap;

@end

/*
@interface UserAccountFormMapModel ()

@property (nonatomic,strong) NSString *userUid;

@property (nonatomic,strong)NSString *userPhone;

@property (nonatomic,strong)NSString *userName;

@property (nonatomic,strong)NSString *userHead;

@property (nonatomic,strong)NSString *starLevel;

@property (nonatomic,strong)NSString *position;

@property (nonatomic,strong)NSString *isOccupation;

@property (nonatomic,strong)NSString *isEducation;

@property (nonatomic,strong)NSString *isBasic;

@property (nonatomic,strong)NSString *helpNum;

@property (nonatomic,strong)NSString *dataPrivacyType;

@property (nonatomic,strong)NSString *company;

@property (nonatomic, copy) NSString *comLogo;

@end
*/
