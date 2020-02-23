//
//  PayTypePickView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/11.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTypePickView : UIView
@property(nonatomic,copy)void(^pickBlock)(NSString *string);

@property(nonatomic,strong)NSString *payType;

@property(nonatomic,assign)BOOL isRecharge;

+ (void)showTypePickViewWithAnimation:(BOOL)bAnimation
                           isRecharge:(BOOL)isRecharge
                              payType:(NSString *)payType
                            pickBlock:(void(^)(NSString *string))pickBlock;

@end
