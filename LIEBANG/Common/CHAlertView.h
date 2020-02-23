//
//  ZZPAlertView.h
//  ZhangZhonePai_iOS
//
//  Created by 朱攀峰 on 2018/1/29.
//  Copyright © 2018年 朱攀峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHAlertView : NSObject

/**
 Alert
 
 @param message message
 @param title title
 @param confim 点击回调
 @return UIAlertController
 */
+ (UIAlertController *)showAlertWith:(NSString *)message
                               title:(NSString *)title
                              confim:(void (^)())confim;


/**
 Alert

 @param message message
 @param title title
 @param confim 点击回调
 @return UIAlertController
 */
+ (UIAlertController *)showMessageWith:(NSString *)message
                                 title:(NSString *)title
                                confim:(void (^)())confim;

/**
 ActionSheet

 @param message message
 @param list list
 @param confim 点击回调
 @return UIAlertController
 */
+ (UIAlertController *)showSheetMessageWith:(NSString *)message
                                       list:(NSArray *)list
                                     confim:(void (^)(NSString *returnInfo))confim;


/**
 半透明提示文字

 @param message 显示文本
 @param view 显示试图
 */
+ (void)presentHUBMessage:(NSString *)message showView:(UIView *)view;

+ (void)displayOverFlowActivityView:(UIView *)view;

+ (void)removeOverFlowActivityView:(UIView *)view;

@end
