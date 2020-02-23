//
//  PayTypeCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTypeCell : UITableViewCell
@property(nonatomic,copy)void(^rechargeButtonBlock)(void);
@property(nonatomic,copy)void(^usePayTypeBlock)(void);
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,strong)NSString *payPrice;

@end
