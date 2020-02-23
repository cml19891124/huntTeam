//
//  CouponService.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CouponModel.h"

@interface CouponService : NSObject

/**
 获取优惠券
 */
+ (void)getCouponListWithParameters:(NSDictionary *)parameters
                            success:(void (^)(CouponModel *model))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 优惠券说明
 */
+ (void)getCouponDetailWithParameters:(NSDictionary *)parameters
                              success:(void (^)(NSString *success))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

@end
