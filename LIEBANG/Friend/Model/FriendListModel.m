//
//  FriendListModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/1.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "FriendListModel.h"
#import "FriendModel.h"

@implementation FriendListModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"data" : [FriendModel class]
             };
}

@end

