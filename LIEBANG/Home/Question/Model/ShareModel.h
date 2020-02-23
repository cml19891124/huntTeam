//
//  ShareModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject

/**
 分享
 */
+ (void)shareWithMessageObject:(UMSocialMessageObject *)messageObject
                       success:(void (^)(NSString *success))success
                       failure:(void (^)(NSString *errorStr))failure;

@end
