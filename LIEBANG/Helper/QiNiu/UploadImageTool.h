//
//  UploadImageTool.h
//  Lottery
//
//  Created by  YIQI on 2018/5/21.
//  Copyright © 2018年 zhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadImageTool : NSObject


/**
 上传图片

 @param image 需要上传的image
 @param progress 上传进度block
 @param success 成功block返回url地址
 @param failure 失败block
 */
+ (void)uploadImage:(UIImage*)image progress:(QNUpProgressHandler)progress success:(void(^)(NSDictionary *url))success failure:(void(^)())failure;

//上传多张图片,按队列依次上传
+ (void)uploadImages:(NSArray*)imageArray progress:(void(^)(CGFloat))progress success:(void(^)(NSArray*))success failure:(void(^)())failure;

@end
