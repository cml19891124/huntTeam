//
//  PostAnswerView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/3.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PostAnswerView.h"
#import "IQTextView.h"

@interface PostAnswerView ()<UITextViewDelegate>

@property (nonatomic,strong)UIView *contentView;

@property (nonatomic,strong)UILabel *typelabel;
@property (nonatomic,strong)UILabel *answerlabel;

@property (nonatomic,strong)UIButton *oneButton;
@property (nonatomic,strong)UIButton *freeButton;

@property (nonatomic,strong)IQTextView *xmView;

@end

@implementation PostAnswerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        
        self.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kCurrentWidth(70)-kCurrentWidth(49));
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(105))];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"EEF2F5"];
        [self addSubview:_contentView];
        
        _typelabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(120), kCurrentWidth(40))];
        _typelabel.text = @"回答类型";
        _typelabel.textColor = kLBSixColor;
        _typelabel.font = kSystem(13);
        [_contentView addSubview:_typelabel];
        
        _answerlabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(65), kCurrentWidth(120), kCurrentWidth(40))];
        _answerlabel.text = @"我的回答";
        _answerlabel.textColor = kLBSixColor;
        _answerlabel.font = kSystem(13);
        [_contentView addSubview:_answerlabel];
        
        self.oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.oneButton.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(40), (kDeviceWidth-kCurrentWidth(32))/2, kCurrentWidth(25));
        self.oneButton.backgroundColor = kWhiteColor;
        self.oneButton.titleLabel.font = kSystem(14);
        [self.oneButton setTitle:@"1猎帮币查看" forState:UIControlStateNormal];
        [self.oneButton setTitleColor:kLBNineColor forState:UIControlStateNormal];
        [self.oneButton setTitleColor:kLBRedColor forState:UIControlStateSelected];
        self.oneButton.layer.cornerRadius = kCurrentWidth(25)/2;
        self.oneButton.layer.borderColor = kLBRedColor.CGColor;
        self.oneButton.layer.borderWidth = 0.5;
        self.oneButton.layer.masksToBounds = YES;
        [self.oneButton addTarget:self action:@selector(oneTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        self.oneButton.selected = YES;
        [self addSubview:self.oneButton];
        
        self.freeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.freeButton.frame = CGRectMake(kDeviceWidth/2+kCurrentWidth(4), kCurrentWidth(40), (kDeviceWidth-kCurrentWidth(32))/2, kCurrentWidth(25));
        self.freeButton.backgroundColor = kWhiteColor;
        self.freeButton.titleLabel.font = kSystem(14);
        [self.freeButton setTitle:@"限时免费" forState:UIControlStateNormal];
        [self.freeButton setTitleColor:kLBNineColor forState:UIControlStateNormal];
        [self.freeButton setTitleColor:kLBRedColor forState:UIControlStateSelected];
        self.freeButton.layer.cornerRadius = kCurrentWidth(25)/2;
        self.freeButton.layer.borderColor = kSepparteLineColor.CGColor;
        self.freeButton.layer.borderWidth = 0.5;
        self.freeButton.layer.masksToBounds = YES;
        [self.freeButton addTarget:self action:@selector(freeTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.freeButton];
        
        self.xmView = [[IQTextView alloc] initWithFrame:CGRectMake(0, _contentView.bottom, kDeviceWidth,self.height-kCurrentWidth(105))];
        self.xmView.placeholder = @"请输入回答内容";
        self.xmView.placeholderTextColor = kLBNineColor;
        self.xmView.textColor = kLBBlackColor;
        self.xmView.font = kSystem(13);
        self.xmView.delegate = self;
        [self addSubview:self.xmView];
    }
    return self;
}

//- (void)setAnswerContent:(NSString *)answerContent {
//    _answerContent = answerContent;
//
////    self.xmView.text = answerContent;
//}

- (NSString *)answerContent {
    return self.xmView.text;
}

- (NSString *)price {
    if (self.freeButton.selected) {
        return @"0";
    }
    else {
        return @"1";
    }
}

- (void)setOrderUid:(NSString *)orderUid {
    if ([orderUid isEqualToString:[Config currentConfig].answerOrderUid]) {
        self.xmView.text = [Config currentConfig].answerContent;
    }
}

- (void)freeTypeClick:(UIButton *)sender {
    self.freeButton.selected = YES;
    self.oneButton.selected = NO;
    self.oneButton.layer.borderColor = kSepparteLineColor.CGColor;
    self.freeButton.layer.borderColor = kLBRedColor.CGColor;
}

- (void)oneTypeClick:(UIButton *)sender {
    self.freeButton.selected = NO;
    self.oneButton.selected = YES;
    self.oneButton.layer.borderColor = kLBRedColor.CGColor;
    self.freeButton.layer.borderColor = kSepparteLineColor.CGColor;
}

#pragma mark UITextViewDelegate


@end
