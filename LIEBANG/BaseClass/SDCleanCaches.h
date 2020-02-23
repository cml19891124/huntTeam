//
//  SDCleanCaches.h
//  LIEBANG
//
//  Created by caominglei on 2019/11/6.
//  Copyright © 2019  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDCleanCaches : NSObject
//利用SDWebImage计算并清理缓存:计算单个文件大小:

+ (float)fileSizeAtPath:(NSString *)path;
//计算文件夹大小(要利用上面的1提供的方法)

+ (float)folderSizeAtPath:(NSString *)path;
//清除缓存:

+ (void)clearCache:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
