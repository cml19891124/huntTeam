//
//  QuestionStateCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "QuestionStateCell.h"

@interface QuestionStateCell ()

@property (nonatomic,strong)UILabel *typeLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UIButton *stateLabel;

@property (nonatomic,strong)ConfimButton *confimButton;

@property (nonatomic,assign)QuestionDetailState detailState;

@end

@implementation QuestionStateCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//
//        [self createSubViews];
//
//    }
//    return self;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(450));
        [self createSubViews];
    }
    return self;
}

- (void)setDetailModel:(QuestionOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
    if ([detailModel.orderStates intValue] == 1)
    {
        NSString *string = [InsureValidate timestamp:detailModel.endTime];
        NSLog(@"string = %@",string);
        if (self.detailType == QuestionDetailTypeStudent) {
            if ([string containsString:@"-"]) {
                self.detailState = QuestionDetailStateStudentTimeOut;
            }
            else {
                self.detailState = QuestionDetailStateStudentWait;
                [self calculateOrderTime:string];
            }
        }
        else if (self.detailType == QuestionDetailTypeExpert) {
            if ([string containsString:@"-"]) {
                self.detailState = QuestionDetailStateExpertTimeOut;
            }
            else {
                self.detailState = QuestionDetailStateExpertNormal;
                [self calculateOrderTime:string];
            }
        }
    }
    else if ([detailModel.orderStates intValue] == 6)
    {
        if (self.detailType == QuestionDetailTypeStudent) {
            self.detailState = QuestionDetailStateStudentOmit;
        }
        else if (self.detailType == QuestionDetailTypeExpert) {
            self.detailState = QuestionDetailStateExpertOmit;
        }
    }
    else if ([detailModel.orderStates intValue] == 7)
    {
        if (self.detailType == QuestionDetailTypeStudent) {
            self.detailState = QuestionDetailStateStudentTimeOut;
        }
        else if (self.detailType == QuestionDetailTypeExpert) {
            self.detailState = QuestionDetailStateExpertTimeOut;
        }
    }
    else if ([detailModel.orderStates intValue] == 5)
    {
        if (self.detailType == QuestionDetailTypeStudent) {
            self.detailState = QuestionDetailStateStudentOmit;
        }
        else if (self.detailType == QuestionDetailTypeExpert) {
            self.detailState = QuestionDetailStateExpertOmit;
        }
    }
    else if ([detailModel.orderStates intValue] == 8)
    {
        if (self.detailType == QuestionDetailTypeStudent) {
            self.detailState = QuestionDetailStateStudentTimeOut;
        }
        else if (self.detailType == QuestionDetailTypeExpert) {
            self.detailState = QuestionDetailStateExpertTimeOut;
        }
    }
}

- (void)calculateOrderTime:(NSString *)remainingTime {
    
    if ([remainingTime containsString:@"-"])
    {
        _timeLabel.text = @"";
    }
    else
    {
        int time = [remainingTime intValue];
        int second = time%60;//秒
        int minute = time/60%60;
        int house = time/3600;
        int day = time/(24*3600);
        
        if (day != 0) {
            house = house - 24;
            _timeLabel.text = [NSString stringWithFormat:@"剩余%d天%d小时%d分钟问题失效",day,house,minute];
        }else if (day==0 && house !=0) {
            _timeLabel.text = [NSString stringWithFormat:@"剩余%d小时%d分钟问题失效",house,minute];
        }else if (day==0 && house==0 && minute!=0) {
            _timeLabel.text = [NSString stringWithFormat:@"剩余%d分钟问题失效",minute];
        }else{
//            _timeLabel.text = [NSString stringWithFormat:@"剩余%d秒问题失效",second];
            _timeLabel.text = @"";
        }
    }
}

