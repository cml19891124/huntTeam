//
//  AppDelegate+PushService.m
//  Starwood
//
//  Created by 一七 on 2018/6/21.
//  Copyright © 2018年 pony. All rights reserved.
//

#import "AppDelegate+PushService.h"
//#import "ScribeDetailController.h"
//#import "HomeViewController.h"

#define JPushID @"JPushID"

@implementation AppDelegate (PushService)

#pragma mark ————— 配置极光推送 —————
- (void)initJPush {
    
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // 自定义消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
        [JPUSHService setupWithOption:self.launchOptions appKey:kAppKey_JPush
                              channel:channel
                     apsForProduction:isProduction
                advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
        [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
            if(resCode == 0) {
                DLog(@"registrationID获取成功：%@",registrationID);
                //偏好设置 存储到本地
                [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:JPushID];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                [Config currentConfig].registrationID = registrationID;
                            }
            else{
                DLog(@"registrationID获取失败，code：%d",resCode);
            }
        }];
}

//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:2];
//    
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.applicationIconBadgeNumber = -1;
//    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//    [JPUSHService setBadge:0];
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [application setApplicationIconBadgeNumber:0];
//    [application cancelAllLocalNotifications];
//}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    DLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    DLog(@"iOS7及以上系统，收到通知:%@", userInfo);
//    DLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateInactive ||  application.applicationState == UIApplicationStateBackground) {
        return;
    }

    [self customJumpWith:userInfo];
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
#pragma clang diagnostic pop
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;

    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容

    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    NSString *IdentifyKey = userInfo[@"type"]; // 自定义推送消息辨别标识
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);

    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {

    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容

    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        // 自定义跳转
        [self customJumpWith:userInfo];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }

    completionHandler();  // 系统要求执行这个方法
}
#endif

/*
 {
 "_j_business" = 1;
 "_j_msgid" = 29273404492802811;
 "_j_uid" = 16515791006;
 aps =     {
 alert = "\U60a8\U6709\U65b0\U7684\U95ee\U7b54\U8ba2\U5355!\U8bf7\U5c3d\U5feb\U56de\U7b54\Uff0c48\U5c0f\U65f6\U540e\U8ba2\U5355\U5931\U6548";
 badge = 9;
 "content-available" = 1;
 "mutable-content" = 1;
 sound = "sound.caf";
 };
 extrasParam = "{\"orderType\":0,\"orderUid\":\"DD100604760408\",\"type\":4}";
 "notification_title" = "\U60a8\U6709\U65b0\U7684\U95ee\U7b54\U8ba2\U5355!\U8bf7\U5c3d\U5feb\U56de\U7b54\Uff0c48\U5c0f\U65f6\U540e\U8ba2\U5355\U5931\U6548";
 order = HJOrderDetaildController;
 type = order;
 }
 
 orderType:0问答  2话题
 orderUid:订单id
 type:4y收到的订单
 */
#pragma mark - ---- 推送自定义跳转 ----
- (void)customJumpWith:(NSDictionary*)userInfo {
    
    NSMutableDictionary *dictInfo = [userInfo objectForKey:@"extrasParam"];
    NSLog(@"dictInfo == %@",dictInfo);
    [[RCDataManager shareManager] refreshBadgeValue];
    
    if ([dictInfo isKindOfClass:[NSDictionary class]]) {
        if ([dictInfo[@"orderType"] isEqualToString:@"0"] || [dictInfo[@"orderType"] isEqualToString:@"2"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REMOTE_ORDER_DETAIL_NOTIFICATION" object:dictInfo];
        }
        else {
            if (!IsNilOrNull(dictInfo[@"pushType"])) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REMOTE_ORDER_DETAIL_NOTIFICATION" object:dictInfo];
            }
        }
    }
    
//    if (!IsNilOrNull(dictInfo)) {
////        NSData *jsonData = [dictInfo dataUsingEncoding:NSUTF8StringEncoding];
////        NSError *err;
////        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
////                                                            options:NSJSONReadingMutableContainers
////                                                              error:&err];
//
//
//    }
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

//- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSString *messageID = [userInfo valueForKey:@"_j_msgid"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"type"]; //服务端传递的Extras附加字段，key是自己定义的
//    DLog(@"%@ %@ %@ %@", content, messageID, extras, customizeField1);
//
//}
//
- (void)networkDidLogin:(NSNotification *)notification {
    LoginModel *account = [SDUserTool account];
    if (account.registrationId) {//已登录[JPUSHService registrationID]
        NSString *registrationIDStr = [JPUSHService registrationID];
        NSLog(@"get RegistrationID:%@",registrationIDStr);//获取registrationID
//        [JPUSHService setAlias:[NSString stringWithFormat:@"liebang%@",account.userUid] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//
//        } seq:0];
        [JPUSHService setTags:[NSString stringWithFormat:@"liebang%@",account.userUid] aliasInbackground:[NSString stringWithFormat:@"liebang%@",account.userUid]];

        if (![account.registrationId isEqualToString:registrationIDStr])
        {
            NSLog(@"get RegistrationID 上传服务器");
            [Config currentConfig].registrationID = registrationIDStr;
        }
    }
}

@end

