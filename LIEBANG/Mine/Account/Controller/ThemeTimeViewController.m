//
//  ThemeTimeViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/30.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ThemeTimeViewController.h"

@interface ThemeTimeViewController ()

@property (nonatomic,strong)UITextField *codeTextField;

@end

@implementation ThemeTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"自定义话题时间";
    self.view.backgroundColor = kBackgroundColor;
    
    [self setRightNaviBtnTitle:@"保存"];
    [self.rightNaviBtn addTarget:self action:@selector(saveThemeTimeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self createSubViews];
}

- (void)saveThemeTimeClick {
    
    if (IsStrEmpty(_codeTextField.text) || IsNilOrNull(_codeTextField.text)) {
        [self showAlertWithString:@"请输入时长"];
        return;
    }
    
    if (_saveButtonBlock) {
        _saveButtonBlock(_codeTextField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UI
- (void)createSubViews {
    
    UIView *left1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(12), kCurrentWidth(44))];
    left1.backgroundColor = kWhiteColor;
    
    _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, kCurrentWidth(10), kDeviceWidth, kCurrentWidth(44))];
    _codeTextField.font = kSystem(15);
    _codeTextField.placeholder = @"时长(以每小时为单位)";
    _codeTextField.textColor = kLBBlackColor;
    _codeTextField.backgroundColor = kWhiteColor;
    _codeTextField.leftView = left1;
    _codeTextField.leftViewMode = UITextFieldViewModeAlways;
    _codeTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:_codeTextField];
    
    if ([self.time isEqualToString:@"自定义"] || IsStrEmpty(self.time) || IsNilOrNull(self.time)) {
        _codeTextField.text = nil;
    }
    else {
        _codeTextField.text = self.time;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
