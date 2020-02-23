//
//  AppClassifyButton.m
//  LIEBANG
//
//  Created by AUX on 2018/8/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AppClassifyButton.h"

@interface AppClassifyButton ()

@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIImageView *contentView;

@end

@implementation AppClassifyButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _contentView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-45)/2, kCurrentWidth(10), 44, 44)];
        _contentView.image = [UIImage imageNamed:@"home_button_logo"];
        _contentView.layer.cornerRadius = 22;
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _contentView.bottom+kCurrentWidth(5), self.width, 13)];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = kSystem(13);
        _contentLabel.text = @"猎帮";
        _contentLabel.textColor = kLBBlackColor;
        [self addSubview:_contentLabel];
    }
    return self;
}

- (void)setImageString:(NSString *)imageString {
    _imageString = imageString;
    
    if ([imageString containsString:@"http"] || IsStrEmpty(imageString) || IsNilOrNull(imageString)) {
        [_contentView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"home_button_logo"]];
    }
    else {
        _contentView.image = [UIImage imageNamed:imageString];
    }
}

- (void)setContentString:(NSString *)contentString {
    _contentString = contentString;
    
    _contentLabel.text = contentString;
}

@end
