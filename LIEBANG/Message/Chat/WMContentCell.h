//
//  WMContentCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/11/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WMContentCell : RCMessageCell

@property (nonatomic,strong)UIImageView *bubbleBackgroundView;
@property (nonatomic,strong)UIImageView *backView;

@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UILabel *tradeLabel;

- (void)setDataModel:(RCMessageModel *)model;
- (void)initialize;

@end

NS_ASSUME_NONNULL_END
