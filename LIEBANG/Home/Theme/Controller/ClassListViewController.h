//
//  ClassListViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"
#import "AllClassModel.h"

@interface ClassListViewController : CommonViewController

@property (nonatomic,strong)AllClassModel *classModel;

@property (nonatomic,assign)NSInteger classifyIndex;
@property (nonatomic,assign)NSInteger classify2Index;

@property (nonatomic,assign)BOOL isOpen;
@property (nonatomic,assign)BOOL isQuestion;

@end
