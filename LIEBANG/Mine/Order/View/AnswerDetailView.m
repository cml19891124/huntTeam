//
//  AnswerDetailView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/4.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AnswerDetailView.h"
#import "StarView.h"
#import <Accelerate/Accelerate.h>

@interface AnswerDetailView ()

@property (nonatomic,strong)UIView *content;
@property (nonatomic,strong)UILabel *typelabel;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)StarView *starView;

@property (nonatomic,strong)UIButton *payButton;

@property (nonatomic,strong)UIImageView *effectView;

@end

@implementation AnswerDetailView


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(6), kDeviceWidth-kCurrentWidth(24), 0)];
        _contentLabel.font = kSystem(13);
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
        
        _content = [[UIView alloc] initWithFrame:CGRectMake(0, _contentLabel.bottom+kCurrentWidth(15), kDeviceWidth, kCurrentWidth(40))];
        _content.backgroundColor = kBackgroundColor;
        [self addSubview:_content];
        
        NSString *string = @"用户评价：";
        CGSize size = [string sizeWithFont:kSystem(13) maxSize:CGSizeMake(MAXFLOAT, kCurrentWidth(40))];
        
        _typelabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, size.width, kCurrentWidth(40))];
        _typelabel.font = kSystem(13);
        _typelabel.textColor = kLBSixColor;
        _typelabel.text = string;
        [_content addSubview:_typelabel];
        
        _starView = [[StarView alloc] initWithFrame:CGRectMake(_typelabel.right+kCurrentWidth(10), kCurrentWidth(15), kCurrentWidth(78), kCurrentWidth(10))];
        [_content addSubview:_starView];
        
        _effectView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(6), kDeviceWidth-kCurrentWidth(24), ((kDeviceWidth-kCurrentWidth(24))/1115)*761)];
        _effectView.image =[UIImage imageNamed:@"question_detail"];
        _effectView.hidden = YES;
        [self addSubview:_effectView];
        
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.frame = CGRectMake(0, 0, kCurrentWidth(150), kCurrentWidth(35));
        _payButton.backgroundColor = [UIColor colorWithHexString:@"2AA0F8"];
        [_payButton setTitle:@"1猎帮币  查看回答" forState:UIControlStateNormal];
        [_payButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _payButton.layer.cornerRadius = kCurrentWidth(35)/2;
        _payButton.layer.masksToBounds = YES;
        _payButton.titleLabel.font = kSystem(15);
        [_payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _payButton.hidden = YES;
        [self addSubview:_payButton];
    }
    return self;
}

- (void)setDetailModel:(QuestionOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
    if (IsStrEmpty(detailModel.answerContent) && IsNilOrNull(detailModel.answerContent))
    {
        detailModel.answerContent = @"暂无回答内容";
    }
    
    CGSize size = [detailModel.answerContent sizeWithFont:kSystem(13) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), MAXFLOAT)];
    
    _contentLabel.text = detailModel.answerContent;
    _contentLabel.height = size.height;
    _content.top = _contentLabel.bottom+kCurrentWidth(15);
    
    
//    if ([detailModel.orderStates intValue] == 2)
//    {
//        NSString *string = @"用户评价：暂未评分";
//        CGSize size = [string sizeWithFont:kSystem(13) maxSize:CGSizeMake(MAXFLOAT, kCurrentWidth(40))];
//
//        _typelabel.width = size.width;
//        _starView.hidden = YES;
//        _typelabel.text = @"用户评价：暂未评分";
//    }
//    else if ([detailModel.orderStates intValue] == 3 || [detailModel.orderStates intValue] == 4)
//    {
//        NSString *string = @"用户评价：";
//        CGSize size = [string sizeWithFont:kSystem(13) maxSize:CGSizeMake(MAXFLOAT, kCurrentWidth(40))];
//
//        _starView.hidden = NO;
//        _typelabel.text = @"用户评价：";
//        _typelabel.width = size.width;
////        _starView.score = [detailModel.score floatValue];
//        _starView.score = [detailModel.startLevel floatValue];
//    }
    
    NSString *string = @"用户评价：";
    CGSize size1 = [string sizeWithFont:kSystem(13) maxSize:CGSizeMake(MAXFLOAT, kCurrentWidth(40))];
    
    _starView.hidden = NO;
    _typelabel.text = string;
    _typelabel.width = size1.width;
    _starView.score = [detailModel.startLevel floatValue];
    
    self.height = _content.bottom;
}

- (void)setModel:(QuestionDetailModel *)model {
    _model = model;
    
    if (IsNilOrNull(model)) {
        self.height = _content.bottom;
        return;
    }
    
    CGSize size = [model.answerContent sizeWithFont:kSystem(13) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), MAXFLOAT)];
    if (size.height < kCurrentWidth(40)) {
        size.height = kCurrentWidth(40);
    }
    
    _contentLabel.text = model.answerContent;
    _contentLabel.height = size.height;
    
    NSLog(@"userUid = %@ == %@",[Config currentConfig].userUid,model.userUid);
    if ([model.chargeState intValue] == 1 && [model.isBuy intValue] == 0 && ![[Config currentConfig].userUid isEqualToString:model.userUid] && !self.isMy)
    {
        _payButton.hidden = NO;
        _effectView.hidden = NO;
        _contentLabel.height = ((kDeviceWidth-kCurrentWidth(24))/1115)*761;
        _payButton.center = _contentLabel.center;
    }
    else
    {
        _payButton.hidden = YES;
        _effectView.hidden = YES;
    }

    _content.top = _contentLabel.bottom+kCurrentWidth(15);
    NSString *string = @"用户评价：";
    CGSize size1 = [string sizeWithFont:kSystem(13) maxSize:CGSizeMake(MAXFLOAT, kCurrentWidth(40))];
    
    _starView.hidden = NO;
    _typelabel.text = string;
    _typelabel.width = size1.width;
    _starView.score = [model.startLevel floatValue];
    
    self.height = _content.bottom;
}

- (void)payButtonClick {
    if (_onePayBlock) {
        _onePayBlock();
    }
}

- (CGFloat)viewHeight {
    return self.height;
}

@end
