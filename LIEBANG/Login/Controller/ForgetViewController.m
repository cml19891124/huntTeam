//
//  ForgetViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/6/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ForgetViewController.h"
#import "ForgetPasswordView.h"
#import "LoginService.h"

@interface ForgetViewController ()

@property (nonatomic,strong)ForgetPasswordView *forgetPasswordView;
@property (nonatomic,strong)Calculagraph *codeTimer;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"重置密码";
    self.view.backgroundColor = kWhiteColor;
    
    [self.view addSubview:self.forgetPasswordView];
}

#pragma mark Event
- (void)forgetButtonClick {
    
    NSString *checkResult = [LBForProject isCheckPhone:self.forgetPasswordView.phone];
    if (![checkResult isEqualToString:@""]) {
        [self presentSheet:checkResult];
        return;
    }
    
    if (IsStrEmpty(self.forgetPasswordView.code)) {
        [self presentSheet:@"请输入验证码"];
        return;
    }
    
    if (self.forgetPasswordView.code.length > 6) {
        [self presentSheet:@"验证码不能大于6位"];
        return;
    }
    
    if (IsStrEmpty(self.forgetPasswordView.password)) {
        [self presentSheet:@"请输入密码"];
        return;
    }
    
    if (self.forgetPasswordView.password.length < 6) {
        [self presentSheet:@"密码不能小于6位"];
        return;
    }
    
    if (self.forgetPasswordView.password.length > 20) {
        [self presentSheet:@"密码不能大于20位"];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.forgetPasswordView.phone forKey:@"userPhone"];
    [postDic setValue:[MD5 md532BitLower:self.forgetPasswordView.password] forKey:@"newPassword"];
    [postDic setValue:self.forgetPasswordView.code forKey:@"code"];
    
    NSLog(@"忘记密码postDic == %@",postDic);
    
    [self displayOverFlowActivityView];
    [LoginService getResetPasswordWithParameters:postDic success:^(NSString *success) {
        [self removeOverFlowActivityView];
        [self presentSheet:success];
        [self performBlock:^{
            [self backNavItemTapped];
        } afterDelay:1.5f];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)codeButtonClick {
    
    NSString *checkResult = [LBForProject isCheckPhone:self.forgetPasswordView.phone];
    if (![checkResult isEqualToString:@""]) {
        [self presentSheet:checkResult];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.forgetPasswordView.phone forKey:@"userPhone"];
    
    [self displayOverFlowActivityView];
    [LoginService getSendCodeWithParameters:postDic success:^(NSString *success) {
        [self removeOverFlowActivityView];
        UITextField *contentTF = [self.view viewWithTag:21];
        contentTF.text = success;
        [self presentSheet:@"发送验证码成功"];
        [self.codeTimer start];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark UI
- (ForgetPasswordView *)forgetPasswordView {
    if (!_forgetPasswordView) {
        __weak typeof(self)weakSelf = self;
        _forgetPasswordView = [[ForgetPasswordView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight)];
        _forgetPasswordView.resetPasswordBlock = ^{
            [weakSelf forgetButtonClick];
        };
        _forgetPasswordView.sendCodeBlock = ^{
            [weakSelf codeButtonClick];
        };
    }
    return _forgetPasswordView;
}

- (Calculagraph *)codeTimer {
    if (!_codeTimer) {
        _codeTimer = [[Calculagraph alloc] init];
        [_codeTimer addObserver:self forKeyPath:@"time" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _codeTimer;
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"time"]) {
        NSInteger seconds = [[change objectForKey:@"new"] integerValue];
        NSString *time = [NSString stringWithFormat:@"%zdS",60-seconds];
        self.forgetPasswordView.codeButton.enabled = NO;
        [self.forgetPasswordView.codeButton setTitle:time forState:UIControlStateDisabled];
        
        if ([time isEqualToString:@"0S"]) {
            [self.codeTimer stop];
            self.forgetPasswordView.codeButton.enabled = YES;
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
