//
//  UserProtocolCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/29.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "UserProtocolCell.h"

@interface UserProtocolCell ()

@property (nonatomic,strong)UIButton *userProtocolButton;
@property (nonatomic,strong)YYLabel *userProtocolLabel;
@property (nonatomic,strong)UILabel *numberLabel;

@property (nonatomic,strong)UIImageView *markImageView;

@end

@implementation UserProtocolCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(113), 0, kCurrentWidth(100), kCurrentWidth(30))];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    _numberLabel.text = @"0/500";
    _numberLabel.textColor = kLBFiveColor;
    _numberLabel.font = kSystem(12);
    [self addSubview:_numberLabel];
    
    _markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(18), kCurrentWidth(10), kCurrentWidth(6), kCurrentWidth(10))];
    _markImageView.image = [UIImage imageNamed:@"list_btn_enter"];
//    [self addSubview:_markImageView];
    
    _userProtocolButton = [[UIButton alloc] initWithFrame:CGRectMake(kCurrentWidth(8), 0, kCurrentWidth(21), kCurrentWidth(30))];
    [_userProtocolButton setImage:[UIImage imageNamed:@"icon_weixuanzhong_normal"] forState:UIControlStateNormal];
    [_userProtocolButton setImage:[UIImage imageNamed:@"icon_sel_login"] forState:UIControlStateSelected];
    [_userProtocolButton addTarget:self action:@selector(userProtocolClick) forControlEvents:UIControlEventTouchUpInside];
    _userProtocolButton.selected = YES;
    [self addSubview:_userProtocolButton];
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSString *title = @"我已阅读并同意猎帮用户协议";
    CGSize size = [title sizeWithFont:kSystem(12) maxSize:CGSizeMake(MAXFLOAT, kCurrentWidth(30))];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
    [text yy_setColor:kLBRedColor range:[title rangeOfString:@"猎帮用户协议"]];
//    text.yy_underlineColor = kLBRedColor;
    [text yy_setUnderlineStyle:NSUnderlineStyleSingle range:[title rangeOfString:@"猎帮用户协议"]];
    [text yy_setUnderlineColor:kLBRedColor range:[title rangeOfString:@"猎帮用户协议"]];
    [text yy_setTextHighlightRange:[title rangeOfString:@"猎帮用户协议"] color:kLBRedColor backgroundColor:kWhiteColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (self.userProtocolBlock) {
            self.userProtocolBlock();
        }
    }];
    
    _userProtocolLabel = [YYLabel new];
    _userProtocolLabel.userInteractionEnabled = YES;
    _userProtocolLabel.numberOfLines = 0;
    _userProtocolLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _userProtocolLabel.frame = CGRectMake(_userProtocolButton.right, 0, size.width, kCurrentWidth(30));
    _userProtocolLabel.font = kSystem(12);
    _userProtocolLabel.textColor = kLBNineColor;
    _userProtocolLabel.attributedText = text;
    [self addSubview:_userProtocolLabel];
}

- (void)userProtocolClick {
    _userProtocolButton.selected = !_userProtocolButton.selected;
}

- (BOOL)isUserProtocol {
    return _userProtocolButton.selected;
}

- (void)setNumber:(NSInteger)number {
    _number = number;
    
    _numberLabel.text = [NSString stringWithFormat:@"%zd/500",number];
}

- (void)setIsLabelShow:(BOOL)isLabelShow {
    _isLabelShow = isLabelShow;
    
    _markImageView.hidden = isLabelShow;
    _numberLabel.hidden = !isLabelShow;
}

@end
