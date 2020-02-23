//
//  NSArray+Extensional.h
//  Lottery
//
//  Created by steve on 2018/4/23.
//  Copyright © 2018 zhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extensional)

- (BOOL)containsString:(NSString*)anString;

- (id)getObjectAtIndex:(NSInteger)nIndex;
@end
