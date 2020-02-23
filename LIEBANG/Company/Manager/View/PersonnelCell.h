//
//  PersonnelCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonnelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonnelCell : UITableViewCell

@property(nonatomic,copy)void(^deletePersonnelBlock)(NSString *userUid);
@property(nonatomic,strong)PersonnelModel *model;


@end

NS_ASSUME_NONNULL_END
