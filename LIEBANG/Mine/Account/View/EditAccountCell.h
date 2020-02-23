//
//  EditAccountCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountModel.h"
#import "ThemeOrderDetailModel.h"

/**
 ButtonCell的样式
 */
typedef enum{
    EditAccountCellNormel                             = 0,//正常
    EditAccountCellAccessory                          = 1,//Accessory
    EditAccountCellImage                              = 2,//ImageView
}EditAccountCellState;

@interface EditAccountCell : UITableViewCell

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,assign)EditAccountCellState editAccountCellState;

@property(nonatomic,copy)void(^editMessageBlock)(NSInteger index,NSString *content);

@property (nonatomic,strong)AccountModel *accountModel;

@property (nonatomic,strong)ThemeOrderDetailModel *detailModel;

@property (nonatomic,strong)UIImage *image;

//教育经历、工作经历
- (void)setExperienceDataWith:(NSArray *)titleArray indexPath:(NSIndexPath *)indexPath;

//预约话题时间
- (void)setThemeDataWith:(NSArray *)titleArray plTitleArray:(NSArray *)plTitleArray indexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong)EducationModel *educationModel;
@property (nonatomic,strong)WorkModel *workModel;

@property (nonatomic,strong)UIImageView *rowImage;

@end
