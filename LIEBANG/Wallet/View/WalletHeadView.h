//
//  WalletHeadView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/24.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletHeadView : UIView

@property(nonatomic,copy)void(^backButtonBlock)(void);
@property(nonatomic,copy)void(^rechargeButtonBlock)(void);
@property(nonatomic,copy)void(^forwardButtonBlock)(void);

@property (nonatomic,strong)NSString *balance;

@end
