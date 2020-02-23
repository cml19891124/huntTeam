//
//  OrderStatusCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/20.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "OrderStatusCell.h"
#import "DetailStatusView.h"

@interface OrderStatusCell ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)DetailStatusView *statusView;

@end

@implementation OrderStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self createSubViews];
    }
    return self;
}

- (void)setDetailModel:(ThemeOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
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
                _titleLabel.text = @"您已超时，预约已失效";
                _detailLabel.text = @"您未在72小时内确认预约，预约已失效";
                [_statusView updataDetailStatus:2];
            }
            else if (self.detailType == QuestionDetailTypeStudent)
            {
                _titleLabel.text = @"行家未确认，预约已失效";
                _detailLabel.text = @"行家未在72小时内确认预约，您的退款费用将返回至原账户信息";
                [_statusView updataDetailStatus:1];
            }
        }
        else
        {
            if (self.detailType == QuestionDetailTypeExpert)
            {
                _titleLabel.text = @"学员已付款，请尽快确认";
                [self calculateOrderTime:string];
                [_statusView updataDetailStatus:1];
            }
            else if (self.detailType == QuestionDetailTypeStudent)
            {
                _titleLabel.text = @"已付款，待行家确认";
                [self calculateOrderTime:string];
                [_statusView updataDetailStatus:1];
            }
        }
    }
    else if ([detailModel.orderStates intValue] == 2)
    {
//        if (self.detailType == QuestionDetailTypeExpert)
//        {
//            _titleLabel.text = @"待学员确认服务完成";
//            _detailLabel.text = @"剩余4天确认服务完成";
//        }
//        else if (self.detailType == QuestionDetailTypeStudent)
//        {
//            _titleLabel.text = @"服务已完成";
//            _detailLabel.text = @"剩余4天确认服务完成";
//        }
    }
    else if ([detailModel.orderStates intValue] == 3)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"服务已完成";
            _detailLabel.hidden = YES;
            [_statusView updataDetailStatus:4];
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"服务已完成";
            _detailLabel.hidden = YES;
            [_statusView updataDetailStatus:4];
        }
    }
    else if ([detailModel.orderStates intValue] == 5)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"学员已取消预约";
            _detailLabel.text = @"学员因个人原因取消了预约，预约已失效";
            [_statusView updataDetailStatus:1];
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"您已取消预约";
            _detailLabel.text = @"取消原因：个人原因，预约已无效";
            [_statusView updataDetailStatus:1];
        }
    }
    else if ([detailModel.orderStates intValue] == 6)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"您已忽略此预约";
            _detailLabel.text = @"预约失效";
            [_statusView updataDetailStatus:1];
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            if ([detailModel.serviceType intValue] == 0) {
                _titleLabel.text = @"行家已忽略，无法完成约见，请预约其他行家";
                _detailLabel.text = @"行家因个人原因无法确认约见，您的退款费用将返回至原账户";
            }
            else {
                _titleLabel.text = @"行家已忽略，无法完成通话，请预约其他行家";
                _detailLabel.text = @"行家因个人原因无法确认通话，您的退款费用将返回至原账户";
            }
            [_statusView updataDetailStatus:1];
        }
    }
    else if ([detailModel.orderStates intValue] == 7)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"您已超时，预约已失效";
            _detailLabel.text = @"您未在72小时内确认预约，预约已失效";
            [_statusView updataDetailStatus:2];
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"行家未确认，预约已失效";
            _detailLabel.text = @"行家未在72小时内确认预约，您的退款费用将返回至原账户信息";
            [_statusView updataDetailStatus:1];
        }
    }
    else if ([detailModel.orderStates intValue] == 8)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"已退款";
            _detailLabel.text = @"预约已无效";
            [_statusView updataDetailStatus:1];
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"已退款";
            _detailLabel.text = @"预约已无效";
            [_statusView updataDetailStatus:1];
        }
    }
    else if ([detailModel.orderStates intValue] == 4)//已确认
    {
//        if (self.detailType == QuestionDetailTypeExpert)
//        {
//            _titleLabel.text = @"服务已完成";
//            _detailLabel.hidden = YES;
//            [_statusView updataDetailStatus:3];
//        }
//        else if (self.detailType == QuestionDetailTypeStudent)
//        {
//            NSString *string = [InsureValidate timestamp:detailModel.endTime];
//            _titleLabel.text = @"服务已完成";
//            [self calculateConfimOrderTime:string];
//            [_statusView updataDetailStatus:3];
//        }
        NSString *string = [InsureValidate timestamp:detailModel.endTime];
        _titleLabel.text = @"服务已完成";
//        [self calculateConfimOrderTime:string];
        _detailLabel.text = @"待评价";
        [_statusView updataDetailStatus:3];
    }
    else if ([detailModel.orderStates intValue] == 9)//行家已确定预约，待用户确定
    {
        NSString *string = [InsureValidate timestamp:detailModel.endTime];
        if (self.detailType == QuestionDetailTypeExpert)
        {
            if ([detailModel.serviceType intValue] == 0) {
                _titleLabel.text = @"待学员确认时间地点约见";
            }
            else {
                _titleLabel.text = @"待学员确认通话时间";
            }
            [_statusView updataDetailStatus:2];
            [self calculateOrderTime:string];
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            if ([detailModel.serviceType intValue] == 0) {
                _titleLabel.text = @"行家确认您的预约，请确认时间地点约见";
            }
            else {
                _titleLabel.text = @"行家确认您的预约，请确认通话时间";
            }
            [_statusView updataDetailStatus:2];
            [self calculateOrderTime:string];
        }
    }
    else if ([detailModel.orderStates intValue] == 10)//用户与行家都已确认预约
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            if ([detailModel.serviceType intValue] == 0) {
                _titleLabel.text = @"已确认,待与学员见面";//通话
            }
            else {
                _titleLabel.text = @"已确认,待与学员通话";//通话
            }
            [_statusView updataDetailStatus:2];
            _detailLabel.hidden = YES;
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            if ([detailModel.serviceType intValue] == 0) {
                _titleLabel.text = @"已确认,待与行家见面";//通话
            }
            else {
                _titleLabel.text = @"已确认,待与行家通话";//通话
            }
            _detailLabel.hidden = YES;
            [_statusView updataDetailStatus:2];
        }
    }
    else if ([detailModel.orderStates intValue] == 11)//行家确认完成
    {
        NSString *string = [InsureValidate timestamp:detailModel.endTime];
        if (self.detailType == QuestionDetailTypeExpert)
        {
            _titleLabel.text = @"服务完成，待学员确认服务完成";//
            [self calculateConfimOrderTime:string];
            [_statusView updataDetailStatus:2];
        }
        else if (self.detailType == QuestionDetailTypeStudent)
        {
            _titleLabel.text = @"行家已确认服务完成，待学员确认";//
            [self calculateConfimOrderTime:string];
            [_statusView updataDetailStatus:3];
        }
    }
}

