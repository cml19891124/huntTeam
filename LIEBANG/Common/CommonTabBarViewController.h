//
//  CommonTabBarViewController.h
//  Storm
//
//  Created by 朱攀峰 on 15/11/27.
//  Copyright (c) 2015年 MCDS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTabBar.h"


@interface CommonTabBarViewController : UITabBarController<CommonTabBarDelegate,UITabBarControllerDelegate>

@property (nonatomic,strong)CommonTabBar *tabBarView;

- (void)popToRootViewController:(BOOL)animate;

- (void)tabBarSetSelectedIndex:(NSInteger)index;

@property (nonatomic,strong)NSString *titleStr;


@end
