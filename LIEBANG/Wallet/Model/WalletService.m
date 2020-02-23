//
//  WalletService.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "WalletService.h"

@implementation WalletService

/**
 充值
 */
+ (void)getRechargeWithParameters:(NSMutableDictionary *)parameters
                          success:(void (^)(PayModel *data))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kRECHARGE_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            PayModel *model = [PayModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
            if (success) {
                success(model);
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
 钱包列表
 */
+ (void)getWalletWithParameters:(NSMutableDictionary *)parameters
                        success:(void (^)(WalletListModel *model))success
                        failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kASSET_DETAIL_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            WalletListModel *dto = [WalletListModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
            if (success) {
                success(dto);
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
 是否绑定微信
 */
+ (void)getIsWechatWithSuccess:(void (^)(NSString *info))success
                       failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kIS_WECHAT_URL parameters:nil success:^(id responseObject) {
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
 提现
 */
+ (void)getWithDrawWithParameters:(NSMutableDictionary *)parameters
                          success:(void (^)(id data))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kFORWARD_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(responseObject[@"data"][@"status"]);
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
 猎帮币充值
 */
+ (void)appleRechargeWithParameters:(NSMutableArray *)parameters
                            success:(void (^)(NSString *data))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableArray *list = [NSMutableArray array];
    for (NSString *key in parameters) {
        NSDictionary *dict= @{@"receipt":key};
        [list addObject:dict];
    }
    NSLog(@"猎帮币充值count == %zd",parameters.count);

    [HttpClient sendPostRequest:kAPPLE_RECHARGE_URL parameters:list success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success([responseObject objectForKey:@"msg"]);
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
