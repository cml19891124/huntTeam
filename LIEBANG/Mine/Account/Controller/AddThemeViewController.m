//
//  AddThemeViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AddThemeViewController.h"
#import "ThemePriceViewController.h"
#import "ThemeTimeViewController.h"
#import "IQTextView.h"
#import "ClassService.h"
#import "ThemeClassModel.h"
#import "MineViewController.h"

#import "MessageViewController.h"

#import "CertiViewController.h"


static NSArray *titleArray;
static NSArray *heightArray;
static NSArray *typeArray;
static NSArray *timeArray;
@interface AddThemeViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UITextField *themeTf;
@property (nonatomic,strong)UIButton *priceButton;
@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,strong)UITextField *timeTf;
@property (nonatomic,strong)UIView *contentView;

@property (nonatomic,strong)IQTextView *serviceTv;
@property (nonatomic,strong)IQTextView *messageTv;
@property (nonatomic,strong)PriceLabel *priceLabel;

@property (strong, nonatomic) UIButton *selectBtn;

@end

@implementation AddThemeViewController

- (void)backNavItemTapped {
    if (self.navigationController.childViewControllers.count >= 2) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[AccountViewController class]]) {
                AccountViewController *messageVC =(AccountViewController *)controller;
                [self.navigationController popToViewController:messageVC animated:YES];
            }else if ([controller isKindOfClass:[MessageViewController class]]) {
                MessageViewController *messageVC =(MessageViewController *)controller;
                [self.navigationController popToViewController:messageVC animated:YES];
            }else if ([controller isKindOfClass:[CertiViewController class]]) {
                CertiViewController *messageVC =(CertiViewController *)controller;
                [self.navigationController popToViewController:messageVC animated:YES];
            }
        }
        
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackgroundColor;
    
    [self loadDataSource];
    [self createSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.themeModel.serviceType = @"0";//默认 选中 “线下约见”
    if (!IsNilOrNull(self.themeModel.id) && !IsStrEmpty(self.themeModel.id)) {
        UIButton *sender = [self.view viewWithTag:(10+[self.themeModel.serviceType intValue])];
        sender.selected = YES;
        sender.layer.borderColor = kLBRedColor.CGColor;
    }
}

- (void)loadDataSource {
    titleArray = @[@"话题名称",@"话题类型",@"话题时长"];//,@"话题价格",@"话题介绍",@"您想了解的学员信息（选填）"
    heightArray = @[[NSNumber numberWithFloat:kCurrentWidth(0)],
                    [NSNumber numberWithFloat:kCurrentWidth(35)],
                    [NSNumber numberWithFloat:kCurrentWidth(30)],
                    [NSNumber numberWithFloat:kCurrentWidth(30)],
                    [NSNumber numberWithFloat:kCurrentWidth(35)]];//,[NSNumber numberWithFloat:kCurrentWidth(137)]
    typeArray = @[@"线下约见",@"全国通话"];
    timeArray = @[@"1小时",@"1.5小时",@"2小时",@"自定义"];
}

