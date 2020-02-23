//
//  UserHelpCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/13.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserHelpModel.h"

@interface UserHelpCell : UITableViewCell

@property (nonatomic,strong)HelpModel *detailModel;

@property (nonatomic,assign)CGFloat cellHeight;

@end
