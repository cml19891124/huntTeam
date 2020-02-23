//
//  ZZPAlertView.m
//  ZhangZhonePai_iOS
//
//  Created by 朱攀峰 on 2018/1/29.
//  Copyright © 2018年 朱攀峰. All rights reserved.
//

#import "CHAlertView.h"

@implementation CHAlertView

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
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confimAction = [UIAlertAction actionWithTitle:message style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        confim();
    }];
    
    [alertController addAction:confimAction];
    return alertController;
}

+ (UIAlertController *)showMessageWith:(NSString *)message
                                 title:(NSString *)title
                                confim:(void (^)())confim
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confimAction = [UIAlertAction actionWithTitle:message style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        confim();
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:confimAction];
    [alertController addAction:cancelAction];
    return alertController;
}

+ (UIAlertController *)showSheetMessageWith:(NSString *)message
                                       list:(NSArray *)list
                                     confim:(void (^)(NSString *returnInfo))confim
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];//UIAlertControllerStyleActionSheet
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    for (NSString *str in list) {
        UIAlertAction *one = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            confim(str);
        }];
        [alert addAction:one];
    }

    [alert addAction:cancelAction];
    return alert;
}

+ (void)presentHUBMessage:(NSString *)message showView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
    
    MBProgressHUD *progressHud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:progressHud];
   
    progressHud.mode = MBProgressHUDModeText;
    progressHud.label.text = message;
    [progressHud showAnimated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [progressHud hideAnimated:YES];
        [progressHud removeFromSuperview];
    });
}

+ (void)displayOverFlowActivityView:(UIView *)view {
    
    [MBProgressHUD hideHUDForView:view animated:YES];
    
    MBProgressHUD *progressHud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:progressHud];
    [view bringSubviewToFront:progressHud];
    progressHud.mode = MBProgressHUDModeIndeterminate;
    //_progressHud.delegate = self;
    //_HUD.labelText = cString;
    [progressHud showAnimated:YES];
    [progressHud setTag:9955];
    
}

+ (void)removeOverFlowActivityView:(UIView *)view {
    [[view viewWithTag:9955]removeFromSuperview];
}

@end
