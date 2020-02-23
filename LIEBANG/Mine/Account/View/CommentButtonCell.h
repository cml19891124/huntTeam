//
//  CommentButtonCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentButtonCell : UITableViewCell

@property(nonatomic,copy)void(^editButtonBlock)(void);

@property (nonatomic,strong)AccountInfo *accountInfo;

@end
