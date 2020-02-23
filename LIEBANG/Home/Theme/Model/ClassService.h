//
//  ClassService.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassService : NSObject

/**
 添加话题
 */
+ (void)getAddThemeWithParameters:(NSMutableDictionary *)parameters
                          success:(void (^)(NSString *info))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 编辑话题
 */
+ (void)getEditThemeWithParameters:(NSMutableDictionary *)parameters
                           success:(void (^)(NSString *info))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 删除话题
 */
+ (void)getDeleteThemeWithParameters:(NSMutableDictionary *)parameters
                              success:(void (^)(NSString *info))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 话题筛选
 */
+ (void)getThemeListWithParameters:(NSMutableDictionary *)parameters
                           success:(void (^)(NSArray *list))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 话题详情
 */
+ (void)getThemeDetailWithParameters:(NSString *)parameters
                             success:(void (^)(ThemeClassModel *model))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 问题筛选
 */
+ (void)getQuestionListWithParameters:(NSMutableDictionary *)parameters
                              success:(void (^)(NSArray *list))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

@end
