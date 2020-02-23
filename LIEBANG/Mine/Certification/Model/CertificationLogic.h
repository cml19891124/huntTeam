//
//  CertificationLogic.h
//  LIEBANG
//
//  Created by  YIQI on 2018/10/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 认证资料单例
 */
@interface CertificationLogic : NSObject

+ (CertificationLogic *)currentCert;

/**
 基础信息认证
 */
@property (nonatomic,strong)AccountModel *__nullable basicModel;

/*
 @{@"id":{@"Imagekey":@"Image"}}
 */
/**
 教育经历认证
 */
@property (nonatomic,strong)NSMutableDictionary *eduDic;

/**
 工作经历认证
 */
@property (nonatomic,strong)NSMutableDictionary *workDic;

/**
 清空所有数据
 */
- (void)removeAllData;


@end

NS_ASSUME_NONNULL_END
