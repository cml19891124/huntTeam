//
//  CommonNavgationViewController.m
//  Storm
//
//  Created by 朱攀峰 on 15/11/27.
//  Copyright (c) 2015年 MCDS. All rights reserved.
//

#import "CommonNavgationViewController.h"
#import "CommonNavigationBar.h"
#import <objc/runtime.h>

//需要隐藏navigationBar的Controller
static NSArray *hiddenNavBarClassArray = nil;

@interface CommonNavgationViewController ()

@end

@implementation CommonNavgationViewController

+ (void)initialize {
    hiddenNavBarClassArray = [[NSArray alloc] initWithObjects:
                              NSClassFromString(@"AccountViewController"),
                              NSClassFromString(@"HXDatePhotoEditViewController"),
                              NSClassFromString(@"HelpViewController"),
                              NSClassFromString(@"WelcomeViewController"),
                              nil];
}

- (void)loadView {
    [super loadView];
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self setNavBarBackgroundWithColor];
    } else {
        object_setClass(self.navigationBar, [CommonNavigationBar class]);
    }
    self.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    [self.view addSubview:self.backgroundView];
    [self.view sendSubviewToBack:_backgroundView];
}

- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] init];
        CGRect frame = [[UIScreen mainScreen] bounds];
        _backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        //_backgroundView.image = [UIImage imageNamed:@""];
        _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundView;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    Class vcClass = [viewController class];
    
    if ([hiddenNavBarClassArray containsObject:vcClass]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    }
    else
    {
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
    [super presentModalViewController:modalViewController animated:animated];
}

- (void)setNavBarBackgroundWithColor {
    self.navigationBar.alpha = 0.0f;
    self.navigationBar.translucent = NO;
    
//    UIImage *backGroundImage = [UIImage imageNamed:@"zhuangtailan"];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kLBBlackColor,NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
//    [[UINavigationBar appearance] setBackgroundImage:backGroundImage forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector  (interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
    UIViewController *vc = [self.viewControllers objectAtIndex:0];
    vc.hidesBottomBarWhenPushed = NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (gestureRecognizer == self.interactivePopGestureRecognizer) {
            if (self.viewControllers.count == 1) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
