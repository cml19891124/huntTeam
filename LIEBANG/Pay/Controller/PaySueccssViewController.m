//
//  PaySueccssViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PaySueccssViewController.h"

@interface PaySueccssViewController ()

@end

@implementation PaySueccssViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"建立企业AI智能名片";
    self.view.backgroundColor = kWhiteColor;
    
    UIButton *stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stateButton.frame = CGRectMake(0, (kDeviceHeight-kNavBarHeight-kViewHeight-kCurrentWidth(92))/2-kCurrentWidth(60), kDeviceWidth, kCurrentWidth(50));
    [stateButton setTitle:@"已支付" forState:UIControlStateNormal];
    [stateButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
    [stateButton setImage:[UIImage imageNamed:@"icon_sel.png"] forState:UIControlStateNormal];
    stateButton.titleLabel.font = kSystemBold(16);
    [stateButton setImgViewStyle:ButtonImgViewStyleLeft imageSize:CGSizeMake(45, 45) space:12];
    [self.view addSubview:stateButton];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, stateButton.bottom+kCurrentWidth(15), kDeviceWidth, kCurrentWidth(20))];
    titleLabel.font = kSystemBold(14);
    titleLabel.text = @"下一步，去建立企业AI智能名片";
    titleLabel.textColor = kLBNineColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(kCurrentWidth(12), kDeviceHeight-kNavBarHeight-kViewHeight-kCurrentWidth(92), kDeviceWidth-kCurrentWidth(24), kCurrentWidth(49));
    [sureButton setTitle:@"下一步" forState:UIControlStateNormal];
    [sureButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    sureButton.titleLabel.font = kSystemBold(16);
    sureButton.layer.cornerRadius = 3;
    sureButton.layer.masksToBounds = YES;
    sureButton.backgroundColor = kLBRedColor;
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
}

- (void)sureButtonClick {
    
}

- (void)backNavItemTapped {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
