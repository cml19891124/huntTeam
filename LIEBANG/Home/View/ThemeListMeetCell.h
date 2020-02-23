//
//  HomeMeetCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModel.h"
#import "ThemeClassModel.h"
#import "ThemeOrderDetailModel.h"

@interface ThemeListMeetCell : UITableViewCell

@property(nonatomic,copy)void(^deleteButtonBlock)(ThemeClassModel *model);
@property(nonatomic,copy)void(^confimButtonBlock)(ThemeClassModel *model);
@property(nonatomic,copy)void(^GetWorkSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^GetBasicSourceBlock)(NSString *imageUrl);

@property(nonatomic,copy)void(^accountButtonBlock)(void);

@property (nonatomic,strong)ThemeModel *themeModel;

@property (nonatomic,strong)ThemeClassModel *themeClassModel;

@property (nonatomic,strong)ThemeOrderDetailModel *detailModel;

@property (nonatomic,assign)QuestionDetailType detailtype;

@property (nonatomic,assign)CGFloat cellHeight;

@end
