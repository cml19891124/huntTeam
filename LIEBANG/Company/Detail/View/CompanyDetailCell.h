//
//  CompanyDetailCell.h
//  LIEBANG
//
//  Created by  YIQI on 2019/1/8.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 CompanyDetailCellState
 */
typedef enum{
    CompanyDetailCellCompanyInfo                            = 0,//企业信息
    CompanyDetailCellProductService                         = 1,//产品服务
    CompanyDetailCellCompanyDiscuss                         = 2,//企业点评
    CompanyDetailCellrecruit                                = 3,//招聘
}CompanyDetailCellState;

@interface CompanyDetailCell : UITableViewCell

@property(nonatomic,copy)void(^refreshDetailCellBlock)(CompanyDetailCellState detailState);
@property(nonatomic,copy)void(^saveCompanyDetailBlock)(NSString *companyUid);
@property(nonatomic,copy)void(^scanCompanyDetailBlock)(CompanyModel *companyModel);
@property(nonatomic,copy)void(^claimCompanyDetailBlock)(CompanyModel *companyModel);

@property(nonatomic,copy)void(^GetWorkSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^GetBasicSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^sureButtonBlock)(InterestFriendModel *friendModel);

@property (nonatomic,readonly)CGFloat cellHeight;
@property (nonatomic,assign)CompanyDetailCellState detailState;
@property (nonatomic,strong)CompanyModel *companyModel;
@property (nonatomic,strong)NSString *type;//0:自己查看 1:他人查看

@property (strong, nonatomic) UIView *lineV;
- (void)showStallMessage:(BOOL)isShow array:(NSArray *)array isClaim:(BOOL)isClaim;


@end

NS_ASSUME_NONNULL_END
