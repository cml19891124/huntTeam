//
//  MoreFootView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/22.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreFootView : UIView

@property(nonatomic,copy)void(^moreButtonBlock)(void);

- (instancetype)initWithTitle:(NSString *)title;

@end
