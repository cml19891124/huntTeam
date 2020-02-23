//
//  CompanyCertViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2019/1/2.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyCertViewController : CommonViewController

@property (nonatomic,strong)NSString *companyUid;

@property (nonatomic,strong)NSString *level;
@property (nonatomic,strong)NSString *payPrice;
@property (nonatomic,assign)BOOL isModify;

@end

NS_ASSUME_NONNULL_END
