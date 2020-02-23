//
//  SearchService.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/1.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "SearchService.h"
#import "ThemeClassModel.h"
#import "QuestionClassModel.h"

@implementation SearchService

/**
 搜索好友
 */
+ (void)getSearchFriendWithParameters:(NSMutableDictionary *)parameters
                              success:(void (^)(SearchFriendModel *model))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{

    NSLog(@"搜索好友postDic = %@",parameters);
    
    [HttpClient sendPostRequest:kSEARCH_FRIEND_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            SearchFriendModel *dto = [SearchFriendModel yy_modelWithJSON:responseObject];
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
 搜索话题
 */
+ (void)getSearchThemeWithParameters:(NSMutableDictionary *)parameters
                             success:(void (^)(NSArray *model))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableArray *array = [NSMutableArray array];
    [HttpClient sendPostRequest:kSEARCH_THEME_URL parameters:parameters success:^(id responseObject) {
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
 搜索问答
 */
+ (void)getSearchQuestionWithParameters:(NSMutableDictionary *)parameters
                                success:(void (^)(NSArray *model))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableArray *array = [NSMutableArray array];
    [HttpClient sendPostRequest:kSEARCH_QUESTION_URL parameters:parameters success:^(id responseObject) {
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
