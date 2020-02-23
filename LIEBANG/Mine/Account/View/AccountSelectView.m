//
//  AccountSelectView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountSelectView.h"

static NSArray *titleArray;
static NSArray *imageArray;

@interface AccountSelectView ()

@property (nonatomic,strong)UIView *lineView;

@end

@implementation AccountSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setAccountState:(AccountState)accountState {
    _accountState = accountState;
    
    if (accountState == AccountStateOther)
    {
        titleArray = @[@"话题",@"问答",@"好友"];
        imageArray = @[@"btn_huati",@"btn_wenda",@"btn_haoyou"];
        
        [self createButtonWithArray];
    }
    else if (accountState == AccountStateNormal || accountState == AccountStateEdit)
    {
        titleArray = @[@"话题",@"问答",@"好友",@"订单"];
        imageArray = @[@"btn_huati",@"btn_wenda",@"btn_haoyou",@"btn_dingdan"];
        
        [self createButtonWithArray];
    }
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-3, self.width/titleArray.count, 2.0)];
    _lineView.backgroundColor = kLBRedColor;
    [self addSubview:_lineView];
}

- (void)createButtonWithArray {
    
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((self.width/titleArray.count)*i, 0, self.width/titleArray.count, self.height);
        [button setTitleColor:kLBBlackColor forState:UIControlStateNormal];
        [button setTitle:[titleArray safeObjectAtIndex:i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[imageArray safeObjectAtIndex:i]] forState:UIControlStateNormal];
        button.titleLabel.font = kSystem(13);
        button.tag = i;
        if (i == 0) {
            button.titleLabel.font = kSystemBold(13);
        }
        [button setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(20, 20) space:10];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)buttonClick:(UIButton *)sender {
    
    if (_selectViewButtonBlock) {
        _selectViewButtonBlock(sender.tag);
    }
}

@end
