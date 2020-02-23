//
//  PendModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/1.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PendModel.h"

@implementation PendModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"applicationFriend" : [PendFriendModel class],
             @"applicationStaff" : [PendStallModel class]
             };
}

@end

@implementation PendFriendModel

//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"effectSocre" : @"UserAccountFormMap.effectSocre",
//             @"isEducation" : @"UserAccountFormMap.isEducation",
//             @"userUid" : @"UserAccountFormMap.userUid",
//             @"userStatus" : @"UserAccountFormMap.userStatus",
//             @"userName" : @"UserAccountFormMap.userName",
//             @"isBasic" : @"UserAccountFormMap.isBasic",
//             @"userPhone" : @"UserAccountFormMap.userPhone",
//             @"createTime" : @"UserAccountFormMap.createTime",
//             @"registrationId" : @"UserAccountFormMap.registrationId",
//             @"starLevel" : @"UserAccountFormMap.starLevel",
//             @"position" : @"UserAccountFormMap.position",
//             @"userBirth" : @"UserAccountFormMap.userBirth",
//             @"userHometown" : @"UserAccountFormMap.userHometown",
//             @"userIntroduce" : @"UserAccountFormMap.userIntroduce",
//             @"userHead" : @"UserAccountFormMap.userHead",
//             @"isOccupation" : @"UserAccountFormMap.isOccupation"
//             };
//}

@end

@implementation PendStallModel

//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"effectSocre" : @"UserAccountFormMap.effectSocre",
//             @"isEducation" : @"UserAccountFormMap.isEducation",
//             @"userUid" : @"UserAccountFormMap.userUid",
//             @"userStatus" : @"UserAccountFormMap.userStatus",
//             @"userName" : @"UserAccountFormMap.userName",
//             @"isBasic" : @"UserAccountFormMap.isBasic",
//             @"userPhone" : @"UserAccountFormMap.userPhone",
//             @"createTime" : @"UserAccountFormMap.createTime",
//             @"registrationId" : @"UserAccountFormMap.registrationId",
//             @"starLevel" : @"UserAccountFormMap.starLevel",
//             @"position" : @"UserAccountFormMap.position",
//             @"userBirth" : @"UserAccountFormMap.userBirth",
//             @"userHometown" : @"UserAccountFormMap.userHometown",
//             @"userIntroduce" : @"UserAccountFormMap.userIntroduce",
//             @"userHead" : @"UserAccountFormMap.userHead",
//             @"isOccupation" : @"UserAccountFormMap.isOccupation"
//             };
//}

@end
