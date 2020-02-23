//
//  PersonnelManagerViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PersonnelManagerViewController.h"
#import "PersonnelCell.h"
#import "PersonnelHeadView.h"
#import "CompanyService.h"
#import "PersonnelModel.h"

@interface PersonnelManagerViewController ()

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)PersonnelHeadView *headView;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)BOOL isRefresh;

@end

@implementation PersonnelManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"企业员工管理";
    self.view.backgroundColor = kWhiteColor;
    
    WeakSelf;
    self.headView = [[PersonnelHeadView alloc] init];
    self.headView.addMessageBlock = ^(NSString * _Nonnull phone) {
        [weakSelf addPersonnelMessage:phone];
    };
    
    [self.view addSubview:self.headView];
    self.groupTableView.frame = CGRectMake(0, self.headView.bottom, kDeviceWidth, kDeviceHeight-kNavBarHeight-self.headView.height);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    self.page = 1;
    self.isRefresh = NO;
    [self getStallDataSource];
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isRefresh = NO;
        [self getStallDataSource];
    }];
    
    self.groupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.dataSource.count < 10) {
            [self.groupTableView.mj_footer endRefreshing];
            return;
        }
        
        self.page++;
        self.isRefresh = YES;
        [self getStallDataSource];
    }];
}

- (void)getStallDataSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:@"10" forKey:@"pageSize"];
    [postDic setValue:@(self.page).stringValue forKey:@"pageNow"];
    [postDic setValue:self.enterpriseId forKey:@"enterpriseId"];
    [postDic setValue:@"0" forKey:@"type"];//0:自己查看 1:他人查看
    
    [self displayOverFlowActivityView];
    [CompanyService getStallListCompanyWithParameters:postDic success:^(NSArray * _Nonnull data) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        
        if (self.isRefresh) {
            if (IsArrEmpty(data)) {
                [self presentSheet:@"暂无更多数据"];
            } else {
                [self.dataSource addObjectsFromArray:data];
            }
        } else {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:data];
        }

        [self setEmptyView];
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        [self presentSheet:errorStr];
        [self setEmptyView];
    }];
}

- (void)setEmptyView {
    if (IsArrEmpty(self.dataSource)) {
        self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-self.headView.height];
    } else {
        self.groupTableView.tableFooterView = [UIView new];
    }
}

#pragma mark
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    static NSString *cellStr = @"PersonnelCell";
    PersonnelModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    PersonnelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[PersonnelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.model = model;
    cell.deletePersonnelBlock = ^(NSString * _Nonnull userUid) {
        [weakSelf deletePersonnel:userUid];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(70);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PersonnelModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    [self gotoAccountViewController:nil userUid:model.userUid];
}

#pragma mark
#pragma mark Event
- (void)deletePersonnel:(NSString *)userUid {
    UIAlertController *alert = [CHAlertView showMessageWith:@"确定" title:@"确认删除该员工？" confim:^{
        [self displayOverFlowActivityView];
        [CompanyService removeCompanyStallWithParameters:userUid success:^(NSString * _Nonnull data) {
            [self removeOverFlowActivityView];
            [self presentSheet:data];
            self.page = 1;
            self.isRefresh = NO;
            [self getStallDataSource];
        } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addPersonnelMessage:(NSString *)phone {
    
    [self.headView.phoneTf resignFirstResponder];
    NSString *checkResult = [LBForProject isCheckPhone:phone];
    if (![checkResult isEqualToString:@""]) {
        [self presentSheet:checkResult];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.enterpriseId forKey:@"enterpriseId"];
    [postDic setValue:phone forKey:@"userPhone"];
    
    [self displayOverFlowActivityView];
    [CompanyService addCompanyStallWithParameters:postDic success:^(NSString * _Nonnull data) {
        [self removeOverFlowActivityView];
        [self presentSheet:data];
        self.headView.phoneTf.text = nil;
        self.page = 1;
        self.isRefresh = NO;
        [self getStallDataSource];
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
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
        [self.navigationController presentViewController:nextNav animated:YES completion:^{}];
        return YES;
    } else {
        return NO;
    }
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
