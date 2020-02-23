//
//  QuestionListViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/25.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"
#import "AllClassModel.h"

@interface QuestionListViewController : CommonViewController

@property (nonatomic,strong)AllClassModel *classModel;

@property (nonatomic,assign)NSInteger classifyIndex;
@property (nonatomic,assign)NSInteger classify2Index;

@property (nonatomic,assign)BOOL isOpen;

@end
