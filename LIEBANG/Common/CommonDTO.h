//
//  CommonDTO.h
//  Storm
//
//  Created by 朱攀峰 on 15/11/26.
//  Copyright (c) 2015年 MCDS. All rights reserved.
//

#import <Foundation/Foundation.h>
SN_EXTERN id EncodeObjectFromDic(NSDictionary *dic, NSString *key);
SN_EXTERN NSString* EncodeStringFromDic(NSDictionary *dic,NSString *key);
SN_EXTERN NSNumber* EncodeNumberFromDic(NSDictionary *dic,NSString *key);
SN_EXTERN NSDictionary* EncodeDicFromDic(NSDictionary *dic,NSString *key);
SN_EXTERN NSArray* EncodeArrayFromDic(NSDictionary *dic,NSString *key);
@interface CommonDTO : NSObject
- (void)encodeFromDictionary:(NSDictionary *)dic;

+ (id)dtoFromDic:(NSDictionary *)dic;
@end
