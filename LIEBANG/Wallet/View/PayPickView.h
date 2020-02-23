//
//  PayPickView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayPickView : UIView

@property(nonatomic,copy)void(^pickBlock)(NSString *string);
@property(nonatomic,assign)CGFloat betPrice;
@property(nonatomic,strong)NSString *payType;
+ (void)showTypePickViewWithAnimation:(BOOL)bAnimation
                             betPrice:(CGFloat)betPrice
                            pickBlock:(void(^)(NSString *string))pickBlock;

@end
