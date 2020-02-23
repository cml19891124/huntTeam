//
//  EditPhoneViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/8.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "EditPhoneViewController.h"
#import "BindZFBViewController.h"
#import "LoginService.h"

@interface EditPhoneViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)SectionHeadView *headView;
@property (nonatomic,strong)ConfimButton *sureButton;
@property (nonatomic,strong)UITextField *phoneTextField;
@property (nonatomic,strong)UITextField *codeTextField;
@property (nonatomic,strong)UIButton *codeButton;
@property (nonatomic,strong)Calculagraph *codeTimer;
@property (nonatomic,strong)NSString *oldPhone;

@end

@implementation EditPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
}

- (void)backNavItemTapped {
//    [self.navigationController popToRootViewControllerAnimated:YES];
    BOOL isBack = NO;
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(@"SafeViewController")]) {
            [self.navigationController popToViewController:viewController animated:YES];
            isBack = YES;
        }
    }
    
    if (!isBack) {
        [super backNavItemTapped];
    }

    if (self.editPhoneState == EditPhoneStateNormal) {
        [Config currentConfig].userUid = nil;
        [Config currentConfig].mobile = nil;
        [Config currentConfig].username = nil;
        [Config currentConfig].token = nil;
        [Config currentConfig].company = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IS_PAY_COMPANY_NOTIFICATION" object:nil];
    }
}

