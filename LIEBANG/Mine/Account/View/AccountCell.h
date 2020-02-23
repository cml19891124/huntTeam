//
//  AccountCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDTableViewCell.h"

#import "AccountInfo.h"

/**
 AccountCell的样式
 */
typedef enum{
    AccountCellStateJob                              = 0,//职业标签
    AccountCellStateSource                           = 1,//更多资料
    AccountCellStateHome    //家乡
}AccountCellState;

@interface AccountCell : SDTableViewCell
@property(nonatomic,copy)void(^voteButtonBlock)(UserClassify *model);
@property (nonatomic,assign)AccountCellState accountCellState;

@property (nonatomic,strong)AccountInfo *accountInfo;

@property (nonatomic,strong)NSIndexPath *indexPath;
@end
