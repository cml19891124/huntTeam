//
//  NSObject+Hook.m
//  HuoYun
//
//  Created by meixf on 2018/9/24.
//  Copyright © 2018年 zhaoda. All rights reserved.
//

#import "NSObject+Hook.h"
#import <objc/runtime.h>
#import "NSObject+Encode.h"
#import "RunTimeHelp.h"
@implementation NSObject (Hook)
+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
       // Class selfClass = object_getClass([self class]);
        Class selfClass = [self class];
        [RunTimeHelp exchangeMethod:@selector(encodeWithCoder:) sourceSelector:@selector(encodeWithCoder:) class:selfClass];
        
        [RunTimeHelp exchangeMethod:@selector(initWithCoder:) sourceSelector:@selector(initWithCoder:) class:selfClass];

    });
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self cEncodeWithCoder:aCoder];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    [self cInitWithCoder:aDecoder];
    return self;
}

@end
