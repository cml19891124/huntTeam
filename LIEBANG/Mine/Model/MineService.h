//
//  MineService.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountModel.h"
#import "AccountInfo.h"

@interface MineService : NSObject

/**
 个人中心
 */
+ (void)getUserMsgInfoWithSuccess:(void (^)(AccountInfo *info))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 个人信息页面
 */
+ (void)getAccountInfoWithParameters:(NSString *)parameters
                             success:(void (^)(AccountInfo *info))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取个人名片
 */
+ (void)getAccountMessageWithSuccess:(void (^)(AccountModel *model))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 使用帮助
 */
+ (void)getUserHelpWithSuccess:(void (^)(NSArray *array))success
                       failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 退出登陆
 */
+ (void)getLoginOutWithSuccess:(void (^)(NSString *info))success
                       failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

@end
