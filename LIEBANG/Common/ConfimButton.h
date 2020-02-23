//
//  ConfimButton.h
//  Lottery
//
//  Created by  YIQI on 2018/4/8.
//  Copyright © 2018年 zhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfimButton : UIButton

- (instancetype)initWithTop:(CGFloat)top title:(NSString *)title;

@property (nonatomic,strong)NSString *title;

@end
