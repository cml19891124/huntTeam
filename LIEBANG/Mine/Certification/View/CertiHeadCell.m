//
//  CertiHeadCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/7.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CertiHeadCell.h"

@interface CertiHeadCell ()
@property (nonatomic, weak) UIImageView *titleImageView;
@end

@implementation CertiHeadCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTabTitleImageView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addTabTitleImageView];
    }
    return self;
}

- (void)addTabTitleImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _titleImageView = imageView;
    
//    UILabel *titleLabel = [[UILabel alloc]init];
//    titleLabel.font = [UIFont systemFontOfSize:15];
//    titleLabel.textColor = [UIColor darkTextColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.contentView addSubview:titleLabel];
//    _titleLabel = titleLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleImageView.frame = CGRectMake(0, 0, kCurrentWidth(55), kCurrentWidth(55));
    
    self.titleLabel.frame = self.contentView.bounds;
}


@end
