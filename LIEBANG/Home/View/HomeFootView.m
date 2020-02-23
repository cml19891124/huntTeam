//
//  HomeFootView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "HomeFootView.h"

@interface HomeFootView ()

@property (nonatomic,strong)UIButton *allButton;

@end

@implementation HomeFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _allButton.frame = CGRectMake((kDeviceWidth-kCurrentWidth(104))/2, kCurrentWidth(25), kCurrentWidth(104), kCurrentWidth(32));
        [_allButton setTitle:@"查看全部分类" forState:UIControlStateNormal];
        [_allButton setTitleColor:[UIColor colorWithHexString:@"FC6A55"] forState:UIControlStateNormal];
        _allButton.titleLabel.font = kSystem(14);
        _allButton.layer.borderColor = [UIColor colorWithHexString:@"FC6A55"].CGColor;
        _allButton.layer.borderWidth = 1;
        _allButton.layer.cornerRadius = 4;
        _allButton.layer.masksToBounds = YES;
        [_allButton addTarget:self action:@selector(allButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_allButton];
    }
    return self;
}

- (void)allButtonClick {
    if (_allClassBlock) {
        _allClassBlock();
    }
}

@end
