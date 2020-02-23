//
//  WalletListModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/1.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "WalletListModel.h"

@implementation WalletListModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"wallet" : [WalletModel class]
             };
}

@end

@implementation WalletModel

@end
