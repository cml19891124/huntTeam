//
//  QuestionOrderDetailViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/1.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

@interface QuestionOrderDetailViewController : CommonViewController

@property(nonatomic,copy)void(^refrshDataSourceBlock)(NSInteger index);
@property (nonatomic,strong)NSString *orderUid;

@property (nonatomic,strong)NSString *orderStatus;

@property (nonatomic,assign)QuestionDetailType detailType;

@property (nonatomic,assign)BOOL isPay;

@end
