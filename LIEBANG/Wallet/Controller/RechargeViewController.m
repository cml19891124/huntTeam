//
//  RechargeViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/24.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "RechargeViewController.h"
#import "PayPickView.h"
#import "WalletService.h"
#import "PayTypePickView.h"

@interface RechargeViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)ConfimButton *nextButton;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UITextField *amounttf;

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResultNot:) name:@"ALI_ORDER_PAY_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResultWX:) name:@"WX_ORDER_PAY_NOTIFICATION" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ALI_ORDER_PAY_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WX_ORDER_PAY_NOTIFICATION" object:nil];
}

#pragma mark Event
- (void)nextButtonClick {
    
    [self.amounttf resignFirstResponder];
    if (IsStrEmpty(_amounttf.text) || IsNilOrNull(_amounttf.text)) {
        [self showAlertWithString:@"请输入充值金额"];
        return;
    }
    
    [PayPickView showTypePickViewWithAnimation:YES betPrice:[_amounttf.text floatValue] pickBlock:^(NSString *string) {
        
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        [postDic setValue:[NSString stringWithFormat:@"%.2f",[self.amounttf.text floatValue]] forKey:@"transactionamount"];
        [postDic setValue:string forKey:@"payStatus"];//0 支付宝  1：微信
        
        [self displayOverFlowActivityView];
        [WalletService getRechargeWithParameters:postDic success:^(PayModel *data) {
            [self removeOverFlowActivityView];
            
            if ([[postDic objectForKey:@"payStatus"] isEqualToString:@"0"]) {//支付宝
                
                NSString *appScheme = @"LIEBANGYIQI";
                [[AlipaySDK defaultService] payOrder:data.alipay_url fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    
                    if (resultDic && [resultDic objectForKey:@"resultStatus"] && ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000)) {
                        [self getOrderPayResult];
                    } else {
                        [self presentSheet:@"充值失败"];
                    }
                }];
            }
            else if ([[postDic objectForKey:@"payStatus"] isEqualToString:@"1"]) {//微信
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = data.partnerid;
                req.prepayId            = data.prepayid;
                req.nonceStr            = data.noncestr;
                req.timeStamp           = data.timestamp.intValue;
                req.package             = data.package;
                req.sign                = data.sign;
                [WXApi sendReq:req];
            }
            
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];

    }];
}

#pragma mark - 收到支付成功的消息后作相应的处理
- (void)getOrderPayResult {
    [self presentSheet:@"充值成功"];
    [self performBlock:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    } afterDelay:1.5];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //获取账户余额
    });
}

- (void)getOrderPayResultNot:(NSNotification *)notification {
    
    NSDictionary *resultDic = notification.object;
    if (resultDic && [resultDic objectForKey:@"resultStatus"] && ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000)) {
        [self getOrderPayResult];
    } else {
        [self presentSheet:@"充值失败"];
    }
    
}

- (void)getOrderPayResultWX:(NSNotification *)notification {
    
    if ([notification.object isEqualToString:@"success"]) {
        [self getOrderPayResult];
    } else {
        [self presentSheet:@"充值失败"];
    }
}

#pragma mark 界面调试
- (void)createSubViews {
    
    self.view.backgroundColor = kBackgroundColor;
    self.navigationItem.title = @"充值";
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(10), kDeviceWidth, kCurrentWidth(110))];
    _contentView.backgroundColor = kWhiteColor;
    [self.view addSubview:_contentView];
    
    _nextButton = [[ConfimButton alloc] initWithTop:_contentView.bottom+kCurrentWidth(44) title:@"下一步"];
    [_nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(10), kDeviceWidth-kCurrentWidth(24), kCurrentWidth(29))];
    _titleLabel.text = @"充值金额";
    _titleLabel.textColor = kLBBlackColor;
    [_contentView addSubview:_titleLabel];
    
    UILabel *markLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(24), kCurrentWidth(54))];
    markLabel.text = @"¥";
    markLabel.font = kSystemBold(24);
    markLabel.textColor = kLBBlackColor;
    
    _amounttf = [[UITextField alloc] initWithFrame:CGRectMake(kCurrentWidth(12), _titleLabel.bottom, kDeviceWidth-kCurrentWidth(24), kCurrentWidth(54))];
    _amounttf.font = kSystemBold(24);
    _amounttf.textColor = kLBBlackColor;
    _amounttf.placeholder = @"请输入充值金额";
    _amounttf.keyboardType = UIKeyboardTypeDecimalPad;
    _amounttf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _amounttf.leftView = markLabel;
    _amounttf.leftViewMode = UITextFieldViewModeAlways;
    _amounttf.delegate = self;
    [_contentView addSubview:_amounttf];
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if(textField == self.amounttf) {
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
