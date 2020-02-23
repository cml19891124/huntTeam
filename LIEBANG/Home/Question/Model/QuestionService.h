//
//  QuestionService.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VisitorRecordModel.h"
#import "QuestionDetailModel.h"
#import "FriendModel.h"
#import "PayModel.h"
#import "AllClassModel.h"

@interface QuestionService : NSObject

/**
 获取推荐行家
 */
+ (void)getQuestionUserClassifyWithSuccess:(void (^)(NSArray *info))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 根据回答用户id获取标签
 */
+ (void)getUserClassifyWithParameters:(NSString *)parameters
                              success:(void (^)(NSString *info))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 根据标签获取用户
 */
+ (void)getUserByClassifyWithParameters:(NSMutableDictionary *)parameters
                                success:(void (^)(VisitorRecordModel *info))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取问答价格
 */
+ (void)getQuestionPriceWithParameters:(NSString *)parameters
                               success:(void (^)(NSString *info))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 添加问答
 */
+ (void)getAddQuestionWithParameters:(NSMutableDictionary *)parameters
                             success:(void (^)(NSString *info))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 下单
 */
+ (void)getPostQuestionOrderWithParameters:(NSMutableDictionary *)parameters
                                   success:(void (^)(id info))success
                                   failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 回答问答
 */
+ (void)getAnswerQuestionWithParameters:(NSMutableDictionary *)parameters
                                success:(void (^)(NSString *info))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 问答详情
 */
+ (void)getQuestionDetailWithParameters:(NSString *)parameters
                                success:(void (^)(QuestionDetailModel *info))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 搜索用户
 */
+ (void)getSearchUserWithParameters:(NSMutableDictionary *)parameters
                            success:(void (^)(NSArray *array))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

@end
