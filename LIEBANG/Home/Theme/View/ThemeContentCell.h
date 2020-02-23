//
//  ThemeContentCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/29.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeContentCell : UITableViewCell

@property(nonatomic,copy)void(^themeContentBlock)(NSIndexPath *indexPath,NSString *content);
@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,strong)NSString *content;

@end
