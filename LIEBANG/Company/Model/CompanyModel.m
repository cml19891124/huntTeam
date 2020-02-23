//
//  CompanyModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CompanyModel.h"

@implementation CompanyModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"staff" : [StaffModel class],
             @"productServiceImages" : [NSString class],
             @"recruitImages" : [NSString class],
             @"companyInfoImages" : [NSString class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"comLogo" : @"comment.comLogo",
             @"comment" : @"comment.comment",
             @"commentUserUid" : @"comment.userUid",
             @"commentUserHead" : @"comment.commentUserHead",
             @"commentUserName" : @"comment.commentUserName",
             @"company" : @"comment.company",
             @"isOccupation" : @"comment.isOccupation",
             @"isBasic" : @"comment.isBasic",
             @"position" : @"comment.position"
             };
}

@end

@implementation StaffModel

@end
