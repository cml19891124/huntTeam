//
//  AccountBottomView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountBottomView.h"

@interface AccountBottomView ()

@property (nonatomic,strong)UIButton *likeButton;
@property (nonatomic,strong)UIButton *messageButton;
@property (nonatomic,strong)UIButton *questionButton;
@property (nonatomic,strong)UIButton *reserveButton;

@end

@implementation AccountBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, kDeviceHeight-kCurrentWidth(46)-kViewHeight, kDeviceWidth, kCurrentWidth(46));
        self.backgroundColor = kBackgroundColor;
        
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.frame = CGRectMake(0, 0, kCurrentWidth(60), self.height);
        _likeButton.backgroundColor = kWhiteColor;
        [_likeButton setTitle:@"喜欢" forState:UIControlStateNormal];
        [_likeButton setTitleColor:kLBSixColor forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"tab_icon_like.png"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateSelected];
        _likeButton.titleLabel.font = kSystem(11);
        [_likeButton setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(20, 20) space:4];
        [_likeButton addTarget:self action:@selector(likeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeButton];
        
        _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageButton.frame = CGRectMake(_likeButton.right+0.5, 0, kCurrentWidth(60), self.height);
        _messageButton.backgroundColor = kWhiteColor;
        [_messageButton setTitle:@"私信" forState:UIControlStateNormal];
        [_messageButton setTitleColor:kLBSixColor forState:UIControlStateNormal];
        [_messageButton setImage:[UIImage imageNamed:@"tab_icon_sixin.png"] forState:UIControlStateNormal];
        _messageButton.titleLabel.font = kSystem(11);
        [_messageButton setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(20, 20) space:4];
        [_messageButton addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_messageButton];
        
        _questionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _questionButton.frame = CGRectMake(_messageButton.right, 0, kCurrentWidth(120), self.height);
        _questionButton.backgroundColor = [UIColor colorWithHexString:@"AAD6F7"];
        [_questionButton setTitle:@"向TA提问" forState:UIControlStateNormal];
        [_questionButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _questionButton.titleLabel.font = kSystemBold(14);
        [_questionButton addTarget:self action:@selector(questionButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_questionButton];
        
        _reserveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reserveButton.frame = CGRectMake(_questionButton.right, 0, kDeviceWidth-kCurrentWidth(240)-0.5, self.height);
        _reserveButton.backgroundColor = [UIColor colorWithHexString:@"2AA0F8"];
        [_reserveButton setTitle:@"立即预约" forState:UIControlStateNormal];
        [_reserveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _reserveButton.titleLabel.font = kSystemBold(14);
        [_reserveButton addTarget:self action:@selector(reserveButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reserveButton];
    }
    return self;
}

- (void)setLikeStatus:(NSString *)likeStatus {
    
    if ([likeStatus isEqualToString:@"0"])
    {
        _likeButton.selected = NO;
    }
    else if ([likeStatus isEqualToString:@"1"])
    {
        _likeButton.selected = YES;
    }
}

- (NSString *)likeStatus {

    if (_likeButton.selected)
    {
        return @"0";
    }
    return @"1";
}

#pragma mark Event
- (void)likeButtonClick {
    if (_likeButtonBlock) {
        _likeButtonBlock();
    }
}

- (void)messageButtonClick {
    if (_messageButtonBlock) {
        _messageButtonBlock();
    }
}

- (void)questionButtonClick {
    if (_questionButtonBlock) {
        _questionButtonBlock();
    }
}

- (void)reserveButtonClick {
    if (_reserveButtonBlock) {
        _reserveButtonBlock();
    }
}

@end
