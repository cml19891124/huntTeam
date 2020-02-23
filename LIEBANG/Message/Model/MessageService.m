//
//  MessageService.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "MessageService.h"
#import "SystemModel.h"

@implementation MessageService

/**
 访客记录
 */
+ (void)getVisitorWithParameters:(NSDictionary *)parameters
                         success:(void (^)(VisitorRecordModel *info))success
                         failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kVISITOR_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            VisitorRecordModel *model = [VisitorRecordModel yy_modelWithJSON:responseObject];
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
 系统消息
 */
+ (void)getSystemMessageWithParameters:(NSDictionary *)parameters
                               success:(void (^)(NSArray *info))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    [HttpClient sendPostRequest:kSYSTEM_MESSAGE_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in data) {
                    SystemModel *model = [SystemModel yy_modelWithJSON:dict];
                    [dataArray addObject:model];
                }
            }
            if (success) {
                success(dataArray);
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
 删除系统消息
 */
+ (void)getDeleteSystemMessageWithParameters:(NSString *)parameters
                                     success:(void (^)(NSString *info))success
                                     failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"id"];
    
    [HttpClient sendPostRequest:kDELETE_SYSTEM_MESSAGE_URL parameters:postDic success:^(id responseObject) {
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
 消息红点
 */
+ (void)getMessageRedButtonWithSuccess:(void (^)(NSDictionary *info))success
{
    [HttpClient sendGetRequest:kMESSAGE_RED_BUTTON_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {//system系统红点、visit访客红点、privateLetter私信红点
            id data = [responseObject objectForKey:@"data"];
            NSLog(@"消息红点info == %@",data);            
            if (success) {
                success(data);
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        
    }];
}

/**
 是否好友
 */
+ (void)isFriendWithParameters:(NSString *)parameters
                       success:(void (^)(NSString *info))success
                       failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"friendUid"];
    
    [HttpClient sendPostRequest:kIS_FRIEND_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];//1好友  0=非好友
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

@end
