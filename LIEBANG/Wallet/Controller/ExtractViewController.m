//
//  ExtractViewController.m
//  Starwood
//
//  Created by 一七 on 2018/7/17.
//  Copyright © 2018年 pony. All rights reserved.
//

#import "ExtractViewController.h"
#import "BindZFBViewController.h"
#import "EditPhoneViewController.h"
#import "WalletService.h"
#import "PayTypePickView.h"

@interface ExtractViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UILabel *moneylab;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIView *payTypeButton;

@property (nonatomic,strong)NSString *payType;
@property (weak, nonatomic) IBOutlet UIImageView *payImageView;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;

@end

@implementation ExtractViewController

//全部提现
- (IBAction)extractAction:(id)sender {
    self.inputTF.text = _yuer;
}

//立即提现
- (IBAction)payNow:(id)sender {

    if (self.inputTF.text.length ==0) {
        [self showAlertWithString:@"请输入提现金额！"];
        return;
    }
    if (IsStrEmpty(self.inputTF.text) || [self.inputTF.text doubleValue] == 0) {
        [self showAlertWithString:@"请输入合法的提现金额！"];
        return;
    }
    NSString *input = self.inputTF.text;
    if ( [input doubleValue] > [_yuer doubleValue]) {
        [self showAlertWithString:@"提现金额必须小于等于余额！"];
        return;
    }
    if ([self.payType intValue] == 1) {
        // 微信提现直接进行提现 ---- 返回status=1 ，则没有绑定微信，跳到微信拿到userOpenid，重新开始自动提现 status=2绑定成功
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        [postDic setValue:@"" forKey:@"userOpenid"];
        [postDic setValue:[NSNumber numberWithFloat:[self.inputTF.text floatValue]] forKey:@"transactionamount"];//提现金额
        [postDic setValue:@"1" forKey:@"payStatus"];//0 支付宝  1：微信
        
        [self displayOverFlowActivityView];
        [WalletService getWithDrawWithParameters:postDic success:^(id data) {
            [self removeOverFlowActivityView];
            
            if ([data intValue] == 1)
            {
                [self removeOverFlowActivityView];
                [self presentSheet:@"需绑定微信后才可已使用微信提现功能"];
                [self performBlock:^{
                    if ([WXApi isWXAppInstalled]) {
                        SendAuthReq *req = [[SendAuthReq alloc] init];
                        req.scope = @"snsapi_userinfo";
                        req.state = @"com.yiqi.LIEBANG";
                        [WXApi sendReq:req];
                    }
                    else {
                        [self showAlertWithString:@"未安装微信"];
                    }
                } afterDelay:1.5];
            }
            else// if ([data intValue] == 2)
            {
                [self presentSheet:@"提现成功,请等待审核"];
                [self performBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } afterDelay:1.5];
            }
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }
    else if ([self.payType intValue] == 0) {
        //安全验证--支付宝提现--跳转至手机验证界面
        EditPhoneViewController *nextCtr = [[EditPhoneViewController alloc] init];
        nextCtr.yuer = self.inputTF.text;
        nextCtr.editPhoneState = EditPhoneStateModifyAli;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}


- (IBAction)payTypeEvent:(UITapGestureRecognizer *)sender {
    [PayTypePickView showTypePickViewWithAnimation:YES isRecharge:NO payType:self.payType pickBlock:^(NSString *string) {
        self.payType = string;
        if ([string intValue] == 0)
        {
            _payLabel.text = @"支付宝";
            _payImageView.image = [UIImage imageNamed:@"list_icon_zhifubao"];
        }
        else
        {
            _payLabel.text = @"微信";
            _payImageView.image = [UIImage imageNamed:@"list_icon_weixinzhifu"];
        }
    }];
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
    [postDic setValue:dict[@"openid"] forKey:@"userOpenid"];
    [postDic setValue:[NSNumber numberWithFloat:[self.inputTF.text floatValue]] forKey:@"transactionamount"];//提现金额
    [postDic setValue:@"1" forKey:@"payStatus"];//0 支付宝  1：微信
    NSLog(@"微信提现POSTDIC = %@",postDic);
    
    [self displayOverFlowActivityView];
    [WalletService getWithDrawWithParameters:postDic success:^(id data) {
        [self removeOverFlowActivityView];
        [self presentSheet:@"提现成功,请等待审核"];
        [self performBlock:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        } afterDelay:1.5];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现";
    
    self.inputTF.delegate = self;
    self.payType = @"0";
    self.payTypeButton.userInteractionEnabled = YES;
    self.moneylab.text = [NSString stringWithFormat:@"可用余额%.2f元",[self.yuer floatValue]];
    self.sureButton.layer.cornerRadius = 3;
    self.sureButton.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXLogin:) name:@"WX_ACCOUNT_LOGIN_RETURN" object:nil];
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if(textField == self.inputTF) {
        NSScanner      *scanner    = [NSScanner scannerWithString:string];
        NSCharacterSet*numbers;
        NSRange        pointRange = [textField.text rangeOfString:@"."];
        if((pointRange.length>0) && (pointRange.location< range.location  || pointRange.location> range.location+ range.length))
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        }
        else
        {
            numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        }
        
        if([textField.text isEqualToString:@""] && [string isEqualToString:@"."] ) {
            return NO;
        }
        short remain =2;//默认保留2位小数
        NSString*tempStr = [textField.text stringByAppendingString:string];  // 原来的字符+当前输入的字符
        
        NSUInteger strlen = [tempStr length];
        if(pointRange.length>0&& pointRange.location>0) {//判断输入框内是否含有“.”。
            if([string isEqualToString:@"."]) { //当输入框内已经含有“.”时，如果再输入“.”则被视为无效。
                return NO;
            }
            
            if(strlen >0&& (strlen - pointRange.location) > remain+1) {//当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                return NO;
            }
        }
        NSRange zeroRange = [textField.text rangeOfString:@"0"];
        if(zeroRange.length==1&& zeroRange.location==0){//判断输入框第一个字符是否为“0”
            
            if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] ==1){//当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                textField.text= string;
                return NO;
            }else{
                if(pointRange.length==0&& pointRange.location>0){//当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                    if([string isEqualToString:@"0"]){
                        return NO;
                    }
                }
            }
        }
        NSString*buffer;
        if( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] !=0) )
        {
            return NO;
        }
        // 大于10亿的时候不能再编辑
        if([tempStr longLongValue] >=1000000000) {
            return NO;
        }
    }
    
    if ([string isEqualToString:@"."]) {
        if (range.location + 2 < textField.text.length) {
            NSMutableString *notFormatString = [[NSMutableString alloc] initWithString:[textField.text substringWithRange:NSMakeRange(0, range.location + 2)]];
            [notFormatString insertString:@"." atIndex:range.location];
            textField.text = notFormatString;
            return false;
        }
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
