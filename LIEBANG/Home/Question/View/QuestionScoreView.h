//
//  QuestionScoreView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/18.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionScoreView : UIView

@property(nonatomic,copy)void(^scoreButtonBlock)(void);

@property(nonatomic,copy)void(^commentButtonBlock)(void);

@property (nonatomic,assign)NSInteger starNumber;

@end
