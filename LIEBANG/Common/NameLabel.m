//
//  NameLabel.m
//  LIEBANG
//
//  Created by AUX on 2018/8/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "NameLabel.h"
#import "CertiService.h"

@interface NameLabel ()

//@property (nonatomic, strong)UILabel *label;
//@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation NameLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _label.font = kSystem(14);
        _label.textColor = kLBBlackColor;
        
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(self);
        }];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, self.height)];
        _imageView.userInteractionEnabled = NO;
        _imageView.image = [UIImage imageNamed:@"btn.shiming"];
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.hidden = YES;

        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self);
            make.left.mas_equalTo(self.label.mas_right);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(15);
        }];
    }
    return self;
}

- (void)setNameString:(NSString *)nameString showIcon:(NSString *)showIcon {
    
    _label.text = nameString;
    
    CGSize size = [nameString sizeWithFont:_label.font maxSize:CGSizeMake(MAXFLOAT, self.height)];
    _label.width = size.width;
    _imageView.image = IMAGE_NAMED(@"btn.shiming");
    
//    CGSize size = [_label.text sizeWithFont:_font maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(30), self.height)];//文字内容宽度
    if (self.nameWidth == 0.f) {//自身文本文字控件的宽度---存在
        _label.width = size.width;
    }
    else {//自身文本文字控件的宽度---不存在
        if (size.width > self.nameWidth-15.0) {
            _label.width = self.nameWidth-15.0;
        }
        else {
            _label.width = size.width;
        }
    }
    
    if ([showIcon intValue] == 1)
    {
        _imageView.hidden = NO;
        _imageView.left = _label.right+kCurrentWidth(2);
        self.width = _imageView.right - _label.left;

        [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(15);
            make.left.mas_equalTo(self.label.mas_right);
        }];
    }
    else
    {
        _imageView.hidden = YES;
        self.width = _label.width;
        [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}

- (void)renzhenTap:(UITapGestureRecognizer*)tap {
    
    [CertiService getMosaicImageWithType:@"0" userUid:self.userUid success:^(id info) {
        NSString *userCardUrlmosaic = [info objectForKey:@"userCardUrlmosaic"];
        if (!IsStrEmpty(userCardUrlmosaic)) {
            if (self.GetBasicCertiImageViewBlock) {
                self.GetBasicCertiImageViewBlock(userCardUrlmosaic);
            }
        }
    } failure:^(NSUInteger code, NSString *errorStr) {
        
    }];
}

- (CGFloat)nameWidth {
    return self.width;
}

- (void)setLabelFont:(UIFont *)labelFont {
    _labelFont = labelFont;
    _label.font = labelFont;
}

@end
