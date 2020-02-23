//
//  CompanyFeeViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyFeeViewController : CommonViewController

@property (nonatomic,strong)NSString *companyUid;

//续费
@property (nonatomic,strong)NSString *serviceType;
@property (nonatomic,assign)BOOL isOne;
@property (nonatomic,strong)NSString *enterpriseId;
@property (nonatomic,strong)NSString *level;
@property (nonatomic,assign)BOOL isContiues;//用来支付时的判断
@property (nonatomic,assign)BOOL isContiuesII;//用来判断支付完成后的跳转

@end

NS_ASSUME_NONNULL_END
