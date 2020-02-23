//
//  HttpClient.m
//  Lottery
//
//  Created by  YIQI on 2018/3/26.
//  Copyright © 2018年 zhong. All rights reserved.
//

#import "HttpClient.h"

@implementation HttpClient

#pragma mark - 网络请求-Put方式
+ (void)sendPutRequest:(NSString *)url
            parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSUInteger statusCode,NSString *error))failure
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kApphttp,url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    manager.requestSerializer.timeoutInterval = 30.f;
    LoginModel *account = [SDUserTool account];

    [manager.requestSerializer setValue:account.rongCloudToken forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceMod"];
    
    [manager PUT:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@ --- %@",urlStr,dict);
        if (!responseObject) {
            NSInteger errorCode = 6001;
            NSString *tError = [NSString stringWithFormat:@"系统繁忙，请稍后再试(N%ld)",(long)errorCode];
            if (failure) {
                failure(errorCode,tError);
            }
        } else {
            if (success) {
                success(dict);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *tError = nil;
        switch ([error code]) {
            case NSURLErrorTimedOut:
                tError = [NSString stringWithFormat:@"连接服务器超时，请检查你的网络或稍后重试"];
                break;
            case NSURLErrorBadURL:
            case NSURLErrorUnsupportedURL:
            case NSURLErrorCannotFindHost:
            case NSURLErrorDNSLookupFailed:
            case NSURLErrorCannotConnectToHost:
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorUserAuthenticationRequired:
            case NSURLErrorUserCancelledAuthentication:
            case NSURLErrorSecureConnectionFailed:
            case NSURLErrorServerCertificateHasBadDate:
            case NSURLErrorServerCertificateHasUnknownRoot:
            case NSURLErrorServerCertificateNotYetValid:
            case NSURLErrorServerCertificateUntrusted:
            case NSURLErrorClientCertificateRejected:
            case NSURLErrorClientCertificateRequired:
                tError = [NSString stringWithFormat:@"无法连接到服务器，请检查你的网络或稍后重试"];
                break;
            case NSURLErrorHTTPTooManyRedirects:
                tError = [NSString stringWithFormat:@"太多HTTP重定向，请检查你的网络或稍后重试"];
                break;
                
            default:
                tError = [NSString stringWithFormat:@"系统繁忙，请稍后再试"];
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
        if (failure) {
            failure([error code],tError);
        }
    }];
}

#pragma mark - 网络请求-DELETE方式
+ (void)sendDELETERequest:(NSString *)url
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSUInteger statusCode,NSString *error))failure
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kApphttp,url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    manager.requestSerializer.timeoutInterval = 30.f;
    LoginModel *account = [SDUserTool account];

    [manager.requestSerializer setValue:account.rongCloudToken forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceMod"];
    
    [manager DELETE:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@ --- %@",urlStr,dict);
        if (!responseObject) {
            NSInteger errorCode = 6001;
            NSString *tError = [NSString stringWithFormat:@"系统繁忙，请稍后再试(N%ld)",(long)errorCode];
            if (failure) {
                failure(errorCode,tError);
            }
        } else {
            
            if (success) {
                success(dict);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *tError = nil;
        switch ([error code]) {
            case NSURLErrorTimedOut:
                tError = [NSString stringWithFormat:@"连接服务器超时，请检查你的网络或稍后重试"];
                break;
            case NSURLErrorBadURL:
            case NSURLErrorUnsupportedURL:
            case NSURLErrorCannotFindHost:
            case NSURLErrorDNSLookupFailed:
            case NSURLErrorCannotConnectToHost:
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorUserAuthenticationRequired:
            case NSURLErrorUserCancelledAuthentication:
            case NSURLErrorSecureConnectionFailed:
            case NSURLErrorServerCertificateHasBadDate:
            case NSURLErrorServerCertificateHasUnknownRoot:
            case NSURLErrorServerCertificateNotYetValid:
            case NSURLErrorServerCertificateUntrusted:
            case NSURLErrorClientCertificateRejected:
            case NSURLErrorClientCertificateRequired:
                tError = [NSString stringWithFormat:@"无法连接到服务器，请检查你的网络或稍后重试"];
                break;
            case NSURLErrorHTTPTooManyRedirects:
                tError = [NSString stringWithFormat:@"太多HTTP重定向，请检查你的网络或稍后重试"];
                break;
                
            default:
                tError = [NSString stringWithFormat:@"系统繁忙，请稍后再试"];
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
        if (failure) {
            failure([error code],tError);
        }
    }];
}

#pragma mark - 网络请求-Get方式
+ (void)sendGetRequest:(NSString *)url
            parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSUInteger statusCode,NSString *error))failure
{
    [HttpClient sendGetRequest:url
                    parameters:parameters
                       success:success
                       failure:failure
                     parseData:NO];
}

