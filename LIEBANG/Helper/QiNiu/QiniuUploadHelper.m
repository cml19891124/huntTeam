//
//  QiniuUploadHelper.m
//  Lottery
//
//  Created by  YIQI on 2018/5/21.
//  Copyright © 2018年 zhong. All rights reserved.
//

#import "QiniuUploadHelper.h"

@implementation QiniuUploadHelper

static id _instance =nil;

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance= [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedUploadHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance= [[self alloc]init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone*)zone {
    return _instance;
}

@end
