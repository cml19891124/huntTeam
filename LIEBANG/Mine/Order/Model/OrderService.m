//
//  OrderService.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "OrderService.h"

@implementation OrderService

/**
 获取话题订单
 */
+ (void)getThemeOrderWithParameters:(NSDictionary *)parameters
                            success:(void (^)(ThemeOrderModel *info))success
                            failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kTHEME_ORDER_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            ThemeOrderModel *model = [ThemeOrderModel yy_modelWithJSON:responseObject];
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
 获取问答订单
 */
+ (void)getQuestionOrderWithParameters:(NSDictionary *)parameters
                               success:(void (^)(QuestionOrderModel *info))success
                               failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kQUESTION_ORDER_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            QuestionOrderModel *model = [QuestionOrderModel yy_modelWithJSON:responseObject];
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
 问答订单详情
 */
+ (void)getQuestionOrderDetailWithParameters:(NSMutableDictionary *)parameters
                                     success:(void (^)(QuestionOrderDetailModel *info))success
                                     failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{

    [HttpClient sendGetRequest:kQUESTION_ORDER_DETAIL_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            QuestionOrderDetailModel *model = [QuestionOrderDetailModel yy_modelWithJSON:responseObject[@"data"]];
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
 话题订单详情
 */
+ (void)getThemeOrderDetailWithParameters:(NSDictionary *)parameters
                                  success:(void (^)(ThemeOrderDetailModel *info))success
                                  failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSLog(@"postDic == %@",parameters);
    
    [HttpClient sendGetRequest:kTHEME_ORDER_DETAIL_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            ThemeOrderDetailModel *model = [ThemeOrderDetailModel yy_modelWithJSON:responseObject[@"data"]];
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
 获取未读数量
 */
+ (void)getOrderReadWithParameters:(NSString *)parameters
                           success:(void (^)(OrderReadModel *info))success
                           failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"type"];//0 问答 1话题
    
    [HttpClient sendGetRequest:kORDER_READNUM_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            OrderReadModel *model = [OrderReadModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
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
 取消订单
 */
+ (void)getCancelOrderWithParameters:(NSString *)parameters
                             success:(void (^)(NSString *info))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"id"];
    
    NSLog(@"取消订单 == %@",postDic);
    
    [HttpClient sendPostRequest:kCANCEL_ORDER_URL parameters:postDic success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"取消成功");
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
 删除订单
 */
+ (void)getDeleteOrderWithParameters:(NSString *)parameters
                             success:(void (^)(NSString *info))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"id"];
    
    NSLog(@"删除订单 == %@",postDic);
    [HttpClient sendPostRequest:kDELETE_ORDER_URL parameters:postDic success:^(id responseObject) {
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
 删除卖家订单
 */
+ (void)getDeleteSellerOrderWithParameters:(NSString *)parameters
                             success:(void (^)(NSString *info))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"id"];
    
    NSLog(@"删除订单 == %@",postDic);
    [HttpClient sendPostRequest:kDELETE_SELLER_ORDER_URL parameters:postDic success:^(id responseObject) {
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
 评价订单
 */
+ (void)getPostOrderCommentWithParameters:(NSDictionary *)parameters
                                  success:(void (^)(NSString *success))success
                                  failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kPOST_ORDER_COMMENT_URL parameters:parameters success:^(id responseObject) {
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

+ (void)getPostThemeOrderCommentWithParameters:(NSDictionary *)parameters
                                       success:(void (^)(NSString *success))success
                                       failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kPOST_THEME_ORDER_COMMENT_URL parameters:parameters success:^(id responseObject) {
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

+ (void)getPostQuestionCommentWithParameters:(NSDictionary *)parameters
                                     success:(void (^)(NSString *success))success
                                     failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kPOST_QUESTION_COMMENT_URL parameters:parameters success:^(id responseObject) {
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
 忽略话题
 */
+ (void)getCancelThemeWithParameters:(NSString *)parameters
                             success:(void (^)(NSString *info))success
                             failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"id"];
    
    [HttpClient sendGetRequest:kCANCEL_THEME_ORDER_URL parameters:postDic success:^(id responseObject) {
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
 忽略问题
 */
+ (void)getCancelQuestionWithParameters:(NSString *)parameters
                                success:(void (^)(NSString *info))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:parameters forKey:@"id"];
    
    [HttpClient sendGetRequest:kCANCEL_QUESTION_URL parameters:postDic success:^(id responseObject) {
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
 行家确认预约话题
 */
+ (void)getExpAppointmentThemeWithParameters:(NSMutableDictionary *)parameters
                                     success:(void (^)(NSString *info))success
                                     failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kTHEME_APPOINT_EXP_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"预约成功");
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
    
//
//    [HttpClient sendGetRequest:kTHEME_APPOINT_EXP_URL parameters:parameters success:^(id responseObject) {
//        NSString *ret = [responseObject objectForKey:@"info"];
//        if ([ret integerValue] == 200) {
//            if (success) {
//                success(@"预约成功");
//            }
//        } else {
//            if (failure) {
//                failure([ret integerValue],@"预约失败");
//            }
//        }
//    } failure:^(NSUInteger statusCode, NSString *error) {
//        if (failure) {
//            failure(statusCode,@"预约失败");
//        }
//    }];
}

/**
 用户确认预约话题
 */
+ (void)getAppointmentThemeWithParameters:(NSMutableDictionary *)parameters
                                  success:(void (^)(NSString *info))success
                                  failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendGetRequest:kTHEME_APPOINT_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"预约成功");
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
 用户话题确认服务完成
 */
+ (void)getUserConfimThemeWithParameters:(NSMutableDictionary *)parameters
                                 success:(void (^)(NSString *info))success
                                 failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendGetRequest:kCONFIM_THEME_ORDER_URL parameters:parameters success:^(id responseObject) {
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
 行家话题确认服务完成
 */
+ (void)getExpConfimThemeWithParameters:(NSMutableDictionary *)parameters
                                success:(void (^)(NSString *info))success
                                failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendGetRequest:kEXP_CONFIM_THEME_ORDER_URL parameters:parameters success:^(id responseObject) {
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
 提醒行家
 */
+ (void)getRemindExpertWithParameters:(NSMutableDictionary *)parameters
                              success:(void (^)(NSString *info))success
                              failure:(void (^)(NSUInteger code,NSString *errorStr))failure
{
    [HttpClient sendPostRequest:kREMIND_EXPERT_URL parameters:parameters success:^(id responseObject) {
        NSString *ret = [responseObject objectForKey:@"info"];
        if ([ret integerValue] == 200) {
            if (success) {
                success(@"提醒行家确认成功");
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
