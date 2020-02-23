//
//  QuestionService.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "QuestionService.h"

@implementation QuestionService

+ (void)getQuestionUserClassifyWithSuccess:(void (^)(NSArray *info))success
                                   failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableArray *list = [NSMutableArray array];
    [HttpClient sendPostRequest:kGET_HANGJIA_CLASSIFYID_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSMutableDictionary *dict in data) {
                    ClassModel *model = [ClassModel yy_modelWithJSON:dict];
                    [list addObject:model];
                }
            }
            if (success) {
                success(list);
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
 根据回答用户id获取标签
 */
+ (void)getUserClassifyWithParameters:(NSString *)parameters
                              success:(void (^)(NSString *info))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"userUid"];
    
    NSLog(@"根据回答用户id获取标签 == %@",postDic);
    
    [HttpClient sendPostRequest:kUSER_CLASSIFYID_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success([responseObject objectForKey:@"data"]);
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
 根据标签获取用户
 */
+ (void)getUserByClassifyWithParameters:(NSMutableDictionary *)parameters
                                success:(void (^)(VisitorRecordModel *info))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{

    [HttpClient sendPostRequest:kGETUSER_CLASSIFYID_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        VisitorRecordModel *model = [VisitorRecordModel yy_modelWithJSON:responseObject];
        if ([ret integerValue] == 200) {
            if (success) {
                success(model);
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
 获取问答价格
 */
+ (void)getQuestionPriceWithParameters:(NSString *)parameters
                               success:(void (^)(NSString *info))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
//    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
//    [postDic setValue:parameters forKey:@"classifyId"];
    
    [HttpClient sendPostRequest:kGET_QUESTION_PRICE_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(responseObject[@"data"][@"pricing"]);
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
 添加问答
 */
+ (void)getAddQuestionWithParameters:(NSMutableDictionary *)parameters
                             success:(void (^)(NSString *info))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kADD_QUESTION_URL parameters:parameters success:^(id responseObject) {
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
 下单
 */
+ (void)getPostQuestionOrderWithParameters:(NSMutableDictionary *)parameters
                                   success:(void (^)(id info))success
                                   failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kPOST_QUESTION_ORDER_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
//            PayModel *model = [PayModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
            if (success) {
                success([responseObject objectForKey:@"data"]);
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
 回答问答
 */
+ (void)getAnswerQuestionWithParameters:(NSMutableDictionary *)parameters
                                success:(void (^)(NSString *info))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kANSWER_QUESTION_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"回答成功");
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
 问答详情
 */
+ (void)getQuestionDetailWithParameters:(NSString *)parameters
                                success:(void (^)(QuestionDetailModel *info))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"id"];

    [HttpClient sendPostRequest:kQUESTION_DETAIL_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            QuestionDetailModel *model = [QuestionDetailModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
            if (success) {
                success(model);
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
 搜索用户
 */
+ (void)getSearchUserWithParameters:(NSMutableDictionary *)parameters
                            success:(void (^)(NSArray *array))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    
    NSLog(@"搜索用户postDic = %@",parameters);
    NSMutableArray *list = [NSMutableArray array];
    [HttpClient sendPostRequest:kSEARCH_USER_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in data) {
                    VisitorModel *dto = [VisitorModel yy_modelWithJSON:dict];
                    [list addObject:dto];
                }
            }
            if (success) {
                success(list);
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
