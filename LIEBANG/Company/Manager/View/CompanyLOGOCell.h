//
//  CompanyLOGOCell.h
//  LIEBANG
//
//  Created by  YIQI on 2019/1/3.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyLOGOCell : UITableViewCell

@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)CompanyModel *companyModel;

@end

NS_ASSUME_NONNULL_END
