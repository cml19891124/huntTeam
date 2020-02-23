//
//  CompanyMessageViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2019/1/31.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyTextMessageViewController : CommonViewController

@property(nonatomic,copy)void(^editMessageBlock)(NSInteger msgIndex,NSString *message);
@property (nonatomic,strong)NSString *titleString;
@property (nonatomic,strong)NSString *contentString;

@end

NS_ASSUME_NONNULL_END
