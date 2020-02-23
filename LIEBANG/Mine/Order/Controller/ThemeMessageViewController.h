//
//  ThemeMessageViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/4.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"
#import "ThemeOrderDetailModel.h"

@interface ThemeMessageViewController : CommonViewController

@property(nonatomic,copy)void(^confimButtonBlock)(ThemeOrderDetailModel *detailModel);
@property(nonatomic,copy)void(^cancelButtonBlock)(void);

@property (nonatomic,strong)ThemeOrderDetailModel *detailModel;

@end
