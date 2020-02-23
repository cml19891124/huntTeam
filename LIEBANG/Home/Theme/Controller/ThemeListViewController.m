#import "ThemeListMeetCell.h"

#import "ThemeListViewController.h"
#import "ClassListHeadView.h"
#import "HomeMeetCell.h"
#import "ThemeDetailViewController.h"
#import "ThemeClassModel.h"
#import "ZJChooseControlView.h"
#import "ZJChooseShowView.h"
#import "ClassService.h"

@interface ThemeListViewController ()<ZJChooseControlDelegate,ZJChooseShowViewDelegate>

@property (nonatomic,  weak)ZJChooseControlView *chooseControlView;
@property (nonatomic,strong)ZJChooseShowView *showView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSString *intelligentType;
@property (nonatomic,strong)NSString *serviceType;
@property (nonatomic,assign)NSInteger page;

@property (nonatomic,assign)BOOL isRefresh;
@end

@implementation ThemeListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadThemeDataSource];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpAllView];
    
    self.groupTableView.frame = CGRectMake(0, kCurrentWidth(44), kDeviceWidth, kDeviceHeight-kNavBarHeight-kCurrentWidth(44)-kViewHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    
    self.page = 1;
    self.isRefresh = NO;
    
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isRefresh = NO;
        if (self.dataSource.count < 10) {
                   [self.groupTableView.mj_header endRefreshing];
                   return;
               }
        [self loadThemeDataSource];
    }];
    
    self.groupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.dataSource.count < 10) {
            [self.groupTableView.mj_footer endRefreshing];
            return;
        }
        
        self.page++;
        self.isRefresh = YES;
        [self loadThemeDataSource];
    }];
    
//    [self showSelectPickView:self.isOpen];
}

- (void)showSelectPickView:(BOOL)isOpen {
    
    if (isOpen) {
        [self.view addSubview:self.showView];
        self.showView.hidden = NO;
        self.showView.oneLeftIndex = self.classifyIndex;
        self.showView.oneRightIndex = self.classify2Index;
        
        UIButton *button = [self.chooseControlView.btnArr safeObjectAtIndex:0];
        [self.showView hideOtherOneChilViewArray:self.chooseControlView.btnArr Action:button];
    }
}

- (void)loadThemeDataSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    
    ClassModel *model = [self.classModel.data safeObjectAtIndex:self.classifyIndex];
    ClassifyTwoModel *dto = [model.classifyTwo safeObjectAtIndex:self.classify2Index];
    [postDic setValue:model.id forKey:@"classifyId"];//一级类目id
    [postDic setValue:dto.id forKey:@"classify2Id"];//二级类id
    
    [postDic setValue:self.serviceType forKey:@"serviceType"];//0:线下约见 1：全国通话
    [postDic setValue:self.intelligentType forKey:@"intelligentType"];//智能排序 1：帮助最多 2：评分最高 3：最近回答
    [postDic setValue:@"10" forKey:@"pageSize"];
    [postDic setValue:[NSNumber numberWithInteger:self.page] forKey:@"pageNow"];
    
    NSLog(@"话题列表postDic = %@",postDic);
    
    [self displayOverFlowActivityView];
    [ClassService getThemeListWithParameters:postDic success:^(NSArray *list) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        
        if (self.isRefresh) {
            if (IsArrEmpty(list)) {
                [self presentSheet:@"暂无更多数据"];
            } else {
                [self.dataSource addObjectsFromArray:list];
            }
        } else {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:list];
        }
        
        if (IsArrEmpty(self.dataSource)) {
            self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kCurrentWidth(44)-kViewHeight];
        } else {
            self.groupTableView.tableFooterView = [UIView new];
        }
        
        NSLog(@"话题列表count = %zd",self.dataSource.count);
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        if (IsArrEmpty(self.dataSource)) {
            self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kCurrentWidth(44)-kViewHeight];
        } else {
            self.groupTableView.tableFooterView = [UIView new];
        }
        
        [self presentSheet:errorStr];
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    ThemeClassModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    static NSString *cellStr = @"HomeMeetCell";
    ThemeListMeetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[ThemeListMeetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.themeClassModel = model;
    cell.accountButtonBlock = ^{
        [weakSelf gotoAccountViewController:model.dataPrivacyType userUid:model.userUid];
    };
    cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
        [weakSelf pushToMosaicVC:imageUrl];
    };
    cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
        [weakSelf pushToMosaicVC:imageUrl];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeMeetCell *cell = (HomeMeetCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ThemeClassModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    ThemeDetailViewController *nextCtr = [[ThemeDetailViewController alloc] init];
    nextCtr.themeUid = model.id;
    if ([model.userUid isEqualToString:[Config currentConfig].userUid]) {
        nextCtr.detailState = ThemeDetailStateEdit;
    }
    else {
        nextCtr.detailState = ThemeDetailStateNormal;
    }
    [self.navigationController pushViewController:nextCtr animated:YES];
}

