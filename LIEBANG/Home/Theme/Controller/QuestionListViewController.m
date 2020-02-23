#import "ThemeListMeetCell.h"

#import "ThemeListQuestionCell.h"

#import "QuestionListViewController.h"
#import "QuestionDetailViewController.h"
#import "ClassListHeadView.h"
#import "HomeQuestionCell.h"
#import "ClassService.h"
#import "QuestionClassModel.h"

#import "ZJChooseControlView.h"
#import "ZJChooseShowView.h"

@interface QuestionListViewController ()<ZJChooseControlDelegate,ZJChooseShowViewDelegate>

@property (nonatomic,  weak)ZJChooseControlView *chooseControlView;
@property (nonatomic,strong)ZJChooseShowView *showView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSString *intelligentType;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)BOOL isRefresh;

@end

@implementation QuestionListViewController

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
        [self loadQuestionDataSource];
    }];
    
    self.groupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.dataSource.count < 10) {
            [self.groupTableView.mj_footer endRefreshing];
            return;
        }
        
        self.page++;
        self.isRefresh = YES;
        [self loadQuestionDataSource];
    }];
    
    [self loadQuestionDataSource];
//    [self showSelectPickView:self.isOpen];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
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

- (void)loadQuestionDataSource {
    
    NSLog(@"Question classifyIndex = %zd  classify2Index = %zd",self.classifyIndex,self.classify2Index);
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    
    ClassModel *model = [self.classModel.data safeObjectAtIndex:self.classifyIndex];
    ClassifyTwoModel *dto = [model.classifyTwo safeObjectAtIndex:self.classify2Index];
    [postDic setValue:model.id forKey:@"classifyId"];//一级类目id
    [postDic setValue:dto.id forKey:@"classify2Id"];//二级类id
    
    [postDic setValue:self.intelligentType forKey:@"intelligentType"];//智能排序 1：帮助最多 2：评分最高 3：最近回答
    [postDic setValue:@"10" forKey:@"pageSize"];
    [postDic setValue:[NSNumber numberWithInteger:self.page] forKey:@"pageNow"];
    
    NSLog(@"问题列表postDic = %@",postDic);
    [self displayOverFlowActivityView];
    [ClassService getQuestionListWithParameters:postDic success:^(NSArray *list) {
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
    QuestionClassModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    static NSString *cellStr = @"HomeQuestionCell";
    ThemeListQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[ThemeListQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
//    cell.questionCellState = HomeQuestionCellNormal;
    cell.questionClassModel = model;
    cell.accountButtonBlock = ^{
        [weakSelf gotoAccountViewController:model.dataPrivacyType userUid:model.userUid];
    };
    cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
        [weakSelf pushToMosaicVC:imageUrl];
    };
    cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
        [weakSelf pushToMosaicVC:imageUrl];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThemeListQuestionCell *cell = (ThemeListQuestionCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
    return [cell getHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QuestionClassModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    QuestionDetailViewController *nextCtr = [[QuestionDetailViewController alloc] init];
    nextCtr.detailType = QuestionDetailTypeVisitor;
    nextCtr.questionUid = model.id;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)setUpAllView{
    
    ClassModel *model = [self.classModel.data safeObjectAtIndex:self.classifyIndex];
    ClassifyTwoModel *twoModel = [model.classifyTwo safeObjectAtIndex:self.classify2Index];
    NSArray *array = [NSArray array];
    if ([twoModel.classify isEqualToString:@"全部"]) {
        array = @[model.classify,@"智能排序"];
    }
    else {
        array = @[twoModel.classify,@"智能排序"];
    }
    
    ZJChooseControlView *chooseView = [[ZJChooseControlView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(44))];
    chooseView.delegate = self;
//    chooseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    chooseView.layer.borderWidth = 0.5;
    [chooseView setUpAllViewWithTitleArr:array];
    _chooseControlView = chooseView;
    [self.view addSubview:chooseView];
}

- (ZJChooseShowView *)showView{
    if (!_showView) {
        _showView = [[ZJChooseShowView alloc]initWithFrame:CGRectMake(0, kCurrentWidth(44), kDeviceWidth, kDeviceHeight - kNavBarHeight-kCurrentWidth(44))];
        _showView.allClassModel = self.classModel;
        _showView.hidden = YES;
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

#pragma mark - 选中的按钮事件
-(void)chooseControlWithBtnArray:(NSArray *)array button:(UIButton *)sender{
    
    [self.view addSubview:self.showView];
    self.showView.hidden = NO;
    self.showView.oneLeftIndex = self.classifyIndex;
    self.showView.oneRightIndex = self.classify2Index;
    [self.showView chooseQuestionControlViewBtnArray:array Action:sender];
}

#pragma mark ZJChooseShowViewDelegate
- (void)chooseThreeViewCellDidSelectedWithIndex:(NSInteger)index {
    self.intelligentType = [NSString stringWithFormat:@"%zd",index+1];
    NSLog(@"index == %@",self.intelligentType);
    self.page = 1;
    self.isRefresh = NO;
    [self loadQuestionDataSource];
}

- (void)chooseOneViewWithTableLeftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex {
    NSLog(@"leftindex == %zd rightIndex== %zd",leftIndex,rightIndex);
    self.classifyIndex = leftIndex;
    self.classify2Index = rightIndex;
    self.page = 1;
    self.isRefresh = NO;
    [self loadQuestionDataSource];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
