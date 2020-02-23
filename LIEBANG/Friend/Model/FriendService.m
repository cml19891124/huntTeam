//
//  FriendService.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "FriendService.h"
#import "FriendModel.h"
#import "RCUserInfo+Addition.h"

@implementation FriendService

/**
 推荐好友
 */
+ (void)getRecommendFriendWithSuccess:(void (^)(NSArray *array))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableArray *list = [NSMutableArray array];
    [HttpClient sendPostRequest:kRECOMMEND_Friend_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in data) {
                    InterestFriendModel *model = [InterestFriendModel yy_modelWithJSON:dict];
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
 获取他人好友
 */
+ (void)getOtherFriendWithParameters:(NSString *)parameters
                             success:(void (^)(FriendListModel *model))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"userUid"];
    
    NSLog(@"获取他人好友postDic == %@",postDic);
    
//    [HttpClient sendGetRequest:kFriend_OTHER_URL parameters:postDic success:^(id responseObject) {
//        NSString *ret = [responseObject objectForKey:@"info"];
//        if ([ret integerValue] == 200) {
//            FriendListModel *dto = [FriendListModel yy_modelWithJSON:responseObject];
//            if (success) {
//                success(dto);
//            }
//        } else {
//            if (failure) {
//                failure([ret integerValue],@"获取好友失败");
//            }
//        }
//    } failure:^(NSUInteger statusCode, NSString *error) {
//        if (failure) {
//            failure(statusCode,@"获取好友失败");
//        }
//    }];
    
    [HttpClient sendPostRequest:kFriend_OTHER_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            FriendListModel *dto = [FriendListModel yy_modelWithJSON:responseObject];
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
 获取好友列表
 */
+ (void)getFriendListWithSuccess:(void (^)(FriendListModel *model))success
                         failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:[Config currentConfig].userUid forKey:@"userUid"];
    
    [HttpClient sendPostRequest:kFriend_List_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            FriendListModel *dto = [FriendListModel yy_modelWithJSON:responseObject];

            //融云同步好友列表
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray *dataSoure = [NSMutableArray array];
                [Config currentConfig].friendCount = [NSString stringWithFormat:@"%zd",dto.data.count];
                for (FriendModel *dto1 in dto.data) {
                    NSString *name = [NSString stringWithFormat:@"%@%@",dto1.company?:@"",dto1.position];

                    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:dto1.userUid name:dto1.userName portrait:dto1.userHead isBasic:dto1.isBasic isOccupation:dto1.isOccupation job:name];
                    [dataSoure addObject:userInfo];
                }
                [AppDelegate currentAppDelegate].friendsArray = dataSoure;
                [[RCDataManager shareManager] syncRCUserInfo];
                NSLog(@"融云同步好友列表 = %zd",[AppDelegate currentAppDelegate].friendsArray.count);
            });
            
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
 待处理的好友信息
 */
+ (void)getPendFriendWithSuccess:(void (^)(PendModel *model))success
                         failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:[Config currentConfig].userUid forKey:@"userUid"];
    NSLog(@"[Config currentConfig].userUid == == %@",[Config currentConfig].userUid);
    
    [HttpClient sendPostRequest:kTREATED_FRIEND_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            PendModel *dto = [PendModel yy_modelWithJSON:responseObject];
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
 拒绝添加好友
 */
+ (void)getRefuseFriendWithParameters:(NSString *)parameters
                              success:(void (^)(NSString *success))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"id"];
    
    [HttpClient sendPostRequest:kREFUSE_FRIEND_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"忽略成功");
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
 通过好友
 */
+ (void)getPassFriendWithParameters:(NSString *)parameters
                            success:(void (^)(NSString *success))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"id"];
    
    [HttpClient sendPostRequest:kPASS_FRIEND_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"操作成功");
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
 申请好友
 */
+ (void)getAddFriendWithParameters:(NSString *)parameters
                           success:(void (^)(NSString *success))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:[Config currentConfig].userUid forKey:@"userUid"];
    [postDic setValue:parameters forKey:@"applicationUserUid"];
    
    NSLog(@"申请好友 == postDic== %@",postDic);
    
    [HttpClient sendPostRequest:kADD_FRIEND_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"申请成功");
            }
        } else {
            
            if ([ret integerValue] == 10001) {
                if (failure) {
                    failure([ret integerValue],[responseObject objectForKey:@"msg"]);
                }
            }
            else {
                if (failure) {
                    failure([ret integerValue],[responseObject objectForKey:@"msg"]);
                }
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

/**
 解除好友
 */
+ (void)getDeleteFriendWithParameters:(NSString *)parameters
                              success:(void (^)(NSString *success))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:[Config currentConfig].userUid forKey:@"userUid"];
    [postDic setValue:parameters forKey:@"friendUid"];
    
    [HttpClient sendPostRequest:kDELETE_FRIEND_URL parameters:postDic success:^(id responseObject) {
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
 添加黑名单
 */
+ (void)getAddBlackFriendWithParameters:(NSString *)parameters
                                success:(void (^)(NSString *success))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:[Config currentConfig].userUid forKey:@"userUid"];
    [postDic setValue:parameters forKey:@"blackUserUid"];
    
    [HttpClient sendPostRequest:kADD_BLACK_FRIEND_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"添加黑名单成功");
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
 获取未处理事项数量
 */
+ (void)getUnreadNumWithSuccess:(void (^)(NSString *number))success
                        failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendGetRequest:kUNREAD_UNM_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success([responseObject objectForKey:@"data"]);
            }
        } else {
            if (failure) {
                failure([ret integerValue],@"0");
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        if (failure) {
            failure(statusCode,@"0");
        }
    }];
}
@end
