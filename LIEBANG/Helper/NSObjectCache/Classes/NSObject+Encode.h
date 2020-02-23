//
//  NSObject+Encode.h
//  HuoYun
//
//  Created by meixf on 2018/9/24.
//  Copyright © 2018年 zhaoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Encode)

- (void)cEncodeWithCoder:(NSCoder*)encoder;

-(void)cInitWithCoder:(NSCoder *)decoder;

@end