- (void)calculateConfimOrderTime:(NSString *)remainingTime {
    
    if ([remainingTime containsString:@"-"])
    {
        _detailLabel.text = @"";
    }
    else
    {
        int time = [remainingTime intValue];
//        int second = time%60;//秒
        int minute = time/60%60;
        int house = time/3600;
        int day = time/(24*3600);
        
        if (day != 0) {
            house = house - 24;
            _detailLabel.text = [NSString stringWithFormat:@"剩余%d天%d小时%d分确认服务完成",day,house,minute];
        }else if (day==0 && house !=0) {
            _detailLabel.text = [NSString stringWithFormat:@"剩余%d小时%d分确认服务完成",house,minute];
        }else if (day==0 && house==0 && minute!=0) {
            _detailLabel.text = [NSString stringWithFormat:@"剩余%d分确认服务完成",minute];
        }else{
//            _detailLabel.text = [NSString stringWithFormat:@"剩余%d秒确认服务完成",second];
            _detailLabel.text = @"";
        }
    }
}

- (void)calculateOrderTime:(NSString *)remainingTime {
    
    if ([remainingTime containsString:@"-"])
    {
        _detailLabel.text = @"";
    }
    else
    {
        int time = [remainingTime intValue];
        int second = time%60;//秒
        int minute = time/60%60;
        int house = time/3600%24;
        int day = time/(24*3600);
        
        if (day != 0) {
//            house = house - 24;
            _detailLabel.text = [NSString stringWithFormat:@"剩余%d天%d小时%d分钟预约失效",day,house,minute];
        }else if (day==0 && house !=0) {
            _detailLabel.text = [NSString stringWithFormat:@"剩余%d小时%d分钟预约失效",house,minute];
        }else if (day==0 && house==0 && minute!=0) {
            _detailLabel.text = [NSString stringWithFormat:@"剩余%d分钟预约失效",minute];
        }else{
//            _detailLabel.text = [NSString stringWithFormat:@"剩余%d秒预约失效",second];
            _detailLabel.text = @"";
        }
    }
}

- (void)createSubViews {
    
    _statusView = [[DetailStatusView alloc] init];
    [_statusView updataDetailStatus:1];
    [self.contentView addSubview:_statusView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCurrentWidth(60), kDeviceWidth, kCurrentWidth(27))];
    _titleLabel.textColor = kLBRedColor;
    _titleLabel.font = kSystem(16);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom, kDeviceWidth, kCurrentWidth(22))];
    _detailLabel.textColor = kLBNineColor;
    _detailLabel.font = kSystem(14);
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_detailLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(120)-0.5, kDeviceWidth, 0.5)];
    _lineView.backgroundColor = kSepparteLineColor;
    [self.contentView addSubview:_lineView];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
