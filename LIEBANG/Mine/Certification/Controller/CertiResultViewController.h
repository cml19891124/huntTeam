//
//  CertiResultViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

/**
 CertiResultCtrl的样式
 */
typedef enum{
    CertiResultCtrlNormal                             = 0,//正在审核
    CertiResultCtrlFail                               = 1,//审核失败
    CertiResultCtrlSuccess                            = 2,//审核成功
    CertiResultCtrlCompanyNormal                      = 3,//企业审核提交成功
    CertiResultCtrlCompanySuccess                     = 4,//企业审核成功
}CertiResultCtrl;

@interface CertiResultViewController : CommonViewController

@property (nonatomic,assign)CertiResultCtrl certiResultCtrl;

@property (nonatomic,strong)NSString *message;

@property (nonatomic,strong)NSString *pushType;

@property (nonatomic,strong)NSString *failReason;
@property (nonatomic,strong)NSString *failType;
@property (nonatomic,strong)NSString *companyUid;

/// 从编辑企业名片来
@property (assign, nonatomic) BOOL push;

@property (assign, nonatomic) BOOL isSelf;
@end
