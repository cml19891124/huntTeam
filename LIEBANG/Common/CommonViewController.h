//
//  CommonViewController.h
//  Lottery
//
//  Created by YIQI on 2018/3/23.
//  Copyright © 2018年 zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomControllers.h"

@interface CommonViewController : CustomControllers<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UITableView *groupTableView;

@property (nonatomic,assign)BOOL isHiddenBackBtn;

@property(retain,nonatomic)UIButton *rightNaviBtn;
@property(retain,nonatomic)UIButton *rightNavBtn;
@property(retain,nonatomic)UIButton *leftNaviBtn;
@property (nonatomic,strong)UIImageView *noDataImage;


- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay;//延迟调用
- (void)showAlertWithString:(NSString*)message;//提示框
- (void)showHDAlertWithString:(NSString *)message;//黑色提示框 自动消失
- (void)showLoadingViewWithTime:(NSInteger)time;//显示加载等待界面  几秒后小时
- (void)setRightNaviBtnImage:(UIImage *)img image:(UIImage *)image;
- (void)setRightNaviBtnImage:(UIImage*)img;
- (void)setRightNaviBtnTitle:(NSString *)str image:(NSString *)image;
//- (void)setLeftNaviBtnImage:(UIImage*)img;
- (void)setLeftNaviBtnTitle:(NSString*)str image:(NSString *)image;
- (void)setRightNaviBtnTitle:(NSString *)str;
- (void)presentSheet:(NSString *)title;

- (void)displayOverFlowActivityView;

- (void)removeOverFlowActivityView;

- (void)initBackBtn;

- (void)showNoDataWithImage:(NSString *)image;

- (void)hideNoDataImage;

- (void)backNavItemTapped;
@end
