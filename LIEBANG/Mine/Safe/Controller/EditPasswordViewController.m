//
//  EditPasswordViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/8.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "LoginService.h"

@interface EditPasswordViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)SectionHeadView *headView;
@property (nonatomic,strong)ConfimButton *sureButton;
@property (nonatomic,strong)UITextField *phoneTextField;
@property (nonatomic,strong)UITextField *codeTextField;
@property (nonatomic,strong)UITextField *passwordTextField;
@property (nonatomic,strong)UIButton *codeButton;

@property (nonatomic,strong)Calculagraph *codeTimer;

@end

@implementation EditPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.navigationItem.title = @"修改密码";
    
    [self createSubViews];
}

#pragma mark Event
- (void)sureButtonClick {
    
    NSString *checkResult = [LBForProject isCheckPhone:[Config currentConfig].mobile];
    if (![checkResult isEqualToString:@""]) {
        [self presentSheet:checkResult];
        return;
    }
    
    if (IsStrEmpty(_codeTextField.text)) {
        [self presentSheet:@"请输入验证码"];
        return;
    }
    
    if (_codeTextField.text.length > 6) {
        [self presentSheet:@"验证码不能大于6位"];
        return;
    }
    
    if (IsStrEmpty(_passwordTextField.text)) {
        [self presentSheet:@"请输入密码"];
        return;
    }
    
    if (_passwordTextField.text.length < 6) {
        [self presentSheet:@"密码不能小于6位"];
        return;
    }
    
    if (_passwordTextField.text.length > 20) {
        [self presentSheet:@"密码不能大于20位"];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:[Config currentConfig].mobile forKey:@"userPhone"];
    [postDic setValue:_codeTextField.text forKey:@"code"];
    [postDic setValue:[MD5 md532BitLower:_passwordTextField.text] forKey:@"newPassword"];
    
    [self displayOverFlowActivityView];
    [LoginService getResetPasswordWithParameters:postDic success:^(NSString *success) {
        [self removeOverFlowActivityView];
        [self presentSheet:success];
        [self performBlock:^{
//            [self.navigationController popToRootViewControllerAnimated:YES];
            LoginViewController *loginCtr = [[LoginViewController alloc] init];
            CommonNavgationViewController *loginNav = [[CommonNavgationViewController alloc] initWithRootViewController:loginCtr];
            [self.navigationController presentViewController:loginNav animated:YES completion:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[AppDelegate currentAppDelegate].tabBarCtr tabBarSetSelectedIndex:0];
            }];
        } afterDelay:1.5f];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)codeButtonClick {
    
    NSString *checkResult = [LBForProject isCheckPhone:[Config currentConfig].mobile];
    if (![checkResult isEqualToString:@""]) {
        [self presentSheet:checkResult];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:[Config currentConfig].mobile forKey:@"userPhone"];
    
    [self displayOverFlowActivityView];
    [LoginService getSendCodeWithParameters:postDic success:^(NSString *success) {
        [self removeOverFlowActivityView];
        _codeTextField.text = success;
        [self presentSheet:@"发送验证码成功"];
        [self.codeTimer start];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark UI
- (void)createSubViews {
    
    _headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(44)) title:@"请获取短信验证码，并设置新的登录密码"];
    [self.view addSubview:_headView];
    
    _sureButton = [[ConfimButton alloc] initWithTop:kCurrentWidth(230) title:@"提交"];
    [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sureButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(73), kCurrentWidth(44))];
    titleLabel.font = kSystem(15);
    titleLabel.text = @"+86";
    titleLabel.textColor = kLBRedColor;
    
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(73), kCurrentWidth(44))];
    left.backgroundColor = kWhiteColor;
    [left addSubview:titleLabel];
    
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, _headView.bottom, kDeviceWidth, kCurrentWidth(44))];
    _phoneTextField.font = kSystem(15);
    _phoneTextField.placeholder = @"手机号码";
    _phoneTextField.textColor = kLBBlackColor;
    _phoneTextField.backgroundColor = kWhiteColor;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextField.leftView = left;
    _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneTextField.text = [InsureValidate phonenum:[Config currentConfig].mobile];
    _phoneTextField.enabled = NO;
    [self.view addSubview:_phoneTextField];
    
    _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(105), _headView.bottom+kCurrentWidth(19)/2, kCurrentWidth(90), kCurrentWidth(25));
    [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _codeButton.titleLabel.font = kSystem(14);
    _codeButton.layer.cornerRadius = 2.f;
    _codeButton.layer.masksToBounds = YES;
    _codeButton.backgroundColor = kLBRedColor;
    [_codeButton addTarget:self action:@selector(codeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_codeButton];
    
    UIView *left1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(12), kCurrentWidth(44))];
    left1.backgroundColor = kWhiteColor;

    _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, _phoneTextField.bottom+kCurrentWidth(10), kDeviceWidth, kCurrentWidth(44))];
    _codeTextField.font = kSystem(15);
    _codeTextField.placeholder = @"验证码";
    _codeTextField.textColor = kLBBlackColor;
    _codeTextField.backgroundColor = kWhiteColor;
    _codeTextField.leftView = left1;
    _codeTextField.leftViewMode = UITextFieldViewModeAlways;
    _codeTextField.delegate = self;
    [self.view addSubview:_codeTextField];

    UIView *left2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(12), kCurrentWidth(44))];
    left2.backgroundColor = kWhiteColor;

    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, _codeTextField.bottom+kCurrentWidth(10), kDeviceWidth, kCurrentWidth(44))];
    _passwordTextField.font = kSystem(15);
    _passwordTextField.placeholder = @"新密码";
    _passwordTextField.textColor = kLBBlackColor;
    _passwordTextField.backgroundColor = kWhiteColor;
    _passwordTextField.leftView = left2;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    [self.view addSubview:_passwordTextField];
}

- (Calculagraph *)codeTimer {
    if (!_codeTimer) {
        _codeTimer = [[Calculagraph alloc] init];
        [_codeTimer addObserver:self forKeyPath:@"time" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _codeTimer;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    if (textField == _passwordTextField)
    {
        if (_passwordTextField.text.length >= 20 && ![string isEqualToString:@""]) { //添加这半行代码
            return NO;
        }
        return YES;
    }
    if (_codeTextField == textField)
    {
        if (textField.text.length >= 6 && ![string isEqualToString:@""]) { //添加这半行代码
            return NO;
        }
        return YES;
    }
    return YES;
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"time"]) {
        NSInteger seconds = [[change objectForKey:@"new"] integerValue];
        NSString *time = [NSString stringWithFormat:@"%zdS",60-seconds];
        self.codeButton.enabled = NO;
        [self.codeButton setTitle:time forState:UIControlStateDisabled];
        
        if ([time isEqualToString:@"0S"]) {
            [self.codeTimer stop];
            self.codeButton.enabled = YES;
        }
    }
}

- (void)dealloc {
    [self.codeTimer removeObserver:self forKeyPath:@"time"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
