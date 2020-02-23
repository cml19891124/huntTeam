//
//  QuestionScoreView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/18.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "QuestionScoreView.h"

@interface QuestionScoreView ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *messageLabel;

@property (nonatomic,strong)UIView *contentView;

@property (nonatomic,strong)UIButton *sureButton;

@end

@implementation QuestionScoreView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = kBackgroundColor;
        self.frame = CGRectMake(0, kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight, kDeviceWidth, kCurrentWidth(49));
        
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
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(0, self.height, kDeviceWidth, 0);
        [_sureButton setBackgroundColor:kLBRedColor];
        _sureButton.titleLabel.font = kSystem(15);
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureButton];
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

- (void)sureButtonClick {
    if (_commentButtonBlock) {
        _commentButtonBlock();
    }
}

- (void)setViewFrame {
    
    self.height = kCurrentWidth(65)+kCurrentWidth(49);
    self.top = kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kCurrentWidth(65)-kViewHeight;
    _sureButton.height = kCurrentWidth(49);
    _sureButton.top = self.height-kCurrentWidth(49);
    [_sureButton setTitle:@"提交评价" forState:UIControlStateNormal];
}

- (void)setViewFrame2 {
    self.height = kCurrentWidth(49);
    self.top = kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight;
    _sureButton.height = 0;
    _sureButton.top = self.height;
    [_sureButton setTitle:@"" forState:UIControlStateNormal];
}

@end
