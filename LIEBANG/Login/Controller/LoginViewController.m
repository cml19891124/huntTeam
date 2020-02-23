//
//  LoginViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/6/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetViewController.h"
#import "EditPhoneViewController.h"
#import "LoginView.h"
#import "RegisterView.h"
#import "LoginService.h"
#import "WXApi.h"

@interface LoginViewController ()

@property (nonatomic,strong)UIButton *loginNavButton;
@property (nonatomic,strong)UIButton *registerNavButton;
@property (nonatomic,strong)UIView *buttonView;

@property (nonatomic,strong)UILabel *tipLabel;
@property (nonatomic,strong)UIButton *wxButton;
@property (nonatomic,strong)UIButton *wbButton;

@property (nonatomic,strong)LoginView *loginView;
@property (nonatomic,strong)RegisterView *registerView;
@property (nonatomic,strong)Calculagraph *codeTimer;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = kWhiteColor;
    
    [self.view addSubview:self.buttonView];
    [self.buttonView addSubview:self.registerNavButton];
    [self.buttonView addSubview:self.loginNavButton];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.wxButton];
//    [self.view addSubview:self.wbButton];
    [self.view addSubview:self.loginView];
    [self.view addSubview:self.registerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXLogin:) name:@"WX_ACCOUNT_LOGIN_RETURN" object:nil];
}

- (void)dealloc {
    [self.codeTimer removeObserver:self forKeyPath:@"time"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WX_ACCOUNT_LOGIN_RETURN" object:nil];
}

#pragma mark Event
- (void)loginNavButtonClick {
    self.navigationItem.title = @"登录";
    self.loginNavButton.selected = YES;
    self.registerNavButton.selected = NO;
    self.loginView.hidden = NO;
    self.registerView.hidden = YES;
    [self.registerView clearRegisterDataSource];
}

- (void)registerNavButtonClick {
    self.navigationItem.title = @"注册";
    self.loginNavButton.selected = NO;
    self.registerNavButton.selected = YES;
    self.loginView.hidden = YES;
    self.registerView.hidden = NO;
}

- (void)wbButtonClick {
    
}

- (void)wxButtonClick {
    
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"com.yiqi.LIEBANG";
        [WXApi sendReq:req];
    }
    else {
        [self showAlertWithString:@"未安装微信"];
    }
}

