//
//  MineHeadCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountInfo.h"

@interface MineHeadCell : UITableViewCell

@property(nonatomic,copy)void(^GetWorkSourceBlock)(NSString *imageUrl);

@property(nonatomic,copy)void(^GetBasicSourceBlock)(NSString *imageUrl);

@property (strong, nonatomic) AccountInfo *model;

@end

