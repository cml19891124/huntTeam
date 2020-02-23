//
//  AccountService.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountService.h"

@implementation AccountService

/**
 修改个人名片
 */
+ (void)getEditAccountMessageWithParameters:(NSDictionary *)parameters
                                       file:(NSData *)file
                                   fileName:(NSString *)fileName
                                    success:(void (^)(id model))success
                                    failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kEDIT_ACCOUNT_MESSAGE_URL parameters:parameters fileData:file fileName:fileName success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"修改信息成功");
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
 获取教育经历
 */
+ (void)getEducationWithParameters:(NSDictionary *)parameters
                           success:(void (^)(EducationModel *model))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kEDUCATION_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            EducationModel *dto = [EducationModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
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
 新增教育经历
 */
+ (void)getAddEducationWithParameters:(NSDictionary *)parameters
                                 file:(NSData *)file
                             fileName:(NSString *)fileName
                              success:(void (^)(id model))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kADD_EDUCATION_URL parameters:parameters fileData:file fileName:fileName success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"添加成功");
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
 修改教育经历
 */
+ (void)getEditEducationWithParameters:(NSDictionary *)parameters
                                  file:(NSData *)file
                              fileName:(NSString *)fileName
                               success:(void (^)(id model))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kEDIT_EDUCATION_URL parameters:parameters fileData:file fileName:fileName success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"修改成功");
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
 删除教育经历
 */
+ (void)getDeleteEducationWithParameters:(NSDictionary *)parameters
                                 success:(void (^)(id model))success
                                 failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kDELETE_EDUCATION_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"删除成功");
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
 获取工作经历
 */
+ (void)getWorkWithParameters:(NSDictionary *)parameters
                      success:(void (^)(WorkModel *model))success
                      failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kWORK_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            WorkModel *dto = [WorkModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
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
 新增工作经历
 */
+ (void)getAddWorkWithParameters:(NSDictionary *)parameters
                            file:(NSData *)file
                        fileName:(NSString *)fileName
                         success:(void (^)(id model))success
                         failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kADD_WORK_URL parameters:parameters fileData:file fileName:fileName success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"添加成功");
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
 修改工作经历
 */
+ (void)getEditWorkWithParameters:(NSDictionary *)parameters
                             file:(NSData *)file
                         fileName:(NSString *)fileName
                          success:(void (^)(id model))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kEDIT_WORK_URL parameters:parameters fileData:file fileName:fileName success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"修改成功");
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
 删除工作经历
 */
+ (void)getDeleteWorkWithParameters:(NSDictionary *)parameters
                            success:(void (^)(id model))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kDELETE_WORK_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"删除成功");
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
 修改自我介绍
 */
+ (void)getEditIntroduceWithParameters:(NSString *)parameters
                               success:(void (^)(id model))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"userIntroduce"];
    
    [HttpClient sendPostRequest:kEDIT_USER_INTRODUCE_URL parameters:postDic success:^(id responseObject) {
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
 评价用户
 */
+ (void)getPostCommentWithParameters:(NSDictionary *)parameters
                             success:(void (^)(id model))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
//    [parameters setValue:[Config currentConfig].userUid forKey:@"userUid"];
    
    [HttpClient sendPostRequest:kPOST_COMMENT_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"评价成功");
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
 喜欢用户
 */
+ (void)getLikeWithParameters:(NSDictionary *)parameters
                      success:(void (^)(id model))success
                      failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    
    [HttpClient sendPostRequest:kADD_LIKE_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"操作成功");
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
 修改生日与家乡
 */
+ (void)editHomeTownWithParameters:(NSDictionary *)parameters
                           success:(void (^)(NSString *info))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kEDIT_HOMETOWN_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"修改成功");
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
 获取个人权限及黑名单
 */
+ (void)getPrivacyWithSuccess:(void (^)(PrivacyModel *model))success
                      failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:[Config currentConfig].userUid forKey:@"userUid"];
    
    [HttpClient sendPostRequest:kPRIVACY_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            PrivacyModel *dto = [PrivacyModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
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
 修改个人权限及黑名单
 */
+ (void)editPrivacyWithParameters:(NSDictionary *)parameters
                          success:(void (^)(NSString *info))success
                          failure:(void (^)(NSUInteger code,NSString *errorStr))failure;
{
    [HttpClient sendPostRequest:kEDIT_PRIVACY_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"修改成功");
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
 点赞标签
 */
+ (void)getUPClassifyWithParameters:(NSString *)parameters
                            success:(void (^)(id model))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"classifyId"];
    
    NSLog(@"postDic = %@",postDic);
    
    [HttpClient sendPostRequest:kUP_CLASSIFY_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"点赞成功");
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
 点赞评价
 */
+ (void)getUPCommentWithParameters:(NSString *)parameters
                           success:(void (^)(id model))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"commentId"];
    
    [HttpClient sendPostRequest:kUP_COMMENT_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"点赞成功");
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
 获取（审核）系统消息
 */
+ (void)getSystemNotiMessageCenterWithParameters:(NSMutableDictionary *)parameters
                           success:(void (^)(id model))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    
    [HttpClient sendPostRequest:kUP_SYSTEMMESS_CENTER_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"获取成功");
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
 私信权限
 */
+ (void)getPrivateLetterWithParameters:(NSString *)parameters
                               success:(void (^)(id model))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"userUid"];
    NSLog(@"私信权限postDic = %@",postDic);
    [HttpClient sendPostRequest:kPRIVATE_LETTER_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success([responseObject objectForKey:@"data"]);//0 不可以发送  1：可以发送
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
 个人信息获取问答列表
 */
+ (void)getAccountQuestionWithParameters:(NSDictionary *)parameters
                                 success:(void (^)(NSArray *array))success
                                 failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableArray *itemArray = [NSMutableArray array];
    [HttpClient sendPostRequest:kACCOUNT_QUESTION_LIST_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            id data = [responseObject objectForKey:@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in data) {
                    QuestionClassModel *model = [QuestionClassModel yy_modelWithJSON:dic];
                    [itemArray addObject:model];
                }
            }
            if (success) {
                success(itemArray);
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
