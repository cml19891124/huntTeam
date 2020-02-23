//
//  CompanyService.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CompanyService.h"
#import "CompanyModel.h"
#import "CompanyFeeModel.h"
#import "PersonnelModel.h"
#import "CompanyCommentModel.h"

@implementation CompanyService

/**
 我的企业推荐
 */
+ (void)getCompanyWelcomeWithSuccess:(void (^)(StaffModel *data))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendGetRequest:kWELCOME_COMPANY_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                StaffModel *model = [StaffModel yy_modelWithJSON:data];
                if (success) {
                    success(model);
                }
            }
            else {
                if (success) {
                    success(nil);
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
 我的企业名片列表
 */
+ (void)getCompanyListWithParameters:(NSString *)parameters
                             success:(void (^)(NSArray *data))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"type"];//type:1 我的已启用企业名片 type:0 所有企业名片
    
    [HttpClient sendGetRequest:kMY_COMPANY_LIST_URL parameters:postDic success:^(id responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in data) {
                    CompanyModel *model = [CompanyModel yy_modelWithJSON:dict];
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
 我认领的企业名片列表
 */
+ (void)getClaimCompanyListWithParameters:(NSMutableDictionary *)parameters
                                  success:(void (^)(NSArray *data))success
                                  failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendGetRequest:kMY_CLAIM_COMPANY_LIST_URL parameters:parameters success:^(id responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in data) {
                    CompanyModel *model = [CompanyModel yy_modelWithJSON:dict];
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
 收藏企业
 */
+ (void)addCollectCompanyWithParameters:(NSString *)parameters
                                success:(void (^)(NSString *data))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"enterpriseId"];
    
    [HttpClient sendPostRequest:kCOLLECT_COMPANY_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success([responseObject objectForKey:@"msg"]);
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
 通过企业认领
 */
+ (void)passStallCompanyWithParameters:(NSString *)parameters
                               success:(void (^)(NSString *data))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"id"];
    
    [HttpClient sendPostRequest:kPASS_STALL_CLAIM_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success([responseObject objectForKey:@"msg"]);
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
 拒绝企业认领
 */
+ (void)refuseStallCompanyWithParameters:(NSString *)parameters
                                 success:(void (^)(NSString *data))success
                                 failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"id"];
    
    [HttpClient sendPostRequest:kREFUSE_STALL_CLAIM_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success([responseObject objectForKey:@"msg"]);
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
 认领企业申请
 */
+ (void)getStallCompanyWithParameters:(NSString *)parameters
                              success:(void (^)(NSString *data))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"enterpriseId"];
    
    [HttpClient sendPostRequest:kSTALL_CLAIM_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success([responseObject objectForKey:@"msg"]);
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
 企业员工列表
 */
+ (void)getStallListCompanyWithParameters:(NSMutableDictionary *)parameters
                                  success:(void (^)(NSArray *data))success
                                  failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kSTALL_LIST_URL parameters:parameters success:^(id responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in data) {
                    PersonnelModel *model = [PersonnelModel yy_modelWithJSON:dict];
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
 删除员工
 */
+ (void)removeCompanyStallWithParameters:(NSString *)parameters
                                 success:(void (^)(NSString *data))success
                                 failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"id"];
    
    [HttpClient sendPostRequest:kREMOVE_STALL_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success([responseObject objectForKey:@"msg"]);
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
 企业点评列表
 */
+ (void)getCommentListCompanyWithParameters:(NSMutableDictionary *)parameters
                                    success:(void (^)(NSArray *data))success
                                    failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kCOMMENT_LIST_URL parameters:parameters success:^(id responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in data) {
                    CompanyCommentModel *model = [CompanyCommentModel yy_modelWithJSON:dict];
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
 企业点评
 */
+ (void)postCommentCompanyWithParameters:(NSMutableDictionary *)parameters
                                 success:(void (^)(NSString *data))success
                                 failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kADD_COMMENT_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success([responseObject objectForKey:@"msg"]);
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
 //10.23 新增接口  企业名片详情
 */
+ (void)getCompanyCertDetailWithParameters:(NSMutableDictionary *)parameters Success:(void (^)(CompanyModel *data))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
 
    [HttpClient sendGetRequest:kCOMPANY_DETAIL_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            CompanyModel *model = [CompanyModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
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
 企业名片详情
 */
+ (void)getCompanyDetailWithParameters:(NSMutableDictionary *)parameters
                               success:(void (^)(CompanyModel *data))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
 
    [HttpClient sendGetRequest:kPERSONNEL_DETAIL_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            CompanyModel *model = [CompanyModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
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
 企业名片付款
 */
+ (void)postCompanyPayWithParameters:(NSMutableDictionary *)parameters
                             success:(void (^)(NSString *data))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kCOMPANY_PAY_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success([responseObject objectForKey:@"msg"]);
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
 企业认证提交审核
 */
+ (void)postCompanyCertWithParameters:(NSMutableDictionary *)parameters
                              success:(void (^)(NSString *data))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kSUB_AUTHENTICATION_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if (success) {
                success([data objectForKey:@"payPrice"]);
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
 企业认证保存信息
 */
+ (void)saveCompanyCertWithParameters:(NSMutableDictionary *)parameters
                                 file:(NSArray *)file
                             fileName:(NSArray *)fileName
                              success:(void (^)(NSString *data))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure;
{
    [HttpClient sendPostRequest:kSAVE_AUTHENTICATION_URL parameters:parameters fileArray:file fileName:fileName success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(responseObject[@"data"][@"id"]);
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
 获取企业付费列表
 */
+ (void)getCompanyPayListWithSuccess:(void (^)(NSArray *data))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kCOMPANY_PAY_LIST_URL parameters:nil success:^(id responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in data) {
                    CompanyFeeModel *model = [CompanyFeeModel yy_modelWithJSON:dict];
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
 收藏企业列表
 */
+ (void)getCompanyCollectListWithParameters:(NSMutableDictionary *)parameters
                                    success:(void (^)(NSArray *data))success
                                    failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kCOMPANY_COLLECTION_LIST_URL parameters:parameters success:^(id responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in data) {
                    CompanyModel *model = [CompanyModel yy_modelWithJSON:dict];
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
 待处理消息
 */
+ (void)getTreatedMessageWithSuccess:(void (^)(PendModel *data))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendGetRequest:kTREATED_MESSAGE_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            PendModel *model = [PendModel yy_modelWithJSON:data];
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
 待处理消息详情
 */
+ (void)getTreatedMessageDetailWithParameters:(NSMutableDictionary *)parameters
                                      success:(void (^)(NSArray *data))success
                                      failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kTREATED_MESSAGE_DETAIL_URL parameters:parameters success:^(id responseObject) {
        NSMutableArray *array = [NSMutableArray array];
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                NSString *type = [parameters objectForKey:@"type"];//0 申请好友 1：认领企业
                for (NSDictionary *dict in data) {
                    if ([type intValue] == 0) {
                        PendFriendModel *model = [PendFriendModel yy_modelWithJSON:dict];
                        [array addObject:model];
                    }
                    else if ([type intValue] == 1) {
                        PendStallModel *model = [PendStallModel yy_modelWithJSON:dict];
                        [array addObject:model];
                    }
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
 删除收藏企业
 */
+ (void)removeCompanyCollectWithParameters:(NSString *)parameters
                                   success:(void (^)(NSString *data))success
                                   failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"ids"];
    
    NSLog(@"删除收藏企业 == %@",postDic);
    [HttpClient sendPostRequest:kREMOVE_COLLECTION_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success([responseObject objectForKey:@"msg"]);
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
 添加员工
 */
+ (void)addCompanyStallWithParameters:(NSMutableDictionary *)parameters
                              success:(void (^)(NSString *data))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kADD_STALL_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success([responseObject objectForKey:@"msg"]);
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
 搜索企业列表
 */
+ (void)searchCompanyListWithParameters:(NSMutableDictionary *)parameters
                                success:(void (^)(NSArray *data))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kSEARCH_COMPANY_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            NSMutableArray *dataArray = [NSMutableArray array];
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in data) {
                    CompanyModel *model = [CompanyModel yy_modelWithJSON:dict];
                    [dataArray addObject:model];
                }
            }
            if (success) {
                success(dataArray);
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
 我的企业名片数量
 */
+ (void)getCompanyNumberWithSuccess:(void (^)(NSDictionary *data))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kCOMPANY_NUM_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(data);
                }
            } else {
                if (failure) {
                    failure([ret integerValue],[responseObject objectForKey:@"msg"]);
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
 是否购买过企业名片
 true：购买过
 false：未购买过
 */
+ (void)getIsPayCompanyWithSuccess:(void (^)(BOOL data))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    LoginModel *account = [SDUserTool account];

    [HttpClient sendGetRequest:kIS_PAY_COMPANY_URL parameters:nil success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            [Config currentConfig].company = [data boolValue]?@"1":@"0";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IS_PAY_COMPANY_NOTIFICATION" object:nil];
            if (success) {
                success([data boolValue]);
            }
        } else {
            account.rongCloudToken = nil;
            [Config currentConfig].company = nil;
            if (failure) {
                failure([ret integerValue],[responseObject objectForKey:@"msg"]);
            }
        }
    } failure:^(NSUInteger statusCode, NSString *error) {
        account.rongCloudToken = nil;
        [Config currentConfig].company = nil;
        if (failure) {
            failure(statusCode,@"连接异常，请检查您的网络");
        }
    }];
}

/**
 企业名片付款
 */
+ (void)payCompanyWithParameters:(NSMutableDictionary *)parameters
                         success:(void (^)(PayModel *data))success
                         failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kPAY_COMPANY_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            PayModel *model = [PayModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
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
 删除已认领的企业
 */
+ (void)removeCompanyClaimWithParameters:(NSString *)parameters
                                 success:(void (^)(NSString *data))success
                                 failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"ids"];
    
    [HttpClient sendPostRequest:kDELETE_CLAIM_COMPANY_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success([responseObject objectForKey:@"msg"]);
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
