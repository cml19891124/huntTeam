//
//  CertificationLogic.m
//  LIEBANG
//
//  Created by  YIQI on 2018/10/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CertificationLogic.h"

@implementation CertificationLogic

+ (CertificationLogic *)currentCert {
    static CertificationLogic *currentConfig = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        currentConfig = [[CertificationLogic alloc] init];
    });
    return currentConfig;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.basicModel = [AccountModel new];
        self.eduDic = [NSMutableDictionary new];
        self.workDic = [NSMutableDictionary new];
    }
    return self;
}

- (void)removeAllData {
    self.basicModel = nil;
    [self.eduDic removeAllObjects];
    [self.workDic removeAllObjects];
}

@end
