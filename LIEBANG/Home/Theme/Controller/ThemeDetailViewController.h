//
//  ThemeDetailViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

@interface ThemeDetailViewController : CommonViewController

@property (nonatomic,strong)ThemeClassModel *themeModel;
@property (nonatomic,assign)ThemeDetailState detailState;
@property (nonatomic,strong)NSString *themeUid;

@end
