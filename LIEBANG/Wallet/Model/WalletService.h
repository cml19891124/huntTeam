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
 钱包列表
 */
+ (void)getWalletWithParameters:(NSMutableDictionary *)parameters
                        success:(void (^)(WalletListModel *model))success
                        failure:(void (^)(NSUInteger code,NSString *errorStr))failure;
/**
 猎帮币充值
 */
+ (void)appleRechargeWithParameters:(NSMutableArray *)parameters
                            success:(void (^)(NSString *data))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

@end
