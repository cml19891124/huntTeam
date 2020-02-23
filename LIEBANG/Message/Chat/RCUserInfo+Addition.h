//
//  RCUserInfo+Addition.h
//  IHK
//
//  Created by 郑文明 on 15/7/28.
//  Copyright (c) 2015年 郑文明. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface RCUserInfo (Addition)
/**
 用户信息类
 */
/** 用户ID */
@property(nonatomic, strong) NSString *userId;
/** 用户名*/
@property(nonatomic, strong) NSString *name;
/** 头像URL*/
@property(nonatomic, strong) NSString *portraitUri;
/** 实名认证*/
@property(nonatomic, strong) NSString *isBasic;

/** 职业认证*/
@property(nonatomic, strong) NSString *isOccupation;

/** 职业*/
@property(nonatomic, strong) NSString *job;


/**
 指派的初始化方法，根据给定字段初始化实例

 @param userId 用户ID
 @param username 用户名
 @param portrait 头像URL
 @param isBasic 实名认证
 @param isOccupation 职业认证
 @param job 职业
 @return id
 */
- (instancetype)initWithUserId:(NSString *)userId name:(NSString *)username portrait:(NSString *)portrait isBasic:(NSString *)isBasic isOccupation:(NSString *)isOccupation job:(NSString *)job;
@end
