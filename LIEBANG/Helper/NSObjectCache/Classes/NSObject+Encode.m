//
//  NSObject+Encode.m
//  HuoYun
//
//  Created by meixf on 2018/9/24.
//  Copyright © 2018年 zhaoda. All rights reserved.
//

#import "NSObject+Encode.h"
#import "RunTimeHelp.h"
@implementation NSObject (Encode)
- (void)cEncodeWithCoder:(NSCoder*)encoder {
  
    for (NSString *key in [RunTimeHelp propertyNames:[self class]]) {
        [encoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

-(void)cInitWithCoder:(NSCoder *)decoder {
    
    for (NSString *key in [RunTimeHelp propertyNames:[self class]]) {
        id value = [decoder decodeObjectForKey:key];
        if (value != [NSNull null] && value != nil) {
            [self setValue:value forKey:key];
        }
    }
}
@end
