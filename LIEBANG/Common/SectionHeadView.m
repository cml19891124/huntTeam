//
//  SectionHeadView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/11.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "SectionHeadView.h"

@interface SectionHeadView ()

@property (nonatomic,strong)UIButton *detailButton;
@property (nonatomic,strong)UILabel *titleLabel;

@property (strong, nonatomic) UIView *lineV;
@end

@implementation SectionHeadView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.detailButton];
//        [self addSubview:self.lineV];

        self.titleLabel.text = title;
        
        CGSize size = [title sizeWithFont:kSystem(13) maxSize:CGSizeMake(kDeviceWidth, self.height)];
        self.titleLabel.frame = CGRectMake(kCurrentWidth(13), 0, size.width + 50, self.height);
//        self.lineV.frame = CGRectMake(0, self.height - 0.5,kDeviceWidth, 0.5);

    }
    return self;
}

- (void)setExperienceView {
    self.titleLabel.font = kSystem(13);
    self.titleLabel.textColor = kLBBlackColor;
}

- (void)setButtonState:(SectionButtonState)buttonState {
    _buttonState = buttonState;
    
    if (buttonState == SectionButtonStateNormel)
    {
        self.detailButton.titleLabel.font = kSystem(13);
        [self.detailButton setTitleColor:[UIColor colorWithHexString:@"19579E"] forState:UIControlStateNormal];
        self.detailButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(112), (self.height-kCurrentWidth(20))/2, kCurrentWidth(100), kCurrentWidth(20));
        self.detailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    else if (buttonState == SectionButtonStateBorder)
    {
        self.detailButton.titleLabel.font = kSystem(13);
        self.detailButton.layer.borderColor = kLBRedColor.CGColor;
        self.detailButton.layer.borderWidth = 0.5;
        self.detailButton.layer.cornerRadius = kCurrentWidth(10);
        self.detailButton.layer.masksToBounds = YES;
        [self.detailButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
        self.detailButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(56), (self.height-kCurrentWidth(20))/2, kCurrentWidth(44), kCurrentWidth(20));
    }
    else if (buttonState == SectionButtonStateDisable)
    {
        self.detailButton.titleLabel.font = kSystem(13);
        [self.detailButton setTitleColor:kLBNineColor forState:UIControlStateNormal];
        self.detailButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(112), (self.height-kCurrentWidth(20))/2, kCurrentWidth(100), kCurrentWidth(20));
        self.detailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.detailButton.adjustsImageWhenHighlighted = NO;
    }
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;
    
    self.detailButton.hidden = NO;
    [self.detailButton setTitle:buttonTitle forState:UIControlStateNormal];
    self.detailButton.titleLabel.font = kSystem(13);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), 0, 0, self.height)];
        _titleLabel.font = kSystem(14);
        _titleLabel.textColor = kLBNineColor;
    }
    return _titleLabel;
}

- (UIView *)lineV
{
    if (!_lineV) {
        _lineV = UIView.new;
        _lineV.backgroundColor = UIColor.groupTableViewBackgroundColor;
    }
    return _lineV;
}

- (UIButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(75), (self.height-kCurrentWidth(20))/2, kCurrentWidth(60), kCurrentWidth(20));
        _detailButton.hidden = YES;
        [_detailButton addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton;
}

#pragma mark Event
- (void)detailButtonClick {
    if (_detailButtonBlock) {
        _detailButtonBlock();
    }
}

@end
