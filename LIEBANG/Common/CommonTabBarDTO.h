//
//  CommonTabBarDTO.h
//  Storm
//
//  Created by 朱攀峰 on 15/11/27.
//  Copyright (c) 2015年 MCDS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonTabBarDTO : NSObject

@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@interface CommonDTO1 : NSObject

@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)UIImage *normalImage;
@property (nonatomic,strong)UIImage *selectedImage;
@property (nonatomic,strong)UIImage *highlightedImage;

@end
