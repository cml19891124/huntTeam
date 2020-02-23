//
//  CompanyClaimCell.h
//  LIEBANG
//
//  Created by  YIQI on 2019/1/3.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyClaimCell : UITableViewCell
@property(nonatomic,copy)void(^GetWorkSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^GetBasicSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^closeButtonBlock)(PendStallModel *stallModel);
@property(nonatomic,copy)void(^confimButtonBlock)(PendStallModel *stallModel);
@property (nonatomic,strong)PendStallModel *stallModel;

@end

NS_ASSUME_NONNULL_END
