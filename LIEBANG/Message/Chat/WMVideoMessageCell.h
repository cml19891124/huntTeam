//
//  WMVideoMessageCell.h
//  RCIM
//
//  Created by 郑文明 on 16/4/20.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface WMVideoMessageCell : RCMessageCell
@property (nonatomic,strong)UIImageView *bubbleBackgroundView;
@property (nonatomic,strong)UIImageView *backView;

@property (nonatomic,strong)UIImageView *headIcon;
@property (nonatomic,strong)UIImageView *jobImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UIImageView *nameImageView;
@property (nonatomic,strong)UILabel *careerLabel;
@property (nonatomic,strong)UIImageView *careerImageView;
@property (nonatomic,strong)UILabel *tradeLabel;
@property (nonatomic,strong)UIButton *phoneLabel;
@property (nonatomic,strong)UIButton *emailLabel;
@property (nonatomic,strong)UIButton *addressLabel;

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *icon;

- (void)setDataModel:(RCMessageModel *)model;
- (void)initialize;
@end