#pragma mark Event
- (void)sureButtonClick {
    
    if (self.editPhoneState == EditPhoneStateModifyOne || self.editPhoneState == EditPhoneStateModifyAli) {
        
    }
    else {
        NSString *checkResult = [LBForProject isCheckPhone:_phoneTextField.text];
        if (![checkResult isEqualToString:@""]) {
            [self presentSheet:checkResult];
            return;
        }
        
    }
    
    if (IsStrEmpty(_codeTextField.text)) {
        [self presentSheet:@"请输入验证码"];
        return;
    }
    
    if (_codeTextField.text.length > 6) {
        [self presentSheet:@"验证码不能大于6位"];
        return;
    }
    
    if (self.editPhoneState == EditPhoneStateNormal) {//绑定手机号
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        [postDic setValue:_phoneTextField.text forKey:@"userPhone"];
        [postDic setValue:_codeTextField.text forKey:@"code"];
        [postDic setValue:self.openUid forKey:@"userOpenid"];
        [postDic setValue:@"1" forKey:@"bindingType"];//1 微信  2微博
        NSLog(@"绑定手机号 = %@",postDic);
        
        [self displayOverFlowActivityView];
        [LoginService getBindPhoneWithParameters:postDic success:^(NSString *success) {
            [self removeOverFlowActivityView];
            [self presentSheet:success];
            [self performBlock:^{
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            } afterDelay:1.5];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
        
    }
    else if (self.editPhoneState == EditPhoneStateModifyOne) {//修改手机号1--验证验证码
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        [postDic setValue:[Config currentConfig].mobile forKey:@"userPhone"];
        [postDic setValue:_codeTextField.text forKey:@"code"];
        NSLog(@"修改手机号1 = %@",postDic);
        [self displayOverFlowActivityView];
        [LoginService getCheckCodeWithParameters:postDic success:^(NSString *success) {
            [self removeOverFlowActivityView];
            [self presentSheet:success];
            [self performBlock:^{
                EditPhoneViewController *nextCtr = [[EditPhoneViewController alloc] init];
                nextCtr.editPhoneState = EditPhoneStateModifyTwo;
                [self.navigationController pushViewController:nextCtr animated:YES];
            } afterDelay:1.5];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }
    else if (self.editPhoneState == EditPhoneStateModifyTwo) {//修改手机号2
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        [postDic setValue:[Config currentConfig].mobile forKey:@"userPhone"];
        [postDic setValue:_codeTextField.text forKey:@"code"];
        [postDic setValue:_phoneTextField.text forKey:@"newPhone"];
        NSLog(@"修改手机号2 = %@",postDic);
        [self displayOverFlowActivityView];
        [LoginService getModifyPhoneWithParameters:postDic success:^(NSString *success) {
            [self removeOverFlowActivityView];
            [Config currentConfig].mobile = self.phoneTextField.text;
            [self presentSheet:success];
            [self performBlock:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            } afterDelay:1.5];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }
    else if (self.editPhoneState == EditPhoneStateModifyAli) {//支付宝提现
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        [postDic setValue:[Config currentConfig].mobile forKey:@"userPhone"];
        [postDic setValue:_codeTextField.text forKey:@"code"];
        NSLog(@"支付宝提现验证手机 = %@",postDic);
        [self displayOverFlowActivityView];
        [LoginService getCheckCodeWithParameters:postDic success:^(NSString *success) {
            [self removeOverFlowActivityView];
            [self presentSheet:success];
            [self performBlock:^{
                BindZFBViewController *nextCtr = [[BindZFBViewController alloc] init];
                [nextCtr ExtractWithMoney:self.yuer];
                [self.navigationController pushViewController:nextCtr animated:YES];
            } afterDelay:1.5];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }
}

- (void)codeButtonClick {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    if (self.editPhoneState == EditPhoneStateModifyOne  || self.editPhoneState == EditPhoneStateModifyAli) {
        [postDic setValue:[Config currentConfig].mobile forKey:@"userPhone"];
    }
    else {
        NSString *checkResult = [LBForProject isCheckPhone:_phoneTextField.text];
        if (![checkResult isEqualToString:@""]) {
            [self presentSheet:checkResult];
            return;
        }
        
        [postDic setValue:_phoneTextField.text forKey:@"userPhone"];
    }
    
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
#pragma mark UI
- (void)createSubViews {
    
    self.view.backgroundColor = kBackgroundColor;
    
    _sureButton = [[ConfimButton alloc] initWithTop:kCurrentWidth(230) title:@"提交"];
    [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sureButton];
    
    
//    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(110), kCurrentWidth(44))];
//    right.backgroundColor = kWhiteColor;
//    [right addSubview:_codeButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(60), kCurrentWidth(44))];
    titleLabel.font = kSystem(15);
    titleLabel.text = @"+86";
    titleLabel.textColor = kLBRedColor;
    
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(73), kCurrentWidth(44))];
    left.backgroundColor = kWhiteColor;
    [left addSubview:titleLabel];
    
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, kCurrentWidth(44), kDeviceWidth, kCurrentWidth(44))];
    _phoneTextField.font = kSystem(15);
    _phoneTextField.placeholder = @"手机号码";
    _phoneTextField.textColor = kLBBlackColor;
    _phoneTextField.backgroundColor = kWhiteColor;
//    _phoneTextField.rightView = right;
//    _phoneTextField.rightViewMode = UITextFieldViewModeAlways;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextField.leftView = left;
    _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneTextField.delegate = self;
    [self.view addSubview:_phoneTextField];
    
    _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(105), kCurrentWidth(44)+kCurrentWidth(19)/2, kCurrentWidth(90), kCurrentWidth(25));
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
    
    if (self.editPhoneState == EditPhoneStateNormal) {
        self.navigationItem.title = @"绑定手机号";
        
        _headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(44)) title:@"请获取短信验证码，并绑定手机号码"];
        [self.view addSubview:_headView];
    }
    else if (self.editPhoneState == EditPhoneStateModifyOne) {
        _phoneTextField.text = [InsureValidate phonenum:[Config currentConfig].mobile];
        _phoneTextField.enabled = NO;
        self.navigationItem.title = @"修改手机号";
        _sureButton = [[ConfimButton alloc] initWithTop:kCurrentWidth(230) title:@"下一步"];
        _headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(44)) title:@"请获取短信验证码，并验证手机号码"];
        [self.view addSubview:_headView];
    }
    else if (self.editPhoneState == EditPhoneStateModifyTwo) {
        self.navigationItem.title = @"修改手机号";
        
        _headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(44)) title:@"请获取短信验证码，并修改手机号码"];
        [self.view addSubview:_headView];
    }
    else if (self.editPhoneState == EditPhoneStateModifyAli) {
        self.navigationItem.title = @"支付宝提现";
        _headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(44)) title:@"为保证提现安全，请验证手机号码"];
        _phoneTextField.text = [InsureValidate phonenum:[Config currentConfig].mobile];
        _phoneTextField.enabled = NO;
        [self.view addSubview:_headView];
    }
}

- (Calculagraph *)codeTimer {
    if (!_codeTimer) {
        _codeTimer = [[Calculagraph alloc] init];
        [_codeTimer addObserver:self forKeyPath:@"time" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _codeTimer;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (_codeTextField == textField)
    {
        if (textField.text.length >= 6 && ![string isEqualToString:@""]) { //添加这半行代码
            return NO;
        }
        return YES;
    }
    else if (textField == _phoneTextField)
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
