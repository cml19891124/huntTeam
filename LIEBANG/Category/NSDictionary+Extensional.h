//
//  NSDictionary+Extensional.h
//  Lottery
//
//  Created by steve on 2018/4/23.
//  Copyright © 2018 zhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extensional)

- (BOOL)containsKey:(NSString*)key;
- (id)getObjectForKey:(NSString*)key;
- (NSString*)getNSStringObjectForKey:(NSString *)key;
- (NSNumber*)getNSNumberObjectForKey:(NSString *)key;
- (NSArray*)getNSArrayObjectForKey:(NSString *)key;
- (NSDictionary*)getNSDictionaryObjectForKey:(NSString *)key;
- (NSData*)getNSDataObjectForKey:(NSString *)key;
@end
