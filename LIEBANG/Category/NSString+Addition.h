//
//  NSString+HW.h
//  StringDemo
//
//  Created by 何 振东 on 12-10-11.
//  Copyright (c) 2012年 wsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)

/**
 根据字符串来计算label的尺寸。

 @param font 输入字符串的字体大小。
 @param maxSize 输入字符串的最大尺寸。
 @return 返回输入字符串的尺寸。
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


/**
 计算字符串的字数。

 @return 返回输入字符串的字数。
 */
- (int)wordsCount;


/**
 处理为空的字符串

 @return 返回处理过的字符串
 */
- (NSString *)NUllToString;

- (NSString *)URLDecodedString;
- (NSString *)URLEncodedString;
- (NSString *)encodeStringWithUTF8;

- (NSString *)urlByAppendingDict:(NSDictionary *)params;
- (NSUInteger)byteLengthWithEncoding:(NSStringEncoding)encoding;
+(NSString *)documentPathWith:(NSString *)fileName;
+ (NSString *)convertJsonDictToString:(NSDictionary *)json;
@end
