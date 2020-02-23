//
//  CertFailureViewController.h
//  LIEBANG
//
//  Created by caominglei on 2019/10/30.
//  Copyright © 2019  YIQI. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CertFailureViewController : CommonViewController

@property (strong, nonatomic) CompanyModel *model;

@property (nonatomic,strong)NSString *companyUid;

@property (nonatomic,strong)NSString *level;

@end

NS_ASSUME_NONNULL_END
