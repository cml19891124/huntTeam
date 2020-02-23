//
//  RCCustomCell.h
//  RCIM
//
//  Created by 郑文明 on 15/12/30.
//  Copyright © 2015年 郑文明. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

#define kCellHeight 80

@interface RCCustomCell : RCConversationBaseCell

@property(nonatomic,copy)void(^GetWorkSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^GetBasicSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^accountButtonBlock)(void);
///头像
@property (nonatomic,retain) UIImageView *avatarIV;
///真实姓名
@property (nonatomic,retain) NameLabel *nameLabel;
//职位
@property (nonatomic,retain) PostionLabel *jobLabel;
///时间
@property (nonatomic,retain) UILabel *timeLabel;
///内容
@property (nonatomic,retain) UILabel *contentLabel;
///角标（UIView）
@property (nonatomic,retain) UILabel *ppBadgeView;

@property (nonatomic,retain) NSString *name;

- (void)setConversationModel:(RCConversationModel *)model;

@end
