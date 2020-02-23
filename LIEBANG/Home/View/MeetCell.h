//
//  MeetCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/25.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModel.h"

@interface MeetCell : UITableViewCell


@property (nonatomic,strong)ThemeClassModel *themeClassModel;

@property (nonatomic,strong)ThemeOrderDetailModel *detailModel;

@property (nonatomic,assign)CGFloat cellHeight;

@property (nonatomic,assign)BOOL ishelp;

@end
