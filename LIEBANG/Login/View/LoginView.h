//
//  LoginView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView

@property(nonatomic,copy)void(^forgetPasswordBlock)(void);
@property(nonatomic,copy)void(^loginBlock)(void);

@property (nonatomic,strong,readonly)NSString *phone;
@property (nonatomic,strong,readonly)NSString *password;

- (void)clearLoginDataSource;

@end
