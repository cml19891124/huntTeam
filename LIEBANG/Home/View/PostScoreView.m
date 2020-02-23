//
//  PostScoreView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PostScoreView.h"

@interface PostScoreView ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *messageLabel;

@property (nonatomic,strong)UIView *contentView;

@end

@implementation PostScoreView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = kBackgroundColor;
        self.frame = CGRectMake(0, kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kCurrentWidth(49)-kViewHeight, kDeviceWidth, kCurrentWidth(49));
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(kCurrentWidth(180), kCurrentWidth(13), kDeviceWidth-kCurrentWidth(180), kCurrentWidth(18))];
        [self addSubview:_contentView];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _contentView.top, kCurrentWidth(170), _contentView.height)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = kLBNineColor;
        _messageLabel.font = kSystem(14);
        _messageLabel.text = @"请评价一下回答吧";
        _messageLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_messageLabel];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCurrentWidth(43), kDeviceWidth, kCurrentWidth(13))];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"F85C38"];
        _titleLabel.font = kSystem(13);
        [self addSubview:_titleLabel];
        
        WeakSelf;
        GRStarsView *starsView4 = [[GRStarsView alloc] initWithStarSize:CGSizeMake(18, 18) margin:10 numberOfStars:5];
        starsView4.allowDecimal = NO;
        starsView4.allowDragSelect = YES;
        starsView4.touchedActionBlock = ^(CGFloat score) {
            NSString *str = [NSString stringWithFormat:@"%f",score];
            weakSelf.starNumber = [str integerValue];
        };
        starsView4.score = 0.0;
        self.starNumber = 0;
        [_contentView addSubview:starsView4];
    }
    return self;
}

- (void)setStarNumber:(NSInteger)starNumber {
    _starNumber = starNumber;
    
    
    switch (starNumber) {
        case 1:
        {
            _titleLabel.height = kCurrentWidth(16);
            if (_scoreButtonBlock) {
                _scoreButtonBlock();
            }
            _titleLabel.text = @"非常不满意";
            [self setViewFrame];
        }
            break;
        case 2:
        {
            _titleLabel.height = kCurrentWidth(16);
            if (_scoreButtonBlock) {
                _scoreButtonBlock();
            }
            _titleLabel.text = @"不满意";
            [self setViewFrame];
        }
            break;
        case 3:
        {
            _titleLabel.height = kCurrentWidth(16);
            if (_scoreButtonBlock) {
                _scoreButtonBlock();
            }
            _titleLabel.text = @"一般般";
            [self setViewFrame];
        }
            break;
        case 4:
        {
            _titleLabel.height = kCurrentWidth(16);
            if (_scoreButtonBlock) {
                _scoreButtonBlock();
            }
            _titleLabel.text = @"较满意";
            [self setViewFrame];
        }
            break;
        case 5:
        {
            _titleLabel.height = kCurrentWidth(16);
            if (_scoreButtonBlock) {
                _scoreButtonBlock();
            }
            _titleLabel.text = @"非常满意";
            [self setViewFrame];
        }
            break;
        default:
        {
            _titleLabel.text = @"";
            [self setViewFrame2];
        }
            break;
    }
}

- (void)setViewFrame {
    self.height = kCurrentWidth(65);
    self.top = kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kCurrentWidth(65)-kViewHeight;
}

- (void)setViewFrame2 {
    self.height = kCurrentWidth(49);
    self.top = kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kCurrentWidth(49)-kViewHeight;
}

@end
