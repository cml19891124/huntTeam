//
//  HomeButton.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "HomeButton.h"

@interface HomeButton ()

@property (nonatomic,strong)UILabel *buttonTitleLabel;
@property (nonatomic,strong)UILabel *buttonMessageLabel;
@property (nonatomic,strong)UIImageView *buttonImageView;
@property (nonatomic,strong)UIImageView *markImageView;

@end

@implementation HomeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"F9F9F9"];
        
        _buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(113), kCurrentWidth(24), kCurrentWidth(28), kCurrentWidth(28))];
        [self addSubview:_buttonImageView];
        
        _markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(79), kCurrentWidth(16), kCurrentWidth(24), kCurrentWidth(15))];
        _markImageView.image = [UIImage imageNamed:@"list_button_new"];
        _markImageView.hidden = YES;
        [self addSubview:_markImageView];
        
        _buttonTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(10), kCurrentWidth(23), kCurrentWidth(70), kCurrentWidth(15))];
        _buttonTitleLabel.textColor = kLBRedColor;
        _buttonTitleLabel.font = kSystem(16);
        _buttonTitleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_buttonTitleLabel];
        
        _buttonMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(10), kCurrentWidth(3)+_buttonTitleLabel.bottom, kCurrentWidth(90), kCurrentWidth(15))];
        _buttonMessageLabel.textColor = kLBNineColor;
        _buttonMessageLabel.font = kSystem(kCurrentWidth(11));
        _buttonMessageLabel.numberOfLines = 0;
        [self addSubview:_buttonMessageLabel];
    }
    return self;
}

- (void)setIsLoad:(BOOL)isLoad {
    _isLoad = isLoad;
    _markImageView.hidden = !isLoad;
}

- (void)setTitle:(NSString *)title message:(NSString *)message imageString:(NSString *)imageString {
    _buttonTitleLabel.text = title;
    _buttonImageView.image = [UIImage imageNamed:imageString];
    
    CGSize size = [message sizeWithFont:kSystem(kCurrentWidth(11)) maxSize:CGSizeMake(kCurrentWidth(90), MAXFLOAT)];
    _buttonMessageLabel.text = message;
    
    if ([title isEqualToString:@"我要提问"])
    {
        _buttonImageView.left = kCurrentWidth(29);
        _buttonTitleLabel.left = _buttonImageView.right+kCurrentWidth(17);
        _buttonMessageLabel.frame = CGRectMake(_buttonImageView.right+kCurrentWidth(17), kCurrentWidth(3)+_buttonTitleLabel.bottom, kCurrentWidth(90), size.height);
    }
    else
    {
        _buttonTitleLabel.left = kCurrentWidth(22);
        _buttonMessageLabel.frame = CGRectMake(kCurrentWidth(22), kCurrentWidth(3)+_buttonTitleLabel.bottom, kCurrentWidth(90), size.height);
        _buttonImageView.left = self.width-kCurrentWidth(50);
    }
}

@end
