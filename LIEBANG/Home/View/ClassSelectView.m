//
//  ClassSelectView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ClassSelectView.h"

@interface ClassSelectView ()

@property (nonatomic,strong)UILabel *numberLabel;
@property (nonatomic,strong)UIView *contentView;

@end


@implementation ClassSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        
    }
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(15), 0, kDeviceWidth-kCurrentWidth(30), kCurrentWidth(42))];
    _numberLabel.textColor = kLBBlackColor;
    _numberLabel.font = kSystem(13);
    [self addSubview:_numberLabel];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _numberLabel.bottom, kDeviceWidth, 0)];
    _contentView.backgroundColor = kWhiteColor;
    [self addSubview:_contentView];
    
//    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.contentView.height = kCurrentWidth(45)*((titleArray.count-1)/4)+kCurrentWidth(45);
    CGFloat spaceWidth = (kDeviceWidth-kCurrentWidth(344))/3;
    for (int i = 0; i < titleArray.count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kCurrentWidth(12)+(spaceWidth+kCurrentWidth(80))*(i%4), kCurrentWidth(45)*(i/4), kCurrentWidth(80), kCurrentWidth(35));
        button.backgroundColor = kLBRedColor;
        [button setTitle:[titleArray safeObjectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
        button.titleLabel.font = kSystem(13);
        button.layer.cornerRadius = kCurrentWidth(35)/2;
        button.layer.masksToBounds = YES;
        button.tag = 100+i;
//        [button addTarget:self action:@selector(removeObjectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
    
    NSString *selectGameText = [NSString stringWithFormat:@"%zd",titleArray.count];
    NSString *allSelectGameText = [NSString stringWithFormat:@"已选择标签 %zd",titleArray.count];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectGameText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:kLBRedColor
                 range:[allSelectGameText rangeOfString:selectGameText]];
    
    _numberLabel.attributedText = attr;
    
    if (titleArray.count == 0) {
        self.height = 0;
    }
    else {
        self.height = self.contentView.bottom;
    }
}

- (void)removeObjectClick:(UIButton *)sender {
    
    if (_removeObjectBlock) {
        _removeObjectBlock(sender.tag-100);
    }
}

@end
