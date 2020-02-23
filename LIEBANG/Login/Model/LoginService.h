//
//  LoginService.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModel.h"

@interface LoginService : NSObject

/**
 注册
 */
+ (void)getRegisterWithParameters:(NSDictionary *)parameters
                          success:(void (^)(NSString *success))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 登录
 */
+ (void)getLoginWithParameters:(NSDictionary *)parameters
                       success:(void (^)(LoginModel *object))success
                       failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 发送验证码
 */
+ (void)getSendCodeWithParameters:(NSDictionary *)parameters
                          success:(void (^)(NSString *success))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 重置密码
 */
+ (void)getResetPasswordWithParameters:(NSDictionary *)parameters
                               success:(void (^)(NSString *success))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 修改手机号
 */
+ (void)getModifyPhoneWithParameters:(NSDictionary *)parameters
                             success:(void (^)(NSString *success))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 第三方登录
 */
+ (void)getThirdLoginWithParameters:(NSDictionary *)parameters
                            success:(void (^)(id object))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 用户协议
 */
+ (void)getUserProtocolWithParametersSuccess:(void (^)(id object))success
                                     failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 绑定手机号
 */
+ (void)getBindPhoneWithParameters:(NSDictionary *)parameters
                           success:(void (^)(NSString *success))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 验证验证码
 */
+ (void)getCheckCodeWithParameters:(NSDictionary *)parameters
                           success:(void (^)(NSString *success))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

@end
