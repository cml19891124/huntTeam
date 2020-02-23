//
//  AllClassModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/30.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AllClassModel.h"

@implementation AllClassModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"data" : [ClassModel class]
             };
}

@end

@implementation ClassModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"classifyTwo" : [ClassifyTwoModel class]
             };
}

@end

@implementation ClassifyTwoModel

@end
