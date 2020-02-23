//
//  QuestionDetailModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/4.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "QuestionDetailModel.h"

@implementation QuestionDetailModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"question" : [RecommendQuestionModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"helpNum" : @"UserAccountFormMap.helpNum",
             @"isOccupation" : @"UserAccountFormMap.isOccupation",
             @"isOccupationOne" : @"UserAccountFormMap.isOccupationOne",
             @"company": @"UserAccountFormMap.company",
             @"position" : @"UserAccountFormMap.position",
             @"userName" : @"UserAccountFormMap.userName",
             @"userUid" : @"UserAccountFormMap.userUid",
             @"isBasic" : @"UserAccountFormMap.isBasic",
             @"isEducation" : @"UserAccountFormMap.isEducation",
             @"starLevel" : @"UserAccountFormMap.starLevel",
             @"userHead" : @"UserAccountFormMap.userHead"
             };
}

@end

@implementation RecommendQuestionModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"answerUserUid" : @"AnswerUser.userUid",
             @"answerUserName" : @"AnswerUser.userName",
             @"answerUserPhone" : @"AnswerUser.userPhone",
             @"answerisOccupation" : @"AnswerUser.isOccupation",
             @"answerid" : @"AnswerUser.id",
             
             @"answerCompany" : @"AnswerUser.company",
             @"answerHelpNum" : @"AnswerUser.helpNum",
             @"answerIsBasic" : @"AnswerUser.isBasic",
             @"answerIsEducation" : @"AnswerUser.isEducation",
             @"answerPosition" : @"AnswerUser.position",
             @"answerUserHead" : @"AnswerUser.userHead",
             
             
             @"questionUserUid" : @"QuestionUser.userUid",
             @"questionUserName" : @"QuestionUser.userName",
             @"questionid" : @"QuestionUser.id",
             @"questionisOccupation" : @"QuestionUser.isOccupation",
             @"questionUserPhone" : @"QuestionUser.userPhone"
             };
}

@end
