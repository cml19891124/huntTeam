//
//  UploadImageTool.m
//  Lottery
//
//  Created by  YIQI on 2018/5/21.
//  Copyright © 2018年 zhong. All rights reserved.
//

#import "UploadImageTool.h"
#import "QiniuUploadHelper.h"

@implementation UploadImageTool

//给图片命名

+ (NSString*)getDateTimeString
{
    NSDateFormatter *formatter;
    NSString *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}
 
+ (NSString*)randomStringWithLength:(int)len
{
    NSString *letters =@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    for(int i=0; i<len;i++){
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

//上传单张图片
+ (void)uploadImage:(UIImage*)image progress:(QNUpProgressHandler)progress success:(void(^)(NSDictionary *url))success failure:(void(^)())failure {
    
    NSData*data =UIImageJPEGRepresentation(image,0.01);
    if(!data) {
        if(failure) {
            failure();
        }
        return;
    }
    
    NSString*fileName = [NSString stringWithFormat:@"%@_%@.png", [UploadImageTool getDateTimeString], [UploadImageTool randomStringWithLength:8]];
    
    QNUploadOption*opt = [[QNUploadOption alloc]initWithMime:nil
                                             progressHandler:progress
                                                      params:nil
                                                    checkCrc:NO
                                          cancellationSignal:nil];
    
    QNUploadManager*uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
    [uploadManager putData:data
                       key:fileName
                     token:[Config currentConfig].qiniu
                  complete:^(QNResponseInfo*info,NSString*key,NSDictionary*resp) {
                      if(info.statusCode==200&& resp) {
                          NSDictionary *postDic = @{@"hash":resp[@"hash"],@"key":resp[@"key"]};
                          
//                          NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
//                          [postDic setValue:resp[@"hash"] forKey:@"hash"];
//                          [postDic setValue:resp[@"key"] forKey:@"key"];
                          if(success) {
                              success(postDic);
                          }
                      }
                      else{
                          if(failure) {
                              failure();
                          }
                      }
                  }option:opt];
}

//上传多张图片
+ (void)uploadImages:(NSArray*)imageArray progress:(void(^)(CGFloat))progress success:(void(^)(NSArray*))success failure:(void(^)())failure
{
    NSMutableArray*array = [[NSMutableArray alloc] init];
    __block CGFloat totalProgress =0.0f;
    __block CGFloat partProgress =1.0f/ [imageArray count];
    __block NSUInteger currentIndex =0;
    
    QiniuUploadHelper*uploadHelper = [QiniuUploadHelper sharedUploadHelper];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    uploadHelper.singleFailureBlock= ^() {
        failure();
        return;
    };
    
    uploadHelper.singleSuccessBlock= ^(NSDictionary *url) {
        [array addObject:url];
        totalProgress += partProgress;
        progress(totalProgress);
        currentIndex++;
        if([array count] == [imageArray count]) {
            success([array copy]);
            return;
        }else{
            [UploadImageTool uploadImage:imageArray[currentIndex] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
        }
    };
    
    [UploadImageTool uploadImage:imageArray[0] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
    
}


@end
