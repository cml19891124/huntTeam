//
//  SearchFriendModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/1.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "SearchFriendModel.h"
#import "FriendModel.h"
#import "InterestFriendModel.h"

@implementation SearchFriendModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"userFriend" : [FriendModel class],
             @"searchFriend" : [InterestFriendModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userFriend" : @"data.userFriend",
             @"searchFriend" : @"data.friend"
             };
}

@end
