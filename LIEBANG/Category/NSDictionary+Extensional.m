//
//  NSDictionary+Extensional.m
//  Lottery
//
//  Created by steve on 2018/4/23.
//  Copyright © 2018 zhong. All rights reserved.
//

#import "NSDictionary+Extensional.h"
#import "NSArray+Extensional.h"

@implementation NSDictionary (Extensional)

- (BOOL)containsKey:(NSString*)key
{
    NSArray* pAllKeys = [self allKeys];
    BOOL bContain = [pAllKeys containsString:key];
    if (bContain)
    {
        id obj = [self objectForKey:key];
        if ([obj isKindOfClass:[NSNull class]])
        {
            bContain = NO;
        }
    }
    return bContain;
}

- (id)getObjectForKey:(NSString*)key
{
    id obj = nil;
    if ([self containsKey:key])
    {
        //obj不可能为【NSNull】对象,因为【containsKey】方法已经剔除了【NSNull】对象，wei.zhang 2017-12-01
        obj = [self objectForKey:key];
    }
    return obj;
}

- (NSString*)getNSStringObjectForKey:(NSString *)key;
{
    id obj = [self getObjectForKey:key];
    if (obj && ![obj isKindOfClass:[NSString class]])
    {
        obj = nil;
    }
    return obj;
}

- (NSNumber*)getNSNumberObjectForKey:(NSString *)key;
{
    id obj = [self getObjectForKey:key];
    if (obj && ![obj isKindOfClass:[NSNumber class]])
    {
        obj = nil;
    }
    return obj;
}

- (NSArray*)getNSArrayObjectForKey:(NSString *)key;
{
    id obj = [self getObjectForKey:key];
    if (obj && ![obj isKindOfClass:[NSArray class]])
    {
        obj = nil;
    }
    return obj;
}

- (NSDictionary*)getNSDictionaryObjectForKey:(NSString *)key;
{
    id obj = [self getObjectForKey:key];
    if (obj && ![obj isKindOfClass:[NSDictionary class]])
    {
        obj = nil;
    }
    return obj;
}

- (NSData*)getNSDataObjectForKey:(NSString *)key;
{
    id obj = [self getObjectForKey:key];
    if (obj && ![obj isKindOfClass:[NSData class]])
    {
        obj = nil;
    }
    return obj;
}
@end
