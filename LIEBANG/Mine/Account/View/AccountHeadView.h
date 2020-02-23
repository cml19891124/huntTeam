//
//  AccountHeadView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "SDView.h"

#import "AccountInfo.h"

#import "IQTextView.h"
@interface AccountHeadView : SDView

@property(nonatomic,copy)void(^GetWorkSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^GetBasicSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^accountButtonBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^companyButtonBlock)(NSString *userUid);
@property(nonatomic,copy)void(^editButtonBlock)(void);
@property(nonatomic,copy)void(^confimButtonBlock)(void);

@property(nonatomic,copy)void(^headButtonBlock)(NSInteger index);

@property (nonatomic,assign)AccountState accountState;
@property (nonatomic,strong)AccountInfo *accountInfo;
@property (nonatomic,strong) UILabel *addressLabel;

@end
