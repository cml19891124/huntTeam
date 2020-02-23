//
//  EditOtherCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/17.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountInfo.h"

@interface EditOtherCell : UITableViewCell

@property (nonatomic,strong)AccountInfo *accountInfo;
@property (nonatomic,strong)NSIndexPath *indexPath;

@end
