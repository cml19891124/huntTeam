//
//  ExpertListViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ExpertListViewController.h"
#import "SearchExpertViewController.h"
#import "PayViewController.h"
#import "ExpertViewController.h"
#import "TYPagerController.h"
#import "TYTabPagerBar.h"
#import "HomeService.h"
#import "AllClassModel.h"
#import "QuestionService.h"

@interface ExpertListViewController ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;

@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)NSMutableArray *id_datas;
@property (nonatomic,strong)UIButton *confimButton;

@property (nonatomic,strong)ExpertViewController *VC;

@end

@implementation ExpertListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    self.navigationItem.title = @"选择行家";
    
    [self setRightNaviBtnImage:[UIImage imageNamed:@"nav_button_searchlanse"]];
    [self.rightNaviBtn addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadAllClassDataSource];
}

- (void)backNavItemTapped {
    
    [Config currentConfig].answerid = nil;
    [super backNavItemTapped];
}

#pragma mark DataSource
- (void)loadAllClassDataSource {
    
    _id_datas = [NSMutableArray array];
    _datas = [NSMutableArray array];//推荐的id为0
    [Config currentConfig].answerid = nil;
    
    [self displayOverFlowActivityView];
    
    [QuestionService getQuestionUserClassifyWithSuccess:^(NSArray *info) {
        [self removeOverFlowActivityView];
        for (ClassModel *classModel in info) {
            [_datas addObject:classModel.classify];
            [_id_datas addObject:classModel.id];
        }
        
        [self addTabPageBar];
        [self addPagerController];
        [self reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark Event
- (void)nextButtonClick {
    WeakSelf;
    SearchExpertViewController *nextCtr = [[SearchExpertViewController alloc] init];
    nextCtr.selectedExpertBlock = ^(NSMutableArray *list) {
        weakSelf.VC.searchArray = list;
    };
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)confimButtonClick {
    
    if (IsStrEmpty([Config currentConfig].answerid)) {
        [self showAlertWithString:@"请选择行家"];
        return;
    }
    
    if ([[Config currentConfig].answerid isEqualToString:[Config currentConfig].userUid]) {
        [self showAlertWithString:@"不能向自己提问"];
        return;
    }

    [self displayOverFlowActivityView];
    [QuestionService getUserClassifyWithParameters:[Config currentConfig].answerid success:^(NSString *info) {
        [self removeOverFlowActivityView];
        PayViewController *nextCtr = [[PayViewController alloc] init];
        nextCtr.serviceType = @"在线问答";
        nextCtr.quizcontent = self.quizcontent;
        nextCtr.questionPri = self.questionPri;
        nextCtr.classifyId = info;
        [self.navigationController pushViewController:nextCtr animated:YES];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark TYPagerController
- (void)addTabPageBar {
    
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc] init];
    tabBar.layout.normalTextFont = kSystem(14);
    tabBar.layout.selectedTextFont = kSystem(14);
    tabBar.layout.normalTextColor = kLBBlackColor;
    tabBar.layout.selectedTextColor = kLBRedColor;
    tabBar.layout.progressColor = kLBRedColor;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    tabBar.layout.cellSpacing = kCurrentWidth(10);
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
    
    _confimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confimButton.frame = CGRectMake(0, kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight, kDeviceWidth, kCurrentWidth(49));
    _confimButton.backgroundColor = kLBRedColor;
    [_confimButton setTitle:[NSString stringWithFormat:@"花费%@猎帮币，向TA提问",self.questionPri] forState:UIControlStateNormal];
    [_confimButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _confimButton.titleLabel.font = kSystem(15);
    [_confimButton addTarget:self action:@selector(confimButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confimButton];
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.layout.prefetchItemCount = 0;
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
    _tabBar.frame = CGRectMake(0, 0 ,kDeviceWidth, kCurrentWidth(34));
    _pagerController.view.frame = CGRectMake(0, CGRectGetHeight(_tabBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetHeight(_tabBar.frame)-kCurrentWidth(49)-kViewHeight);
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
    return self.VC;
}

#pragma mark - TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    self.VC.classifyId = [_id_datas safeObjectAtIndex:toIndex];
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

- (ExpertViewController *)VC {
    if (!_VC) {
        _VC = [[ExpertViewController alloc] init];
    }
    return _VC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
