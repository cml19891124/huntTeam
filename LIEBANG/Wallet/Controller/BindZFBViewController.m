//
//  BindZFBViewController.m
//  Starwood
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 pony. All rights reserved.
//

#import "BindZFBViewController.h"
#import "WalletService.h"
//#import "UILabel+MoneyAnimation.h"

@interface BindZFBViewController ()
{
    NSString *_money;
}
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *remarkTF;
@property (weak, nonatomic) IBOutlet UIButton *sureBTN;

@end

@implementation BindZFBViewController

- (void)ExtractWithMoney:(NSString*)money {
    _money = money;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.title = @"支付宝提现";
    
    self.sureBTN.layer.cornerRadius = 3;
    self.sureBTN.layer.masksToBounds = YES;
    self.nameLab.text = [NSString stringWithFormat:@"%.2f",[_money floatValue]];
}

- (IBAction)sureTap:(id)sender {
    if (_accountTF.text.length==0) {
        [self showAlertWithString:@"请输入收款方支付宝账号"];
        return;
    }
//    if (_nameTF.text.length==0) {
//        [self showAlertWithString:@"请输入收款方真实姓名"];
//        return;
//    }
    // 提现
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:[NSNumber numberWithFloat:[_money floatValue]] forKey:@"transactionamount"];//提现金额
    [postDic setValue:@"0" forKey:@"payStatus"];//0 支付宝  1：微信
    [postDic setValue:_accountTF.text forKey:@"payeeAccount"];//支付宝账号
    [postDic setValue:_nameTF.text forKey:@"realName"];//真实姓名
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
