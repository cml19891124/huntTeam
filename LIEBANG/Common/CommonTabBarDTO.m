//
//  CommonTabBarDTO.m
//  Storm
//
//  Created by 朱攀峰 on 15/11/27.
//  Copyright (c) 2015年 MCDS. All rights reserved.
//

#import "CommonTabBarDTO.h"

@implementation CommonTabBarDTO

- (id)init
{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:5];
        
        NSArray *titleArr = @[@"首页",@"消息",@"企业AI智能名片",@"人脉",@"我的"];
        NSArray *imageArr = @[@"tab_btn_shouye_norrmal",@"tab_btn_xiaoxi_normal",@"icon_white",@"tab_btn_renmia_normal",@"tab_btn_wo_normal"];
        NSArray *selectImageArr = @[@"tab_btn_shouye_sel",@"tab_btn_xiaoxi_sel",@"icon_white",@"tab_btn_renmia_sel",@"tab_btn_wo_sel"];
        
        for (int i = 0; i < titleArr.count; i++) {
            CommonDTO1 *dto = [[CommonDTO1 alloc] init];
            dto.title = [titleArr objectAtIndex:i];
            dto.normalImage = [UIImage imageNamed:imageArr[i]];
            dto.selectedImage = [UIImage imageNamed:selectImageArr[i]];
            [_dataArray addObject:dto];
        }
    }
    return self;
}

@end

@implementation CommonDTO1

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
