//
//  ClassService.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ClassService.h"
#import "QuestionClassModel.h"
#import "ThemeClassModel.h"

@implementation ClassService

/**
 添加话题
 */
+ (void)getAddThemeWithParameters:(NSMutableDictionary *)parameters
                          success:(void (^)(NSString *info))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kADD_THEME_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"添加成功");
            }
        } else {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

/**
 编辑话题
 */
+ (void)getEditThemeWithParameters:(NSMutableDictionary *)parameters
                           success:(void (^)(NSString *info))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kEDIT_THEME_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"");
            }
        } else {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

/**
 删除话题
 */
+ (void)getDeleteThemeWithParameters:(NSMutableDictionary *)parameters
                             success:(void (^)(NSString *info))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kDELETE_THEME_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"删除成功");
            }
        } else {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

/**
 话题筛选
 */
+ (void)getThemeListWithParameters:(NSMutableDictionary *)parameters
                           success:(void (^)(NSArray *list))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableArray *array = [NSMutableArray array];
    [HttpClient sendPostRequest:kTHEME_LIST_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in data) {
                    ThemeClassModel *model = [ThemeClassModel yy_modelWithJSON:dict];
                    [array addObject:model];
                }
            }
            if (success) {
                success(array);
            }
        } else {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

/**
 话题详情
 */
+ (void)getThemeDetailWithParameters:(NSString *)parameters
                             success:(void (^)(ThemeClassModel *model))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"id"];
    
    NSLog(@"话题详情 == %@",postDic);

    [HttpClient sendGetRequest:kTHEME_DETAIL_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            ThemeClassModel *dto = [ThemeClassModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
            if (success) {
                success(dto);
            }
        } else {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

/**
 问题筛选
 */
+ (void)getQuestionListWithParameters:(NSMutableDictionary *)parameters
                              success:(void (^)(NSArray *list))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableArray *array = [NSMutableArray array];
    [HttpClient sendPostRequest:kQUESTION_LIST_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in data) {
                    QuestionClassModel *model = [QuestionClassModel yy_modelWithJSON:dict];
                    [array addObject:model];
                }
            }
            if (success) {
                success(array);
            }
        } else {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

@end
