//
//  MechanismImageCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/11/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MechanismImageCell : UITableViewCell

@property(nonatomic,copy)void(^editSourceBlock)(void);
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
