//
//  AccountNavView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountNavView : UIView

@property(nonatomic,copy)void(^backButtonBlock)(void);
@property(nonatomic,copy)void(^detailButtonBlock)(UIButton *sender);

@property (nonatomic,assign)BOOL isHidden;
@property (nonatomic,assign)AccountState accountState;

@end
