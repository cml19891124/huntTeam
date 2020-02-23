//
//  FSHTTPSever.m
//  FishState
//
//  Created by mac on 2018/5/3.
//  Copyright © 2018年 caominglei. All rights reserved.
//

#import "SDHTTPSever.h"
#import "SDHTTPManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SDHTTPSever

+ (void)POSTServerWithMethod:(nonnull NSString*)method paraments:(nonnull NSDictionary *)dic needToken:(BOOL)isNeed complete:(nonnull Success)success Failure:(nonnull Failure)failure{
   
    [SDHTTPSever POSTServerWithMethod:method paraments:dic needToken:isNeed complete:success Progress:nil Failure:failure];
}

+ (void)POSTServerWithMethod:(nonnull NSString*)method paraments:(nonnull NSDictionary *)dic needToken:(BOOL)isNeed complete:(nonnull Success)success Progress:(Progress)progress Failure:(nonnull Failure)failure{
    
    SDHTTPManager *manager = [SDHTTPManager shareHPHTTPManage];
    // 解析数据需要
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    
    if (isNeed) {
        LoginModel *account = [SDUserTool account];
//        [manager.requestSerializer setValue:account.rongCloudToken?:@"e28b284b34fa4ab9aacf709f9f8d881d" forHTTPHeaderField:@"token"];
        [manager.requestSerializer setValue:@"FR//RiWgjieRLymFqqOw9Vp9Ss0/gLznv8Ahh/O0DcFj+B6ULmbs/iQV2Rr16RaIZ14tNFtvAIgd/ZvBivzNHVPLzpkJMaRz" forHTTPHeaderField:@"token"];
    }
    
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/plain", nil];
    
//    [manager.requestSerializer setTimeoutInterval:10];
    NSString * urlString  = [NSString stringWithFormat:@"%@%@",kApphttp,method];
    
    [manager POST:urlString parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.fractionCompleted);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (failure) {
            failure(error);
        }
    }];
}

+ (void)HPSecretServerWithMethod:(nonnull NSString*)method  paraments:(nonnull NSDictionary *)dic complete:(nonnull Success)success Failure:(nonnull Failure)failure{
    
    SDHTTPManager *manager = [SDHTTPManager shareHPHTTPManage];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/plain", nil];
    
    
//    [manager.requestSerializer setTimeoutInterval:15];
    NSString * urlString  = [NSString stringWithFormat:@"%@%@",kApphttp,method];
    
    [manager POST:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //            请求失败。
        if (failure) {
            failure(error);
        }
    }];
    
}
+ (void)GETServerWithMethod:(nonnull NSString*)method isNeedToken:(BOOL)isNeed paraments:(nonnull NSDictionary *)dic complete:(nonnull Success)success Failure:(nonnull Failure)failure{
    SDHTTPManager *manager = [SDHTTPManager shareHPHTTPManage];
    if (isNeed) {
        LoginModel *account = [SDUserTool account];
        [manager.requestSerializer setValue:account.rongCloudToken?:@"" forHTTPHeaderField:@"token"];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/plain", nil];
//    [manager.requestSerializer setTimeoutInterval:10];
    NSString * urlString  = [NSString stringWithFormat:@"%@%@",kApphttp,method];
    
    [manager GET:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (failure) {
            failure(error);
        }
    }];

}


+ (void)GETServerWithMethodNoAppendingUrl:(nonnull NSString*)method isNeedToken:(BOOL)isNeed paraments:(nonnull NSDictionary *)dic complete:(nonnull Success)success Failure:(nonnull Failure)failure{
    SDHTTPManager *manager = [SDHTTPManager shareHPHTTPManage];
    if (isNeed) {
        LoginModel *account = [SDUserTool account];
        [manager.requestSerializer setValue:account.rongCloudToken?:@"" forHTTPHeaderField:@"token"];
    }
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/plain", nil];
//    [manager.requestSerializer setTimeoutInterval:10];
    NSString * urlString  = [NSString stringWithFormat:@"%@",method];
    
    [manager GET:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
    
}

- (NSString* _Nonnull)returnMD5StrWithDict:(NSMutableDictionary* _Nonnull)mutDict{
    [mutDict setValue:@"app_key" forKey:@"HLXWDHXB6BXAK0XLWD"];
    NSArray *keysArray = [mutDict allKeys];
    NSArray *resultArray = [keysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    
    NSString * endStr ;
    for (int i =0; i<resultArray.count; i++) {
        
        
        NSString * tempStr =[NSString stringWithFormat:@"%@=%@",resultArray[i],[mutDict objectForKey:resultArray[i]]];
        
        
        
        endStr = [NSString stringWithFormat:@"%@&%@",endStr,tempStr];
        if (!endStr) {
            endStr = tempStr;
        }
        
    }
    
    //return nil;
    return [self md5:endStr];
}
- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
@end
