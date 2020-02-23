//
//  FSHTTPSever.h
//  FishState
//
//  Created by mac on 2018/5/3.
//  Copyright © 2018年 caominglei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Success)( id  _Nonnull responseObject) ;
typedef void(^Failure)(NSError * _Nonnull  error) ;
typedef void(^Progress)(double progress) ;

@interface SDHTTPSever : NSObject

+ (void)POSTServerWithMethod:(nonnull NSString*)method paraments:(nonnull NSDictionary *)dic needToken:(BOOL)isNeed complete:(nonnull Success)success Failure:(nonnull Failure)failure;

+ (void)POSTServerWithMethod:(nonnull NSString*)method paraments:(nonnull NSDictionary *)dic needToken:(BOOL)isNeed complete:(nonnull Success)success Progress:(Progress _Nullable )progress Failure:(nonnull Failure)failure;

+ (void)GETServerWithMethod:(nonnull NSString*)method  isNeedToken:(BOOL)isNeed paraments:(nonnull NSDictionary *)dic complete:(nonnull Success)success Failure:(nonnull Failure)failure;


+ (void)HPSecretServerWithMethod:(nonnull NSString*)method  paraments:(nonnull NSDictionary *)dic complete:(nonnull Success)success Failure:(nonnull Failure)failure;

+ (void)GETServerWithMethodNoAppendingUrl:(nonnull NSString*)method isNeedToken:(BOOL)isNeed paraments:(nonnull NSDictionary *)dic complete:(nonnull Success)success Failure:(nonnull Failure)failure;

@end
