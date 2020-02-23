//
//  AccountService.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EducationModel.h"
#import "WorkModel.h"
#import "PrivacyModel.h"
#import "QuestionClassModel.h"

@interface AccountService : NSObject

/**
 修改个人名片
 */
+ (void)getEditAccountMessageWithParameters:(NSDictionary *)parameters
                                       file:(NSData *)file
                                   fileName:(NSString *)fileName
                                    success:(void (^)(id model))success
                                    failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取教育经历
 */
+ (void)getEducationWithParameters:(NSDictionary *)parameters
                           success:(void (^)(EducationModel *model))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 新增教育经历
 */
+ (void)getAddEducationWithParameters:(NSDictionary *)parameters
                                 file:(NSData *)file
                             fileName:(NSString *)fileName
                              success:(void (^)(id model))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 修改教育经历
 */
+ (void)getEditEducationWithParameters:(NSDictionary *)parameters
                                  file:(NSData *)file
                              fileName:(NSString *)fileName
                               success:(void (^)(id model))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 删除教育经历
 */
+ (void)getDeleteEducationWithParameters:(NSDictionary *)parameters
                                 success:(void (^)(id model))success
                                 failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取工作经历
 */
+ (void)getWorkWithParameters:(NSDictionary *)parameters
                      success:(void (^)(WorkModel *model))success
                      failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 新增工作经历
 */
+ (void)getAddWorkWithParameters:(NSDictionary *)parameters
                            file:(NSData *)file
                        fileName:(NSString *)fileName
                         success:(void (^)(id model))success
                         failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 修改工作经历
 */
+ (void)getEditWorkWithParameters:(NSDictionary *)parameters
                             file:(NSData *)file
                         fileName:(NSString *)fileName
                          success:(void (^)(id model))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 删除工作经历
 */
+ (void)getDeleteWorkWithParameters:(NSDictionary *)parameters
                            success:(void (^)(id model))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 修改自我介绍
 */
+ (void)getEditIntroduceWithParameters:(NSString *)parameters
                               success:(void (^)(id model))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 评价用户
 */
+ (void)getPostCommentWithParameters:(NSDictionary *)parameters
                             success:(void (^)(id model))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 喜欢用户
 */
+ (void)getLikeWithParameters:(NSDictionary *)parameters
                      success:(void (^)(id model))success
                      failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 修改生日与家乡
 */
+ (void)editHomeTownWithParameters:(NSDictionary *)parameters
                           success:(void (^)(NSString *info))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取个人权限及黑名单
 */
+ (void)getPrivacyWithSuccess:(void (^)(PrivacyModel *model))success
                      failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 修改个人权限及黑名单
 */
+ (void)editPrivacyWithParameters:(NSDictionary *)parameters
                          success:(void (^)(NSString *info))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure;


/**
 点赞标签
 */
+ (void)getUPClassifyWithParameters:(NSString *)parameters
                            success:(void (^)(id model))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;


/**
 点赞评价
 */
+ (void)getUPCommentWithParameters:(NSString *)parameters
                           success:(void (^)(id model))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure;
/**
 获取（审核）系统消息
 */
+ (void)getSystemNotiMessageCenterWithParameters:(NSMutableDictionary *)parameters
                                         success:(void (^)(id model))success
                                         failure:(void (^)(NSUInteger code,NSString *errorStr))failure;
/**
 私信权限
 */
+ (void)getPrivateLetterWithParameters:(NSString *)parameters
                               success:(void (^)(id model))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 个人信息获取问答列表
 */
+ (void)getAccountQuestionWithParameters:(NSDictionary *)parameters
                                 success:(void (^)(NSArray *array))success
                                 failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

@end
