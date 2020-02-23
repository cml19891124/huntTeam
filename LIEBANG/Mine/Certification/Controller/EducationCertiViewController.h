//
//  EducationCertiViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/7.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"


/**
 EducationCertiState
 */
typedef enum{
    EducationCertiStateNormal                             = 0,//个人信息页面跳转
    EducationCertiStateVerified                           = 1,//个人认证页面跳转
}EducationCertiState;

/**
 教育经历认证
 */
@interface EducationCertiViewController : CommonViewController

@property(nonatomic,copy)void(^GetSourceBlock)(NSString *imageUrl);
@property (nonatomic,assign)EducationCertiState eduCertiState;

@property (nonatomic,strong)NSMutableArray *UidSource;
@property (nonatomic,strong)NSMutableArray *failSource;
@property (nonatomic,strong)NSString *eduUid;

- (instancetype)initWithEduCertiState:(EducationCertiState)eduCertiState;

@end
