//
//  OrderService.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionOrderModel.h"
#import "ThemeOrderModel.h"
#import "QuestionOrderDetailModel.h"
#import "ThemeOrderDetailModel.h"
#import "OrderReadModel.h"

@interface OrderService : NSObject

/**
 获取话题订单
 */
+ (void)getThemeOrderWithParameters:(NSDictionary *)parameters
                            success:(void (^)(ThemeOrderModel *info))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取问答订单
 */
+ (void)getQuestionOrderWithParameters:(NSDictionary *)parameters
                               success:(void (^)(QuestionOrderModel *info))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 问答订单详情
 */
+ (void)getQuestionOrderDetailWithParameters:(NSMutableDictionary *)parameters
                                     success:(void (^)(QuestionOrderDetailModel *info))success
                                     failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 话题订单详情
 */
+ (void)getThemeOrderDetailWithParameters:(NSDictionary *)parameters
                                  success:(void (^)(ThemeOrderDetailModel *info))success
                                  failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取未读数量
 */
+ (void)getOrderReadWithParameters:(NSString *)parameters
                           success:(void (^)(OrderReadModel *info))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 取消订单
 */
+ (void)getCancelOrderWithParameters:(NSString *)parameters
                             success:(void (^)(NSString *info))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 删除订单
 */
+ (void)getDeleteOrderWithParameters:(NSString *)parameters
                             success:(void (^)(NSString *info))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;
/**
 删除卖家订单
 */
+ (void)getDeleteSellerOrderWithParameters:(NSString *)parameters
                             success:(void (^)(NSString *info))success
                                   failure:(void (^)(NSUInteger code,NSString *errorStr))failure;
/**
 评价订单
 */
+ (void)getPostOrderCommentWithParameters:(NSDictionary *)parameters
                                  success:(void (^)(NSString *success))success
                                  failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 评价话题订单
 */
+ (void)getPostThemeOrderCommentWithParameters:(NSDictionary *)parameters
                                        success:(void (^)(NSString *success))success
                                        failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 问答详情评价--游客
 */
+ (void)getPostQuestionCommentWithParameters:(NSDictionary *)parameters
                                     success:(void (^)(NSString *success))success
                                     failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 忽略话题
 */
+ (void)getCancelThemeWithParameters:(NSString *)parameters
                             success:(void (^)(NSString *info))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 忽略问题
 */
+ (void)getCancelQuestionWithParameters:(NSString *)parameters
                                success:(void (^)(NSString *info))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 行家确认预约话题
 */
+ (void)getExpAppointmentThemeWithParameters:(NSMutableDictionary *)parameters
                                     success:(void (^)(NSString *info))success
                                     failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 用户确认预约话题
 */
+ (void)getAppointmentThemeWithParameters:(NSMutableDictionary *)parameters
                                  success:(void (^)(NSString *info))success
                                  failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 用户话题确认服务完成
 */
+ (void)getUserConfimThemeWithParameters:(NSMutableDictionary *)parameters
                                 success:(void (^)(NSString *info))success
                                 failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 行家话题确认服务完成
 */
+ (void)getExpConfimThemeWithParameters:(NSMutableDictionary *)parameters
                                success:(void (^)(NSString *info))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 提醒行家
 */
+ (void)getRemindExpertWithParameters:(NSMutableDictionary *)parameters
                              success:(void (^)(NSString *info))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

@end
