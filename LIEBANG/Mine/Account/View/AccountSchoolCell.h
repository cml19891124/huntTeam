//
//  AccountSchoolCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EducationModel.h"

/**
 AccountSchoolCellState
 */
typedef enum{
    AccountSchoolCellStateNormal                             = 0,//
    AccountSchoolCellStateEdit                               = 1,//
    AccountSchoolCellStateDisable                            = 2,//无教育经历
    AccountSchoolCellStateBackGround                         = 3,//背景经历
}AccountSchoolCellState;

@interface AccountSchoolCell : UITableViewCell
@property(nonatomic,copy)void(^GetEduCertiImageViewBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^editButtonBlock)(EducationModel *model);
@property(nonatomic,copy)void(^confimButtonBlock)(EducationModel *model);
@property (nonatomic,strong)EducationModel *model;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,assign)AccountSchoolCellState schoolState;

@property (nonatomic,assign)CGFloat cellHeight;

@end
