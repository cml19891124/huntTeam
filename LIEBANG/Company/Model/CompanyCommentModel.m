//
//  CompanyCommentModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CompanyCommentModel.h"

@implementation CompanyCommentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"comLogo" : @"comLogo",
             @"comment" : @"comment",
             @"userUid" : @"commentUserUid",
             @"userHead" : @"commentUserHead",
             @"userName" : @"commentUserName",
             @"company" : @"company",
             @"isOccupation" : @"isOccupation",
             @"isOccupationOne" : @"isOccupationOne",
             @"isBasic" : @"isBasic",
             @"position" : @"position"
             };
}

@end