#pragma mark 界面布局
- (void)createSubViews {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight)];
    _scrollView.contentSize = CGSizeMake(0, kCurrentWidth(550));//690
    [self.view addSubview:_scrollView];
    
    if (IsNilOrNull(self.themeModel)) {
        self.navigationItem.title = @"添加话题";
        [self setRightNaviBtnTitle:@"添加"];
        [self.rightNaviBtn addTarget:self action:@selector(postThemeRequest) forControlEvents:UIControlEventTouchUpInside];
        _scrollView.contentSize = CGSizeMake(0, kCurrentWidth(550));
        _themeModel = [[ThemeClassModel alloc] init];
    }
    else {
        self.navigationItem.title = @"编辑话题";
        [self setRightNaviBtnTitle:@"保存"];
        [self.rightNaviBtn addTarget:self action:@selector(saveThemeRequest) forControlEvents:UIControlEventTouchUpInside];
        _scrollView.contentSize = CGSizeMake(0, kCurrentWidth(550)+kCurrentWidth(60));
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(540), kDeviceWidth-kCurrentWidth(24), kCurrentWidth(40));
        [_cancelButton setTitle:@"删除" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _cancelButton.backgroundColor = kLBRedColor;
        _cancelButton.titleLabel.font = kSystem(15);
        _cancelButton.layer.cornerRadius = kCurrentWidth(20);
        _cancelButton.layer.masksToBounds = YES;
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:_cancelButton];
    }
    
    [self createThemeLabelWithArray];
    
    _themeTf = [[UITextField alloc] initWithFrame:CGRectMake(kCurrentWidth(13), kCurrentWidth(44), kDeviceWidth-kCurrentWidth(26), kCurrentWidth(35))];
    _themeTf.backgroundColor = kWhiteColor;
    _themeTf.textColor = kLBBlackColor;
    _themeTf.placeholder = @"请输入话题名称";
    _themeTf.layer.cornerRadius = 3;
    _themeTf.layer.masksToBounds = YES;
    _themeTf.delegate = self;
    [_themeTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _themeTf.text = self.themeModel.topicName;
    _themeTf.font = kSystem(15);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(14), kCurrentWidth(35))];
    _themeTf.leftView = view;
    _themeTf.leftViewMode = UITextFieldViewModeAlways;
    [_scrollView addSubview:_themeTf];
    
    _timeTf = [[UITextField alloc] initWithFrame:CGRectMake(kCurrentWidth(13), kCurrentWidth(234), kDeviceWidth-kCurrentWidth(26),kCurrentWidth(35))];
    _timeTf.backgroundColor = kWhiteColor;
    _timeTf.textColor = kLBBlackColor;
    _timeTf.placeholder = @"自定义话题时长";
    _timeTf.layer.cornerRadius = 3;
    _timeTf.layer.masksToBounds = YES;
    _timeTf.delegate = self;
    _timeTf.hidden = YES;
    _timeTf.keyboardType = UIKeyboardTypeDecimalPad;
    //    _timeTf.text = self.themeModel.serviceTime;
    _timeTf.font = kSystem(15);
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(14), kCurrentWidth(35))];
    _timeTf.leftView = view1;
    _timeTf.leftViewMode = UITextFieldViewModeAlways;
    [_scrollView addSubview:_timeTf];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(229), kDeviceWidth, kCurrentWidth(260))];
    _contentView.backgroundColor = kBackgroundColor;
    [_scrollView addSubview:_contentView];
    
    UILabel *themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), 0, kDeviceWidth-kCurrentWidth(26), kCurrentWidth(44))];
    themeLabel.text = @"话题价格";
    themeLabel.font = kSystem(15);
    [_contentView addSubview:themeLabel];
    
    UILabel *themeLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), kCurrentWidth(79), kDeviceWidth-kCurrentWidth(26), kCurrentWidth(44))];
    themeLabel1.text = @"话题介绍";
    themeLabel1.font = kSystem(15);
    [_contentView addSubview:themeLabel1];
    
    _priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _priceButton.frame = CGRectMake(kCurrentWidth(13), kCurrentWidth(44), kDeviceWidth-kCurrentWidth(26), kCurrentWidth(35));//kCurrentWidth(273)
    _priceButton.backgroundColor = kWhiteColor;
    _priceButton.layer.cornerRadius = 3;
    _priceButton.layer.masksToBounds = YES;
    [_priceButton addTarget:self action:@selector(gotoThemePriceCtrl) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_priceButton];

    _priceLabel = [[PriceLabel alloc] initWithFrame:CGRectMake(kCurrentWidth(15), 0, kCurrentWidth(200), kCurrentWidth(35))];
    _priceLabel.priceTextAlignment = NSTextAlignmentLeft;
    [_priceLabel setUsePrice:self.themeModel.topicPrice oldPrice:self.themeModel.originalPrice];
    [_priceButton addSubview:_priceLabel];
    
    self.serviceTv = [[IQTextView alloc] initWithFrame:CGRectMake(kCurrentWidth(13), kCurrentWidth(123), kDeviceWidth-kCurrentWidth(26), kCurrentWidth(137))];//kCurrentWidth(352)
    self.serviceTv.placeholder = @"请您介绍下大概将会从哪些维度和思路提纲阐述和表达该话题，便于学员用户更加了解和认知该话题。";
    self.serviceTv.placeholderTextColor = kLBNineColor;
    self.serviceTv.textColor = kLBBlackColor;
    self.serviceTv.font = kSystem(15);
    self.serviceTv.delegate = self;
    self.serviceTv.layer.cornerRadius = 3;
    self.serviceTv.layer.masksToBounds = YES;
    self.serviceTv.tag = 100;
    self.serviceTv.text = self.themeModel.serviceIn;
    [_contentView addSubview:self.serviceTv];

    [self createWithThemeTypeWithArray];
    [self createWithThemeTimeWithArray];
    
