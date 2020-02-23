//
//  PrivacyModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/30.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PrivacyModel.h"

@implementation PrivacyModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"user" : [VisitorModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userMessagePrivacy_id" : @"userMessagePrivacy.id",
             @"userMessagePrivacy_userUid" : @"userMessagePrivacy.userUid",
             @"userMessagePrivacy_type" : @"userMessagePrivacy.type",
             @"phonePrivacy_id" : @"phonePrivacy.id",
             @"phonePrivacy_userUid" : @"phonePrivacy.userUid",
             @"phonePrivacy_type" : @"phonePrivacy.type",
             @"userFriendPrivacy_id" : @"userFriendPrivacy.id",
             @"userFriendPrivacy_userUid" : @"userFriendPrivacy.userUid",
             @"userFriendPrivacy_type" : @"userFriendPrivacy.type",
             @"userDataPrivacy_id" : @"userDataPrivacy.id",
             @"userDataPrivacy_userUid" : @"userDataPrivacy.userUid",
             @"userDataPrivacy_type" : @"userDataPrivacy.type"
             };
}

@end
