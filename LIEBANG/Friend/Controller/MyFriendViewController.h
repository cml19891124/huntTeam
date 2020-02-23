//
//  MyFriendViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"
#import "FriendModel.h"
#import "WMCardMessage.h"
#import "WMContent.h"
#import "WMCompanyMessage.h"

@interface MyFriendViewController : CommonViewController

@property(nonatomic,copy)void(^messageButtonBlock)(FriendModel *model);

@property (nonatomic,strong)NSString *userUid;

@property (nonatomic,strong)NSString *message;

@property (nonatomic,strong)WMCardMessage *cardMessage;

@property (nonatomic,strong)WMContent *shareMessage;

@property (nonatomic,strong)WMCompanyMessage *companyMessage;

@end