- (void)backNavItemTapped {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginButtonClick {
    
    NSString *checkResult = [LBForProject isCheckPhone:self.loginView.phone];
    if (![checkResult isEqualToString:@""]) {
        [self presentSheet:checkResult];
        return;
    }
    
    if (IsStrEmpty(self.loginView.password)) {
        [self presentSheet:@"请输入密码"];
        return;
    }
    
    if (self.loginView.password.length < 6) {
        [self presentSheet:@"密码不能小于6位"];
        return;
    }
    
    if (self.loginView.password.length > 20) {
        [self presentSheet:@"密码不能大于20位"];
        return;
    }
    NSString *registrationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"JPushID"];
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.loginView.phone forKey:@"userPhone"];
    [postDic setValue:[MD5 md532BitLower:self.loginView.password] forKey:@"userPassword"];
    [postDic setValue:[Config currentConfig].registrationID?:registrationID forKey:@"registrationId"];//极光registrationId
    
    NSLog(@"登录registrationID == %@",[Config currentConfig].registrationID);
    NSLog(@"登录postDic == %@",postDic);
    
    [self displayOverFlowActivityView];
    [LoginService getLoginWithParameters:postDic success:^(LoginModel *object) {
        [self removeOverFlowActivityView];
        [self presentSheet:@"登录成功"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AppDelegate currentAppDelegate] loginRongIMService];
        });
        
        [self performBlock:^{
            if (self.loginSueccssBlock) {
                self.loginSueccssBlock();
            }
            [self backNavItemTapped];
        } afterDelay:1.5f];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)registerButtonClick {
    
    NSString *checkResult = [LBForProject isCheckPhone:self.registerView.phone];
    if (![checkResult isEqualToString:@""]) {
        [self presentSheet:checkResult];
        return;
    }
    
    if (IsStrEmpty(self.registerView.code)) {
        [self presentSheet:@"请输入验证码"];
        return;
    }
    
    if (self.registerView.code.length > 6) {
        [self presentSheet:@"验证码不能大于6位"];
        return;
    }
    
    if (IsStrEmpty(self.registerView.password)) {
        [self presentSheet:@"请输入密码"];
        return;
    }
    
    if (self.registerView.password.length < 6) {
        [self presentSheet:@"密码不能小于6位"];
        return;
    }
    
    if (self.registerView.password.length > 20) {
        [self presentSheet:@"密码不能大于20位"];
        return;
    }
    
    if (IsStrEmpty(self.registerView.nickname)) {
        [self presentSheet:@"请输入昵称"];
        return;
    }
    
    if (self.registerView.nickname.length > 10) {
        [self presentSheet:@"昵称不能超过10个字"];
        return;
    }
    
    if (!self.registerView.isUserProtocol) {
        [self presentSheet:@"请阅读并同意猎帮用户协议"];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.registerView.phone forKey:@"userPhone"];
    [postDic setValue:[MD5 md532BitLower:self.registerView.password] forKey:@"userPassword"];
    [postDic setValue:self.registerView.code forKey:@"code"];
    [postDic setValue:self.registerView.nickname forKey:@"userName"];
    [postDic setValue:[Config currentConfig].registrationID forKey:@"registrationId"];
    
    NSLog(@"注册postDic = %@",postDic);
    
    [self displayOverFlowActivityView];
    [LoginService getRegisterWithParameters:postDic success:^(NSString *success) {
        [self removeOverFlowActivityView];
        [self presentSheet:success];
        
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        [postDic setValue:self.registerView.phone forKey:@"userPhone"];
        [postDic setValue:[MD5 md532BitLower:self.registerView.password] forKey:@"userPassword"];
        [postDic setValue:[Config currentConfig].registrationID forKey:@"registrationId"];//极光registrationId
        
        NSLog(@"登录registrationID == %@",[Config currentConfig].registrationID);
        NSLog(@"登录postDic == %@",postDic);
        
        [self displayOverFlowActivityView];
        [LoginService getLoginWithParameters:postDic success:^(LoginModel *object) {
            [self removeOverFlowActivityView];
            [self presentSheet:@"登录成功"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AppDelegate currentAppDelegate] loginRongIMService];
            });
            
            [self performBlock:^{
                if (self.loginSueccssBlock) {
                    self.loginSueccssBlock();
                }
                [self backNavItemTapped];
            } afterDelay:1.5f];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)codeButtonClick {
    
    NSString *checkResult = [LBForProject isCheckPhone:self.registerView.phone];
    if (![checkResult isEqualToString:@""]) {
        [self presentSheet:checkResult];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.registerView.phone forKey:@"userPhone"];
    
    [self displayOverFlowActivityView];
    [LoginService getSendCodeWithParameters:postDic success:^(NSString *success) {
        [self removeOverFlowActivityView];
        UITextField *contentTF = [self.view viewWithTag:2];
        contentTF.text = success;
        [self presentSheet:@"发送验证码成功"];
        [self.codeTimer start];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}


- (void)gotoUserProtocol {
    
    WebViewController *nextCtr = [[WebViewController alloc] init];
    nextCtr.webViewType = WebViewTypeUserProtocol;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)WXLogin:(NSNotification *)notification
{
    if ([notification.object[@"code"] isEqualToString:@"fail"]) {
        [self presentSheet:@"登录失败"];
        return;
    }
    NSDictionary *postDic = @{@"appid":WXappKey,
                              @"secret":WXappSecret,
                              @"code":notification.object[@"code"],
                              @"grant_type":@"authorization_code"};
    
    [HttpClient sendGetRequest:@"https://api.weixin.qq.com/sns/oauth2/access_token" parameters:postDic success:^(id responseObject) {
        NSLog(@"WXLogin :%@",responseObject);
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"WXSaveToken"];
        [self saveTolenAndRequireWXInfo];
    } failure:^(NSUInteger statusCode, NSString *error) {
        NSLog(@"WXLoginerror :%@",error);
    }];
}

- (void)saveTolenAndRequireWXInfo
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"WXSaveToken"];
    NSDictionary *postDic = @{@"openid":dict[@"openid"],
                              @"access_token":dict[@"access_token"]};
    
    [HttpClient sendGetRequest:@"https://api.weixin.qq.com/sns/userinfo" parameters:postDic success:^(id responseObject) {
        NSLog(@"WXLogin :%@",responseObject);
        [self readyToCallTheLogin:responseObject];
    } failure:^(NSUInteger statusCode, NSString *error) {
        NSLog(@"WXLoginerror :%@",error);
    }];
}

