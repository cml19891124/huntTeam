//
//  PayViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/6/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

@interface PayViewController : CommonViewController

@property(nonatomic,copy)void(^onePayResultBlock)(NSString *orderUid);

@property (nonatomic,strong)NSString *quizcontent;

@property (nonatomic,strong)NSString *questionPri;
@property (nonatomic,strong)NSString *classifyId;

@property (nonatomic,strong)NSString *otherString;
@property (nonatomic,strong)NSString *topicId;

@property (nonatomic,strong)NSString *serviceType;

#pragma mark 问答围观
@property (nonatomic,strong)NSString *questionUid;

@property (nonatomic,assign)BOOL isOne;

@property (nonatomic,strong)NSString *enterpriseId;
@property (nonatomic,strong)NSString *level;
@property (nonatomic,assign)BOOL isContiues;//用来支付时的判断
@property (nonatomic,assign)BOOL isContiuesII;//用来判断支付完成后的跳转

@end
