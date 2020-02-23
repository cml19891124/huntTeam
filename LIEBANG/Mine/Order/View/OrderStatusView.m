//
//  OrderStatusView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "OrderStatusView.h"

@interface OrderStatusView ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *isNewLabel;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIImageView *markImageView;

@end

@implementation OrderStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
        _lineView.backgroundColor = kSepparteLineColor;
        [self addSubview:_lineView];
        
        _markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(20), _lineView.bottom, kCurrentWidth(6), self.height-0.5)];
        _markImageView.image = [UIImage imageNamed:@"list_btn_enter"];
        _markImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_markImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), _lineView.bottom, kCurrentWidth(320), self.height-0.5)];
        _titleLabel.text = @"服务已完成，待评价";
        _titleLabel.font = kSystem(12.5);
        _titleLabel.textColor = kLBBlackColor;
        [self addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(225), _lineView.bottom, kCurrentWidth(200), self.height-0.5)];
        _timeLabel.textColor = kLBSixColor;
        _timeLabel.text = @"剩余0小时00分钟问题失效";
        _timeLabel.font = kSystem(10.5);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_timeLabel];

        _isNewLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right+kCurrentWidth(5), _lineView.bottom, kCurrentWidth(30), self.height-0.5)];
        _isNewLabel.text = @"NEW";
        _isNewLabel.textColor = [UIColor colorWithHexString:@"F74545"];
        _isNewLabel.font = kSystem(10);
        [self addSubview:_isNewLabel];
    }
    return self;
}

- (void)setQuestionModel:(QuestionModel *)questionModel {
    _questionModel = questionModel;
    
    NSString *string = [InsureValidate timestamp:questionModel.endTime];
    
    [self hiddenNewLabel:questionModel.readStatus];
    [self calculateOrderTime:string];
    
    
    _timeLabel.hidden = YES;
    if ([questionModel.orderStates intValue] == 0)
    {
        
    }
    else if ([questionModel.orderStates intValue] == 1)
    {
        NSString *string = [InsureValidate timestamp:questionModel.endTime];
        if ([string containsString:@"-"])
        {
            if (self.detailType == QuestionDetailTypeExpert)
            {
                _titleLabel.text = @"行家没有在48小时内回答问题";
            }
            else if (self.detailType == QuestionDetailTypeStudent)
            {
                _titleLabel.text = @"行家没有在48小时内回答问题";
            }
        }
        else
        {
            if (self.detailType == QuestionDetailTypeExpert)
            {
                _titleLabel.text = @"对方已支付，请尽快回答";
                _timeLabel.hidden = NO;
            }
            else if (self.detailType == QuestionDetailTypeStudent)
            {
                _titleLabel.text = @"已支付，请等待行家回答";
                _timeLabel.hidden = NO;
            }
        }
    }
    else if ([questionModel.orderStates intValue] == 2)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"服务已完成，待对方评价";
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"服务已完成，待评价";
        }
    }
    else if ([questionModel.orderStates intValue] == 3)
    {
        _titleLabel.text = @"服务已完成";
    }
    else if ([questionModel.orderStates intValue] == 5)
    {
//        if (self.detailType == QuestionDetailTypeExpert)
//        {
//            _titleLabel.text = @"学员已取消预约";
//        }
//        else if (self.detailType == QuestionDetailTypeStudent)
//        {
//            _titleLabel.text = @"您已取消预约";
//        }
    }
    else if ([questionModel.orderStates intValue] == 6)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"您无法回答，已忽略该问答";
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"行家无法回答，已忽略，请向其他行家提问";
        }
    }
    else if ([questionModel.orderStates intValue] == 7)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"行家没有在48小时内回答问题";
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"行家没有在48小时内回答问题";
        }
    }
    else if ([questionModel.orderStates intValue] == 8)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"已退款";
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"已退款";
        }
    }
    else if ([questionModel.orderStates intValue] == 4)//已确认
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"服务已完成";
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"服务已完成";
        }
    }
    
    CGSize size = [_titleLabel.text sizeWithFont:kSystem(12.5) maxSize:CGSizeMake(MAXFLOAT, self.height-0.5)];
    _titleLabel.frame = CGRectMake(kCurrentWidth(12), _lineView.bottom, size.width, self.height-0.5);
    _isNewLabel.frame = CGRectMake(_titleLabel.right+kCurrentWidth(5), _lineView.bottom, kCurrentWidth(30), self.height-0.5);
}