- (void)setDetailState:(QuestionDetailState)detailState {
    _detailState = detailState;
    
    switch (detailState) {
        case QuestionDetailStateStudentWait:
        {
            [_stateLabel setTitle:@"已支付，请等待行家回答" forState:UIControlStateNormal];
            _iconImageView.image = [UIImage imageNamed:@"icon_dengdaihuida"];
            _typeLabel.text = @"行家疯狂码字中";
            _timeLabel.text = @"剩余48小时00分钟问题失效";
            _confimButton.hidden = YES;
        }
            break;
        case QuestionDetailStateStudentTimeOut:
        {
            [_stateLabel setTitleColor:kBlackColor forState:UIControlStateNormal];
            _stateLabel.titleLabel.font = kSystemBold(15);
            [_stateLabel setImage:nil forState:UIControlStateNormal];
            [_stateLabel setTitle:@"行家没有在48小时内回答问题" forState:UIControlStateNormal];
            _iconImageView.image = [UIImage imageNamed:@"icon_shixiao"];
            _typeLabel.text = @"问题已失效";
            _timeLabel.text = @"您的退款费用将退还至原账户";
            _confimButton.hidden = NO;
        }
            break;
        case QuestionDetailStateExpertNormal:
        {
            [_stateLabel setTitle:@"对方已支付，请尽快回答" forState:UIControlStateNormal];
            _iconImageView.image = [UIImage imageNamed:@"icon_dengdaihuida"];
            _typeLabel.text = @"学员焦急等待回答";
            _timeLabel.text = @"剩余48小时00分钟问题失效";
            _confimButton.hidden = YES;
        }
            break;
        case QuestionDetailStateExpertTimeOut:
        {
            [_stateLabel setTitleColor:kBlackColor forState:UIControlStateNormal];
            _stateLabel.titleLabel.font = kSystemBold(15);
            [_stateLabel setImage:nil forState:UIControlStateNormal];
            [_stateLabel setTitle:@"没有在48小时内回答问题" forState:UIControlStateNormal];
            _iconImageView.image = [UIImage imageNamed:@"icon_shixiao"];
            _typeLabel.text = @"问题已失效";
            _timeLabel.hidden = YES;
            _confimButton.hidden = YES;
        }
            break;
        case QuestionDetailStateStudentOmit:
        {
            [_stateLabel setTitleColor:kBlackColor forState:UIControlStateNormal];
            _stateLabel.titleLabel.font = kSystemBold(15);
            [_stateLabel setImage:nil forState:UIControlStateNormal];
            [_stateLabel setTitle:@"行家无法回答，已忽略，请向其他行家提问" forState:UIControlStateNormal];
            _iconImageView.image = [UIImage imageNamed:@"icon_shixiao"];
            _typeLabel.text = @"问题已失效";
            _timeLabel.text = @"您的退款费用将返回至原账户";
            _confimButton.hidden = NO;
        }
            break;
        case QuestionDetailStateExpertOmit:
        {
            [_stateLabel setTitleColor:kBlackColor forState:UIControlStateNormal];
            _stateLabel.titleLabel.font = kSystemBold(15);
            [_stateLabel setImage:nil forState:UIControlStateNormal];
            [_stateLabel setTitle:@"您无法回答，已忽略该问答" forState:UIControlStateNormal];
            _iconImageView.image = [UIImage imageNamed:@"icon_shixiao"];
            _typeLabel.text = @"问题已失效";
            _timeLabel.hidden = YES;
            _confimButton.hidden = YES;
        }
            break;
        default:
            break;
    }
}

#pragma mark 界面布局
- (void)createSubViews {
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(150), kDeviceWidth, kCurrentWidth(100))];
    _iconImageView.image = [UIImage imageNamed:@"icon_dengdaihuida"];
    _iconImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_iconImageView];
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCurrentWidth(273), kDeviceWidth, kCurrentWidth(20))];
    _typeLabel.text = @"学员焦急等待回答";
    _typeLabel.font = kSystemBold(14);
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    _typeLabel.textColor = kBlackColor;
    [self addSubview:_typeLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _typeLabel.bottom+kCurrentWidth(8), kDeviceWidth, kCurrentWidth(20))];
    _timeLabel.text = @"剩余48小时00分钟问题失效";
    _timeLabel.font = kSystem(12);
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = kLBSixColor;
    [self addSubview:_timeLabel];
    
    _stateLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _stateLabel.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(150));
    _stateLabel.adjustsImageWhenHighlighted = NO;
    [_stateLabel setTitleColor:kLBRedColor forState:UIControlStateNormal];
    [_stateLabel setTitle:@"对方已支付，请尽快回答" forState:UIControlStateNormal];
    [_stateLabel setImage:[UIImage imageNamed:@"icon_sel.png"] forState:UIControlStateNormal];
    _stateLabel.titleLabel.font = kSystemBold(16);
//    _stateLabel.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    _stateLabel.titleEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(11), 0, 0);
    [self addSubview:_stateLabel];
    
    _confimButton = [[ConfimButton alloc] initWithTop:_timeLabel.bottom+kCurrentWidth(40) title:@"向其他行家提问"];
    _confimButton.hidden = YES;
    [_confimButton addTarget:self action:@selector(confimButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confimButton];
}

- (void)confimButtonClick {
    if (_messageButtonBlock) {
        _messageButtonBlock();
    }
}

@end
