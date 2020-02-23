//
//  ClassListViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ClassListViewController.h"
#import "ThemeListViewController.h"
#import "QuestionListViewController.h"
#import "PostQuestionViewController.h"
#import "TYPagerController.h"
#import "TYTabPagerBar.h"
#import "ClassListHeadView.h"

@interface ClassListViewController ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic,strong)ClassListHeadView *headView;

@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic,assign)BOOL isEncode;

@end

@implementation ClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    
//    [self encodeAllClassifyDataSource];
    
    [self addTabPageBar];
    [self addPagerController];
    [self reloadData];
}

- (void)encodeAllClassifyDataSource {
    
    for (ClassModel *model in self.classModel.data) {
        ClassifyTwoModel *dto = [[ClassifyTwoModel alloc] init];
        dto.id = nil;
        dto.classify = @"全部";
        ClassifyTwoModel *model1 = [model.classifyTwo safeObjectAtIndex:0];
        if (![model1.classify isEqualToString:@"全部"]) {
            [model.classifyTwo insertObject:dto atIndex:0];
        }
    }
}

- (void)addTabPageBar {
    _datas = @[@"话题",@"问答"];
    
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc] init];
    tabBar.layout.barStyle = TYPagerBarStyleProgressBounceView;
    tabBar.layout.normalTextFont = kSystem(16);
    tabBar.layout.selectedTextFont = kSystemBold(16);
    tabBar.layout.normalTextColor = kLBBlackColor;
    tabBar.layout.selectedTextColor = kLBRedColor;
    tabBar.layout.progressColor = kLBRedColor;
    tabBar.layout.cellSpacing = 10;
    tabBar.layout.adjustContentCellsCenter = YES;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    self.navigationItem.titleView = tabBar;
    _tabBar = tabBar;
    
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.layout.prefetchItemCount = 1;
//    pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
    
    if (self.isQuestion) {
        [self.pagerController scrollToControllerAtIndex:1 animate:YES];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tabBar.frame = CGRectMake(0, 0 ,kDeviceWidth, 44);
    _pagerController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
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
    if (index == 0) {
        ThemeListViewController *VC = [[ThemeListViewController alloc]init];
        VC.classModel = self.classModel;
        VC.classifyIndex = self.classifyIndex;
        VC.classify2Index = self.classify2Index+1;
        VC.isOpen = self.isOpen;
        return VC;
    } else {
        QuestionListViewController *VC = [[QuestionListViewController alloc]init];
        VC.classModel = self.classModel;
        VC.classifyIndex = self.classifyIndex;
        VC.classify2Index = self.classify2Index+1;
        VC.isOpen = self.isOpen;
        return VC;
    }
}

#pragma mark - TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    if (toIndex == 0)
    {
        [self setRightNaviBtnTitle:nil];
    } else {
        [self setRightNaviBtnTitle:@"提问"];
        [self.rightNaviBtn addTarget:self action:@selector(postQuestionEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    self.rightNaviBtn.width = 30;//不可设置更大的宽度，否则导致tabbar不居中显示
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

- (void)dealloc {
    self.classModel = nil;
}

- (void)postQuestionEvent {
    PostQuestionViewController *nextCtr = [[PostQuestionViewController alloc] init];
    [Config currentConfig].answerid = nil;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
