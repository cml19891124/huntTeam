//
//  QuestionClassModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/21.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "QuestionClassModel.h"

@implementation QuestionClassModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"helpNum" : @"UserAccountFormMap.helpNum",
             @"isBasic" : @"UserAccountFormMap.isBasic",
             @"dataPrivacyType" : @"UserAccountFormMap.dataPrivacyType",
             @"isEducation" : @"UserAccountFormMap.isEducation",
             @"isOccupation" : @"UserAccountFormMap.isOccupation",
             @"starLevel" : @"UserAccountFormMap.starLevel",
             @"userName" : @"UserAccountFormMap.userName",
             @"starLevel" : @"UserAccountFormMap.starLevel",
             @"position" : @"UserAccountFormMap.position",
             @"userUid" : @"UserAccountFormMap.userUid",
             @"userPhone" : @"UserAccountFormMap.userPhone",
             @"userHead" : @"UserAccountFormMap.userHead",
             @"company":@"UserAccountFormMap.company"
             };
}

@end
