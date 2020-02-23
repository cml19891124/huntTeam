//
//  AccountModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/30.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"classify" : [OClassifyModel class]
             };
}

@end

@implementation OClassifyModel

@end
