//
//  CompanyFootView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CompanyBottomView.h"

@interface CompanyBottomView ()

@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,strong)UIButton *editButton;

@property (nonatomic,strong)UIButton *selectButton;

@property (nonatomic,strong)UIImageView *backImageView;

@end

@implementation CompanyBottomView

- (instancetype)initWith:(CGFloat)top
{
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.frame = CGRectMake(0, top, kDeviceWidth, 40);
        
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.frame = CGRectMake(kCurrentWidth(220), 0, self.width-kCurrentWidth(220), 40);
        [_editButton setTitle:@"删除" forState:UIControlStateNormal];
        [_editButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _editButton.titleLabel.font = kSystemBold(16);
        _editButton.backgroundColor = kLBRedColor;
        [_editButton addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_editButton];
        
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(220), 40)];
        _backImageView.image = [UIImage imageNamed:@"Rectangle15"];
        [self addSubview:_backImageView];
        
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(kCurrentWidth(20), 0, kCurrentWidth(200), 40);
        [_selectButton setTitle:@"全部选择" forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"icon_xuanze_weixuanzhong"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"icon_xuanze_dui"] forState:UIControlStateSelected];
        [_selectButton setTitleColor:kLBThreeColor forState:UIControlStateNormal];
        _selectButton.titleLabel.font = kSystem(16);
        _selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _selectButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//        _selectButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
//        [_selectButton setBackgroundImage:[UIImage imageNamed:@"Rectangle15"] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectButton];
    }
    return self;
}

- (void)setFootHidden:(BOOL)footHidden {
    _footHidden = footHidden;
    
    self.hidden = footHidden;
    _selectButton.selected = NO;
}

- (void)selectButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_selectButtonBlock) {
        _selectButtonBlock(sender.selected);
    }
}

- (void)editClick {
    if (_editButtonBlock) {
        _editButtonBlock();
    }
}

@end
