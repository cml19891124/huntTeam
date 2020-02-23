//
//  FastView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FastView : UIView

@property(nonatomic,copy)void(^backButtonBlock)(void);
@property(nonatomic,copy)void(^questionButtonBlock)(void);
@property(nonatomic,copy)void(^friendButtonBlock)(void);

@end
