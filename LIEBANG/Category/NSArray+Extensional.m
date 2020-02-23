//
//  NSArray+Extensional.m
//  Lottery
//
//  Created by steve on 2018/4/23.
//  Copyright © 2018 zhong. All rights reserved.
//

#import "NSArray+Extensional.h"

@implementation NSArray (Extensional)

- (BOOL)containsString:(NSString*)anString
{
    if (anString && [anString isKindOfClass:[NSString class]] && [self indexOfObject:anString] != NSNotFound)
    {
        return YES;
    }
    return NO;
}

- (id)getObjectAtIndex:(NSInteger)nIndex
{
    id obj = nil;
    if (nIndex >= 0 && nIndex < [self count])
    {
        obj = [self objectAtIndex:nIndex];
        if (obj && [obj isKindOfClass:[NSNull class]])
        {
            obj = nil;
        }
    }
    return obj;
}
@end
