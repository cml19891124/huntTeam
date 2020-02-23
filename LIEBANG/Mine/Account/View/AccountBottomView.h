//
//  AccountBottomView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountBottomView : UIView

@property(nonatomic,copy)void(^likeButtonBlock)(void);
@property(nonatomic,copy)void(^messageButtonBlock)(void);
@property(nonatomic,copy)void(^questionButtonBlock)(void);
@property(nonatomic,copy)void(^reserveButtonBlock)(void);

@property(nonatomic,strong)NSString *likeStatus;

@end