//    self.messageTv = [[IQTextView alloc] initWithFrame:CGRectMake(kCurrentWidth(13), kCurrentWidth(533), kDeviceWidth-kCurrentWidth(26), kCurrentWidth(137))];
////    self.messageTv.placeholder = @"请问学员：1.您有几年的工作经验？2.现在从事哪方面的工作？3.希望获得怎样的指导？4关于该话题，之前是否有相关的经验？";
//    self.messageTv.placeholderTextColor = kLBNineColor;
//    self.messageTv.textColor = kLBBlackColor;
//    self.messageTv.font = kSystem(15);
//    self.messageTv.delegate = self;
//    self.messageTv.layer.cornerRadius = 3;
//    self.messageTv.layer.masksToBounds = YES;
//    self.messageTv.tag = 200;
//    self.messageTv.text = self.themeModel.remarks;
//    [_scrollView addSubview:self.messageTv];
}

- (void)createWithThemeTypeWithArray {
    
    for (int i = 0; i < typeArray.count; i ++) {
        UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
        sender.frame = CGRectMake(kCurrentWidth(12)+((kDeviceWidth-kCurrentWidth(34))/2+kCurrentWidth(10))*i, kCurrentWidth(123), (kDeviceWidth-kCurrentWidth(34))/2, kCurrentWidth(30));
        sender.backgroundColor = kWhiteColor;
        sender.titleLabel.font = kSystemBold(14);
        [sender setTitle:[typeArray safeObjectAtIndex:i] forState:UIControlStateNormal];
        [sender setTitleColor:kLBNineColor forState:UIControlStateNormal];
        [sender setTitleColor:kLBRedColor forState:UIControlStateSelected];
        sender.layer.cornerRadius = kCurrentWidth(15);
        sender.layer.borderColor = kSepparteLineColor.CGColor;
        sender.layer.borderWidth = 0.5;
        sender.layer.masksToBounds = YES;
        if (i == 0) {
            sender.selected = YES;
            self.selectBtn = sender;
        }
        sender.tag = i+10;
        [sender addTarget:self action:@selector(senderTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:sender];
        
    }
}

- (void)createWithThemeTimeWithArray {
    CGFloat width = (kDeviceWidth-kCurrentWidth(296))/3;
    for (int i = 0; i < timeArray.count; i ++) {
        UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
        sender.frame = CGRectMake(kCurrentWidth(12)+(width+kCurrentWidth(68))*i, kCurrentWidth(199), kCurrentWidth(68), kCurrentWidth(29));
        sender.backgroundColor = kWhiteColor;
        sender.titleLabel.font = kSystem(14);
        [sender setTitle:[timeArray safeObjectAtIndex:i] forState:UIControlStateNormal];
        [sender setTitleColor:kLBBlackColor forState:UIControlStateNormal];
        [sender setTitleColor:kLBRedColor forState:UIControlStateSelected];
        sender.layer.cornerRadius = kCurrentWidth(29)/2;
        sender.layer.borderColor = kSepparteLineColor.CGColor;
        sender.layer.borderWidth = 0.5;
        sender.layer.masksToBounds = YES;
        sender.tag = i+20;
        [sender addTarget:self action:@selector(senderTimeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:sender];
        
        if ([self.themeModel.serviceTime intValue] == 0) {
            
        }
        else if ([self.themeModel.serviceTime floatValue] == 1.f) {
            if (i == 0) {
                sender.selected = YES;
                sender.layer.borderColor = kLBRedColor.CGColor;
            }
        }
        else if ([self.themeModel.serviceTime floatValue] == 1.5f) {
            if (i == 1) {
                sender.selected = YES;
                sender.layer.borderColor = kLBRedColor.CGColor;
            }
        }
        else if ([self.themeModel.serviceTime floatValue] == 2.f) {
            if (i == 2) {
                sender.selected = YES;
                sender.layer.borderColor = kLBRedColor.CGColor;
            }
        }
        else {
            if (i == 3) {
                sender.selected = YES;
                sender.layer.borderColor = kLBRedColor.CGColor;
//                [sender setTitle:[NSString stringWithFormat:@"%@小时",self.themeModel.serviceTime] forState:UIControlStateNormal];
                _contentView.top = kCurrentWidth(269);
                _timeTf.hidden = NO;
                _timeTf.text = self.themeModel.serviceTime;
            }
        }
    }
}

//title
- (void)createThemeLabelWithArray {
    
    CGFloat totalPrice = 0.0;
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), totalPrice, kDeviceWidth-kCurrentWidth(26), kCurrentWidth(44))];
        themeLabel.text = [titleArray safeObjectAtIndex:i];
        themeLabel.font = kSystem(15);
        [_scrollView addSubview:themeLabel];
        totalPrice += ([[heightArray safeObjectAtIndex:i+1] floatValue]+kCurrentWidth(44));
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    if (self.themeTf == textField) {
        self.themeModel.topicName = textField.text;
    }
    else if (self.timeTf == textField) {
        self.themeModel.serviceTime = textField.text;
    }
    return YES;
}

