//
//  MemberPhoneCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/24.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeOrderDetailModel.h"

@interface MemberPhoneCell : UITableViewCell

@property(nonatomic,copy)void(^GetWorkSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^GetBasicSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^callPhoneButtonBlock)(void);
@property (nonatomic,strong)ThemeOrderDetailModel *detailModel;
@property (nonatomic,strong)NSString *orderStatus;
@end