-(void)setUpAllView{
    
    ClassModel *model = [self.classModel.data safeObjectAtIndex:self.classifyIndex];
    ClassifyTwoModel *twoModel = [model.classifyTwo safeObjectAtIndex:self.classify2Index];
    NSArray *array = [NSArray array];
    if ([twoModel.classify isEqualToString:@"全部"]) {
        array = @[model.classify,@"服务类型",@"智能排序"];
    }
    else {
        array = @[twoModel.classify,@"服务类型",@"智能排序"];
    }
    
    ZJChooseControlView *chooseView = [[ZJChooseControlView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(44))];
    chooseView.delegate = self;
    [chooseView setUpAllViewWithTitleArr:array];
    _chooseControlView = chooseView;
    [self.view addSubview:chooseView];
}

-(ZJChooseShowView *)showView{
    if (!_showView) {
        _showView = [[ZJChooseShowView alloc]initWithFrame:CGRectMake(0, kCurrentWidth(44), kDeviceWidth, kDeviceHeight - kCurrentWidth(44)-kNavBarHeight)];
        _showView.hidden = YES;
        _showView.allClassModel = self.classModel;
        _showView.delegate = self;
    }
    return _showView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

//未登陆状态
- (BOOL)gotoLoginViewController {
    LoginModel *account = [SDUserTool account];

    if (IsNilOrNull(account.rongCloudToken) || IsStrEmpty(account.rongCloudToken)) {
        LoginViewController *nextCtr = [[LoginViewController alloc] init];
        CommonNavgationViewController *nextNav = [[CommonNavgationViewController alloc] initWithRootViewController:nextCtr];
        [self.navigationController presentViewController:nextNav animated:YES completion:^{
            
        }];
//        UIAlertController *alert = [CHAlertView showMessageWith:@"去登陆" title:@"您还没有登陆" confim:^{
//            LoginViewController *nextCtr = [[LoginViewController alloc] init];
//            CommonNavgationViewController *nextNav = [[CommonNavgationViewController alloc] initWithRootViewController:nextCtr];
//            [self.navigationController presentViewController:nextNav animated:YES completion:^{
//
//            }];
//        }];
//        [self presentViewController:alert animated:YES completion:nil];
        return YES;
    } else {
        return NO;
    }
}

//查看资料权限
- (void)gotoAccountViewController:(NSString *)dataPrivacyType userUid:(NSString *)userUid {
    
    if ([self gotoLoginViewController]) return;

    AccountViewController *nextCtr = [[AccountViewController alloc] init];
    if ([[Config currentConfig].userUid isEqualToString:userUid]) {
        nextCtr.accountState = AccountStateNormal;
    }
    else {
        nextCtr.accountState = AccountStateOther;
    }
    nextCtr.userUid = userUid;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

#pragma mark - 选中的按钮事件
-(void)chooseControlWithBtnArray:(NSArray *)array button:(UIButton *)sender{
    
    [self.view addSubview:self.showView];
    self.showView.hidden = NO;
    self.showView.oneLeftIndex = self.classifyIndex;
    self.showView.oneRightIndex = self.classify2Index;
    [self.showView chooseThemeControlViewBtnArray:array Action:sender];
}

#pragma mark ZJChooseShowViewDelegate
- (void)chooseThreeViewCellDidSelectedWithIndex:(NSInteger)index {
    if (index == 0)
    {
        self.serviceType = nil;
    }
    else if (index == 1)
    {
        self.serviceType = @"1";
    }
    else if (index == 2)
    {
        self.serviceType = @"0";
    }
    NSLog(@"serviceType == %@",self.serviceType);
    self.page = 1;
    self.isRefresh = NO;
    [self loadThemeDataSource];
}

- (void)chooseThreeViewVCellDidSelectedWithIndex:(NSInteger)index {
    self.intelligentType = [NSString stringWithFormat:@"%zd",index+1];
    NSLog(@"intelligentType == %@",self.intelligentType);
    self.page = 1;
    self.isRefresh = NO;
    [self loadThemeDataSource];
}

- (void)chooseOneViewWithTableLeftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex {
    NSLog(@"leftindex == %zd rightIndex== %zd",leftIndex,rightIndex);
    self.classifyIndex = leftIndex;
    self.classify2Index = rightIndex;
    self.page = 1;
    self.isRefresh = NO;
    [self loadThemeDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
