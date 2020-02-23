//
//  CertiService.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MechanismModel.h"

@interface CertiService : NSObject

/**
 工作经历认证
 */
+ (void)getCertiWorkWithParameters:(NSMutableDictionary *)parameters
                              file:(NSArray *)file
                          fileName:(NSArray *)fileName
                           success:(void (^)(NSString *info))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 教育经历认证
 */
+ (void)getCertiEducationWithParameters:(NSMutableDictionary *)parameters
                                   file:(NSArray *)file
                               fileName:(NSArray *)fileName
                                success:(void (^)(NSString *info))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 基础认证
 */
+ (void)getCertiBasicWithParameters:(NSMutableDictionary *)parameters
                               file:(NSArray *)file
                           fileName:(NSArray *)fileName
                            success:(void (^)(NSString *info))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 机构认证
 */
+ (void)getCertiMechanismWithParameters:(NSMutableDictionary *)parameters
                                   file:(NSData *)file
                               fileName:(NSString *)fileName
                                success:(void (^)(NSString *info))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取机构认证
 */
+ (void)getMechanismResultWithSuccess:(void (^)(MechanismModel *info))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取所有教育经历
 */
+ (void)getAllEduResultWithSuccess:(void (^)(NSArray *info))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取所有工作经历
 */
+ (void)getAllWorkResultWithSuccess:(void (^)(NSArray *info))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取认证打码图片
 
 BASIC_MOSAIC(0, "基础认证未打码"),
 OCCUPATION_MOSAIC(1, "工作经历未打码"),
 EDUCATION_MOSAIC(2, "教育经历未打码"),
 MECHANISM_MOSAIC(3, "机构认证未打码");
 */
+ (void)getMosaicImageWithType:(NSString *)type
                       userUid:(NSString *)userUid
                       success:(void (^)(id info))success
                       failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取认证打码图片--经历
 
 BASIC_MOSAIC(0, "基础认证未打码"),
 OCCUPATION_MOSAIC(1, "工作经历未打码"),
 EDUCATION_MOSAIC(2, "教育经历未打码"),
 MECHANISM_MOSAIC(3, "机构认证未打码");
 */
+ (void)getUserMosaicImageWithType:(NSString *)type
                                Uid:(NSString *)Uid
                           success:(void (^)(id info))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取个人认证状态
 */
+ (void)getBasicCertResultWithSuccess:(void (^)(NSDictionary *info))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取基础认证
 */
+ (void)getBasicCertMessageWithSuccess:(void (^)(id info))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 上传认证图片
 */
+ (void)postCertiImageWithParameters:(NSMutableDictionary *)parameters
                                 file:(NSArray *)file
                             fileName:(NSArray *)fileName
                              success:(void (^)(NSString *info))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 认证提交审核
 */
+ (void)postCertiSourceWithParameters:(NSMutableDictionary *)parameters
                               success:(void (^)(NSString *info))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

@end
