//
//  RegisterView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterView : UIView

@property(nonatomic,copy)void(^registerBlock)(void);
@property(nonatomic,copy)void(^sendCodeBlock)(void);
@property(nonatomic,copy)void(^userProtocolBlock)(void);

@property (nonatomic,strong,readonly)NSString *phone;
@property (nonatomic,strong,readonly)NSString *code;
@property (nonatomic,strong,readonly)NSString *password;
@property (nonatomic,strong,readonly)NSString *nickname;
@property (nonatomic,assign,readonly)BOOL isUserProtocol;

@property (nonatomic,strong)UIButton *codeButton;

- (void)clearRegisterDataSource;

@end
