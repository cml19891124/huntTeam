//
//  ThemePriceViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ThemePriceViewController.h"

@interface ThemePriceViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *priceTf;
@property (nonatomic,strong)UITextField *offerPriceTf;
@property (nonatomic,strong)UILabel *messageLabel;

@end

@implementation ThemePriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"话题价格";
    self.view.backgroundColor = kBackgroundColor;
    
    [self setRightNaviBtnTitle:@"保存"];
    [self.rightNaviBtn addTarget:self action:@selector(saveThemePriceClick) forControlEvents:UIControlEventTouchUpInside];
    [self createSubViews];
}

#pragma mark Event
- (void)saveThemePriceClick {
 
    if (_priceTf.text.length == 0) {
        [self showAlertWithString:@"请输入话题价格"];
        return;
    }
    
    if (_offerPriceTf.text.length == 0) {
        [self showAlertWithString:@"请输入话题优惠价格"];
        return;
    }
    
    if ([_offerPriceTf.text doubleValue] > [_priceTf.text doubleValue]) {
        [self showAlertWithString:@"话题优惠价格不能大于话题价格"];
        return;
    }
    
    if (_themePriceBlock) {
        _themePriceBlock(_priceTf.text,_offerPriceTf.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSubViews {
    
    _priceTf = [[UITextField alloc] initWithFrame:CGRectMake(kCurrentWidth(13), kCurrentWidth(11), kDeviceWidth-kCurrentWidth(26), kCurrentWidth(40))];
    _priceTf.backgroundColor = kWhiteColor;
    _priceTf.placeholder = @"0.00";
    _priceTf.layer.cornerRadius = 2;
    _priceTf.layer.masksToBounds = YES;
    _priceTf.textAlignment = NSTextAlignmentRight;
    _priceTf.keyboardType = UIKeyboardTypeDecimalPad;
    _priceTf.font = kSystemBold(15);
    if (self.price.intValue) {
        _priceTf.text = [NSString stringWithFormat:@"%.2f",self.price.doubleValue];

    }
    _priceTf.delegate = self;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(110), kCurrentWidth(40))];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(10), 0, kCurrentWidth(100), kCurrentWidth(40))];
    titleLabel.text = @"话题价格";
    titleLabel.font = kSystem(15);
    [view addSubview:titleLabel];
    _priceTf.leftView = view;
    _priceTf.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(60), kCurrentWidth(40))];
    titleLabel1.text = @"  猎帮币";
    titleLabel1.font = kSystemBold(15);
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.textColor = kLBSixColor;
    titleLabel1.adjustsFontSizeToFitWidth = YES;
    _priceTf.rightView = titleLabel1;
    _priceTf.rightViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:_priceTf];
    
    _offerPriceTf = [[UITextField alloc] initWithFrame:CGRectMake(kCurrentWidth(13), _priceTf.bottom+kCurrentWidth(1), kDeviceWidth-kCurrentWidth(26), kCurrentWidth(40))];
    _offerPriceTf.backgroundColor = kWhiteColor;
    _offerPriceTf.placeholder = @"0.00";
    _offerPriceTf.layer.cornerRadius = 2;
    _offerPriceTf.layer.masksToBounds = YES;
    _offerPriceTf.textAlignment = NSTextAlignmentRight;
    _offerPriceTf.keyboardType = UIKeyboardTypeDecimalPad;
    _offerPriceTf.font = kSystemBold(15);
    _offerPriceTf.delegate = self;
    if (self.offPrice.intValue) {
        _offerPriceTf.text = [NSString stringWithFormat:@"%.2f",self.offPrice.doubleValue];

    }
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(110), kCurrentWidth(40))];
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(10), 0, kCurrentWidth(100), kCurrentWidth(40))];
    titleLabel2.text = @"话题优惠价格";
    titleLabel2.font = kSystem(15);
    [view1 addSubview:titleLabel2];
    _offerPriceTf.leftView = view1;
    _offerPriceTf.leftViewMode = UITextFieldViewModeAlways;
    
    UILabel *titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(60), kCurrentWidth(40))];
    titleLabel3.text = @"  猎帮币";
    titleLabel3.textAlignment = NSTextAlignmentCenter;
    titleLabel3.font = kSystemBold(15);
    titleLabel3.textColor = kLBSixColor;
    titleLabel3.adjustsFontSizeToFitWidth = YES;
    _offerPriceTf.rightView = titleLabel3;
    _offerPriceTf.rightViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:_offerPriceTf];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, _offerPriceTf.bottom, kDeviceWidth-kCurrentWidth(50), kCurrentWidth(33))];
    _messageLabel.text = @"填写优惠价格便于尽快破单";
    _messageLabel.textColor = kLBNineColor;
    _messageLabel.font = kSystem(13);
    [self.view addSubview:_messageLabel];
}


- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
//    if(textField == _timeTf) {
        NSScanner      *scanner    = [NSScanner scannerWithString:string];
        NSCharacterSet*numbers;
        NSRange        pointRange = [textField.text rangeOfString:@"."];
        if((pointRange.length>0) && (pointRange.location < range.location  || pointRange.location> range.location+ range.length))
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
        // 大于千万的时候不能再编辑
        if([tempStr longLongValue] >99999999.99) {
            tempStr = [tempStr substringToIndex:tempStr.length - 2];
            return NO;
        }
//    }
    
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

@end
