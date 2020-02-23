//
//  ThemeOrderModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/15.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ThemeOrderModel.h"
#import "ThemeModel.h"

@implementation ThemeOrderModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"data" : [ThemeModel class]
             };
}

@end
