//
//  QuestionOrderModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/15.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "QuestionOrderModel.h"
#import "QuestionModel.h"

@implementation QuestionOrderModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"data" : [QuestionModel class]
             };
}

@end
