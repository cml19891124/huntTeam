//
//  CouponListViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/11.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"
#import "CouponModel.h"

@interface CouponListViewController : CommonViewController

@property(nonatomic,copy)void(^userCouponBlock)(CouponListModel *couponModel);

@property (nonatomic,strong)NSString *status;

@property (nonatomic,strong)NSString *classifyId;

@property (nonatomic,assign)BOOL isUse;

@property (nonatomic,assign)BOOL isCompany;

@property (nonatomic,strong)NSString *questionPri;

@end

