//
//  CouponCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/11.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

/**
 CouponCell的样式
 */
typedef enum{
    SureButtonStateNormal                             = 0,//未使用
    SureButtonStateDisabled                           = 1,//已使用、已过期
}CouponCellState;

@interface CouponCell : UITableViewCell

@property(nonatomic,copy)void(^sureButtonBlock)(CouponListModel *couponModel);

@property (nonatomic,assign)CouponCellState couponState;

@property (nonatomic,strong)CouponListModel *couponModel;

@end
