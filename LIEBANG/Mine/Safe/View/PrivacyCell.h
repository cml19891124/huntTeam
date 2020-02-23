//
//  PrivacyCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivacyModel.h"

@interface PrivacyCell : UITableViewCell

@property(nonatomic,copy)void(^chooseButtonBlock)(NSIndexPath *indexPath);
@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,strong)PrivacyModel *privacyModel;

@end
