//
//  QuestionDetailViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

@interface QuestionDetailViewController : CommonViewController

@property (nonatomic,strong)NSString *questionUid;

@property (nonatomic,strong)NSString *orderUid;

@property (nonatomic,assign)BOOL isMy;

@property (nonatomic,assign)QuestionDetailType detailType;

@end
