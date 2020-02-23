//
//  OrderConfimCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/4.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeOrderDetailModel.h"

@interface OrderConfimCell : UITableViewCell

@property(nonatomic,copy)void(^messageButtonBlock)(void);

@property (nonatomic,strong)ThemeOrderDetailModel *detailModel;

@property (nonatomic,assign)QuestionDetailType detailType;

- (CGFloat)getCellHeight;

@end
