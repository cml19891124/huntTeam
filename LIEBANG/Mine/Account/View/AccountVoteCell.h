//
//  AccountVoteCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountVoteCell : UITableViewCell

@property(nonatomic,copy)void(^accountButtonBlock)(Comment *model);
@property(nonatomic,copy)void(^voteButtonBlock)(Comment *model);
@property (nonatomic,strong)Comment *model;
@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,assign)AccountState accountState;
@end
