//
//  AllCommentButtonCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountInfo.h"

@interface AllCommentButtonCell : UITableViewCell

@property(nonatomic,copy)void(^editButtonBlock)(BOOL isOpen);

@property (nonatomic,strong)AccountInfo *accountInfo;

@end
