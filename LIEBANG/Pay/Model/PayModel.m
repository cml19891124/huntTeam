//
//  PayModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/8.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PayModel.h"

@implementation PayModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"appid" : @"wxpay_url.appid",
             @"info" : @"wxpay_url.info",
             @"msg" : @"wxpay_url.msg",
             @"noncestr" : @"wxpay_url.noncestr",
             @"package" : @"wxpay_url.package",
             @"partnerid" : @"wxpay_url.partnerid",
             @"prepayid" : @"wxpay_url.prepayid",
             @"sign" : @"wxpay_url.sign",
             @"timestamp" : @"wxpay_url.timestamp"
             };
}

@end
