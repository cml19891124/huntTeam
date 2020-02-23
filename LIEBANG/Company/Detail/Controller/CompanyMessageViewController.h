//
//  CompanyMessageViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2019/1/8.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "CommonViewController.h"
#import "CompanyDetailCell.h"
#import "CompanyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyMessageViewController : CommonViewController

@property (nonatomic,strong)CompanyModel *detailModel;
@property (nonatomic,assign)CompanyDetailCellState detailState;

@end

NS_ASSUME_NONNULL_END