- (void)readyToCallTheLogin:(NSDictionary *)dict
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:dict[@"openid"] forKey:@"userOpenid"];//第三方授权id
    [postDic setValue:[Config currentConfig].registrationID forKey:@"registrationId"];//极光推送id
    [postDic setValue:dict[@"nickname"] forKey:@"userName"];
    [postDic setValue:dict[@"headimgurl"] forKey:@"userHead"];
    [postDic setValue:@"0" forKey:@"type"];//0"微信  1：微博
    
    NSLog(@"微信登录头像 = %@",dict[@"headimgurl"]);
    NSLog(@"微信登录POSTDIC = %@",postDic);
    
    [self displayOverFlowActivityView];
    [LoginService getThirdLoginWithParameters:postDic success:^(id object) {
        [self removeOverFlowActivityView];

        dispatch_async(dispatch_get_main_queue(), ^{
            [[AppDelegate currentAppDelegate] loginRongIMService];
        });
        
        if ([object intValue] == 0) {
            [self presentSheet:@"微信登录成功，请绑定手机号码"];
            [self performBlock:^{
                EditPhoneViewController *nextCtr = [[EditPhoneViewController alloc] init];
                nextCtr.editPhoneState = EditPhoneStateNormal;
                nextCtr.openUid = dict[@"openid"];
                [self.navigationController pushViewController:nextCtr animated:YES];
            } afterDelay:1.5];
        }
        else {
            [self presentSheet:@"登录成功"];
            [self performBlock:^{
                if (self.loginSueccssBlock) {
                    self.loginSueccssBlock();
                }
                [self backNavItemTapped];
            } afterDelay:1.5];
        }
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark 界面布局
- (UIButton *)loginNavButton {
    if (!_loginNavButton) {
        _loginNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginNavButton.frame = CGRectMake(self.buttonView.width/2, 0, self.buttonView.width/2, kCurrentWidth(28));
        [_loginNavButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginNavButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
        [_loginNavButton setTitleColor:kWhiteColor forState:UIControlStateSelected];
        [_loginNavButton setBackgroundImage:[UIImage createImageWithColor:kWhiteColor] forState:UIControlStateNormal];
        [_loginNavButton setBackgroundImage:[UIImage createImageWithColor:kLBRedColor] forState:UIControlStateSelected];
        _loginNavButton.titleLabel.font = kSystem(14);
        _loginNavButton.selected = YES;
        [_loginNavButton addTarget:self action:@selector(loginNavButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginNavButton;
}

- (UIButton *)registerNavButton {
    if (!_registerNavButton) {
        _registerNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerNavButton.frame = CGRectMake(0, 0, self.buttonView.width/2, kCurrentWidth(28));
        [_registerNavButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerNavButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
        [_registerNavButton setTitleColor:kWhiteColor forState:UIControlStateSelected];
        [_registerNavButton setBackgroundImage:[UIImage createImageWithColor:kWhiteColor] forState:UIControlStateNormal];
        [_registerNavButton setBackgroundImage:[UIImage createImageWithColor:kLBRedColor] forState:UIControlStateSelected];
        _registerNavButton.titleLabel.font = kSystem(14);
        [_registerNavButton addTarget:self action:@selector(registerNavButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerNavButton;
}

- (UIView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(145))/2, kCurrentWidth(25), kCurrentWidth(145), kCurrentWidth(28))];
        _buttonView.layer.cornerRadius = 3;
        _buttonView.layer.masksToBounds = YES;
        _buttonView.layer.borderColor = kLBRedColor.CGColor;
        _buttonView.layer.borderWidth = 1.5;
    }
    return _buttonView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kDeviceHeight-kNavBarHeight-kCurrentWidth(180), kDeviceWidth, kCurrentWidth(15))];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = kSystem(14);
        _tipLabel.text = @"用社交账号登录";
        _tipLabel.textColor = kLBNineColor;
        _tipLabel.hidden = ![WXApi isWXAppInstalled];
    }
    return _tipLabel;
}

- (UIButton *)wxButton {
    if (!_wxButton) {
        _wxButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _wxButton.frame = CGRectMake(kDeviceWidth/2-kCurrentWidth(90), kDeviceHeight-kNavBarHeight-kCurrentWidth(140), kCurrentWidth(50), kCurrentWidth(50));
        _wxButton.frame = CGRectMake(kDeviceWidth/2-kCurrentWidth(25), kDeviceHeight-kNavBarHeight-kCurrentWidth(140), kCurrentWidth(50), kCurrentWidth(50));
        [_wxButton setTitle:@"微信登录" forState:UIControlStateNormal];
        [_wxButton setTitleColor:kLBSixColor forState:UIControlStateNormal];
        [_wxButton setImage:[UIImage imageNamed:@"login_btn_weixin"] forState:UIControlStateNormal];
        _wxButton.titleLabel.font = kSystem(12);
        _wxButton.selected = YES;
        [_wxButton setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(33, 28) space:6];
        [_wxButton addTarget:self action:@selector(wxButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _wxButton.hidden = ![WXApi isWXAppInstalled];
    }
    return _wxButton;
}

- (UIButton *)wbButton {
    if (!_wbButton) {
        _wbButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _wbButton.frame = CGRectMake(kDeviceWidth/2+kCurrentWidth(40), kDeviceHeight-kNavBarHeight-kCurrentWidth(140), kCurrentWidth(50), kCurrentWidth(50));
        [_wbButton setTitle:@"微博登录" forState:UIControlStateNormal];
        [_wbButton setTitleColor:kLBSixColor forState:UIControlStateNormal];
        _wbButton.titleLabel.font = kSystem(12);
        [_wbButton setImage:[UIImage imageNamed:@"login_btn_weibo"] forState:UIControlStateNormal];
        [_wbButton setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(33, 28) space:6];
        [_wbButton addTarget:self action:@selector(wbButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wbButton;
}

- (LoginView *)loginView {
    if (!_loginView) {
        __weak typeof(self)weakSelf = self;
        _loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, self.buttonView.bottom, kDeviceWidth, kCurrentWidth(340))];
        _loginView.forgetPasswordBlock = ^{
            ForgetViewController *nextCtr = [[ForgetViewController alloc] init];
            [weakSelf.navigationController pushViewController:nextCtr animated:YES];
        };
        _loginView.loginBlock = ^{
            [weakSelf loginButtonClick];
        };
    }
    return _loginView;
}

- (RegisterView *)registerView {
    if (!_registerView) {
        __weak typeof(self)weakSelf = self;
        _registerView = [[RegisterView alloc] initWithFrame:CGRectMake(0, self.buttonView.bottom, kDeviceWidth, kCurrentWidth(340))];
        _registerView.hidden = YES;
        _registerView.registerBlock = ^{
            [weakSelf registerButtonClick];
        };
        _registerView.sendCodeBlock = ^{
            [weakSelf codeButtonClick];
        };
        _registerView.userProtocolBlock = ^{
            [weakSelf gotoUserProtocol];
        };
    }
    return _registerView;
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
        self.registerView.codeButton.enabled = NO;
        [self.registerView.codeButton setTitle:time forState:UIControlStateDisabled];
        
        if ([time isEqualToString:@"0S"]) {
            [self.codeTimer stop];
            self.registerView.codeButton.enabled = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
