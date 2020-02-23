//
//  CouponViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/25.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponListViewController.h"
#import "TYPagerController.h"
#import "TYTabPagerBar.h"
#import "CouponService.h"

@interface CouponViewController ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;

@property (nonatomic, strong) NSArray *datas;

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的优惠券";
    self.view.backgroundColor = kWhiteColor;
    
    [self setRightNaviBtnTitle:@"优惠券说明"];
    [self.rightNaviBtn addTarget:self action:@selector(couponDetailClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addTabPageBar];
    [self addPagerController];
    [self reloadData];
}

- (void)addTabPageBar {
    _datas = @[@"未使用",@"已使用",@"已过期"];
    
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc] init];
    tabBar.layout.normalTextFont = kSystem(14);
    tabBar.layout.selectedTextFont = kSystem(14);
    tabBar.layout.normalTextColor = kLBBlackColor;
    tabBar.layout.selectedTextColor = kLBRedColor;
    tabBar.layout.progressColor = kLBRedColor;
    tabBar.layout.adjustContentCellsCenter = YES;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    tabBar.layout.cellWidth = CGRectGetWidth(self.view.frame)/3.0;
    tabBar.layout.cellSpacing = 0;
    tabBar.layout.cellEdging = 0;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.layout.prefetchItemCount = 1;
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tabBar.frame = CGRectMake(0, 0 ,kDeviceWidth, kCurrentWidth(43));
    _pagerController.view.frame = CGRectMake(0, CGRectGetHeight(_tabBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetHeight(_tabBar.frame));
}

#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return _datas.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = _datas[index];
    return cell;
}

#pragma mark - TYTabPagerBarDelegate
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = _datas[index];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return _datas.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    CouponListViewController *VC = [[CouponListViewController alloc]init];
    VC.status = [NSString stringWithFormat:@"%zd",index];
    return VC;
}

#pragma mark - TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

#pragma mark Event
- (void)couponDetailClick {
    
    [self displayOverFlowActivityView];
    [CouponService getCouponDetailWithParameters:nil success:^(NSString *success) {
        [self removeOverFlowActivityView];
        WebViewController *nextCtr = [[WebViewController alloc] init];
        nextCtr.navTitle = @"优惠券说明";
        nextCtr.webViewType = WebViewTypeHTML;
        nextCtr.contentString = success;
        [self.navigationController pushViewController:nextCtr animated:YES];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
