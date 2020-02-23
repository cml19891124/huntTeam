//
//  WalletService.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WalletListModel.h"
#import "PayModel.h"

@interface WalletService : NSObject

/**
 充值
 */
+ (void)getRechargeWithParameters:(NSMutableDictionary *)parameters
                          success:(void (^)(PayModel *data))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 钱包列表
 */
+ (void)getWalletWithParameters:(NSMutableDictionary *)parameters
                        success:(void (^)(WalletListModel *model))success
                        failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 是否绑定微信
 */
+ (void)getIsWechatWithSuccess:(void (^)(NSString *info))success
                       failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 提现
 */
+ (void)getWithDrawWithParameters:(NSMutableDictionary *)parameters
                          success:(void (^)(id data))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 猎帮币充值
 */
+ (void)appleRechargeWithParameters:(NSMutableArray *)parameters
                            success:(void (^)(NSString *data))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

@end
