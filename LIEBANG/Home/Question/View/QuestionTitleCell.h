//
//  QuestionTitleCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionOrderDetailModel.h"
#import "QuestionDetailModel.h"

@interface QuestionTitleCell : UITableViewCell

@property(nonatomic,copy)void(^questionButtonBlock)(BOOL isShowAllTitle);

@property (nonatomic,strong)QuestionOrderDetailModel *detailModel;

@property (nonatomic,strong)QuestionDetailModel *model;

@property (nonatomic,assign)CGFloat cellHeight;

@property (nonatomic,assign)BOOL isShowNum;

@property (nonatomic,assign)BOOL isShowAllTitle;

@end
