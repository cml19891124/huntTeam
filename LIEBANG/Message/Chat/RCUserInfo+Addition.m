//
//  RCUserInfo+Addition.m
//  IHK
//
//  Created by 郑文明 on 15/7/28.
//  Copyright (c) 2015年 郑文明. All rights reserved.
//

#import "RCUserInfo+Addition.h"
#import <objc/runtime.h>




@implementation RCUserInfo (Addition)
@dynamic isBasic;
@dynamic isOccupation;
@dynamic job;
- (instancetype)initWithUserId:(NSString *)userId name:(NSString *)username portrait:(NSString *)portrait isBasic:(NSString *)isBasic isOccupation:(NSString *)isOccupation job:(NSString *)job{
    if (self = [super init]) {
        self.userId        =   userId;
        self.name          =   username;
        self.portraitUri   =   portrait;
        self.isBasic         =   isBasic;
        self.isOccupation   =   isOccupation;
        self.job            = job;
    }
    return self;
}

//添加属性扩展set方法
static char* const isBasic = "isBasic";
static char* const isOccupation = "isOccupation";
static char* const job = "job";

//-(void)setQQ:(NSString *)newQQ{
//
//    objc_setAssociatedObject(self,isBasic,newQQ,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//}
//-(void)setSex:(NSString *)newSex{
//
//    objc_setAssociatedObject(self,SEX,newSex,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//}
//
////添加属性扩展get方法
//-(NSString *)QQ{
//    return objc_getAssociatedObject(self,QQ);
//}
//-(NSString *)sex{
//    return objc_getAssociatedObject(self,SEX);
//}

- (NSString *)isBasic {
    return objc_getAssociatedObject(self,isBasic);
}

- (NSString *)isOccupation {
    return objc_getAssociatedObject(self,isOccupation);
}

- (NSString *)job {
    return objc_getAssociatedObject(self,job);
}


- (void)setIsBasic:(NSString *)newisBasic {
    objc_setAssociatedObject(self,isBasic,newisBasic,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIsOccupation:(NSString *)newisOccupation {
    objc_setAssociatedObject(self,isOccupation,newisOccupation,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setJob:(NSString *)newjob {
    objc_setAssociatedObject(self,job,newjob,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

