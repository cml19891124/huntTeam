//
//  OrderStatusView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
#import "ThemeModel.h"

@interface OrderStatusView : UIView

@property (nonatomic,assign)QuestionDetailType detailType;

@property (nonatomic,strong)QuestionModel *questionModel;

@property (nonatomic,strong)ThemeModel *themeModel;

@end
