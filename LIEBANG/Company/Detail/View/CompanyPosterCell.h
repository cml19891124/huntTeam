//
//  CompanyPosterCell.h
//  LIEBANG
//
//  Created by  YIQI on 2019/1/3.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyPosterCell : UITableViewCell

@property(nonatomic,copy)void(^saveCompanyPosterBlock)(void);

@end

NS_ASSUME_NONNULL_END
