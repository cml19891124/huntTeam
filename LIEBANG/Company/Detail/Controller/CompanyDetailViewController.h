//
//  CompanyDetailViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyDetailViewController : CommonViewController

@property (nonatomic,strong)NSString *companyUid;
@property (nonatomic,strong)NSString *companyName;
@property (nonatomic,strong)NSString *companyType;

/// 是否是自己---从自己的企业信息界面过来，就表示是自己
@property (assign, nonatomic) BOOL isSelf;

/// 是否是个人界面
@property (assign, nonatomic) BOOL isMine;
@end

NS_ASSUME_NONNULL_END
