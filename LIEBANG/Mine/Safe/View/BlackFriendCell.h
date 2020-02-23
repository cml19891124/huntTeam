//
//  BlackFriendCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/11.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisitorRecordModel.h"

@interface BlackFriendCell : UITableViewCell

@property(nonatomic,copy)void(^GetWorkSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^GetBasicSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^accountButtonBlock)(VisitorModel *friendModel);
@property(nonatomic,copy)void(^sureButtonBlock)(VisitorModel *friendModel);
@property (nonatomic,strong)VisitorModel *model;

@end
