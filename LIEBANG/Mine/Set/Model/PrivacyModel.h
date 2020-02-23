//
//  PrivacyModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/30.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VisitorRecordModel.h"

@interface PrivacyModel : NSObject

//接受消息权限
@property (nonatomic,strong)NSString *userMessagePrivacy_id;
@property (nonatomic,strong)NSString *userMessagePrivacy_userUid;
@property (nonatomic,strong)NSString *userMessagePrivacy_type;//0 所有人 1：仅好友

//添加好友权限
@property (nonatomic,strong)NSString *userFriendPrivacy_id;
@property (nonatomic,strong)NSString *userFriendPrivacy_userUid;
@property (nonatomic,strong)NSString *userFriendPrivacy_type;//0：全部 1：影响力低于**分 2未认证基本 3未认证教育 4未认证工作

//查看资料权限
@property (nonatomic,strong)NSString *userDataPrivacy_id;
@property (nonatomic,strong)NSString *userDataPrivacy_userUid;
@property (nonatomic,strong)NSString *userDataPrivacy_type;//0 所有人 1：仅好友

@property (nonatomic,strong)NSString *phonePrivacy_id;
@property (nonatomic,strong)NSString *phonePrivacy_userUid;
@property (nonatomic,strong)NSString *phonePrivacy_type;//0 不允许 1：允许

@property (nonatomic,strong)NSArray *user;

@end
