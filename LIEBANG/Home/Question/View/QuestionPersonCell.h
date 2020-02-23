//
//  QuestionPersonCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionOrderDetailModel.h"
#import "QuestionDetailModel.h"

@interface QuestionPersonCell : UITableViewCell

@property(nonatomic,copy)void(^GetWorkSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^GetBasicSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^questionButtonBlock)(void);

@property (nonatomic,strong)QuestionOrderDetailModel *detailModel;

@property (nonatomic,strong)QuestionDetailModel *model;

@property (nonatomic,assign)QuestionDetailType detailType;

@end
