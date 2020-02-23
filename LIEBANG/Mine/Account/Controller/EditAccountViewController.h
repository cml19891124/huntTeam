//
//  EditAccountViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"
#import "EditAccountFootView.h"
#import "AccountModel.h"

/**
 EditAccountCtrlState
 */
typedef enum{
    EditAccountCtrlStateNormal                             = 0,//
    EditAccountCtrlStateVerified                           = 1,//基础认证
    EditAccountCtrlStateAccountVerified                    = 2,//个人页面认证
}EditAccountCtrlState;

@interface EditAccountViewController : CommonViewController

@property(nonatomic,copy)void(^certErrorMessageBlock)(NSString *msg);
@property(nonatomic,copy)void(^certFinshMessageBlock)(NSString *msg);
@property (nonatomic,strong)AccountModel *accountModel;
@property (nonatomic,strong)EditAccountFootView *footView;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)NSMutableArray *fileArray;
@property (nonatomic,assign)EditAccountCtrlState editAccountCtrlState;

- (void)certiBasicRequest:(BOOL)loading;

@end
