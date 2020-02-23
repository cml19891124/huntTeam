//
//  DetailStatusView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/3.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "DetailStatusView.h"


static NSArray *titleArray;
@interface DetailStatusView ()

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIView *showView;

@end

@implementation DetailStatusView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        titleArray = @[@"预约付款",@"行家确认",@"服务完成",@"学员评价"];
        
        self.backgroundColor = kWhiteColor;
        self.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(60));
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(40), kDeviceWidth, 0.5)];
        _lineView.backgroundColor = kSepparteLineColor;
        [self addSubview:_lineView];
        
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
        _showView.backgroundColor = kLBRedColor;
        [_lineView addSubview:_showView];
        
        [self createLabelWithArray];
    }
    return self;
}

- (void)createLabelWithArray {
    
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*kDeviceWidth/titleArray.count, 0, kDeviceWidth/titleArray.count, kCurrentWidth(40))];
        label.text = [titleArray safeObjectAtIndex:i];
        label.textColor = kLBNineColor;
        label.font = kSystem(14);
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = i+1;
        [self addSubview:label];
        
        UIView *wView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(14), kCurrentWidth(14))];
        wView.center = CGPointMake(label.centerX, _lineView.centerY);
        wView.backgroundColor = kWhiteColor;
        [self addSubview:wView];
        
        UIView *lbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(8), kCurrentWidth(8))];
        lbView.center = CGPointMake(wView.centerX, wView.centerY);
        lbView.backgroundColor = kSepparteLineColor;
        lbView.layer.cornerRadius = kCurrentWidth(4);
        lbView.layer.masksToBounds = YES;
        lbView.tag = i+10;
        [self addSubview:lbView];
    }
}

- (void)updataDetailStatus:(NSInteger)status {
    
    for (int i = 0; i < status; i++) {
        UILabel *label = [self viewWithTag:i+1];
        label.textColor = kLBRedColor;
        
        UIView *lbView = [self viewWithTag:i+10];
        lbView.backgroundColor = kLBRedColor;
    }
    
    if (status == 4)
    {
        _showView.width = kDeviceWidth;
    }
    else
    {
        UILabel *indexLabel = [self viewWithTag:status];
        _showView.width = indexLabel.centerX;
    }
}

@end