+ (void)sendGetRequest:(NSString *)url
            parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSUInteger statusCode,NSString *error))failure
             parseData:(BOOL)parseData;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    NSString *urlStr;
    
    if ([url containsString:@"http"]) {
        urlStr = url;
    }
    else {
        urlStr = [NSString stringWithFormat:@"%@%@",kApphttp,url];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    manager.requestSerializer.timeoutInterval = 10.f;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    LoginModel *account = [SDUserTool account];

    [manager.requestSerializer setValue:account.rongCloudToken forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceMod"];
    
    [manager GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@ --- %@",urlStr,dict);
        if (parseData)
        {
            [HttpClient parseServerDataWithSessionDataTask:task
                                            responseObject:dict
                                                  finished:^(BOOL successed, id serverData, NSString *errorCode, NSString *errorMessage)
             {
                 if (success) {
                     if (success) {
                         success(serverData);
                     }
                 }
                 else
                 {
                     if (failure) {
                         failure([errorCode integerValue],errorMessage);
                     }
                 }
                 
             }];
        }
        else
        {
            if (!responseObject) {
                NSInteger errorCode = 6001;
                NSString *tError = [NSString stringWithFormat:@"系统繁忙，请稍后再试(N%ld)",(long)errorCode];
                if (failure) {
                    failure(errorCode,tError);
                }
            } else {

                if (success) {
                    success(dict);
                }
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@" error= %zd === %@",[error code],[error localizedDescription]);
        NSString *tError = nil;
        switch ([error code]) {
            case NSURLErrorTimedOut:
                tError = [NSString stringWithFormat:@"连接服务器超时，请检查你的网络或稍后重试"];
                break;
            case NSURLErrorBadURL:
            case NSURLErrorUnsupportedURL:
            case NSURLErrorCannotFindHost:
            case NSURLErrorDNSLookupFailed:
            case NSURLErrorCannotConnectToHost:
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorUserAuthenticationRequired:
            case NSURLErrorUserCancelledAuthentication:
            case NSURLErrorSecureConnectionFailed:
            case NSURLErrorServerCertificateHasBadDate:
            case NSURLErrorServerCertificateHasUnknownRoot:
            case NSURLErrorServerCertificateNotYetValid:
            case NSURLErrorServerCertificateUntrusted:
            case NSURLErrorClientCertificateRejected:
            case NSURLErrorClientCertificateRequired:
                tError = [NSString stringWithFormat:@"无法连接到服务器，请检查你的网络或稍后重试"];
                break;
            case NSURLErrorHTTPTooManyRedirects:
                tError = [NSString stringWithFormat:@"太多HTTP重定向，请检查你的网络或稍后重试"];
                break;
                
            default:
                tError = [NSString stringWithFormat:@"系统繁忙，请稍后再试"];
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
        if (failure) {
            failure([error code],tError);
        }
    }];
}

#pragma mark - 网络请求-Post方式
+ (void)sendPostRequest:(NSString *)url
             parameters:(id)parameters
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSUInteger statusCode,NSString *error))failure
{
    [HttpClient sendPostRequest:url
                     parameters:parameters
                        success:success
                        failure:failure
                      parseData:NO];
}

+ (void)sendPostRequest:(NSString *)url
             parameters:(id)parameters
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSUInteger statusCode,NSString *error))failure
              parseData:(BOOL)parseData;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kApphttp,url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