- (void)setThemeModel:(ThemeModel *)themeModel {
    _themeModel = themeModel;
    
    NSString *string = [InsureValidate timestamp:themeModel.endTime];
    [self hiddenNewLabel:themeModel.readStatus];
    [self calculateOrderTime:string];
    
    _timeLabel.hidden = YES;
    if ([themeModel.orderStates intValue] == 0)
    {
        
    }
    else if ([themeModel.orderStates intValue] == 1)
    {
        NSString *string = [InsureValidate timestamp:themeModel.endTime];
        if ([string containsString:@"-"])
        {
            if (self.detailType == QuestionDetailTypeExpert)
            {
                _titleLabel.text = @"您已超时，预约已失效";
            }
            else if (self.detailType == QuestionDetailTypeStudent)
            {
                _titleLabel.text = @"行家未确认，预约已失效";
            }
        }
        else
        {
            if (self.detailType == QuestionDetailTypeExpert)
            {
                _titleLabel.text = @"学员已付款，请尽快确认";
                _timeLabel.hidden = NO;
            }
            else if (self.detailType == QuestionDetailTypeStudent)
            {
                _titleLabel.text = @"已付款，待行家确认";
                _timeLabel.hidden = NO;
            }
        }
    }
    else if ([themeModel.orderStates intValue] == 2)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"待学员确认服务完成";
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"服务已完成";
        }
    }
    else if ([themeModel.orderStates intValue] == 3)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"服务已完成";
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"服务已完成";
        }
    }
    else if ([themeModel.orderStates intValue] == 5)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"学员已取消预约";
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"您已取消预约";
        }
    }
    else if ([themeModel.orderStates intValue] == 6)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"您已忽略此预约";
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            if ([themeModel.serviceType intValue] == 0) {
                _titleLabel.text = @"行家已忽略，无法完成约见，请预约其他行家";
            }
            else {
                _titleLabel.text = @"行家已忽略，无法完成通话，请预约其他行家";
            }
        }
    }
    else if ([themeModel.orderStates intValue] == 7)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"您已超时，预约已失效";
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"行家未确认，预约已失效";
        }
    }
    else if ([themeModel.orderStates intValue] == 8)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"已退款";
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"已退款";
        }
    }
    else if ([themeModel.orderStates intValue] == 4)//已确认---买家服务已完成，待买家评价
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"服务已完成,待评价";
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"服务已完成,待评价";
        }
    }
    else if ([themeModel.orderStates intValue] == 9)//行家已确定预约，待用户确定
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            if ([themeModel.serviceType intValue] == 0) {
                _titleLabel.text = @"待学员确认时间地点约见";
            }
            else {
                _titleLabel.text = @"待学员确认通话时间";
            }
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            if ([themeModel.serviceType intValue] == 0) {
                _titleLabel.text = @"行家确认您的预约，请确认时间地点约见";
            }
            else {
                _titleLabel.text = @"行家确认您的预约，请确认通话时间";
            }
        }
    }
    else if ([themeModel.orderStates intValue] == 10)//用户与行家都已确认预约
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            if ([themeModel.serviceType intValue] == 0) {
                _titleLabel.text = @"已确认,待与学员见面";//通话
            }
            else {
                _titleLabel.text = @"已确认,待与学员通话";//通话
            }
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            if ([themeModel.serviceType intValue] == 0) {
                _titleLabel.text = @"已确认,待与行家见面";//通话
            }
            else {
                _titleLabel.text = @"已确认,待与行家通话";//通话
            }
        }
    }
    else if ([themeModel.orderStates intValue] == 11)//行家确认完成
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"服务完成，待学员确认服务完成";//通话
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"行家已确认服务完成，待学员确认";//通话
        }
    }
    
    CGSize size = [_titleLabel.text sizeWithFont:kSystem(12.5) maxSize:CGSizeMake(MAXFLOAT, self.height-0.5)];
    _titleLabel.frame = CGRectMake(kCurrentWidth(12), _lineView.bottom, size.width, self.height-0.5);
    _isNewLabel.frame = CGRectMake(_titleLabel.right+kCurrentWidth(5), _lineView.bottom, kCurrentWidth(30), self.height-0.5);
}

- (void)calculateOrderTime:(NSString *)remainingTime {
    
    if ([remainingTime containsString:@"-"])
    {
        _timeLabel.text = @"";
    }
    else
    {
        int time = [remainingTime intValue];
//        int second = time%60;//秒
        int minute = time/60%60;
        int house = time/3600%24;
        int day = time/(24*3600);
        
        if (day != 0) {
//            house = house - 24;
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

- (void)hiddenNewLabel:(NSString *)readStatus {
    if ([readStatus intValue] == 0)
    {
        _isNewLabel.hidden = NO;
    }
    else
    {
        _isNewLabel.hidden = YES;
    }
}

@end
