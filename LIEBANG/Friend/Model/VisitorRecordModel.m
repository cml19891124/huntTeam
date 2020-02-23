//
//  VisitorRecordModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/2.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "VisitorRecordModel.h"

@implementation VisitorRecordModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"data" : [VisitorModel class]
             };
}

@end

@implementation VisitorModel

@end
