//
//  HomeService.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"
#import "AllClassModel.h"
#import "APPADModel.h"

@interface HomeService : NSObject

/**
 首页
 */
+ (void)getHomeWithParameters:(NSDictionary *)parameters
                            success:(void (^)(HomeModel *model))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 全部分类
 */
+ (void)getAllClassWithParameters:(NSDictionary *)parameters
                          success:(void (^)(AllClassModel *model))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

/**
 广告页
 */
+ (void)getAPPADClassWithParameters:(NSDictionary *)parameters
                            success:(void (^)(APPADModel *model))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure;

@end
