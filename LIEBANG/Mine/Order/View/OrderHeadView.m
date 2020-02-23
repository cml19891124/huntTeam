//
//  OrderHeadView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "OrderHeadView.h"

@interface OrderHeadView ()

@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)UIView *lineView;

@end

@implementation OrderHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.titleArray = @[@"进行中",@"待评价",@"已结束",@"已收到"];
        self.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(45));
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(45)-0.5, kDeviceWidth, 0.5)];
        self.lineView.backgroundColor = kSepparteLineColor;
        [self addSubview:self.lineView];
        
        [self createButtonWithArray:self.titleArray];
    }
    return self;
}

- (void)setReadModel:(OrderReadModel *)readModel {
    _readModel = readModel;
    
    UILabel *label1 = [self viewWithTag:10];
    UILabel *label2 = [self viewWithTag:11];
    UILabel *label3 = [self viewWithTag:12];
    UILabel *label4 = [self viewWithTag:13];
    
    [self hiddenLabel:label1 number:readModel.unreadNum1];
    [self hiddenLabel:label2 number:readModel.unreadNum2];
    [self hiddenLabel:label3 number:readModel.unreadNum3];
    [self hiddenLabel:label4 number:readModel.unreadNum4];
    
}

- (void)hiddenLabel:(UILabel *)label number:(NSString *)number {
    label.text = number;
    if ([number intValue] == 0)
    {
        label.hidden = YES;
    }
    else
    {
        label.hidden = NO;
    }
}

- (void)createButtonWithArray:(NSArray *)titleArray {
    
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
        sender.frame = CGRectMake(i*kDeviceWidth/4, 0, kDeviceWidth/4, kCurrentWidth(45));
        [sender setTitle:[titleArray safeObjectAtIndex:i] forState:UIControlStateNormal];
        [sender setTitleColor:kLBBlackColor forState:UIControlStateNormal];
        [sender setTitleColor:kLBRedColor forState:UIControlStateSelected];
        sender.titleLabel.font = kSystem(14);
        sender.tag = 20+i;
        if (i == 0) {
            sender.selected = YES;
        }
        [sender addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sender];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(sender.width/2-38, kCurrentWidth(31)/2, kCurrentWidth(14), kCurrentWidth(14))];
        label.backgroundColor = [UIColor colorWithHexString:@"F74545"];
        label.textColor = kWhiteColor;
        label.font = kSystem(11);
        label.text = @"0";
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = kCurrentWidth(7);
        label.layer.masksToBounds = YES;
        label.tag = 10+i;
        label.hidden = YES;
        [sender addSubview:label];
    }
}

#pragma mark Event
- (void)headButtonClick:(UIButton *)sender {
    
    if (sender.selected) {
        return;
    }
    
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton *button = [self viewWithTag:i+20];
        button.selected = NO;
    }
    sender.selected = YES;
    
    NSInteger index = sender.tag - 19;
    if (_headButtonBlock) {
        _headButtonBlock(index);
    }
}

@end
