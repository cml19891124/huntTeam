//
//  ClassCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ClassCell.h"

@interface ClassCell ()

@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation ClassCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setClassifyTwoModel:(ClassifyTwoModel *)classifyTwoModel {
    _classifyTwoModel = classifyTwoModel;
    
    self.titleLabel.text = classifyTwoModel.classify;
    
    NSLog(@" ===== %@",classifyTwoModel.isClick?@"yes":@"no");
    if (classifyTwoModel.isClick) {
        self.titleLabel.backgroundColor = kLBRedColor;
        self.titleLabel.textColor = kWhiteColor;
    }
    else {
        self.titleLabel.backgroundColor = kWhiteColor;
        self.titleLabel.textColor = kLBNineColor;
    }
}

#pragma mark 界面布局
- (UILabel *)titleLabel {//CGRectMake(0, 0, self.width, self.heigh
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(0, 0, self.width-1, self.height-1))];
        _titleLabel.text = @"数据分析";
        _titleLabel.textColor = kLBNineColor;
        _titleLabel.font = kSystem(13);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = kWhiteColor;
    }
    return _titleLabel;
}

@end
