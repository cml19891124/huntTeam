//
//  PostAnswerViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/3.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"
#import "QuestionOrderDetailModel.h"

@interface PostAnswerViewController : CommonViewController

@property(nonatomic,copy)void(^refrshDataSourceBlock)(void);
@property (nonatomic,strong)QuestionOrderDetailModel *detailModel;
@property (nonatomic,assign)BOOL isShowAllTitle;

@end
