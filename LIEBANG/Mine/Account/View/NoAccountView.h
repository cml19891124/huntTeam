//
//  NoAccountView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/24.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoAccountView : UIView

@property(nonatomic,copy)void(^backButtonBlock)(void);

@property (nonatomic,strong)NSString *titleString;

@end

NS_ASSUME_NONNULL_END
