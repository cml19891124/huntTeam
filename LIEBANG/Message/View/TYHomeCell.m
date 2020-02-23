//
//  MessageTabPagerBarCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/7.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "TYHomeCell.h"

@interface TYHomeCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *redView;
@end

@implementation TYHomeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTabTitleLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addTabTitleLabel];
    }
    return self;
}

- (void)addTabTitleLabel
{
    UIView *markView = [[UIView alloc] init];
    markView.backgroundColor = kRedColor;
    markView.layer.cornerRadius = 3;
    markView.layer.masksToBounds = YES;
    markView.hidden = YES;
    [self.contentView addSubview:markView];
    _redView = markView;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
}

+ (NSString *)cellIdentifier {
    return @"TYHomeCell";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = self.contentView.bounds;
    _redView.frame = CGRectMake(_titleLabel.width/2+20, 10, 6, 6);
}

@end

