//
//  MineService.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "MineService.h"
#import "UserHelpModel.h"

@implementation MineService

/**
 个人中心
 */
+ (void)getUserMsgInfoWithSuccess:(void (^)(AccountInfo *info))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kUSER_CENTER_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            AccountInfo *info = [AccountInfo yy_modelWithJSON:[responseObject objectForKey:@"data"]];

            [Config currentConfig].mobile = info.userPhone;
            
            RCUserInfo *dto = [RCUserInfo new];
            dto.name = info.userName;
            dto.userId = info.userUid;
            dto.portraitUri = info.userHead;
            [[RCIM sharedRCIM] setCurrentUserInfo:dto];
            if (success) {
                success(info);
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
 个人信息页面
 */
+ (void)getAccountInfoWithParameters:(NSString *)parameters
                             success:(void (^)(AccountInfo *info))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
//    [postDic setValue:[Config currentConfig].userUid forKey:@"userUid"];
    [postDic setValue:parameters forKey:@"visitorUid"];
    if ([[Config currentConfig].userUid isEqualToString:parameters])
    {
        [postDic setValue:@"0" forKey:@"type"];//0：自己查看主页 1：他人查看主页
    }
    else
    {
        [postDic setValue:@"1" forKey:@"type"];
    }
    NSLog(@"个人信息页面 == %@",postDic);
    
    [HttpClient sendPostRequest:kACCOUNT_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            AccountInfo *dto = [AccountInfo yy_modelWithJSON:[responseObject objectForKey:@"data"]];
            if (success) {
                success(dto);
            }
        } else if ([ret intValue] == 10001 || [ret intValue] == 10002 || [ret intValue] == 10008) {
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
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
 获取个人名片
 */
+ (void)getAccountMessageWithSuccess:(void (^)(AccountModel *model))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{

    [HttpClient sendPostRequest:kACCOUNT_MESSAGE_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            AccountModel *dto = [AccountModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
            [Config currentConfig].userUid = dto.userUid;
            [Config currentConfig].mobile = dto.userPhone;
            [Config currentConfig].username = dto.userName;
//            account.rongCloudToken = dto.rongCloudToken;
            [Config currentConfig].headIcon = dto.userHead;
            
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
 使用帮助
 */
+ (void)getUserHelpWithSuccess:(void (^)(NSArray *array))success
                       failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableArray *dataSource = [NSMutableArray array];
    [HttpClient sendPostRequest:kUSER_HELP_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in data) {
                    UserHelpModel *model = [UserHelpModel yy_modelWithJSON:dict];
                    [dataSource addObject:model];
                }
            }
            if (success) {
                success(dataSource);
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
 退出登陆
 */
+ (void)getLoginOutWithSuccess:(void (^)(NSString *info))success
                       failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kLOGIN_OUT_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"退出成功");
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
