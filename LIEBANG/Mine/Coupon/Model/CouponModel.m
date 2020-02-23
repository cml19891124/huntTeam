//
//  CouponModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/30.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CouponModel.h"

@implementation CouponModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"data" : [CouponListModel class]
             };
}

@end

@implementation CouponListModel


@end

