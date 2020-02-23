//
//  RegisterView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "RegisterView.h"

static NSArray *titleArray;
static NSArray *placeholderArray;

@interface RegisterView ()<UITextFieldDelegate>

@property (nonatomic,strong)ConfimButton *registerButton;
@property (nonatomic,strong)UIButton *userProtocolButton;
@property (nonatomic,strong)YYLabel *userProtocolLabel;


@end

@implementation RegisterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _registerButton = [[ConfimButton alloc] initWithTop:kCurrentWidth(255) title:@"注册"];
        [_registerButton setBackgroundImage:[UIImage createImageWithColor:kSepparteLineColor] forState:UIControlStateDisabled];
        [_registerButton setTitle:@"尚未同意用户协议" forState:UIControlStateDisabled];
//        _registerButton.enabled = NO;
        [_registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_registerButton];
        
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        NSString *title = @"我已阅读并同意猎帮用户协议";
        CGSize size = [title sizeWithFont:kSystem(12) maxSize:CGSizeMake(MAXFLOAT, kCurrentWidth(26))];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
        [text yy_setColor:kLBRedColor range:[title rangeOfString:@"猎帮用户协议"]];
        [text yy_setUnderlineStyle:NSUnderlineStyleSingle range:[title rangeOfString:@"猎帮用户协议"]];
        [text yy_setUnderlineColor:kLBRedColor range:[title rangeOfString:@"猎帮用户协议"]];
        [text yy_setTextHighlightRange:[title rangeOfString:@"猎帮用户协议"] color:kLBRedColor backgroundColor:kLBRedColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (self.userProtocolBlock) {
                self.userProtocolBlock();
            }
        }];
        
        _userProtocolLabel = [YYLabel new];
        _userProtocolLabel.userInteractionEnabled = YES;
        _userProtocolLabel.numberOfLines = 0;
        _userProtocolLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _userProtocolLabel.frame = CGRectMake((kDeviceWidth-size.width+kCurrentWidth(20))/2, _registerButton.bottom+kCurrentWidth(10), size.width, kCurrentWidth(26));
        _userProtocolLabel.font = kSystem(12);
        _userProtocolLabel.attributedText = text;
        [self addSubview:_userProtocolLabel];
        
        _userProtocolButton = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth-size.width+kCurrentWidth(20))/2-kCurrentWidth(24), _registerButton.bottom+kCurrentWidth(10), kCurrentWidth(24), kCurrentWidth(26))];
        [_userProtocolButton setImage:[UIImage imageNamed:@"icon_weixuanzhong_normal"] forState:UIControlStateNormal];
        [_userProtocolButton setImage:[UIImage imageNamed:@"icon_sel_login"] forState:UIControlStateSelected];
        [_userProtocolButton addTarget:self action:@selector(userProtocolClick) forControlEvents:UIControlEventTouchUpInside];
        _userProtocolButton.selected = YES;
        [self addSubview:_userProtocolButton];
        
        titleArray = @[@"手机号码  ",@"验证码      ",@"密码          ",@"昵称          "];
        placeholderArray = @[@"+86",@"输入你收到的验证码",@"密码不少于6个字",@"不做无名之辈"];
        
        [self createContentTextFieldWithArray];
    }
    return self;
}


- (void)clearRegisterDataSource {
    UITextField *contentTF1 = [self viewWithTag:1];
    UITextField *contentTF2 = [self viewWithTag:2];
    UITextField *contentTF3 = [self viewWithTag:3];
    UITextField *contentTF4 = [self viewWithTag:4];
    
    contentTF1.text = nil;
    contentTF2.text = nil;
    contentTF3.text = nil;
    contentTF4.text = nil;
}

#pragma mark Event
- (void)registerButtonClick {
    if (_registerBlock) {
        _registerBlock();
    }
}

- (void)codeButtonClick {
    if (_sendCodeBlock) {
        _sendCodeBlock();
    }
}

- (void)userProtocolClick {
    _userProtocolButton.selected = !_userProtocolButton.selected;
    _registerButton.enabled = _userProtocolButton.selected;
}

#pragma mark GET
- (NSString *)phone {
    UITextField *contentTF = [self viewWithTag:1];
    return contentTF.text;
}

- (NSString *)code {
    UITextField *contentTF = [self viewWithTag:2];
    return contentTF.text;
}

- (NSString *)password {
    UITextField *contentTF = [self viewWithTag:3];
    return contentTF.text;
}

- (NSString *)nickname {
    UITextField *contentTF = [self viewWithTag:4];
    return contentTF.text;
}

- (BOOL)isUserProtocol {
    return _userProtocolButton.selected;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@" "]) {
        return NO;
    }
//    if (textField.tag == 3)
//    {
//        if (textField.text.length >= 20 && ![string isEqualToString:@""]) { //添加这半行代码
//            return NO;
//        }
//        return YES;
//    }
//    else if (textField.tag == 2)
//    {
//        if (textField.text.length >= 6 && ![string isEqualToString:@""]) { //添加这半行代码
//            return NO;
//        }
//        return YES;
//    }
//    else
        if (textField.tag == 1)
    {
        if ([string isEqualToString:@""]) {
            return YES;
        }
//        if (textField.text.length >= 11) {
//            return NO;
//        }
        
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

- (void)textFieldDidChange:(UITextField *)textField
{
    int max_name = 0;
    if (textField.tag == 3)
    {
        max_name = 20;
    }
    else if (textField.tag == 2 || textField.tag == 4)
    {
        max_name = 6;
    }
    else if (textField.tag == 1)
    {
        max_name = 11;
    }
    
    
    NSString *toBeString = textField.text;// [Util trim:textField.text];
    
    NSLog(@"- --------- --%@",toBeString);
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    
    if ([current.primaryLanguage isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > max_name) {
                textField.text = [toBeString substringToIndex:max_name];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
        if (toBeString.length > max_name) {
            //            NSLog(@"- change to --%@",textField.text);
            
            textField.text = [toBeString substringToIndex:max_name];
        }
    }
    //    _oldInputStr = textField.text;
    NSLog(@"- change to --%@",textField.text);
    
}


#pragma mark UI
- (void)createContentTextFieldWithArray {
    
    for (int i = 0; i < titleArray.count; i ++)
    {
        UITextField *contentTf = [[UITextField alloc] initWithFrame:CGRectMake(kCurrentWidth(20), kCurrentWidth(32)+kCurrentWidth(49)*i, kDeviceWidth-kCurrentWidth(40), kCurrentWidth(35))];
        contentTf.placeholder = [placeholderArray safeObjectAtIndex:i];
        contentTf.font = kSystem(15);
        contentTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        contentTf.tag = 1+i;
        [contentTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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

@end
