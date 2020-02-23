//
//  HttpClient.h
//  Lottery
//
//  Created by  YIQI on 2018/3/26.
//  Copyright © 2018年 zhong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^queryResultHandle)(BOOL successed, id serverData, NSString* errorCode, NSString* errorMessage);

@interface HttpClient : NSObject

#pragma mark - 网络请求-Put方式
+ (void)sendPutRequest:(NSString *)url
            parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSUInteger statusCode,NSString *error))failure;

#pragma mark - 网络请求-DELETE方式
+ (void)sendDELETERequest:(NSString *)url
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSUInteger statusCode,NSString *error))failure;

#pragma mark - 网络请求-Get方式
+ (void)sendGetRequest:(NSString *)url
            parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSUInteger statusCode,NSString *error))failure;

+ (void)sendGetRequest:(NSString *)url
            parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSUInteger statusCode,NSString *error))failure
             parseData:(BOOL)parseData;

#pragma mark - 网络请求-Post方式
+ (void)sendPostRequest:(NSString *)url
             parameters:(id)parameters
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSUInteger statusCode,NSString *error))failure;

+ (void)sendPostRequest:(NSString *)url
             parameters:(id)parameters
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSUInteger statusCode,NSString *error))failure
              parseData:(BOOL)parseData;

#pragma mark - 网络请求-Post+file方式
+ (void)sendPostRequest:(NSString *)url
             parameters:(NSDictionary *)parameters
               fileData:(NSData *)fileData
               fileName:(NSString *)fileName
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSUInteger statusCode,NSString *error))failure;

+ (void)sendPostRequest:(NSString *)url
             parameters:(NSDictionary *)parameters
               fileData:(NSData *)fileData
               fileName:(NSString *)fileName
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSUInteger statusCode,NSString *error))failure
              parseData:(BOOL)parseData;

+ (void)sendPostRequest:(NSString *)url
             parameters:(NSDictionary *)parameters
              fileArray:(NSArray *)fileArray
               fileName:(NSArray *)fileName
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSUInteger statusCode,NSString *error))failure;

@end
