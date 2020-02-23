//
//  WorkCertiViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/7.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"


/**
 WorkCertiState
 */
typedef enum{
    WorkCertiStateNormal                             = 0,//个人信息页面跳转
    WorkCertiStateVerified                           = 1,//个人认证页面跳转
}WorkCertiState;

/**
 职业经历认证
 */
@interface WorkCertiViewController : CommonViewController

@property(nonatomic,copy)void(^GetSourceBlock)(NSString *imageUrl);
@property (nonatomic,assign)WorkCertiState workCertiState;

@property (nonatomic,strong)NSMutableArray *UidSource;
@property (nonatomic,strong)NSMutableArray *failSource;
@property (nonatomic,strong)NSString *workUid;

@end
