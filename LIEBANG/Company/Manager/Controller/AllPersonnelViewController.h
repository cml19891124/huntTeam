//
//  AllPersonnelViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AllPersonnelViewController : CommonViewController

@property (nonatomic,strong)NSString *enterpriseId;
@property (nonatomic,strong)NSString *type;//0:自己查看 1:他人查看

@end

NS_ASSUME_NONNULL_END
