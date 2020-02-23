//
//  ThemeTimeViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/30.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

@interface ThemeTimeViewController : CommonViewController

@property(nonatomic,copy)void(^saveButtonBlock)(NSString *time);

@property (nonatomic,strong)NSString *time;

@end
