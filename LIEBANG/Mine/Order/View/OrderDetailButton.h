//
//  OrderDetailButton.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/24.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeOrderDetailModel.h"

#warning 可以统一到订单详情状态里面
/**
 OrderDetailButtonState的样式
 */
typedef enum{
    OrderDetailButtonStateNormal                             = 0,//确定预约
    OrderDetailButtonStateDisabled                           = 1,//预约其他行家
    OrderDetailButtonStateServiceCompleted                   = 2,//服务完成
    OrderDetailButtonStateSureCompleted                      = 3,//确认完成
    OrderDetailButtonStatePostComment                        = 4,//提交评论
    OrderDetailButtonStateRemind                             = 5,//提醒行家确认
    OrderDetailButtonStateNOButton                           = 6,//没有按钮
    OrderDetailButtonStateAccount                            = 7,//去他人主页
}OrderDetailButtonState;

@interface OrderDetailButton : UIView

@property(nonatomic,copy)void(^reserveOtherButtonBlock)(OrderDetailButtonState buttonState);
@property(nonatomic,copy)void(^messageButtonBlock)(void);
@property(nonatomic,copy)void(^confimButtonBlock)(OrderDetailButtonState buttonState);
@property (nonatomic,assign)OrderDetailButtonState buttonState;

@property (nonatomic,assign)QuestionDetailType detailType;
@property (nonatomic,strong)ThemeOrderDetailModel *detailModel;

@end
