//
//  GRCertiViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"


/**
 个人认证
 */
@interface GRCertiViewController : CommonViewController

@property (nonatomic,strong)NSString *type;

@property (nonatomic,assign)BOOL isReUpload;//审核失败后重新提交

@end
