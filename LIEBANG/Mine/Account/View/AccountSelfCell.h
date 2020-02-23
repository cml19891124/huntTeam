//
//  AccountSelfCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountInfo.h"

@interface AccountSelfCell : UITableViewCell

@property(nonatomic,copy)void(^confimButtonBlock)(void);
- (CGFloat)getHeight;

@property (nonatomic,strong)AccountInfo *model;

@end
