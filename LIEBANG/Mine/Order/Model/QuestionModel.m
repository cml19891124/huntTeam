//
//  QuestionModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/15.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"helpNum" : @"QuestionFormMap.UserAccountFormMap.helpNum",
             @"userUid" : @"QuestionFormMap.UserAccountFormMap.userUid",
             @"type" : @"QuestionFormMap.UserAccountFormMap.UserDataPrivacyFormMap.type",
             @"isBasic" : @"QuestionFormMap.UserAccountFormMap.isBasic",
             @"isEducation" : @"QuestionFormMap.UserAccountFormMap.isEducation",
             @"isOccupation" : @"QuestionFormMap.UserAccountFormMap.isOccupation",
             @"isOccupationOne" : @"QuestionFormMap.UserAccountFormMap.isOccupationOne",

             @"starLevel" : @"QuestionFormMap.UserAccountFormMap.starLevel",
             @"userName" : @"QuestionFormMap.UserAccountFormMap.userName",
             @"userHead" : @"QuestionFormMap.UserAccountFormMap.userHead",
             @"company" : @"QuestionFormMap.UserAccountFormMap.company",
             @"position" : @"QuestionFormMap.UserAccountFormMap.position",
             @"createTime" : @"QuestionFormMap.createTime",
             @"endTime" : @"QuestionFormMap.endTime",
             @"startLevel" : @"QuestionFormMap.startLevel",
             @"quizcontent" : @"QuestionFormMap.quizcontent"
             };
}

@end
