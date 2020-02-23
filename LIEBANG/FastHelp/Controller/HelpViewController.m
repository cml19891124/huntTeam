//
//  HelpViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/6/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "HelpViewController.h"
#import "FastView.h"

@interface HelpViewController ()

@property (nonatomic,strong)FastView *fastView;

@property (nonatomic,strong)UIView *backView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"快速提问";
    self.view.backgroundColor = kClearColor;
    self.view.superview.backgroundColor = kClearColor;
    
    [self.view addSubview:self.backView];
    [self.view addSubview:self.fastView];
    WeakSelf;
    
    self.fastView.backButtonBlock = ^{
        weakSelf.backView.alpha = 0.0;
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    };
    
    self.fastView.questionButtonBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.backView.alpha = 0.0;
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        });
        if (weakSelf.questionButtonBlock) {
            weakSelf.questionButtonBlock();
        }
    };
    
    self.fastView.friendButtonBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.backView.alpha = 0.0;
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        });
        if (weakSelf.friendButtonBlock) {
            weakSelf.friendButtonBlock();
        }
    };
}

- (FastView *)fastView {
    if (!_fastView) {
        _fastView = [[FastView alloc] initWithFrame:CGRectMake(0, (kDeviceHeight-kCurrentWidth(245))/2, kDeviceWidth, kCurrentWidth(245))];
    }
    return _fastView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        _backView.backgroundColor = kBlackColor;
        _backView.alpha = 0.4;
    }
    return _backView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
