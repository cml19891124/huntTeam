//
//  CommonTabBar.h
//  Storm
//
//  Created by 朱攀峰 on 15/11/27.
//  Copyright (c) 2015年 MCDS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTabBarDTO.h"

@protocol CommonTabBarDelegate;

@interface CommonTabBar : UIView

@property (nonatomic,weak)id<CommonTabBarDelegate>delegate;

@property (nonatomic,weak)UIButton *selectedButton;

@property (nonatomic,strong)CommonTabBarDTO *dataSource;

- (void)setSelectedButtonIndex:(NSInteger)index;

@end
@protocol CommonTabBarDelegate <NSObject>

- (void)tabBar:(CommonTabBar *)tabBar didPressButton:(UIButton *)button atIndex:(NSUInteger)tabIndex;

@end