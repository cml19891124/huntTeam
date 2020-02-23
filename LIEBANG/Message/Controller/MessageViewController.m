//
//  MessageViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/6/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "MessageViewController.h"
#import "WMConversationListViewController.h"
#import "VisitorViewController.h"
#import "SystemViewController.h"
#import "InterestFriendViewController.h"
#import "TYPagerController.h"
#import "TYTabPagerBar.h"
#import "MessageService.h"
#import "TYHomeCell.h"

@interface MessageViewController ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;

@property (nonatomic, strong) NSArray *datas;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息中心";
    self.view.backgroundColor = kWhiteColor;
    
    [self addTabPageBar];
    [self addPagerController];
    [self reloadData];
}

 - (void)addTabPageBar {
    _datas = @[@"私信",@"访客",@"系统"];
    
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc] init];
    tabBar.layout.normalTextFont = kSystemBold(14);
    tabBar.layout.selectedTextFont = kSystemBold(14);
    tabBar.layout.normalTextColor = kLBBlackColor;
    tabBar.layout.selectedTextColor = kLBBlackColor;
    tabBar.layout.progressColor = kLBRedColor;
    tabBar.layout.adjustContentCellsCenter = YES;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    tabBar.layout.cellWidth = CGRectGetWidth(self.view.frame)/3.0;
    tabBar.layout.cellSpacing = 0;
    tabBar.layout.cellEdging = 0;
     UIView *line = UIView.new;
     line.frame = CGRectMake(0, kCurrentWidth(39.5), kDeviceWidth, 0.5);
     line.backgroundColor = kSepparteLineColor;
    [tabBar registerClass:[TYHomeCell class] forCellWithReuseIdentifier:[TYHomeCell cellIdentifier]];
    [self.view addSubview:tabBar];
     [tabBar addSubview:line];

    _tabBar = tabBar;
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.layout.prefetchItemCount = 1;
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.scrollView.scrollEnabled = NO;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RCDataManager shareManager] refreshBadgeValue];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[RCDataManager shareManager] refreshBadgeValue];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tabBar.frame = CGRectMake(0, 0 ,kDeviceWidth, kCurrentWidth(40));
    _pagerController.view.frame = CGRectMake(0, CGRectGetHeight(_tabBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetHeight(_tabBar.frame));
}

#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return _datas.count;
}

- (UICollectionViewCell *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    TYHomeCell *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYHomeCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = _datas[index];
    cell.redView.tag = 100000+index;
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
    if (index == 0) {
        WMConversationListViewController *VC = [[WMConversationListViewController alloc]init];
        return VC;
    } else if (index == 1) {
        VisitorViewController *VC = [[VisitorViewController alloc]init];
        return VC;
    } else {
        SystemViewController *VC = [[SystemViewController alloc]init];
        return VC;
    }
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    if (toIndex == 0)
    {
        [self setRightNaviBtnImage:[UIImage imageNamed:@"nav_button_addressbook.png"]];
        [self.rightNaviBtn addTarget:self action:@selector(gotoAddressBook) forControlEvents:UIControlEventTouchUpInside];
    } else if (toIndex == 1)
    {
        [self setRightNaviBtnImage:[UIImage imageNamed:@"nav_button_jiahaoyou.png"]];
        [self.rightNaviBtn addTarget:self action:@selector(gotoAddFriendCtr) forControlEvents:UIControlEventTouchUpInside];
    } else
    {
        [self setRightNaviBtnImage:nil];
    }
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
- (void)gotoAddFriendCtr {
    InterestFriendViewController *nextCtr = [[InterestFriendViewController alloc] init];
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)gotoAddressBook {
    MyFriendViewController *nextCtr = [[MyFriendViewController alloc] init];
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
