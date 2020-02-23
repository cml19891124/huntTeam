//
//  AccountSelectView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSelectView : UIView

@property(nonatomic,copy)void(^selectViewButtonBlock)(NSInteger index);
@property (nonatomic,assign)AccountState accountState;

@end
