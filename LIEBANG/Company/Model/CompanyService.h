//
//  CompanyService.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyModel.h"
#import "PendModel.h"
#import "PayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyService : NSObject

/**
 我的企业推荐
 */
+ (void)getCompanyWelcomeWithSuccess:(void (^)(StaffModel *data))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 我的企业名片列表
 */
+ (void)getCompanyListWithParameters:(NSString *)parameters
                             success:(void (^)(NSArray *data))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 我认领的企业名片列表
 */
+ (void)getClaimCompanyListWithParameters:(NSMutableDictionary *)parameters
                                  success:(void (^)(NSArray *data))success
                                  failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 收藏企业
 */
+ (void)addCollectCompanyWithParameters:(NSString *)parameters
                                success:(void (^)(NSString *data))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 通过企业认领
 */
+ (void)passStallCompanyWithParameters:(NSString *)parameters
                                success:(void (^)(NSString *data))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 拒绝企业认领
 */
+ (void)refuseStallCompanyWithParameters:(NSString *)parameters
                                 success:(void (^)(NSString *data))success
                                 failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 认领企业申请
 */
+ (void)getStallCompanyWithParameters:(NSString *)parameters
                               success:(void (^)(NSString *data))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 企业员工列表
 */
+ (void)getStallListCompanyWithParameters:(NSMutableDictionary *)parameters
                                   success:(void (^)(NSArray *data))success
                                   failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 企业点评列表
 */
+ (void)getCommentListCompanyWithParameters:(NSMutableDictionary *)parameters
                                    success:(void (^)(NSArray *data))success
                                     failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 企业点评
 */
+ (void)postCommentCompanyWithParameters:(NSMutableDictionary *)parameters
                                 success:(void (^)(NSString *data))success
                                 failure:(void (^)(NSUInteger code,NSString *errorStr))failure;
/**
 //10.23 新增接口  企业名片详情
 */
+ (void)getCompanyCertDetail:(NSMutableDictionary *)parameters Success:(void (^)(CompanyModel *data))success
failure:(void (^)(NSUInteger code,NSString *errorStr))failure;
/**
 企业名片详情
 */
+ (void)getCompanyDetailWithParameters:(NSMutableDictionary *)parameters
                                success:(void (^)(CompanyModel *data))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 企业名片付款
 */
+ (void)postCompanyPayWithParameters:(NSMutableDictionary *)parameters
                             success:(void (^)(NSString *data))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 企业认证提交审核
 */
+ (void)postCompanyCertWithParameters:(NSMutableDictionary *)parameters
                             success:(void (^)(NSString *data))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 企业认证保存信息
 */
+ (void)saveCompanyCertWithParameters:(NSMutableDictionary *)parameters
                                 file:(NSArray *)file
                             fileName:(NSArray *)fileName
                              success:(void (^)(NSString *data))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取企业付费列表
 */
+ (void)getCompanyPayListWithSuccess:(void (^)(NSArray *data))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 收藏企业列表
 */
+ (void)getCompanyCollectListWithParameters:(NSMutableDictionary *)parameters
                                    success:(void (^)(NSArray *data))success
                                    failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 删除收藏企业
 */
+ (void)removeCompanyCollectWithParameters:(NSString *)parameters
                                    success:(void (^)(NSString *data))success
                                    failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 删除员工
 */
+ (void)removeCompanyStallWithParameters:(NSString *)parameters
                                  success:(void (^)(NSString *data))success
                                  failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 待处理消息
 */
+ (void)getTreatedMessageWithSuccess:(void (^)(PendModel *data))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 待处理消息详情
 */
+ (void)getTreatedMessageDetailWithParameters:(NSMutableDictionary *)parameters
                                      success:(void (^)(NSArray *data))success
                                      failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 添加员工
 */
+ (void)addCompanyStallWithParameters:(NSMutableDictionary *)parameters
                              success:(void (^)(NSString *data))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 搜索企业列表
 */
+ (void)searchCompanyListWithParameters:(NSMutableDictionary *)parameters
                                success:(void (^)(NSArray *data))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 我的企业名片数量
 */
+ (void)getCompanyNumberWithSuccess:(void (^)(NSDictionary *data))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 是否购买过企业名片
 true：购买过
 false：未购买过
 */
+ (void)getIsPayCompanyWithSuccess:(void (^)(BOOL data))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 企业名片付款
 */
+ (void)payCompanyWithParameters:(NSMutableDictionary *)parameters
                         success:(void (^)(PayModel *data))success
                         failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 删除已认领的企业
 */
+ (void)removeCompanyClaimWithParameters:(NSString *)parameters
                                 success:(void (^)(NSString *data))success
                                 failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

@end

NS_ASSUME_NONNULL_END