//    manager.requestSerializer.timeoutInterval = 10.f;
    LoginModel *account = [SDUserTool account];

    NSLog(@"token == %@",account.rongCloudToken);
    NSLog(@"urlStr == %@",urlStr);
    
    [manager.requestSerializer setValue:account.rongCloudToken forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceMod"];
    
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //登录过期
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if ([[dict objectForKey:@"info"] intValue] == 401) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CH_LOGIN_NOTIFICATION" object:nil];
            }
        }
        
        //10002  该账号已被停用 --- --- 注册过的号码在此处注册会崩溃
        if ([dict isKindOfClass:[NSDictionary class]]) {
            if ([[dict objectForKey:@"info"] intValue] == 10002 && ![[dict objectForKey:@"msg"] containsString:@"注册"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CH_LOGIN_STOP_NOTIFICATION" object:nil];
            }
        }
        
        NSLog(@"%@ --- %@",urlStr,dict);
        if (parseData)
        {
            [HttpClient parseServerDataWithSessionDataTask:task
                                            responseObject:dict
                                                  finished:^(BOOL successed, id serverData, NSString *errorCode, NSString *errorMessage)
             {
                 if (success) {
                     if (success) {
                         success(serverData);
                     }
                 }
                 else
                 {
                     if (failure) {
                         failure([errorCode integerValue],errorMessage);
                     }
                 }
             }];
        }
        else
        {
            if (!responseObject) {
                NSInteger errorCode = 6001;
                NSString *tError = [NSString stringWithFormat:@"系统繁忙，请稍后再试(N%ld)",(long)errorCode];
                if (failure) {
                    failure(errorCode,tError);
                }
            } else {
                if (success) {
                    success(dict);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@ ---",urlStr);
        NSLog(@" error === %@",[error localizedDescription]);
        NSString *tError = nil;
        switch ([error code]) {
            case NSURLErrorTimedOut:
                tError = [NSString stringWithFormat:@"连接服务器超时，请检查你的网络或稍后重试"];
                break;
            case NSURLErrorBadURL:
            case NSURLErrorUnsupportedURL:
            case NSURLErrorCannotFindHost:
            case NSURLErrorDNSLookupFailed:
            case NSURLErrorCannotConnectToHost:
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorUserAuthenticationRequired:
            case NSURLErrorUserCancelledAuthentication:
            case NSURLErrorSecureConnectionFailed:
            case NSURLErrorServerCertificateHasBadDate:
            case NSURLErrorServerCertificateHasUnknownRoot:
            case NSURLErrorServerCertificateNotYetValid:
            case NSURLErrorServerCertificateUntrusted:
            case NSURLErrorClientCertificateRejected:
            case NSURLErrorClientCertificateRequired:
                tError = [NSString stringWithFormat:@"无法连接到服务器，请检查你的网络或稍后重试"];
                break;
            case NSURLErrorHTTPTooManyRedirects:
                tError = [NSString stringWithFormat:@"太多HTTP重定向，请检查你的网络或稍后重试"];
                break;
                
            default:
                tError = [NSString stringWithFormat:@"系统繁忙，请稍后再试"];
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
        if (failure) {
            failure([error code],tError);
        }
    }];
}

#pragma mark - 网络请求-Post+file方式
+ (void)sendPostRequest:(NSString *)url
             parameters:(NSDictionary *)parameters
               fileData:(NSData *)fileData
               fileName:(NSString *)fileName
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSUInteger statusCode,NSString *error))failure
{
    [HttpClient sendPostRequest:url
                     parameters:parameters
                       fileData:fileData
                       fileName:fileName
                        success:success
                        failure:failure
                      parseData:NO];
}

