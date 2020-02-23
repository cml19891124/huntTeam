//
//  OrderQuestionCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/20.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeOrderDetailModel.h"

@interface OrderQuestionCell : UITableViewCell



@property (nonatomic,strong)ThemeOrderDetailModel *detailModel;

@property (nonatomic,assign)QuestionDetailType detailType;

- (CGFloat)getCellHeight;

@end
