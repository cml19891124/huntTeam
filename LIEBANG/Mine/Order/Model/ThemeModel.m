//
//  ThemeModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/15.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ThemeModel.h"

@implementation ThemeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"helpNum" : @"TopicFormMap.UserAccountFormMap.helpNum",
             @"userUid" : @"TopicFormMap.UserAccountFormMap.userUid",
             @"isBasic" : @"TopicFormMap.UserAccountFormMap.isBasic",
             @"isEducation" : @"TopicFormMap.UserAccountFormMap.isEducation",
             @"isOccupation" : @"TopicFormMap.UserAccountFormMap.isOccupation",
             @"isOccupationOne" : @"TopicFormMap.UserAccountFormMap.isOccupationOne",

             @"starLevel" : @"TopicFormMap.UserAccountFormMap.starLevel",
             @"userName" : @"TopicFormMap.UserAccountFormMap.userName",
             @"userHead" : @"TopicFormMap.UserAccountFormMap.userHead",
             @"position" : @"TopicFormMap.UserAccountFormMap.position",
             @"userPosition" : @"TopicFormMap.UserAccountFormMap.userPosition",
             @"createTime" : @"TopicFormMap.createTime",
             @"TopicFormMap_id" : @"TopicFormMap.id",
             @"serviceTime" : @"TopicFormMap.serviceTime",
             @"Remarks" : @"TopicFormMap.Remarks",
             @"topicPrice" : @"TopicFormMap.topicPrice",
             @"originalPrice" : @"TopicFormMap.originalPrice",
             @"serviceType" : @"TopicFormMap.serviceType",
             @"startLevel" : @"TopicFormMap.startLevel",
             @"serviceIn" : @"TopicFormMap.serviceIn",
             @"topicName" : @"TopicFormMap.topicName",
             @"company" : @"TopicFormMap.UserAccountFormMap.company"

             };
}

@end
