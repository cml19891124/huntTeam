//
//  PostionLabel.m
//  LIEBANG
//
//  Created by AUX on 2018/8/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PostionLabel.h"
#import "CertiService.h"

@interface PostionLabel ()

@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation PostionLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = UIColor.blueColor;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _label.textColor = kLBSixColor;
//        _label.backgroundColor = UIColor.redColor;
        [self addSubview:_label];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, self.height)];
        _imageView.image = [UIImage imageNamed:@"icon_bianqian"];
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.hidden = YES;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(renzhenTap:)];
        [_imageView addGestureRecognizer:tap];
        
        [self addSubview:_imageView];

    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.right.mas_lessThanOrEqualTo(0);
    }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.imageView.mas_left).mas_equalTo(-5);
    }];
}

- (void)setCompany:(NSString *)company postion:(NSString *)postion showIcon:(NSString *)showIcon {
    
    _label.text = postion;
    _label.textAlignment = self.alignment;
    
    if (IsStrEmpty(postion))
    {
        _label.text = @" | 未完善公司和职位信息";
    }
    else if (IsStrEmpty(postion) && !IsStrEmpty(company))
    {
        _label.text = [NSString stringWithFormat:@"%@",company];
    }
    else if (!IsStrEmpty(postion) && IsStrEmpty(company))
    {
        _label.text = [NSString stringWithFormat:@"%@",postion];
    }
    else
    {
        _label.text = [NSString stringWithFormat:@" |  %@",postion];
    }
    
    _label.textColor = kLBSixColor;
//    CGSize size = [_label.text sizeWithFont:_font maxSize:CGSizeMake(MAXFLOAT, self.height)];
    CGSize size = BoundWithSize(_label.text, SCREEN_WIDTH, 14).size;
//    CGSize size = [_label.text sizeWithFont:_font maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(30), self.height)];//文字内容宽度
    if (self.labelWidth == 0.f) {//自身文本文字控件的宽度---存在
        _label.width = size.width;
    }
    else {//自身文本文字控件的宽度---不存在
        
        if (size.width >= self.labelWidth-15.0) {
            _label.width = self.labelWidth;
        }
        else {
            _label.width = size.width;
        }
    }
    
    if ([showIcon intValue] == 1)
    {
        _imageView.hidden = NO;
        _imageView.left = _label.right+kCurrentWidth(5);
        self.width = _imageView.right - _label.left;
    }
    else
    {
        _imageView.hidden = YES;
        self.width = _label.width;
    }
}

- (void)renzhenTap:(UITapGestureRecognizer*)tap {
    
    [CertiService getMosaicImageWithType:@"1" userUid:self.userUid success:^(id info) {
        NSString *visitingImagemosaic = [info objectForKey:@"visitingImagemosaic"];
        NSString *certificateImagemosaic = [info objectForKey:@"certificateImagemosaic"];
        NSString *licenseImagemosaic = [info objectForKey:@"licenseImagemosaic"];
        NSString *workCardImagemosaic = [info objectForKey:@"workCardImagemosaic"];
        if (!IsStrEmpty(visitingImagemosaic)) {
            if (self.GetWorkCertiImageViewBlock) {
                self.GetWorkCertiImageViewBlock(visitingImagemosaic);
            }
        }
        if (!IsStrEmpty(certificateImagemosaic)) {
            if (self.GetWorkCertiImageViewBlock) {
                self.GetWorkCertiImageViewBlock(certificateImagemosaic);
            }
        }
        if (!IsStrEmpty(licenseImagemosaic)) {
            if (self.GetWorkCertiImageViewBlock) {
                self.GetWorkCertiImageViewBlock(licenseImagemosaic);
            }
        }
        if (!IsStrEmpty(workCardImagemosaic)) {
            if (self.GetWorkCertiImageViewBlock) {
                self.GetWorkCertiImageViewBlock(workCardImagemosaic);
            }
        }
    } failure:^(NSUInteger code, NSString *errorStr) {
        
    }];
}

- (CGFloat)postionWidth {
    return self.width;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    
    _label.font = font;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    
    _label.textColor = color;
}

- (void)setAlignment:(NSTextAlignment)alignment
{
    _alignment = alignment;
}

@end
