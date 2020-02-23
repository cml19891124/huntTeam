//
//  HomeQuestionCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
#import "QuestionClassModel.h"
#import "QuestionDetailModel.h"

/**
 HomeQuestionCell的样式
 */
typedef enum{
    HomeQuestionCellNormal                             = 0,//
    HomeQuestionCellOrder                              = 1,//订单
}HomeQuestionCellState;

@interface HomeQuestionCell : UITableViewCell

@property(nonatomic,copy)void(^GetWorkSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^GetBasicSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^accountButtonBlock)(void);

@property (nonatomic,strong)QuestionModel *questionModel;

@property (nonatomic,strong)QuestionClassModel *questionClassModel;

@property (nonatomic,assign)HomeQuestionCellState questionCellState;

@property (nonatomic,strong)RecommendQuestionModel *recommendModel;

@property (nonatomic,assign)QuestionDetailType detailType;

- (CGFloat)getHeight;

@end
