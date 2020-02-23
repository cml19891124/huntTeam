//
//  QuestionOrderDetailViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/1.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

#import "QuestionOrderDetailModel.h"

@interface PostMAnswerViewController : CommonViewController

//@property(nonatomic,copy)void(^refrshDataSourceBlock)(NSInteger index);
@property (nonatomic,strong)NSString *orderUid;

@property(nonatomic,copy)void (^refrshDataSourceBlock)(void);

@property (nonatomic,strong)NSString *orderStatus;

@property (nonatomic,assign)QuestionDetailType detailType;

@property (nonatomic,assign)BOOL isPay;

@property (nonatomic,strong)QuestionOrderDetailModel *detailModel;

@end
