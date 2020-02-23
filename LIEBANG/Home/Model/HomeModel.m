//
//  HomeModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/30.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "HomeModel.h"
#import "QuestionClassModel.h"
#import "ThemeClassModel.h"

@implementation HomeModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"appClassify" : [AppClassify class],
             @"topicBanner" : [TopicBanner class],
             @"question" : [QuestionClassModel class],
             @"topic" : [ThemeClassModel class],
             @"enterprise" : [Enterprise class],
             @"indexBanner" : [IndexBanner class]
             };
}

@end

@implementation AppClassify

@end

@implementation TopicBanner

@end

@implementation IndexBanner

@end

@implementation Enterprise

@end
