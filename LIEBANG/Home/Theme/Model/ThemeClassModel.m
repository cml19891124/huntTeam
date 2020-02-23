//
//  ThemeClassModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/21.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ThemeClassModel.h"

@implementation ThemeClassModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"map_helpNum" : @"UserAccountFormMap.helpNum",
             @"isBasic" : @"UserAccountFormMap.isBasic",
             @"dataPrivacyType" : @"UserAccountFormMap.dataPrivacyType",
             @"isEducation" : @"UserAccountFormMap.isEducation",
             @"isOccupation" : @"UserAccountFormMap.isOccupation",
             @"isOccupationOne" : @"UserAccountFormMap.isOccupationOne",

             @"starLevel" : @"UserAccountFormMap.starLevel",
             @"userName" : @"UserAccountFormMap.userName",
             @"userHead" : @"UserAccountFormMap.userHead",
             @"userUid" : @"UserAccountFormMap.userUid",
             @"userPhone" : @"UserAccountFormMap.userPhone",
             @"position" : @"UserAccountFormMap.position",
             @"company" : @"UserAccountFormMap.company"

             };
}


@end
