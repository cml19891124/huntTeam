//
//  CompanyCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "SDTableViewCell.h"
#import "CompanyModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 HomeQuestionCell的样式
 */
typedef enum{
    CompanyCellStateNormal                               = 0,//
    CompanyCellStateDisable                              = 1,//无按钮
    CompanyCellStateEdit                                 = 2,//编辑 - 认证按钮
}CompanyCellState;

@interface CompanyCell : SDTableViewCell

@property(nonatomic,copy)void(^allPersonnelMessageBlock)(NSString *uid);
@property(nonatomic,copy)void(^daleyMessageBlock)(CompanyModel *companyModel);
@property(nonatomic,copy)void(^certiMessageBlock)(NSString *uid,NSString *status,NSString *time,NSString *level);

/// 头像点击回调block
@property(nonatomic,copy)void(^HeaderPersonnelBlock)(NSString *uid);

@property (nonatomic,assign)CompanyCellState companyState;
@property (nonatomic,strong)CompanyModel *companyModel;

/// 是否认领  认领的不需要显示“续费”按钮
@property (assign, nonatomic) BOOL isRen;
@property (nonatomic,strong)UIButton *daleyButton;
@property (nonatomic,strong)UILabel *dayLabel;

- (void)showCompanyPosterMessage;

@end

NS_ASSUME_NONNULL_END
