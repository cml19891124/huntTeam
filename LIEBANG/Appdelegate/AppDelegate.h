//
//  AppDelegate.h
//  LIEBANG
//
//  Created by  YIQI on 2018/6/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTabBarViewController.h"

//com.changhong.Lottery
//com.yiqi.LIEBANG
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSManagedObjectContext * _context;
}
@property(nonatomic,retain) NSMutableArray *friendsArray;

@property (strong, nonatomic) UIWindow *window;

////@property (nonatomic, strong) NSPersistentContainer *persistentContainer;
//
////插入数据
//- (void)insertData:(NSString *)userUid;
////删除
//- (void)deleteData:(NSString *)userUid;
////更新，修改
//- (void)updateData:(NSString *)userUid;
////读取查询
//- (void)readData:(NSString *)userUid;

@property (copy, nonatomic) NSDictionary *launchOptions;

@property (nonatomic,strong)CommonTabBarViewController *tabBarCtr;

- (void)enterRootViewController;

- (void)loginRongIMService;

+ (AppDelegate *)currentAppDelegate;

@end

