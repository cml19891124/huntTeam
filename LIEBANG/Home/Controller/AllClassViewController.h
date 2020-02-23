//
//  AllClassViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"


/**
 AllClassState的样式
 */
typedef enum{
    AllClassStateNormal                             = 0,//全部分类
    AllClassStateSelected                           = 1,//选择职业标签
}AllClassState;

@interface AllClassViewController : CommonViewController

@property(nonatomic,copy)void(^saveLabelBlock)(NSString *label,NSString *labelId);

@property (nonatomic,assign)AllClassState classState;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *IDdataSource;
@property (nonatomic,assign)BOOL isQuestion;

@end
