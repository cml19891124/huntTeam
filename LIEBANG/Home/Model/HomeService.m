//
//  HomeService.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "HomeService.h"

@implementation HomeService

/**
 首页
 */
+ (void)getHomeWithParameters:(NSDictionary *)parameters
                      success:(void (^)(HomeModel *model))success
                      failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kHome_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            HomeModel *dto = [HomeModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
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
 全部分类
 */
+ (void)getAllClassWithParameters:(NSDictionary *)parameters
                          success:(void (^)(AllClassModel *model))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{

    [HttpClient sendPostRequest:kALL_CLASS_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            AllClassModel *dto = [AllClassModel yy_modelWithJSON:responseObject];
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
 广告页
 */
+ (void)getAPPADClassWithParameters:(NSDictionary *)parameters
                            success:(void (^)(APPADModel *model))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendGetRequest:kGET_ADVERTISEMENT_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            APPADModel *dto = [APPADModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
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

@end
