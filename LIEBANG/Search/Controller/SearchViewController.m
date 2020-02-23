//
//  SearchViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/11.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "SearchViewController.h"
#import "MESearchTextField.h"

#import "SearchThemeViewController.h"
#import "SearchFriendViewController.h"
#import "SearchQuestionViewController.h"
#import "TYPagerController.h"
#import "TYTabPagerBar.h"

@interface SearchViewController ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate,UITextFieldDelegate>
{
    NSInteger currentIndex;
}
@property (nonatomic,strong)UITextField *searchTf;
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;

@property (nonatomic,strong)SearchThemeViewController *themeVC;

@property (nonatomic,strong)SearchQuestionViewController *questionVC;

@property (nonatomic,strong)SearchFriendViewController *friendVC;

@property (nonatomic, strong) NSArray *datas;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavSubViews];
    [self addTabPageBar];
    [self addPagerController];
    [self reloadData];
}

- (void)addTabPageBar {
    _datas = @[@"话题",@"问答",@"好友/人脉"];
    
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc] init];
    tabBar.layout.normalTextFont = kSystem(14);
    tabBar.layout.selectedTextFont = kSystem(14);
    tabBar.layout.normalTextColor = kLBNineColor;
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
    //    pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
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
    _tabBar.frame = CGRectMake(0, 0 ,kDeviceWidth, kCurrentWidth(40));
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
    if (index == 0)
    {
        return self.themeVC;
    }
    else if (index == 1)
    {
        return self.questionVC;
    }
    else
    {
        return self.friendVC;
    }
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    currentIndex = toIndex;
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.searchTf resignFirstResponder];
    
    if (IsStrEmpty(textField.text)) {
        [self showAlertWithString:@"请输入搜索关键字"];
        return NO;
    }
    if (currentIndex == 0)
    {
        self.themeVC.themeString = textField.text;
    }
    else if (currentIndex == 1)
    {
        self.questionVC.questionString = textField.text;
    }
    else if (currentIndex == 2)
    {
        self.friendVC.friendString = textField.text;
    }
    return YES;
}

- (void)backNavItemTapped {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)createNavSubViews {
    self.view.backgroundColor = kWhiteColor;
    
    self.searchTf = [[MESearchTextField alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-kCurrentWidth(70), 30)];
    self.searchTf.placeholder = @" 搜索行家帮手、话题或问答";
    self.searchTf.backgroundColor = [UIColor colorWithHexString:@"FAFAFA"];
    self.searchTf.font = kSystem(14);
    self.searchTf.layer.cornerRadius = 15;
    self.searchTf.layer.masksToBounds = YES;
    self.searchTf.layer.borderColor = kLBRedColor.CGColor;
    self.searchTf.layer.borderWidth = 0.5;
    self.searchTf.returnKeyType = UIReturnKeySearch;
    self.searchTf.delegate = self;
    
    UIButton *searchImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    [searchImage setImage:IMAGE_NAMED(@"nav_button_search") forState:UIControlStateNormal];
    searchImage.contentMode = UIViewContentModeCenter;
    searchImage.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    searchImage.contentMode = UIViewContentModeCenter;
//    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    searchImageView.image = [UIImage imageNamed:@"nav_button_search"];
//    searchImageView.contentMode = UIViewContentModeCenter;
    self.searchTf.leftView = searchImage;
    self.searchTf.leftViewMode = UITextFieldViewModeAlways;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:self.searchTf];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (SearchThemeViewController *)themeVC {
    if (!_themeVC) {
        _themeVC = [[SearchThemeViewController alloc] init];
    }
    return _themeVC;
}

- (SearchQuestionViewController *)questionVC {
    if (!_questionVC) {
        _questionVC = [[SearchQuestionViewController alloc] init];
    }
    return _questionVC;
}

- (SearchFriendViewController *)friendVC {
    if (!_friendVC) {
        _friendVC = [[SearchFriendViewController alloc] init];
    }
    return _friendVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
