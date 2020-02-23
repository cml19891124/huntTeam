//
//  QuestionStateCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionOrderDetailModel.h"

@interface QuestionStateCell : UIView

@property(nonatomic,copy)void(^messageButtonBlock)(void);

@property (nonatomic,strong)QuestionOrderDetailModel *detailModel;

@property (nonatomic,assign)QuestionDetailType detailType;

@end
