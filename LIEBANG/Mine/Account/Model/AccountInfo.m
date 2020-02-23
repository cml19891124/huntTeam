//
//  AccountInfo.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/2.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountInfo.h"

@implementation AccountInfo

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"OccupationAuthentication" : [WorkModel class],
             @"UserFriend" : [InterestFriendModel class],
             @"Comment" : [Comment class],
             @"Topic" : [ThemeClassModel class],
             @"EducationAuthentication" : [EducationModel class],
             @"UserClassify" : [UserClassify class]
             };
}

@end

@implementation Comment

@end

//@implementation Topic
//
//@end

@implementation UserClassify

@end
