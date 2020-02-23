//
//  AnswerDetailView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/4.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionOrderDetailModel.h"
#import "QuestionDetailModel.h"

@interface AnswerDetailView : UITableViewCell

@property(nonatomic,copy)void(^onePayBlock)(void);

@property (nonatomic,strong)QuestionOrderDetailModel *detailModel;
@property (nonatomic,strong)QuestionDetailModel *model;
@property (nonatomic,assign)QuestionDetailType detailType;
@property (nonatomic,assign)BOOL isMy;
@property (nonatomic,assign,readonly)CGFloat viewHeight;

@end
