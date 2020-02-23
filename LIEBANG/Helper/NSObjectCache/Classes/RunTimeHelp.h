//
//  RunTimeHelp.h
//  NSObjectCache
//
//  Created by meixf on 2018/9/27.
//

#import <Foundation/Foundation.h>

@interface RunTimeHelp : NSObject
+ (NSArray *)propertyNames:(Class)klass;
+(void)exchangeMethod:(SEL)originSelector sourceSelector:(SEL)sourceSelector class:(Class)theClsss;
@end