#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //如果是删除减少字数，都返回允许修改
    if ([text isEqualToString:@""]) {
        return YES;
    }
//    if ([text isEqualToString:@" "]) {
//        return NO;
//    }
    if (range.location >= 2000)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if(textField == _timeTf) {
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
//
//
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//
//
//    if ([string isEqualToString:@" "]) {
//        return NO;
//    }
////    if ((textField.text.length+string.length) > 20 && ![string isEqualToString:@""]) { //添加这半行代码
////        return NO;
////    }
//    return YES;
//}

- (void)textFieldDidChange:(UITextField *)textField
{
    int max_name = 20;
    
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

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 2000) {
        return;
    }
    if (textView.tag == 100)
    {
        self.themeModel.serviceIn = textView.text;
    }
    else if (textView.tag == 200)
    {
        self.themeModel.remarks = textView.text;
    }
}

#pragma mark Event
- (void)cancelButtonClick {
    
    UIAlertController *alert = [CHAlertView showMessageWith:@"确定" title:@"确定删除该话题？" confim:^{
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        [postDic setValue:self.themeModel.id forKey:@"id"];
        
        [self displayOverFlowActivityView];
        [ClassService getDeleteThemeWithParameters:postDic success:^(NSString *info) {
            [self removeOverFlowActivityView];
//            [self presentSheet:info];
//            [self performBlock:^{
                NSInteger vcIndex = [self.navigationController.viewControllers indexOfObject:self];
                if (vcIndex >= 2) {
                    UIViewController *vc = self.navigationController.viewControllers[vcIndex-2];
                    [self.navigationController popToViewController:vc animated:YES];
                }
                else {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
//            } afterDelay:1.5];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)senderTypeClick:(UIButton *)sender {
    for (int i = 0; i < 2; i++) {
        UIButton *button = [self.view viewWithTag:10+i];
        button.selected = NO;
        button.layer.borderColor = kSepparteLineColor.CGColor;
    }
    sender.selected = YES;
    sender.layer.borderColor = kLBRedColor.CGColor;
    self.themeModel.serviceType = [NSString stringWithFormat:@"%zd",sender.tag-10];
}

- (void)senderTimeClick:(UIButton *)sender {
    for (int i = 0; i < 4; i++) {
        UIButton *button = [self.view viewWithTag:20+i];
        button.selected = NO;
        button.layer.borderColor = kSepparteLineColor.CGColor;
    }
    sender.layer.borderColor = kLBRedColor.CGColor;
    sender.selected = YES;
    
    switch (sender.tag) {
        case 20:
        {
            _contentView.top = kCurrentWidth(229);
            _timeTf.hidden = YES;
            self.themeModel.serviceTime = @"1";
        }
            break;
        case 21:
        {
            _contentView.top = kCurrentWidth(229);
            _timeTf.hidden = YES;
            self.themeModel.serviceTime = @"1.5";
        }
            break;
        case 22:
        {
            _contentView.top = kCurrentWidth(229);
            _timeTf.hidden = YES;
            self.themeModel.serviceTime = @"2";
        }
            break;
        case 23:
        {
            _contentView.top = kCurrentWidth(269);
            _timeTf.hidden = NO;
            self.themeModel.serviceTime = nil;
//            WeakSelf;
//            ThemeTimeViewController *nextCtr = [[ThemeTimeViewController alloc] init];
//            nextCtr.time = self.themeModel.serviceTime;
//            nextCtr.saveButtonBlock = ^(NSString *time) {
//                weakSelf.themeModel.serviceTime = time;
//                UIButton *btn = [self.view viewWithTag:23];
//                [btn setTitle:[NSString stringWithFormat:@"%@小时",time] forState:UIControlStateNormal];
//            };
//            [weakSelf.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)postThemeRequest {
    
    [_themeTf resignFirstResponder];
    [_messageTv resignFirstResponder];
    [_serviceTv resignFirstResponder];
    
    if (IsStrEmpty(self.themeModel.topicName)) {
        [self presentSheet:@"请输入话题名称"];
        return;
    }
    
    if (IsStrEmpty(self.themeModel.serviceType)) {
        [self presentSheet:@"请选择话题类型"];
        return;
    }
    
    if (IsStrEmpty(self.themeModel.serviceTime)) {
        [self presentSheet:@"请选择话题时长"];
        return;
    }
    
    if (IsStrEmpty(self.themeModel.serviceIn)) {
        [self presentSheet:@"请输入服务介绍"];
        return;
    }
    
    if ([InsureValidate deleteWhiteSpaceInStr:self.themeModel.serviceIn].length <= 0) {
        [self showAlertWithString:@"请输入的有效服务介绍"];
        return;
    }
    
    if ([self.themeModel.topicPrice doubleValue] == 0.f && [self.themeModel.originalPrice doubleValue] == 0.f) {
        [self presentSheet:@"请输入服务价格"];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.themeModel.topicName forKey:@"topicName"];
    [postDic setValue:self.themeModel.serviceType.intValue > 0?@(1):@(0) forKey:@"serviceType"];//0:线下约见 1：全国通话
    [postDic setValue:self.themeModel.serviceTime forKey:@"serviceTime"];
    [postDic setValue:@([self.themeModel.topicPrice doubleValue]) forKey:@"topicPrice"];//话题价格
    [postDic setValue:self.themeModel.serviceIn forKey:@"serviceIn"];//服务介绍
    [postDic setValue:self.themeModel.remarks forKey:@"remarks"];//其他信息
    [postDic setValue:@([self.themeModel.originalPrice doubleValue]) forKey:@"originalPrice"];//原价
    
    NSLog(@"添加话题postDic = %@",postDic);
    
    [self displayOverFlowActivityView];
    [ClassService getAddThemeWithParameters:postDic success:^(NSString *info) {
        [self removeOverFlowActivityView];
//        [self presentSheet:info];
//        [self performBlock:^{
            [self backNavItemTapped];
//        } afterDelay:1.5f];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)saveThemeRequest {
    [_themeTf resignFirstResponder];
    [_messageTv resignFirstResponder];
    [_serviceTv resignFirstResponder];
    
    if (IsStrEmpty(self.themeModel.topicName)) {
        [self presentSheet:@"请输入话题名称"];
        return;
    }
    
    if (IsStrEmpty(self.themeModel.serviceType)) {
        [self presentSheet:@"请选择话题类型"];
        return;
    }
    
    if (IsStrEmpty(self.themeModel.serviceTime)) {
        [self presentSheet:@"请选择话题时长"];
        return;
    }
    
    if (IsStrEmpty(self.themeModel.serviceIn)) {
        [self presentSheet:@"请输入服务介绍"];
        return;
    }
    
    if ([self.themeModel.topicPrice doubleValue] == 0.f && [self.themeModel.originalPrice doubleValue] == 0.f) {
        [self presentSheet:@"请输入服务价格"];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.themeModel.topicName forKey:@"topicName"];
    [postDic setValue:self.themeModel.serviceType.intValue > 0?@(1):@(0) forKey:@"serviceType"];//0:线下约见 1：全国通话
    [postDic setValue:self.themeModel.serviceTime forKey:@"serviceTime"];
    [postDic setValue:@([self.themeModel.topicPrice doubleValue]) forKey:@"topicPrice"];//话题价格
    [postDic setValue:self.themeModel.serviceIn forKey:@"serviceIn"];//服务介绍
    [postDic setValue:self.themeModel.remarks forKey:@"remarks"];//其他信息
    [postDic setValue:@([self.themeModel.originalPrice doubleValue]) forKey:@"originalPrice"];//原价
    [postDic setValue:self.themeModel.id forKey:@"id"];//其他信息
    
    NSLog(@"编辑话题postDic = %@",postDic);
    
    [self displayOverFlowActivityView];
    [ClassService getEditThemeWithParameters:postDic success:^(NSString *info) {
        [self removeOverFlowActivityView];
        
//        [self presentSheet:info];
//        [self performBlock:^{
            [self backNavItemTapped];
//        } afterDelay:1.5f];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)gotoThemePriceCtrl {
    ThemePriceViewController *nextCtr = [[ThemePriceViewController alloc] init];
    nextCtr.price = self.themeModel.originalPrice;
    nextCtr.offPrice = self.themeModel.topicPrice;
    nextCtr.themePriceBlock = ^(NSString *price, NSString *offPrice) {
        NSLog(@"原价 = %@ 优惠价 = %@",price,offPrice);
        [self.priceLabel setUsePrice:offPrice oldPrice:price];
        self.themeModel.originalPrice = price;
        self.themeModel.topicPrice = offPrice;
    };
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
