//
//  PersonnelHeadView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PersonnelHeadView.h"

@interface PersonnelHeadView ()<UITextFieldDelegate>

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UIButton *addButton;

@end

@implementation PersonnelHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(44));
        self.backgroundColor = kWhiteColor;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(120), kCurrentWidth(44))];
        self.titleLabel.textColor = kLBSixColor;
        self.titleLabel.font = kSystem(14);
        self.titleLabel.text = @"添加员工手机号";
        [self addSubview:self.titleLabel];
        
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(28), kCurrentWidth(14), kCurrentWidth(16), kCurrentWidth(16));
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"company_tianjia"] forState:UIControlStateNormal];
        [self.addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addButton];
        
        self.phoneTf = [[MESearchTextField alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(210), kCurrentWidth(11), kCurrentWidth(160), kCurrentWidth(22))];
        self.phoneTf.placeholder = @"请输入员工手机号";
        self.phoneTf.font = kSystemBold(14);
        self.phoneTf.textAlignment = NSTextAlignmentLeft;
        self.phoneTf.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneTf.layer.cornerRadius = kCurrentWidth(11);
        self.phoneTf.layer.masksToBounds = YES;
        self.phoneTf.layer.borderColor = kSepparteLineColor.CGColor;
        self.phoneTf.layer.borderWidth = 0.5;
        self.phoneTf.delegate = self;
        
        UIView *leftView = UIView.new;
        leftView.frame = CGRectMake(0, 0, 20, 30);
        self.phoneTf.leftView = leftView;
        [self addSubview:self.phoneTf];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(44)-0.5, kDeviceWidth, 0.5)];
//        lineView.backgroundColor = kSepparteLineColor;
//        [self addSubview:lineView];
    }
    return self;
}

- (void)addButtonClick {
    if (_addMessageBlock) {
        _addMessageBlock(IsStrEmpty(self.phoneTf.text)?nil:self.phoneTf.text);
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (_editMessageBlock) {
        _editMessageBlock(IsStrEmpty(textField.text)?nil:textField.text);
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
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


@end
