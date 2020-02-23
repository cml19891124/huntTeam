//
//  QuestionOrderDetailModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "QuestionOrderDetailModel.h"
#import "QuestionDetailModel.h"

@implementation QuestionOrderDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"helpNum" : @"QuestionFormMap.QuestionUserAccount.helpNum",
             @"isBasic" : @"QuestionFormMap.QuestionUserAccount.isBasic",
             @"isEducation" : @"QuestionFormMap.QuestionUserAccount.isEducation",
             @"company" : @"QuestionFormMap.QuestionUserAccount.company",

             @"position" : @"QuestionFormMap.QuestionUserAccount.position",
             @"isOccupation" : @"QuestionFormMap.QuestionUserAccount.isOccupation",
             @"isOccupationOne" : @"QuestionFormMap.QuestionUserAccount.isOccupationOne",

             @"starLevel" : @"QuestionFormMap.QuestionUserAccount.starLevel",
             @"userName" : @"QuestionFormMap.QuestionUserAccount.userName",
             @"userHead" : @"QuestionFormMap.QuestionUserAccount.userHead",
             @"userUid" : @"QuestionFormMap.QuestionUserAccount.userUid",
             @"QuestionFormMapUid" : @"QuestionFormMap.id",
             @"quizcontent" : @"QuestionFormMap.quizcontent",
             @"startLevel" : @"QuestionFormMap.startLevel",
             @"answerContent" : @"QuestionFormMap.answerContent",
             @"endTime" : @"QuestionFormMap.endTime",
             @"recommendedQuestion" : @"question",
             @"answerUid" : @"QuestionFormMap.answerUid"
             };
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"recommendedQuestion" : [RecommendQuestionModel class]
             };
}

@end
