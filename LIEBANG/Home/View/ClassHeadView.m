//
//  ClassHeadView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ClassHeadView.h"

@interface ClassHeadView ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *headImageView;

@end

@implementation ClassHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headImageView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setModel:(ClassModel *)model {
    _model = model;
    
    self.titleLabel.text = model.classify;
}

#pragma mark 界面布局
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(25)/2, kCurrentWidth(9), kCurrentWidth(12))];
        _headImageView.image = [UIImage imageNamed:@"icon_b"];
    }
    return _headImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(26), 0, kDeviceWidth-kCurrentWidth(26), kCurrentWidth(37))];
        _titleLabel.text = @"职场发展";
        _titleLabel.textColor = kLBFiveColor;
        _titleLabel.font = kSystem(13);
    }
    return _titleLabel;
}

@end
