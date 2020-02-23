//
//  LoginModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *effectSocre;
@property (nonatomic,strong)NSString *registrationId;
@property (nonatomic,strong)NSString *ly_table;
@property (nonatomic,strong)NSString *isEducation;
@property (nonatomic,strong)NSString *userStatus;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *isBasic;
@property (nonatomic,strong)NSString *userPhone;
@property (nonatomic,strong)NSString *isOccupation;


@property (nonatomic,strong)NSString *userPassword;
@property (nonatomic,strong)NSString *userHead;

@property (nonatomic,strong)NSString *helpNum;
@property (nonatomic,strong)NSString *isRecommend;
@property (nonatomic,strong)NSString *likeNum;
@property (nonatomic,strong)NSString *rongCloudToken;
@property (nonatomic,strong)NSString *starLevel;
@property (nonatomic,strong)NSString *userUid;

@property (nonatomic,strong)NSString *userBalance;
@property (nonatomic,strong)NSString *userBirth;
@property (nonatomic,strong)NSString *userHometown;
@property (nonatomic,strong)NSString *userIntroduce;

@property (nonatomic,strong)NSString *isPhone;////是否绑定手机 0：否 1：是
@property (nonatomic,strong)NSString *userOpenid;

@end
