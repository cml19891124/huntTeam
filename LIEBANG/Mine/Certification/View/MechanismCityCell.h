//
//  MechanismCityCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/10/29.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MechanismModel.h"
#import "CompanyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MechanismCityCell : UITableViewCell

@property(nonatomic,copy)void(^editCitySourceBlock)(NSInteger index,NSString *cityName);
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,strong)MechanismModel *model;
@property (nonatomic,strong)CompanyModel *companyModel;

@end

NS_ASSUME_NONNULL_END
