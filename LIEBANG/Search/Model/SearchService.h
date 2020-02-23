//
//  SearchService.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/1.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchFriendModel.h"

@interface SearchService : NSObject

/**
 搜索好友
 */
+ (void)getSearchFriendWithParameters:(NSMutableDictionary *)parameters
                              success:(void (^)(SearchFriendModel *model))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 搜索话题
 */
+ (void)getSearchThemeWithParameters:(NSMutableDictionary *)parameters
                             success:(void (^)(NSArray *model))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 搜索问答
 */
+ (void)getSearchQuestionWithParameters:(NSMutableDictionary *)parameters
                                success:(void (^)(NSArray *model))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

@end
