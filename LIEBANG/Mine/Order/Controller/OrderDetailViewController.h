//
//  OrderDetailViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/20.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

/**
 线下约见
 */
@interface OrderDetailViewController : CommonViewController

@property(nonatomic,copy)void(^refrshDataSourceBlock)(NSInteger index);
@property (nonatomic,strong)NSString *orderUid;

@property (nonatomic,strong)NSString *orderStatus;

@property (nonatomic,assign)QuestionDetailType detailType;

@property (nonatomic,assign)BOOL isPay;

@end
