//
//  Config.h
//  Storm
//
//  Created by 朱攀峰 on 15/12/5.
//  Copyright (c) 2015年 MCDS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
{
    NSUserDefaults *defaults;
}
+ (Config *)currentConfig;

@property (readwrite,retain)NSUserDefaults *defaults;

@property (nonatomic,readwrite,retain)NSString *token;

@property (nonatomic,readwrite,retain)NSString *userUid;

@property (nonatomic,readwrite,retain)NSString *mobile;

@property (nonatomic,readwrite,retain)NSString *password;

@property (nonatomic,readwrite,retain)NSString *effectSocre;

@property (nonatomic,readwrite,retain)NSString *username;

@property (nonatomic,readwrite,retain)NSString *headIcon;

@property (nonatomic,readwrite,retain)NSString *position;

//七牛token
@property (nonatomic,readwrite,retain)NSString *qiniu;

//当前可用余额
@property (nonatomic,readwrite,retain)NSString *balanceAmount;
@property (nonatomic,readwrite,retain)NSString *liebangCurrency;//猎帮币余额
//当前可提现余额
@property (nonatomic,readwrite,retain)NSString *availableAmount;

@property (nonatomic,readwrite,retain)NSString *remeberPassword;

//回答者userid
@property (nonatomic,readwrite,retain)NSString *answerid;

@property (nonatomic,readwrite,retain)NSString *isMessage;

@property (nonatomic,readwrite,retain)NSString *comment;

@property (nonatomic,readwrite,retain)NSString *friendCount;

//极光registrationID
@property (nonatomic,readwrite,retain)NSString *registrationID;

//回答orderUid
@property (nonatomic,readwrite,retain)NSString *answerOrderUid;
//回答内容
@property (nonatomic,readwrite,retain)NSString *answerContent;

//是否购买企业服务
@property (nonatomic,readwrite,retain)NSString *company;

//认证的入口
@property (nonatomic,readwrite,retain)NSString *enterAccount;

@end
