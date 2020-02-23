//
//  PendModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/1.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendModel : NSObject

@property (nonatomic,strong)NSArray *applicationFriend;
@property (nonatomic,strong)NSArray *applicationStaff;

@end

@interface PendFriendModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *status;//（0:未通过  1：已同意  2：拒绝  3:未添加）
@property (nonatomic,strong)NSString *effectSocre;
@property (nonatomic,strong)NSString *isEducation;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *userStatus;////0 正常 1停用
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *isBasic;
@property (nonatomic,strong)NSString *userPhone;
@property (nonatomic,strong)NSString *isOccupation;

@property (nonatomic,strong)NSString *position;
@property (nonatomic,strong)NSString *company;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *registrationId;
@property (nonatomic,strong)NSString *starLevel;
@property (nonatomic,strong)NSString *userBirth;
@property (nonatomic,strong)NSString *userHometown;
@property (nonatomic,strong)NSString *userDetailAddress;
@property (nonatomic,strong)NSString *userWorkAddress;
@property (nonatomic,strong)NSString *userIntroduce;
@property (nonatomic,strong)NSString *userHead;

@end

@interface PendStallModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *status;//（0:未通过  1：已同意  2：拒绝  3:未添加）
@property (nonatomic,strong)NSString *isEducation;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *isBasic;
@property (nonatomic,strong)NSString *userPhone;
@property (nonatomic,strong)NSString *isOccupation;

@property (nonatomic,strong)NSString *position;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *userHead;

@property (nonatomic,strong)NSString *companyAbbreviation;
@property (nonatomic,strong)NSString *comLogo;
@property (nonatomic,strong)NSString *company;

@end
