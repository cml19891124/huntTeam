//
//  ThemeOrderDetailModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ThemeOrderDetailModel.h"

@implementation ThemeOrderDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"helpNum" : @"TopicFormMap.TopicUserAccount.helpNum",
             @"isBasic" : @"TopicFormMap.TopicUserAccount.isBasic",
             @"isEducation" : @"TopicFormMap.TopicUserAccount.isEducation",
             @"isOccupation" : @"TopicFormMap.TopicUserAccount.isOccupation",
             @"isOccupationOne" : @"TopicFormMap.TopicUserAccount.isOccupationOne",

             @"starLevel" : @"TopicFormMap.TopicUserAccount.starLevel",
             @"userName" : @"TopicFormMap.TopicUserAccount.userName",
             @"userHead" : @"TopicFormMap.TopicUserAccount.userHead",
             @"userPhone" : @"TopicFormMap.TopicUserAccount.userPhone",
             @"position" : @"TopicFormMap.TopicUserAccount.position",
             @"company" : @"TopicFormMap.TopicUserAccount.company",
             @"userUid" : @"TopicFormMap.TopicUserAccount.userUid",
             @"originalPrice" : @"TopicFormMap.originalPrice",
             @"serviceTime" : @"TopicFormMap.serviceTime",
             @"topicPrice" : @"TopicFormMap.topicPrice",
             @"serviceType" : @"TopicFormMap.serviceType",
             @"startLevel" : @"TopicFormMap.startLevel",
             @"topicName" : @"TopicFormMap.topicName",
             
             @"StudenthelpNum" : @"studentUser.helpNum",
             @"StudentisBasic" : @"studentUser.isBasic",
             @"StudentisEducation" : @"studentUser.isEducation",
             @"StudentisOccupation" : @"studentUser.isOccupation",
             @"StudentisOccupationOne" : @"studentUser.isOccupationOne",

             @"StudentregistrationId" : @"studentUser.registrationId",
             @"StudentuserName" : @"studentUser.userName",
             @"StudentuserPhone" : @"studentUser.userPhone",
             
             @"StudentuserHead" : @"studentUser.userHead",
             @"Studentposition" : @"studentUser.position",
             @"Studentcompany" : @"studentUser.company",
             
             @"StudentuserUid" : @"studentUser.userUid"
             };
}

@end

@implementation StudentUser

@end
