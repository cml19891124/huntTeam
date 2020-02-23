//
//  OrderHeadView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderReadModel.h"

@interface OrderHeadView : UIView

@property(nonatomic,copy)void(^headButtonBlock)(NSInteger buttonIndex);
@property (nonatomic,strong)OrderReadModel *readModel;

@end
