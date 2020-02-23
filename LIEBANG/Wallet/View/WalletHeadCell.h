//
//  WalletHeadCell.h
//  LIEBANG
//
//  Created by  YIQI on 2019/1/30.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletHeadCell : UITableViewCell

@property(nonatomic,copy)void(^rechargeButtonBlock)(void);
@property(nonatomic,copy)void(^forwardButtonBlock)(void);
@property(nonatomic,strong)NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
