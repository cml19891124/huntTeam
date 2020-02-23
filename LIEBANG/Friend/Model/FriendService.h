//
//  FriendService.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendListModel.h"
#import "PendModel.h"
#import "VisitorRecordModel.h"

@interface FriendService : NSObject

/**
 推荐好友
 */
+ (void)getRecommendFriendWithSuccess:(void (^)(NSArray *array))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取他人好友
 */
+ (void)getOtherFriendWithParameters:(NSString *)parameters
                             success:(void (^)(FriendListModel *model))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 获取好友列表
 */
+ (void)getFriendListWithSuccess:(void (^)(FriendListModel *model))success
                         failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 待处理的好友信息
 */
+ (void)getPendFriendWithSuccess:(void (^)(PendModel *model))success
                         failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 拒绝添加好友
 */
+ (void)getRefuseFriendWithParameters:(NSString *)parameters
                              success:(void (^)(NSString *success))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 通过好友
 */
+ (void)getPassFriendWithParameters:(NSString *)parameters
                            success:(void (^)(NSString *success))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 申请好友
 */
+ (void)getAddFriendWithParameters:(NSString *)parameters
                           success:(void (^)(NSString *success))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 解除好友
 */
+ (void)getDeleteFriendWithParameters:(NSString *)parameters
                              success:(void (^)(NSString *success))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 添加黑名单
 */
+ (void)getAddBlackFriendWithParameters:(NSString *)parameters
                                success:(void (^)(NSString *success))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure;


/**
 获取未处理事项数量
 */
+ (void)getUnreadNumWithSuccess:(void (^)(NSString *number))success
                         failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

@end
