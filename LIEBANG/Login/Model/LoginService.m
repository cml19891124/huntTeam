//
//  LoginService.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "LoginService.h"
#import "CompanyService.h"

@implementation LoginService

/**
 注册
 */
+ (void)getRegisterWithParameters:(NSDictionary *)parameters
                          success:(void (^)(NSString *success))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kREGISTER_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"注册成功");
            }
        } else if ([ret integerValue] == 10002 || [ret integerValue] == 10003) {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        } else {
            if (failure) {
                failure([ret integerValue],@"注册失败");
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

/**
 登录
 */
+ (void)getLoginWithParameters:(NSDictionary *)parameters
                       success:(void (^)(LoginModel *object))success
                       failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kLOGIN_URL parameters:parameters success:^(id responseObject) {

        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            LoginModel *model = [LoginModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
            [Config currentConfig].userUid = model.userUid;
            [Config currentConfig].mobile = model.userPhone;
            [Config currentConfig].username = model.userName;
//            account.rongCloudToken = model.rongCloudToken;
            [Config currentConfig].headIcon = model.userHead;
            [Config currentConfig].registrationID = model.registrationId;
//            [Config currentConfig].position = model.
//            [Config currentConfig].effectSocre = model.
            [SDUserTool saveAccount:model];

            [CompanyService getIsPayCompanyWithSuccess:^(BOOL data) {} failure:^(NSUInteger code, NSString * _Nonnull errorStr) { }];
            if (success) {
                success(model);
            }
        } else if ([ret integerValue] == 10005 || [ret integerValue] == 10004 || [ret integerValue] == 10007) {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        } else {
            if (failure) {
                failure([ret integerValue],@"登录失败");
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

/**
 发送验证码
 */
+ (void)getSendCodeWithParameters:(NSDictionary *)parameters
                          success:(void (^)(NSString *success))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kSEND_CODE_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            NSString *code = responseObject[@"data"][@"code"];
            if (success) {
                success(code);
            }
        } else {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

/**
 重置密码
 */
+ (void)getResetPasswordWithParameters:(NSDictionary *)parameters
                               success:(void (^)(NSString *success))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kMODIFY_LOGINPWD_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"修改密码成功");
            }
        } else {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

/**
 修改手机号
 */
+ (void)getModifyPhoneWithParameters:(NSDictionary *)parameters
                             success:(void (^)(NSString *success))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kMODIFY_PHONE_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"修改手机号成功");
            }
        } else {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

/**
 第三方登录
 */
+ (void)getThirdLoginWithParameters:(NSDictionary *)parameters
                            success:(void (^)(id object))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kTHIRD_LOGIN_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            LoginModel *model = [LoginModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
            [Config currentConfig].userUid = model.userUid;
            [Config currentConfig].mobile = model.userPhone;
            [Config currentConfig].username = model.userName;
//            account.rongCloudToken = model.rongCloudToken;
            [SDUserTool saveAccount:model];
            [CompanyService getIsPayCompanyWithSuccess:^(BOOL data) {} failure:^(NSUInteger code, NSString * _Nonnull errorStr) { }];
            if (success) {
                success(model.isPhone);
            }
        } else if ([ret integerValue] == 10004 || [ret integerValue] == 10005 || [ret integerValue] == 10007) {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        } else {
            if (failure) {
                failure([ret integerValue],@"登录失败");
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

/**
 用户协议
 */
+ (void)getUserProtocolWithParametersSuccess:(void (^)(id object))success
                                     failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kUSER_PROTOCOL_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success([responseObject objectForKey:@"data"]);
            }
        } else {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

/**
 绑定手机号
 */
+ (void)getBindPhoneWithParameters:(NSDictionary *)parameters
                           success:(void (^)(NSString *success))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kBIND_PHONE_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"绑定成功");
            }
        } else {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

/**
 验证验证码
 */
+ (void)getCheckCodeWithParameters:(NSDictionary *)parameters
                           success:(void (^)(NSString *success))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kCHECK_CODE_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"验证成功");
            }
        } else {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

@end
