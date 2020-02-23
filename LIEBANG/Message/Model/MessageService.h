//
//  MessageService.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VisitorRecordModel.h"

@interface MessageService : NSObject

/**
 访客记录
 */
+ (void)getVisitorWithParameters:(NSDictionary *)parameters
                         success:(void (^)(VisitorRecordModel *info))success
                         failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 系统消息
 */
+ (void)getSystemMessageWithParameters:(NSDictionary *)parameters
                               success:(void (^)(NSArray *info))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 删除系统消息
 */
+ (void)getDeleteSystemMessageWithParameters:(NSString *)parameters
                                     success:(void (^)(NSString *info))success
                                     failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 是否好友
 */
+ (void)isFriendWithParameters:(NSString *)parameters
                         success:(void (^)(NSString *info))success
                         failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 消息红点
 */
+ (void)getMessageRedButtonWithSuccess:(void (^)(NSDictionary *info))success;

@end
