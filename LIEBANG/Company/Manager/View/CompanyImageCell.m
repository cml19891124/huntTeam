//
//  CompanyImageCell.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/2.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "CompanyImageCell.h"

static NSArray *titleArray;
@interface CompanyImageCell ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *iconButton;
@property (nonatomic,strong)UIImageView *icon;

@end

@implementation CompanyImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        titleArray = @[@"* 营业执照",@"背景图"];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(100), kCurrentWidth(44))];
        _titleLabel.font = kSystem(14);
        _titleLabel.textColor = kLBBlackColor;
        [self.contentView addSubview:_titleLabel];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(40), kCurrentWidth(44), kDeviceWidth-kCurrentWidth(80), kCurrentWidth(193))];
        _icon.image = [UIImage imageNamed:@"icon_yingyezhizhao"];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconButtonClick)];
        [self.contentView addSubview:_icon];
        [_icon addGestureRecognizer:tap];
        
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.frame = CGRectMake((kDeviceWidth-kCurrentWidth(98))/2, kCurrentWidth(122), kCurrentWidth(98), kCurrentWidth(40));
        [_iconButton setTitle:@"上传" forState:UIControlStateNormal];
        [_iconButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _iconButton.titleLabel.font = kSystem(15);
        _iconButton.backgroundColor = [UIColor colorWithHexString:@"000000"];
        _iconButton.layer.cornerRadius = kCurrentWidth(20);
        _iconButton.layer.masksToBounds = YES;
        _iconButton.alpha = 0.5;
        [_iconButton addTarget:self action:@selector(iconButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_iconButton];
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    NSString *selectGameText = @"*";
    NSString *allSelectGameText = [titleArray safeObjectAtIndex:indexPath.row-17];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectGameText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithHexString:@"FB3F3F"]
                 range:[allSelectGameText rangeOfString:selectGameText]];
    _titleLabel.attributedText = attr;
}

//- (void)setLicense:(UIImage *)license {
//    if (!IsNilOrNull(license) && self.indexPath.row == 16) {
//        _license = license;
//        
//        _icon.image = license;
//    }
//}
//
//- (void)setBackground:(UIImage *)background {
//    if (!IsNilOrNull(background) && self.indexPath.row == 17) {
//        _background = background;
//        
//        _icon.image = background;
//    }
//}

- (void)setImage:(UIImage *)image {
    if (!IsNilOrNull(image)) {
        _image = image;
        _iconButton.hidden = YES;
        _icon.image = image;
    }
    else {
//        _icon.image = [UIImage imageNamed:@"icon_yingyezhizhao"];
//        _iconButton.hidden = NO;
    }
}

- (void)setCompanyModel:(CompanyModel *)companyModel {
    _companyModel = companyModel;
    
    if (self.indexPath.row == 17) {
        [_icon sd_setImageWithURL:[NSURL URLWithString:companyModel.businessLicense] placeholderImage:[UIImage imageNamed:@"icon_yingyezhizhao"]];
        if (companyModel.businessLicense) {
            _iconButton.hidden = YES;
        }
//        else{
//            _iconButton.hidden = NO;
//        }
    }
    else if (self.indexPath.row == 18) {
        [_icon sd_setImageWithURL:[NSURL URLWithString:companyModel.background] placeholderImage:[UIImage imageNamed:@"icon_yingyezhizhao"]];
        if (companyModel.background) {
            _iconButton.hidden = YES;
        }
//        else{
//            _iconButton.hidden = NO;
//        }
    }
}

#pragma mark Event
- (void)iconButtonClick {
    if (_editSourceBlock) {
        _editSourceBlock(self.indexPath);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
