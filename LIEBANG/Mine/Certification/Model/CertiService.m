//
//  CertiService.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CertiService.h"
#import "EducationModel.h"
#import "WorkModel.h"

@implementation CertiService


/**
 工作经历认证
 */
+ (void)getCertiWorkWithParameters:(NSMutableDictionary *)parameters
                              file:(NSArray *)file
                          fileName:(NSArray *)fileName
                           success:(void (^)(NSString *info))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure;
{
    [HttpClient sendPostRequest:kWORK_AUTH_URL parameters:parameters fileArray:file fileName:fileName success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"");
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
 教育经历认证
 */
+ (void)getCertiEducationWithParameters:(NSMutableDictionary *)parameters
                                   file:(NSArray *)file
                               fileName:(NSArray *)fileName
                                success:(void (^)(NSString *info))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kEDUCATION_AUTH_URL parameters:parameters fileArray:file fileName:fileName success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"");
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
 基础认证
 */
+ (void)getCertiBasicWithParameters:(NSMutableDictionary *)parameters
                               file:(NSArray *)file
                           fileName:(NSArray *)fileName
                            success:(void (^)(NSString *info))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kBASIC_AUTH_URL parameters:parameters fileArray:file fileName:fileName success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"");
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
    
//    [HttpClient sendPostRequest:kBASIC_AUTH_URL parameters:parameters fileData:file fileName:fileName success:^(id responseObject) {
//        NSString *ret = [responseObject objectForKey:@"info"];
//        if ([ret integerValue] == 200) {
//            if (success) {
//                success(@"认证成功");
//            }
//        } else {
//            if (failure) {
//                failure([ret integerValue],@"认证失败");
//            }
//        }
//    } failure:^(NSUInteger statusCode, NSString *error) {
//        if (failure) {
//            failure(statusCode,@"认证失败");
//        }
//    }];
}

/**
 机构认证
 */
+ (void)getCertiMechanismWithParameters:(NSMutableDictionary *)parameters
                                   file:(NSData *)file
                               fileName:(NSString *)fileName
                                success:(void (^)(NSString *info))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kMECHANISM_AUTH_URL parameters:parameters fileData:file fileName:fileName success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"提交认证资料成功");
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
 获取机构认证
 */
+ (void)getMechanismResultWithSuccess:(void (^)(MechanismModel *info))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kGET_MECHANISM_AUTH_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            MechanismModel *model = [MechanismModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
            if (success) {
                success(model);
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
 获取所有教育经历
 */
+ (void)getAllEduResultWithSuccess:(void (^)(NSArray *info))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableArray *array = [NSMutableArray array];
    [HttpClient sendPostRequest:kGET_EDU_AUTH_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in data) {
                    EducationModel *model = [EducationModel yy_modelWithJSON:dic];
                    [array addObject:model];
                }
            }
            if (success) {
                success(array);
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
 获取所有工作经历
 */
+ (void)getAllWorkResultWithSuccess:(void (^)(NSArray *info))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableArray *array = [NSMutableArray array];
    [HttpClient sendPostRequest:kGET_WORK_AUTH_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in data) {
                    WorkModel *model = [WorkModel yy_modelWithJSON:dic];
                    [array addObject:model];
                }
            }
            if (success) {
                success(array);
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
 获取认证打码图片
 */
+ (void)getMosaicImageWithType:(NSString *)type
                       userUid:(NSString *)userUid
                       success:(void (^)(id info))success
                       failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:type forKey:@"type"];
    [postDic setValue:userUid forKey:@"userUid"];
    
    [HttpClient sendGetRequest:kGET_MOSAIC_AUTH_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(data);
                }
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
 获取认证打码图片--经历
 
 BASIC_MOSAIC(0, "基础认证未打码"),
 OCCUPATION_MOSAIC(1, "工作经历未打码"),
 EDUCATION_MOSAIC(2, "教育经历未打码"),
 MECHANISM_MOSAIC(3, "机构认证未打码");
 */
+ (void)getUserMosaicImageWithType:(NSString *)type
                               Uid:(NSString *)Uid
                           success:(void (^)(id info))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:type forKey:@"type"];
    [postDic setValue:Uid forKey:@"id"];
    
    [HttpClient sendGetRequest:kGET_USER_MOSAIC_AUTH_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(data);
                }
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
 获取个人认证状态
 */
+ (void)getBasicCertResultWithSuccess:(void (^)(NSDictionary *info))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendGetRequest:kGET_ALL_AUTH_STATE_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(data);
                }
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
 获取基础认证
 */
+ (void)getBasicCertMessageWithSuccess:(void (^)(id info))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kGET_BASIC_AUTH_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            AccountModel *dto = [AccountModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
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
 上传认证图片
 */
+ (void)postCertiImageWithParameters:(NSMutableDictionary *)parameters
                                file:(NSArray *)file
                            fileName:(NSArray *)fileName
                             success:(void (^)(NSString *info))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kPOST_AUTH_IMAGE_URL parameters:parameters fileArray:file fileName:fileName success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"上传认证图片成功");
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
 认证提交审核
 */
+ (void)postCertiSourceWithParameters:(NSMutableDictionary *)parameters
                              success:(void (^)(NSString *info))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kPOST_ALL_AUTH_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"提交认证资料成功");
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
