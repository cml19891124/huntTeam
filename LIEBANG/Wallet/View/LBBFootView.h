//
//  LBBFootView.h
//  LIEBANG
//
//  Created by  YIQI on 2019/1/29.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LBBFootView : UIView

@property(nonatomic,copy)void(^LBBConfimBlock)(void);
@property(nonatomic,copy)void(^useHelpBlock)(void);
@property(nonatomic,copy)void(^useProtocolBlock)(void);

@end

NS_ASSUME_NONNULL_END
