//
//  LoginView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "LoginView.h"

static NSArray *titleArray;
static NSArray *placeholderArray;

@interface LoginView ()<UITextFieldDelegate>

@property (nonatomic,strong)ConfimButton *loginButton;
@property (nonatomic,strong)UIButton *forgetButton;

@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _loginButton = [[ConfimButton alloc] initWithTop:kCurrentWidth(210) title:@"登录"];
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loginButton];
        
        titleArray = @[@"手机号码  ",@"密码          "];
        placeholderArray = @[@"+86",@"密码不少于6个字"];
        
        [self createContentTextFieldWithArray];
    }
    return self;
}

- (void)clearLoginDataSource {
    UITextField *contentTF = [self viewWithTag:10];
    UITextField *contentTF1 = [self viewWithTag:11];
    
    contentTF.text = nil;
    contentTF1.text = nil;
}

#pragma mark Event
- (void)forgetButtonClick {
    if (_forgetPasswordBlock) {
        _forgetPasswordBlock();
    }
}

- (void)loginButtonClick {
    if (_loginBlock) {
        _loginBlock();
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 11)
    {
        if (textField.text.length >= 20 && ![string isEqualToString:@""]) { //添加这半行代码
            return NO;
        }
        return YES;
    }
    else if (textField.tag == 10)
    {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (textField.text.length >= 11) {
           return NO;
        }

        NSString *validRegEx =@"^[0-9]$";
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        if (myStringMatchesRegEx) {
           return YES;
        }
        return NO;
    }
    return YES;
}


#pragma mark GET
- (NSString *)phone {
    UITextField *contentTF = [self viewWithTag:10];
    return contentTF.text;
}

- (NSString *)password {
    UITextField *contentTF = [self viewWithTag:11];
    return contentTF.text;
}

#pragma mark UI
- (void)createContentTextFieldWithArray {
    
    for (int i = 0; i < titleArray.count; i ++)
    {
        UITextField *contentTf = [[UITextField alloc] initWithFrame:CGRectMake(kCurrentWidth(20), kCurrentWidth(75)+kCurrentWidth(60)*i, kDeviceWidth-kCurrentWidth(40), kCurrentWidth(35))];
        contentTf.placeholder = [placeholderArray safeObjectAtIndex:i];
        contentTf.font = kSystem(15);
        contentTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        contentTf.tag = 10+i;

        if (i == 0)
        {
            contentTf.keyboardType = UIKeyboardTypeNumberPad;
        }
        else
        {
            contentTf.rightView = self.forgetButton;
            contentTf.rightViewMode = UITextFieldViewModeAlways;
            contentTf.secureTextEntry = YES;
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(70), kCurrentWidth(35))];
        titleLabel.text = [titleArray safeObjectAtIndex:i];
        titleLabel.font = kSystemBold(15);
        titleLabel.textColor = kLBBlackColor;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        contentTf.leftView = titleLabel;
        contentTf.leftViewMode = UITextFieldViewModeAlways;
        contentTf.delegate = self;
        [self addSubview:contentTf];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kCurrentWidth(20), contentTf.bottom, kDeviceWidth-kCurrentWidth(40), 0.5)];
        lineView.backgroundColor = kSepparteLineColor;
        [self addSubview:lineView];
        
    }
    
}

- (UIButton *)forgetButton {
    if (!_forgetButton) {
        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetButton.frame = CGRectMake(0, 0, kCurrentWidth(70), kCurrentWidth(35));
        [_forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = kSystem(14);
        _forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_forgetButton addTarget:self action:@selector(forgetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetButton;
}

@end
