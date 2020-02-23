//
//  CompanyImageCell.h
//  LIEBANG
//
//  Created by  YIQI on 2019/1/2.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyImageCell : UITableViewCell

@property(nonatomic,copy)void(^editSourceBlock)(NSIndexPath *indexPath);
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)CompanyModel *companyModel;
@property (nonatomic,strong)UIImage *image;//营业执照

@end

NS_ASSUME_NONNULL_END
