//
//  HomeButton.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeButton : UIButton

- (void)setTitle:(NSString *)title message:(NSString *)message imageString:(NSString *)imageString;

@property (nonatomic,assign)BOOL isLoad;

@end
