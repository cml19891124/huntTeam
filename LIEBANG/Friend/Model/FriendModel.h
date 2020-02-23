//
//  FriendModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/1.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 我的好友Model
 */
@interface FriendModel : NSObject

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
@property (nonatomic,strong)NSString *phone;

@end
