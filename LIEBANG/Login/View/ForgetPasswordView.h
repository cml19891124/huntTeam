//
//  ForgetPasswordView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordView : UIView

@property(nonatomic,copy)void(^resetPasswordBlock)(void);
@property(nonatomic,copy)void(^sendCodeBlock)(void);

@property (nonatomic,strong,readonly)NSString *phone;
@property (nonatomic,strong,readonly)NSString *code;
@property (nonatomic,strong,readonly)NSString *password;

@property (nonatomic,strong)UIButton *codeButton;

@end
