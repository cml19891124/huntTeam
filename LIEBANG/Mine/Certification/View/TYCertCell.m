//
//  TYCertCell.m
//  LIEBANG
//
//  Created by  YIQI on 2019/3/6.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "TYCertCell.h"

@interface TYCertCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *redView;
@end

@implementation TYCertCell

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
    UIImageView *markView = [[UIImageView alloc] init];
    [self.contentView addSubview:markView];
    _redView = markView;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = kSystem(13);
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
}

+ (NSString *)cellIdentifier {
    return @"TYCertCell";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    _titleLabel.frame = self.contentView.bounds;
    _titleLabel.frame = CGRectMake(0, self.contentView.bounds.size.height-45, self.contentView.bounds.size.width, 30);
    _redView.frame = CGRectMake(_titleLabel.width/2-(45/2), 20, 45, 45);
}


@end
