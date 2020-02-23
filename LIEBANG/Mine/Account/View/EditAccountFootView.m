//
//  EditAccountFootView.m
//  LIEBANG
//
//  Created by AUX on 2018/8/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "EditAccountFootView.h"

@interface EditAccountFootView ()

@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *icon;
@property (nonatomic,strong)UIButton *iconButton;
@property (nonatomic,strong)ConfimButton *saveButton;

@end

@implementation EditAccountFootView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(354));
        self.backgroundColor = kWhiteColor;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(150), kCurrentWidth(44))];
        _titleLabel.font = kSystem(15);
        _titleLabel.textColor = kLBBlackColor;
        
        NSString *selectGameText = @"*";
        NSString *allSelectGameText = @"*  手持身份证照片";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectGameText];
        [attr addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorWithHexString:@"FB3F3F"]
                     range:[allSelectGameText rangeOfString:selectGameText]];
        _titleLabel.attributedText = attr;
        [self addSubview:_titleLabel];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(45), kCurrentWidth(44), kDeviceWidth-kCurrentWidth(90), kCurrentWidth(173))];
        _icon.backgroundColor = kBackgroundColor;
        _icon.userInteractionEnabled = YES;
//        _icon.contentMode = UIViewContentModeScaleAspectFill;
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.clipsToBounds = YES;
        _icon.image = [UIImage imageNamed:@"img_shenfenzhengpaishe"];
        [self addSubview:_icon];
        
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.frame = CGRectMake((_icon.width-kCurrentWidth(90))/2, (_icon.height-kCurrentWidth(40))/2, kCurrentWidth(90), kCurrentWidth(40));
        _iconButton.layer.cornerRadius = kCurrentWidth(20);
        _iconButton.layer.masksToBounds = YES;
        [_iconButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"313131"]] forState:UIControlStateNormal];
        _iconButton.alpha = 0.5;
        [_iconButton setTitle:@"上传" forState:UIControlStateNormal];
        _iconButton.titleLabel.font = kSystem(15);
        [_iconButton addTarget:self action:@selector(iconButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_icon addSubview:_iconButton];
        
        self.saveButton = [[ConfimButton alloc] initWithTop:kCurrentWidth(20)+_icon.bottom title:@"保存"];
        [self.saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.saveButton];
    }
    return self;
}

- (void)saveButtonClick {
    if (_saveBasicMessageBlock) {
        _saveBasicMessageBlock();
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _icon.image = image;
}

- (void)setImageString:(NSString *)imageString {
    _imageString = imageString;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"img_shenfenzhengpaishe"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if (!error) {
//            self.upImage = image;
//        }
    }];
}

- (void)setIsSaveButton:(BOOL)isSaveButton {
    _isSaveButton = isSaveButton;
    
    self.saveButton.hidden = isSaveButton;
    if (isSaveButton) {
        self.height = kCurrentWidth(254);
    }
    else {
        self.height = kCurrentWidth(354);
    }
}

- (void)iconButtonClick {
    if (_editSourceBlock) {
        _editSourceBlock();
    }
}

@end
