//
//  OrderDetailButton.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/24.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "OrderDetailButton.h"

@interface OrderDetailButton ()

@property (nonatomic,strong)UIButton *orderButton;

@property (nonatomic,strong)UIButton *confimButton;
@property (nonatomic,strong)UIButton *messageButton;

@end

@implementation OrderDetailButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.orderButton];
        [self addSubview:self.confimButton];
        [self addSubview:self.messageButton];
    }
    return self;
}

- (void)setDetailModel:(ThemeOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
    self.buttonState = OrderDetailButtonStateNOButton;
    
    if ([detailModel.orderStates intValue] == 0)
    {
        
    }
    else if ([detailModel.orderStates intValue] == 1)
    {
        NSString *string = [InsureValidate timestamp:detailModel.endTime];
        if ([string containsString:@"-"])
        {
            if (self.detailType == QuestionDetailTypeExpert)
            {
                self.buttonState = OrderDetailButtonStateNOButton;
            }
            else
            {
                self.buttonState = OrderDetailButtonStateNOButton;
            }
        }
        else
        {
            if (self.detailType == QuestionDetailTypeExpert)
            {
                self.buttonState = OrderDetailButtonStateNormal;
            }
            else
            {
                self.buttonState = OrderDetailButtonStateRemind;
            }
        }
    }
    else if ([detailModel.orderStates intValue] == 2)
    {
//        self.buttonState = OrderDetailButtonStateSureCompleted;//OrderDetailButtonStatePostComment
    }
    else if ([detailModel.orderStates intValue] == 3)
    {
        self.buttonState = OrderDetailButtonStateNOButton;
    }
    else if ([detailModel.orderStates intValue] == 4)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            self.buttonState = OrderDetailButtonStateAccount;
        }
        else
        {
            self.buttonState = OrderDetailButtonStatePostComment;
        }
    }
    else if ([detailModel.orderStates intValue] == 5)
    {
        self.buttonState = OrderDetailButtonStateNOButton;
    }
    else if ([detailModel.orderStates intValue] == 6)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            self.buttonState = OrderDetailButtonStateNOButton;
        }
        else
        {
            self.buttonState = OrderDetailButtonStateDisabled;
        }
    }
    else if ([detailModel.orderStates intValue] == 7)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            self.buttonState = OrderDetailButtonStateNOButton;
        }
        else
        {
            self.buttonState = OrderDetailButtonStateDisabled;
        }
    }
    else if ([detailModel.orderStates intValue] == 8)
    {
        self.buttonState = OrderDetailButtonStateNOButton;
    }
    else if ([detailModel.orderStates intValue] == 9)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            self.buttonState = OrderDetailButtonStateNormal;
        }
        else
        {
            self.buttonState = OrderDetailButtonStateNormal;
        }
    }
    else if ([detailModel.orderStates intValue] == 10)
    {
        self.buttonState = OrderDetailButtonStateServiceCompleted;
    }
    else if ([detailModel.orderStates intValue] == 11)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            self.buttonState = OrderDetailButtonStateAccount;
        }
        else
        {
            self.buttonState = OrderDetailButtonStateSureCompleted;
        }
    }
}

- (void)setButtonState:(OrderDetailButtonState)buttonState {
    _buttonState = buttonState;
    
    switch (buttonState) {
        case OrderDetailButtonStateNormal:
        {
            self.orderButton.hidden = YES;
            self.messageButton.hidden = NO;
            self.confimButton.hidden = NO;
        }
            break;
        case OrderDetailButtonStateDisabled:
        {
            self.confimButton.hidden = YES;
            self.messageButton.hidden = YES;
            self.orderButton.hidden = NO;
            [_orderButton setTitle:@"预约其他行家" forState:UIControlStateNormal];
        }
            break;
        case OrderDetailButtonStateServiceCompleted:
        {
            self.orderButton.hidden = YES;
            self.confimButton.hidden = NO;
            self.messageButton.hidden = NO;
            [self.confimButton setTitle:@"服务完成" forState:UIControlStateNormal];
        }
            break;
        case OrderDetailButtonStateSureCompleted:
        {
            self.confimButton.hidden = YES;
            self.messageButton.hidden = YES;
            self.orderButton.hidden = NO;
            [self.orderButton setTitle:@"确认完成" forState:UIControlStateNormal];
        }
            break;
        case OrderDetailButtonStatePostComment:
        {
            self.confimButton.hidden = YES;
            self.messageButton.hidden = YES;
            self.orderButton.hidden = NO;
            [self.orderButton setTitle:@"提交评论" forState:UIControlStateNormal];
        }
            break;
        case OrderDetailButtonStateRemind:
        {
            self.confimButton.hidden = YES;
            self.messageButton.hidden = YES;
            self.orderButton.hidden = NO;
            [self.orderButton setTitle:@"提醒行家确认" forState:UIControlStateNormal];
        }
            break;
        case OrderDetailButtonStateNOButton:
        {
            self.confimButton.hidden = YES;
            self.messageButton.hidden = YES;
            self.orderButton.hidden = YES;
        }
            break;
        case OrderDetailButtonStateAccount:
        {
            self.orderButton.hidden = YES;
            self.confimButton.hidden = NO;
            self.messageButton.hidden = NO;
            [self.confimButton setTitle:@"去TA的主页" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

#pragma mark Event
- (void)orderButtonClick {
    if (_reserveOtherButtonBlock) {
        _reserveOtherButtonBlock(_buttonState);
    }
}

- (void)confimButtonClick {
    if (_confimButtonBlock) {
        _confimButtonBlock(_buttonState);
    }
}

- (void)messageButtonClick {
    if (_messageButtonBlock) {
        _messageButtonBlock();
    }
}

#pragma mark 界面布局
- (UIButton *)orderButton {
    if (!_orderButton) {
        _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _orderButton.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(49));
        _orderButton.backgroundColor = kLBRedColor;
        _orderButton.titleLabel.font = kSystem(15);
        [_orderButton setTitle:@"预约其他行家" forState:UIControlStateNormal];
        [_orderButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _orderButton.hidden = YES;
        [_orderButton addTarget:self action:@selector(orderButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderButton;
}

- (UIButton *)confimButton {
    if (!_confimButton) {
        _confimButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confimButton.frame = CGRectMake(kCurrentWidth(115),0 , kDeviceWidth-kCurrentWidth(115), kCurrentWidth(49));
        _confimButton.backgroundColor = kLBRedColor;
        _confimButton.titleLabel.font = kSystem(16);
        [_confimButton setTitle:@"确认预约" forState:UIControlStateNormal];
        [_confimButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _confimButton.hidden = YES;
        [_confimButton addTarget:self action:@selector(confimButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confimButton;
}

- (UIButton *)messageButton {
    if (!_messageButton) {
        _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageButton.frame = CGRectMake(0, 0, kCurrentWidth(115), kCurrentWidth(49));
        _messageButton.backgroundColor = kWhiteColor;
        _messageButton.titleLabel.font = kSystem(11);
        [_messageButton setTitle:@"私信" forState:UIControlStateNormal];
        [_messageButton setTitleColor:kLBNineColor forState:UIControlStateNormal];
        [_messageButton setImage:[UIImage imageNamed:@"tab_icon_sixin.png"] forState:UIControlStateNormal];
        [_messageButton setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(22, 22) space:5];
        _messageButton.hidden = YES;
        [_messageButton addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageButton;
}

@end
