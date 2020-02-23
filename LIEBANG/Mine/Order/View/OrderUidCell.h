//
//  OrderUidCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/4.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeOrderDetailModel.h"

@interface OrderUidCell : UITableViewCell

@property (nonatomic,assign)QuestionDetailType detailType;

@property (nonatomic,strong)ThemeOrderDetailModel *detailModel;

@end
