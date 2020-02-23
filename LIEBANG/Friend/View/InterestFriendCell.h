//
//  InterestFriendCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterestFriendModel.h"
#import "VisitorRecordModel.h"
#import "FriendModel.h"
#import "PendModel.h"
#import "PersonnelModel.h"
#import "CompanyModel.h"

/**
 SureButton的样式
 */
typedef enum{
    SureButtonStateNormal                             = 0,//正常状态--人脉
    SureButtonStateDisabled                           = 1,//禁用状态--人脉
    SureButtonStateMsgNormal                          = 2,//正常状态--消息--你可能感兴趣的好友
    SureButtonStateMsgDisabled                        = 3,//禁用状态--消息--你可能感兴趣的好友
    SureButtonStateMsgPend                            = 4,//待处理申请--消息
    SureButtonStateVisitorNormal                      = 5,//正常状态--访客
    SureButtonStateVisitorDisabled                    = 6,//禁用状态--访客
    SureButtonStateQuestion                           = 7,//提问--选择行家
    SureButtonStateSearchNormal                       = 8,//正常状态--搜索
    SureButtonStateSearchDisabled                     = 9,//禁用状态--搜索
    SureButtonStateSearchNoButton                     = 10,//无按钮状态--搜索
}SureButtonState;

@interface InterestFriendCell : UITableViewCell

@property(nonatomic,copy)void(^GetWorkSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^GetBasicSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^closeButtonBlock)(PendFriendModel *friendModel);
@property(nonatomic,copy)void(^confimButtonBlock)(PendFriendModel *friendModel);
@property(nonatomic,copy)void(^sureButtonBlock)(InterestFriendModel *friendModel);
@property(nonatomic,copy)void(^selectButtonBlock)(id userModel);

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,assign)SureButtonState sureButtonState;

@property (nonatomic,strong)InterestFriendModel *friendModel;

@property (nonatomic,strong)VisitorModel *userModel;

@property (nonatomic,strong)FriendModel *userFriendModel;

@property (nonatomic,strong)PendFriendModel *pendModel;

@property (nonatomic,strong)PersonnelModel *stallModel;

@property (nonatomic,strong)StaffModel *stallTwoModel;

//@property (nonatomic,strong)SearchFriendModel *searchFriendModel;

@end

