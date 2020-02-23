//
//  ViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/31.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "RechargeProtrolViewController.h"
#import "IQTextView.h"

static NSString *const kLBBProtrolData = @"1.我的钱包界面显示有余额和猎帮币？\n\n余额：是人民币为单位的账户余额。\n猎帮币余额：是用户在以iOS（苹果）为系统的设备上使用猎帮应用时，可以充值和使用的代币。\n\n2.猎帮币是什么？\n\n猎帮币是用户在以iOS（苹果）为系统的设备上使用猎帮APP应用时，可以通过iOS IAP的应用内支付功能充值并在猎帮应用内使用的代币。因Apple苹果政策原因，必须通过IAP（应用内购买）充值和使用的虚拟代币。参见App Store审核指南：https://developer.apple.com/cn/app-store/review/guidelines/#in-app-purchase用户只能在以iOS（苹果）为系统设备上使用猎帮应用的特定支付功能，仅支持充值和使用猎帮币。\n以Android（安卓）为系统的设备上，猎帮币不可使用，不可充值、退款、提现、转赠，猎帮币余额不会过期。\n\n3.充值与使用猎帮币？\n\n猎帮币只能在以iOS（苹果）为系统的设备上充值和使用，使用猎帮币可以购买猎帮应用内的话题、10元问答、1元查看、企业AI智能名片等。\n如果没有猎帮币或猎帮币余额不足，可以通过IAP（应用内购买）进行猎帮币充值。充值成功后的猎帮币，不可提现、退款、转赠，猎帮币余额不会过期，会与充值时登录的猎帮帐号相关联。\n目前iOS（苹果）系统猎帮币与Android（安卓）系统猎帮币独立存在。请确认是否从Android（安卓）系统换到了iOS（苹果）系统使用猎帮币。\n请使用原iOS（苹果）为系统的设备上登录，即可正常使用猎帮币支付。\n以Android（安卓）为系统的设备上，猎帮币不可使用，不可充值、提现、退款、转赠，猎帮币余额不会过期。\n\n4.充值与使用余额？\n\n余额只能在以Android（安卓）为系统的设备上使用，使用余额可以购买话题、10元问答、1元查看、企业AI智能名片等。\n如果余额不足，可通过支付宝或微信支付充值。充值的金额，可提现，会与充值时登录的猎帮帐号相关联。也可以不充值，直接使用支付宝或微信支付。\n目前iOS（苹果）系统余额与Android（安卓）系统余额独立存在。请确认是否从iOS（苹果）系统换到了Android（安卓）系统使用余额。\n请使用原Android（安卓）为系统的设备上登录，即可正常使用余额支付。\n以iOS（苹果）为系统的设备上，余额不可充值、不可使用，但余额可提现。\n\n5.为什么iOS（苹果）系统中必须使用猎帮币充值？\n\n猎帮应用内的付费内容，均为自由定价型虚拟商品。因Apple苹果公司政策原因，必须使用IAP（应用内购买）充值的猎帮币代币支付。\n以Android（安卓）为系统的客户端上使用猎帮应用时，就可以直接使用余额、支付宝、微信支付。但猎帮币不可使用，不可充值、提现、退款、转赠，猎帮币余额不会过期。\n\n6.为什么猎帮币不能在Android（安卓）系统中使用？\n\n因Apple苹果政策原因，通过IAP（应用内购买）充值的猎帮币只能在iOS（苹果）设备上充值使用，无法同步到Android（安卓）等其他系统中使用。\n但是充值后购买的虚拟商品会进入您的已购，购买内容切换手机客户端查看不受影响。\n\n7.为什么余额不能在iOS（苹果）系统中使用？\n\n因Apple苹果政策原因，通过IAP（应用内购买）充值的猎帮币只能在iOS（苹果）设备上充值使用，目前iOS（苹果）系统余额与Android（安卓）系统余额独立存在，无法同步到iOS（苹果）系统中使用，但余额可以提现。\n充值后购买的虚拟商品会进入您的已购，购买内容切换手机客户端查看不受影响。\n\n8.温馨提示：\n\n因Apple政策原因，充值仅限iOS系统应用内使用；\n猎帮应用内，1猎帮币的价值相当于1人民币。\n猎帮币可用于直接购买猎帮应用内所有虚拟商品；\n预约话题、在线问答、行家未在时效内确认相关服务，系统自动退回至猎帮币账户，不能退款；\n猎帮币为虚拟货币，仅限iOS系统消费，不支持跨系统使用，充值成功后不会过期，不能退款、提现或转赠他人；\n虚拟商品原则不予退款，参见使用帮助和猎帮用户协议。\n\n如果遇到问题或对以上条款有任何疑问，工作日可拨打客服电话13510019677寻求咨询和帮助。";


@interface RechargeProtrolViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)IQTextView *xmView;

@end

@implementation RechargeProtrolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    self.navigationItem.title = @"充值说明";
    
    self.xmView = [[IQTextView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight)];
    self.xmView.textColor = kLBThreeColor;
    self.xmView.font = kSystem(14);
    self.xmView.text = kLBBProtrolData;
    self.xmView.editable = NO;
    //禁止上下拉弹簧
//    self.xmView.bounces = NO;
//    self.xmView.bouncesZoom = NO;
    [self.view addSubview:self.xmView];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGPoint offset = scrollView.contentOffset;
//    if (offset.y <= 0) {
//        offset.y = 0;
//    }
//    scrollView.contentOffset = offset;
//}
@end
