//
//  AppDelegate+PushService.h
//  Starwood
//
//  Created by 一七 on 2018/6/21.
//  Copyright © 2018年 pony. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
/**
 推送相关在这里处理
 */

static NSString *channel = @"Publish channel";
static BOOL isProduction = YES;

@interface AppDelegate (PushService)<JPUSHRegisterDelegate>

// 初始化 JPush
- (void)initJPush;
@end
