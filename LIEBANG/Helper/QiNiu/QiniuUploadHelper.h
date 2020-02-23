//
//  QiniuUploadHelper.h
//  Lottery
//
//  Created by  YIQI on 2018/5/21.
//  Copyright © 2018年 zhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QiniuUploadHelper : NSObject

@property(copy,nonatomic)void(^singleSuccessBlock)(NSDictionary*);

@property(copy,nonatomic)void(^singleFailureBlock)();

+ (instancetype)sharedUploadHelper;

@end
