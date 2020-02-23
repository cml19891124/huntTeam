//
//  UserHelpModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/13.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "UserHelpModel.h"

@implementation UserHelpModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"help" : [HelpModel class]
             };
}

@end

@implementation HelpModel

@end
