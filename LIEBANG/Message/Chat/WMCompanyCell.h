//
//  WMCompanyCell.h
//  LIEBANG
//
//  Created by  YIQI on 2019/1/11.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WMCompanyCell : RCMessageCell

@property (nonatomic,strong)UIImageView *bubbleBackgroundView;
@property (nonatomic,strong)UIImageView *backView;

@property (nonatomic,strong)UIImageView *companyLogo;
@property (nonatomic,strong)UILabel *companyLabel;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *addressLabel;
@property (nonatomic,strong)UILabel *numberLabel;
@property (nonatomic,strong)UILabel *biaoqianLabel;
@property (nonatomic,strong)UILabel *phoneLabel;
@property (nonatomic,strong)UILabel *webLabel;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIImageView *icon;
@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UIImageView *headIcon;
@property (nonatomic,strong)NameLabel *nickLabel;
@property (nonatomic,strong)PostionLabel *postionLabel;
@property (nonatomic,strong)UILabel *tipLabel;

- (void)setDataModel:(RCMessageModel *)model;
- (void)initialize;

@end

NS_ASSUME_NONNULL_END
