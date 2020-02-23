//
//  ThemePickView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/23.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeClassModel.h"


@interface ThemePickView : UIView

@property(nonatomic,copy)void(^pickBlock)(ThemeClassModel *model);
@property(nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)AccountState accountState;


+ (void)showThemePickViewWithAnimation:(BOOL)bAnimation
                          accountState:(AccountState)accountState
                            dataSource:(NSArray *)dataSource
                             pickBlock:(void(^)(ThemeClassModel *model))pickBlock;

@end
