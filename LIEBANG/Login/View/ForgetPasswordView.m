//
//  ForgetPasswordView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ForgetPasswordView.h"

static NSArray *titleArray;
static NSArray *placeholderArray;

@interface ForgetPasswordView ()<UITextFieldDelegate>

@property (nonatomic,strong)ConfimButton *resetButton;

@property (nonatomic,strong)UILabel *messageLabel;

@end

@implementation ForgetPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _resetButton = [[ConfimButton alloc] initWithTop:kCurrentWidth(260) title:@"重置密码"];
        [_resetButton addTarget:self action:@selector(forgetButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_resetButton];
        [self addSubview:self.messageLabel];
        
        titleArray = @[@"手机号码  ",@"验证码      ",@"密码          "];
        placeholderArray = @[@"+86",@"请输入验证码",@"请输入新密码"];
        
        [self createContentTextFieldWithArray];
    }
    return self;
}

#pragma mark Event
- (void)forgetButtonClick {
    if (_resetPasswordBlock) {
        _resetPasswordBlock();
    }
}

- (void)codeButtonClick {
    if (_sendCodeBlock) {
        _sendCodeBlock();
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 22)
    {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if ([string isEqualToString:@" "]) {
            return NO;
        }
        if (textField.text.length >= 20 && ![string isEqualToString:@""]) { //添加这半行代码
            return NO;
        }
        return YES;
    }
    else if (textField.tag == 21)
    {
        if (textField.text.length >= 6 && ![string isEqualToString:@""]) { //添加这半行代码
            return NO;
        }
        return YES;
    }
    else if (textField.tag == 20)
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
    UITextField *contentTF = [self viewWithTag:20];
    return contentTF.text;
}

- (NSString *)code {
    UITextField *contentTF = [self viewWithTag:21];
    return contentTF.text;
}

- (NSString *)password {
    UITextField *contentTF = [self viewWithTag:22];
    return contentTF.text;
}

- (void)createContentTextFieldWithArray {
    
    for (int i = 0; i < titleArray.count; i ++)
    {
        UITextField *contentTf = [[UITextField alloc] initWithFrame:CGRectMake(kCurrentWidth(20), kCurrentWidth(54)*i+kCurrentWidth(54), kDeviceWidth-kCurrentWidth(40), kCurrentWidth(35))];
        contentTf.placeholder = [placeholderArray safeObjectAtIndex:i];
        contentTf.font = kSystem(15);
        contentTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        contentTf.tag = 20+i;
        if (i == 0)
        {
            contentTf.rightView = self.codeButton;
            contentTf.rightViewMode = UITextFieldViewModeAlways;
            contentTf.keyboardType = UIKeyboardTypeNumberPad;
        }
        else if (i== 1)
        {
            contentTf.keyboardType = UIKeyboardTypeNumberPad;
        }
        else if (i == 2)
        {
            contentTf.secureTextEntry = YES;
        }
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(70), kCurrentWidth(35))];
        titleLabel.text = [titleArray safeObjectAtIndex:i];
        titleLabel.font = kSystemBold(15);
        titleLabel.textColor = kLBBlackColor;
        contentTf.leftView = titleLabel;
        contentTf.leftViewMode = UITextFieldViewModeAlways;
        contentTf.delegate = self;
        [self addSubview:contentTf];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kCurrentWidth(20), contentTf.bottom, kDeviceWidth-kCurrentWidth(40), 0.5)];
        lineView.backgroundColor = kSepparteLineColor;
        [self addSubview:lineView];
        
    }
}

- (UIButton *)codeButton {
    if (!_codeButton) {
        _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeButton.frame = CGRectMake(0, 0, kCurrentWidth(80), kCurrentWidth(35));
        [_codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_codeButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        _codeButton.titleLabel.font = kSystem(15);
        _codeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_codeButton addTarget:self action:@selector(codeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeButton;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(20), kCurrentWidth(198), kDeviceWidth-kCurrentWidth(40), kCurrentWidth(33))];
        _messageLabel.textColor = kLBNineColor;
        _messageLabel.text = @"密码由6-20位字符组成，区分大小写";
        _messageLabel.font = kSystem(12);
    }
    return _messageLabel;
}

@end
