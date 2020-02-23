//
//  PostScoreView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostScoreView : UIView

@property (nonatomic,assign)NSInteger starNumber;
@property(nonatomic,copy)void(^scoreButtonBlock)(void);

@end
