//
//  SDTableViewCell.h
//  HuiZe
//
//  Created by  YIQI on 2019/4/17.
//  Copyright © 2019年 yiqi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDTableViewCell : UITableViewCell
/// 是否填充分割线左边空白 默认否
@property(nonatomic,assign) BOOL isZero;
/// 默认cell注册
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/// cell 注册样式
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style;
/// 创建UI
- (void)initView;
/// 刷新数据
- (void)reloadData:(id __nullable)entity;
/// 刷新数据
- (void)reloadData:(id __nullable)entity indexPath:(NSIndexPath *)indexPath;
/// 计算cell高度
+ (CGFloat)calculateHeightWithEntity:(id __nullable)entity;

@end

NS_ASSUME_NONNULL_END
