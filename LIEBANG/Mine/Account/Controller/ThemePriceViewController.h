//
//  ThemePriceViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

@interface ThemePriceViewController : CommonViewController

@property(nonatomic,copy)void(^themePriceBlock)(NSString *price,NSString *offPrice);

@property(nonatomic,strong)NSString *price;//话题价格
@property(nonatomic,strong)NSString *offPrice;//话题优惠价格

@end