+ (void)sendPostRequest:(NSString *)url
             parameters:(NSDictionary *)parameters
               fileData:(NSData *)fileData
               fileName:(NSString *)fileName
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSUInteger statusCode,NSString *error))failure
              parseData:(BOOL)parseData;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kApphttp,url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    manager.requestSerializer.timeoutInterval = 1000.f;
    LoginModel *account = [SDUserTool account];

    [manager.requestSerializer setValue:account.rongCloudToken forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceMod"];
    
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (!IsNilOrNull(fileData)) {
            [formData appendPartWithFileData:fileData name:fileName fileName:@".png" mimeType:@"image/png"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@ --- %@",urlStr,dict);
        if (parseData)
        {
            [HttpClient parseServerDataWithSessionDataTask:task
                                            responseObject:dict
                                                  finished:^(BOOL successed, id serverData, NSString *errorCode, NSString *errorMessage)
             {
                 if (success)
                 {
                     if (success)
                     {
                         success(serverData);
                     }
                 }
                 else
                 {
                     if (failure)
                     {
                         failure([errorCode integerValue],errorMessage);
                     }
                 }
                 
             }];
        }
        else
        {
            if (!responseObject) {
                NSInteger errorCode = 6001;//？？？？改变的。。。
                NSString *tError = [NSString stringWithFormat:@"系统繁忙，请稍后再试(N%ld)",(long)errorCode];
                if (failure) {
                    failure(errorCode,tError);
                }
            } else {
                if (success) {
                    success(dict);
                }
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@" error === %@",[error localizedDescription]);
        NSString *tError = nil;
        switch ([error code]) {
            case NSURLErrorTimedOut:
                tError = [NSString stringWithFormat:@"连接服务器超时，请检查你的网络或稍后重试"];
                break;
            case NSURLErrorBadURL:
            case NSURLErrorUnsupportedURL:
            case NSURLErrorCannotFindHost:
            case NSURLErrorDNSLookupFailed:
            case NSURLErrorCannotConnectToHost:
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorUserAuthenticationRequired:
            case NSURLErrorUserCancelledAuthentication:
            case NSURLErrorSecureConnectionFailed:
            case NSURLErrorServerCertificateHasBadDate:
            case NSURLErrorServerCertificateHasUnknownRoot:
            case NSURLErrorServerCertificateNotYetValid:
            case NSURLErrorServerCertificateUntrusted:
            case NSURLErrorClientCertificateRejected:
            case NSURLErrorClientCertificateRequired:
                tError = [NSString stringWithFormat:@"无法连接到服务器，请检查你的网络或稍后重试"];
                break;
            case NSURLErrorHTTPTooManyRedirects:
                tError = [NSString stringWithFormat:@"太多HTTP重定向，请检查你的网络或稍后重试"];
                break;
                
            default:
                tError = [NSString stringWithFormat:@"系统繁忙，请稍后再试"];
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        if (failure) {
            failure([error code],tError);
        }
    }];
}

#pragma mark - Private Function
+ (void)parseServerDataWithSessionDataTask:(NSURLSessionDataTask*)operation responseObject:(id)responseObject finished:(queryResultHandle)completedHandle;
{
    NSHTTPURLResponse *operationResponse = (NSHTTPURLResponse *)(operation.response);
    
    [self parseServerDataWithSessionHttpURLResponse:operationResponse responseObject:responseObject finished:completedHandle];
}

+ (void)parseServerDataWithSessionHttpURLResponse:(NSHTTPURLResponse *)httpURLResponse responseObject:(id)responseObject finished:(queryResultHandle)completedHandle
{
    if (200 == httpURLResponse.statusCode)
    {
        if (responseObject)
        {
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                //使用最新的数据解析方式，防止数据结构变更导致crash
                BOOL isSuccess = [[((NSDictionary *)responseObject) getNSNumberObjectForKey:@"status"] boolValue];
                long long codeValue = [[((NSDictionary *)responseObject) getNSNumberObjectForKey:@"code"] longLongValue];
                NSString* errorCode = [NSString stringWithFormat:@"%ld",(long)codeValue];
                NSString* errorMessage = [((NSDictionary *)responseObject) getNSStringObjectForKey:@"message"];
                id serverData = [((NSDictionary *)responseObject) getObjectForKey:@"data"];
                
                if (completedHandle)
                {
                    completedHandle(isSuccess, serverData, errorCode, errorMessage);
                }
            }
            else
            {
                //@"服务器返回的json格式错误"
                NSString* errorCode = @"6001";
                NSString* errorMessage = @"系统繁忙，请稍后再试";
                
                NSLog(@"网络状态码【%ld】开发错误码【%@】URL【%@】responseObject类名【%@】responseObject内容【%@】", (long)httpURLResponse.statusCode, errorCode, httpURLResponse.URL.absoluteString, NSStringFromClass([responseObject class]), responseObject);
                if (completedHandle)
                {
                    completedHandle(NO, nil, errorCode, errorMessage);
                }
            }
        }
        else
        {
            // @"服务器返回的数据为空"
            NSString* errorCode = @"6001";
            NSString* errorMessage = @"系统繁忙，请稍后再试";
            NSLog(@"网络状态码【%ld】开发错误码【%@】URL【%@】", (long)httpURLResponse.statusCode, errorCode, httpURLResponse.URL.absoluteString);
            if (completedHandle)
            {
                completedHandle(NO, nil, errorCode, errorMessage);
            }
        }
    }
    else
    {
        //@"服务器没有响应"
        NSString* errorCode = @"6001";
        NSString* errorMessage = @"系统繁忙，请稍后再试";
        if ([responseObject isKindOfClass:[NSError class]])
        {
            NSError* error = (NSError*)responseObject;
            if (error.code == NSURLErrorTimedOut)
            {
                errorCode = @"6001";
                errorMessage = @"网络超时";
            }
        }
        
        NSLog(@"网络状态码【%ld】开发错误码【%@】URL【%@】", (long)httpURLResponse.statusCode, errorCode, httpURLResponse.URL.absoluteString);
        if (completedHandle)
        {
            completedHandle(NO, nil, errorCode, errorMessage );
        }
    }
}

+ (void)sendPostRequest:(NSString *)url
             parameters:(NSDictionary *)parameters
              fileArray:(NSArray *)fileArray
               fileName:(NSArray *)fileName
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSUInteger statusCode,NSString *error))failure
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kApphttp,url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    manager.requestSerializer.timeoutInterval = 1000.f;
    LoginModel *account = [SDUserTool account];

    [manager.requestSerializer setValue:account.rongCloudToken forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceMod"];
    
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (!IsArrEmpty(fileArray)) {
            for (int i = 0; i < fileArray.count; i++) {
                id image = [fileArray safeObjectAtIndex:i];
                if (!IsNilOrNull(image)) {
                    if ([image isKindOfClass:[UIImage class]]) {
                        NSData *data = UIImageJPEGRepresentation(image, 0.5);
                        [formData appendPartWithFileData:data name:[fileName safeObjectAtIndex:i] fileName:@".jpg" mimeType:@"image/jpg"];
                    }
                }
            }
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@ --- %@",urlStr,dict);
        if (!responseObject) {
            NSInteger errorCode = 6001;//？？？？改变的。。。
            NSString *tError = [NSString stringWithFormat:@"系统繁忙，请稍后再试(N%ld)",(long)errorCode];
            if (failure) {
                failure(errorCode,tError);
            }
        } else {
            if (success) {
                success(dict);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"urlStr -- %@ --- ",urlStr);
        NSLog(@" error === %@",[error localizedDescription]);
        NSString *tError = nil;
        switch ([error code]) {
            case NSURLErrorTimedOut:
                tError = [NSString stringWithFormat:@"连接服务器超时，请检查你的网络或稍后重试"];
                break;
            case NSURLErrorBadURL:
            case NSURLErrorUnsupportedURL:
            case NSURLErrorCannotFindHost:
            case NSURLErrorDNSLookupFailed:
            case NSURLErrorCannotConnectToHost:
            case NSURLErrorNetworkConnectionLost:
            case NSURLErrorNotConnectedToInternet:
            case NSURLErrorUserAuthenticationRequired:
            case NSURLErrorUserCancelledAuthentication:
            case NSURLErrorSecureConnectionFailed:
            case NSURLErrorServerCertificateHasBadDate:
            case NSURLErrorServerCertificateHasUnknownRoot:
            case NSURLErrorServerCertificateNotYetValid:
            case NSURLErrorServerCertificateUntrusted:
            case NSURLErrorClientCertificateRejected:
            case NSURLErrorClientCertificateRequired:
                tError = [NSString stringWithFormat:@"无法连接到服务器，请检查你的网络或稍后重试"];
                break;
            case NSURLErrorHTTPTooManyRedirects:
                tError = [NSString stringWithFormat:@"太多HTTP重定向，请检查你的网络或稍后重试"];
                break;
                
            default:
                tError = [NSString stringWithFormat:@"系统繁忙，请稍后再试"];
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
        if (failure) {
            failure([error code],tError);
        }
    }];
}

@end
