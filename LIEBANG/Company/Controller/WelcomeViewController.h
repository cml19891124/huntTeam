//
//  WelcomeViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WelcomeViewController : CommonViewController

@property (nonatomic,assign)BOOL isRefee;//是否二级页面

@property (nonatomic,assign)BOOL isContiues;//是否续费

@property (nonatomic,assign)BOOL isContiuesTwo;//是否续费(过期)

@property (nonatomic,strong)NSString *companyUid;//续费企业ID
@property (nonatomic,strong)NSString *level;//企业名片付费等级
@end

NS_ASSUME_NONNULL_END
