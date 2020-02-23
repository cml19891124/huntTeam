//
//  AllPersonnelViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AllPersonnelViewController.h"
#import "FriendService.h"
#import "InterestFriendCell.h"
#import "AccountViewController.h"
#import "CompanyService.h"
#import "PersonnelModel.h"
#import "NoAccountView.h"

@interface AllPersonnelViewController ()

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)BOOL isRefresh;
@end

@implementation AllPersonnelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"所有员工";
    self.view.backgroundColor = kWhiteColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kWhiteColor;
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
    [postDic setValue:[self.type boolValue]?@"1":@"0" forKey:@"type"];//0:自己查看 1:他人查看
    
    NSLog(@"全部员工 == %@",postDic);
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
        [self setEmptyView:0];
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        [self setEmptyView:code];
    }];
}

- (void)setEmptyView:(NSUInteger)code {
    if (IsArrEmpty(self.dataSource)) {
        NoAccountView *dataView = [[NoAccountView alloc] init];
        if (code == 40004) {
            dataView.titleString = @"暂无权限查看员工列表";
        }
        else {
            dataView.titleString = @"暂无数据哦";
        }
        dataView.backButtonBlock = ^{
            [self backNavItemTapped];
        };
        self.groupTableView.tableFooterView = dataView;
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
    PersonnelModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    static NSString *cellStr = @"InterestFriendCell";
    InterestFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[InterestFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.sureButtonState = SureButtonStateNormal;
    cell.stallModel = model;
    cell.sureButtonBlock = ^(InterestFriendModel *friendModel) {
        [weakSelf addFriendRequestWith:friendModel];
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
    return kCurrentWidth(70);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PersonnelModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    [self gotoAccountViewController:nil userUid:model.userUid];
}

#pragma mark
#pragma mark Events
- (void)addFriendRequestWith:(InterestFriendModel *)model {
    
    [self displayOverFlowActivityView];
    [FriendService getAddFriendWithParameters:model.userUid success:^(NSString *success) {
        [self removeOverFlowActivityView];
        model.isApplyStatus = @"0";
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
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

#pragma mark
#pragma mark 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
