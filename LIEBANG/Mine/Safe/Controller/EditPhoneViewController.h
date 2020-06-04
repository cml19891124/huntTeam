//
//  EditPhoneViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/8.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

/**
 EditPhoneState的样式
 */
typedef enum{
    EditPhoneStateNormal                                 = 0,//绑定手机号
    EditPhoneStateModifyOne                              = 1,//修改手机号1
    EditPhoneStateModifyTwo                              = 2,//修改手机号2
}EditPhoneState;

@interface EditPhoneViewController : CommonViewController

@property (nonatomic,assign)EditPhoneState editPhoneState;

@property (nonatomic,strong)NSString *openUid;

@property (nonatomic,strong)NSString *yuer;

@end
