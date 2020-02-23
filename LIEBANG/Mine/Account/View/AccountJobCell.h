//
//  AccountJobCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 AccountJobCellState
 */
typedef enum{
    AccountJobCellStateStateNormal                             = 0,//
    AccountJobCellStateStateEdit                               = 1,//
    AccountJobCellStateStateDisable                            = 2,//无工作经历
    AccountJobCellStateStateBackGround                         = 3,//背景经历
}AccountJobCellState;

@interface AccountJobCell : UITableViewCell

@property(nonatomic,copy)void(^GetWorkCertiImageViewBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^editButtonBlock)(WorkModel *model);
@property(nonatomic,copy)void(^confimButtonBlock)(WorkModel *model);

@property (nonatomic,assign)AccountJobCellState jobState;
@property (nonatomic,strong)WorkModel *model;

- (CGFloat)getHeight;

@end
