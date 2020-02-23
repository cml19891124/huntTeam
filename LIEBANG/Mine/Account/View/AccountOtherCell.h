//
//  AccountOtherCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountOtherCell : UITableViewCell

@property(nonatomic,copy)void(^confimButtonBlock)(void);
@property(nonatomic,copy)void(^useHelpBlock)(void);
- (CGFloat)getHeight;

@end
