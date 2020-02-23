//
//  CommentPickView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommentPickView.h"

@interface CommentPickView ()

@property (nonatomic,strong)UIImageView *headIcon;
@property (nonatomic,strong)UILabel *scoreLabel;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UIButton *closeButton;

@end

@implementation CommentPickView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, kCurrentWidth(145), kDeviceWidth, kCurrentWidth(234));
        self.backgroundColor = [UIColor colorWithHexString:@"313131"];
        self.alpha = 0.5;
        
        _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(70))/2, kCurrentWidth(40)+kCurrentWidth(165)+kNavBarHeight, kCurrentWidth(70), kCurrentWidth(70))];
        _headIcon.contentMode = UIViewContentModeCenter;
//        [self addSubview:_headIcon];
        [[AppDelegate currentAppDelegate].window addSubview:_headIcon];
        
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCurrentWidth(120)+kCurrentWidth(165)+kNavBarHeight, kDeviceWidth, kCurrentWidth(25))];
        _scoreLabel.textColor = kWhiteColor;
        _scoreLabel.font = kSystem(16);
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        [[AppDelegate currentAppDelegate].window addSubview:_scoreLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCurrentWidth(150)+kCurrentWidth(165)+kNavBarHeight, kDeviceWidth, kCurrentWidth(24))];
        _messageLabel.textColor = kWhiteColor;
        _messageLabel.font = kSystem(15);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        [[AppDelegate currentAppDelegate].window addSubview:_messageLabel];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(kDeviceWidth-40, +kCurrentWidth(145)+kNavBarHeight, 40, 30);
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _closeButton.titleLabel.font = kSystem(14);
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [[AppDelegate currentAppDelegate].window addSubview:_closeButton];
        
        
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self removeFromSuperview];
//        });
        
    }
    return self;
}

- (void)closeButtonClick {
    [self removeFromSuperview];
    [_headIcon removeFromSuperview];
    [_scoreLabel removeFromSuperview];
    [_messageLabel removeFromSuperview];
    [_closeButton removeFromSuperview];
}

- (void)setStarNumber:(NSInteger)starNumber {
    _starNumber = starNumber;
    //icon_manyi.png
    switch (starNumber) {
        case 1:
        {
            _headIcon.image = [UIImage imageNamed:@"state_ph_five"];
            _scoreLabel.text = @"非常不满意";
            _messageLabel.text = @"没有解决我的问题";
        }
            break;
        case 2:
        {
            _headIcon.image = [UIImage imageNamed:@"state_ph_four"];
            _scoreLabel.text = @"不满意";
            _messageLabel.text = @"没有解决我的问题";
        }
            break;
        case 3:
        {
            _headIcon.image = [UIImage imageNamed:@"state_ph_three"];
            _scoreLabel.text = @"一般般";
            _messageLabel.text = @"解决了我的问题";
        }
            break;
        case 4:
        {
            _headIcon.image = [UIImage imageNamed:@"state_ph_two"];
            _scoreLabel.text = @"较满意";
            _messageLabel.text = @"解决了我的问题";
        }
            break;
        case 5:
        {
            _headIcon.image = [UIImage imageNamed:@"state_ph_one"];
            _scoreLabel.text = @"非常满意";
            _messageLabel.text = @"解决了我的问题";
        }
            break;
        default:
            break;
    }
}

@end
