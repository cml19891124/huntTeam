//
//  NSString+Time.h
//  LIEBANG
//
//  Created by  YIQI on 2018/11/15.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Time)

/**
 传入时间戳，返回今天、昨天、星期几。。。。。
 注：时间戳需要10位及以上，包括10位，否则返回“未知时间”
 */
+ (NSString *)achieveDayFormatByTimeString:(NSString *)timeString;

@end

NS_ASSUME_NONNULL_END
