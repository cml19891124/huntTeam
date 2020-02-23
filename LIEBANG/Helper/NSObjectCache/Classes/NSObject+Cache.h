//
//  NSObject+Cache.h
//  HuoYun
//
//  Created by meixf on 2018/9/24.
//  Copyright © 2018年 zhaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Cache)
//存取删NSUserDefaults内数据
+ (void)saveObj:(NSObject *)obj withKey:(NSString *)key;
+ (NSObject *)readObjforKey:(NSString *)key;
+ (void)removeObjforKey:(NSString *)key;
@end
