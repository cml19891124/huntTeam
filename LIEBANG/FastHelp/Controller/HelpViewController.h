//
//  HelpViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/6/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

@interface HelpViewController : CommonViewController

@property(nonatomic,copy)void(^questionButtonBlock)(void);
@property(nonatomic,copy)void(^friendButtonBlock)(void);

@end
