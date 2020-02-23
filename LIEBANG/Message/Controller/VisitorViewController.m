//
//  VisitorViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/25.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "VisitorViewController.h"
#import "InterestFriendCell.h"
#import "VisitorRecordModel.h"
#import "MessageService.h"
#import "FriendService.h"

@interface VisitorViewController ()

@property (nonatomic,strong)NSMutableArray *dataSource;

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,assign)BOOL isRefresh;

@end

@implementation VisitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kTabBarViewHeight-kCurrentWidth(40));
    self.groupTableView.backgroundColor = kWhiteColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    
    self.page = 1;
    self.isRefresh = NO;
    [self loadVisitorDataSource];
    
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isRefresh = NO;
        [self loadVisitorDataSource];
    }];
    
    self.groupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.dataSource.count < 10) {
            [self.groupTableView.mj_footer endRefreshing];
            return;
        }
        
        self.page++;
        self.isRefresh = YES;
        [self loadVisitorDataSource];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[RCDataManager shareManager] refreshBadgeValue];
}

- (void)loadVisitorDataSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:@"10" forKey:@"pageSize"];
    [postDic setValue:[NSNumber numberWithInteger:self.page] forKey:@"pageNow"];
    
    [self displayOverFlowActivityView];
    [MessageService getVisitorWithParameters:postDic success:^(VisitorRecordModel *info) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        
        if (self.isRefresh) {
            if (IsArrEmpty(info.data)) {
                [self presentSheet:@"暂无更多数据"];
            } else {
                [self.dataSource addObjectsFromArray:info.data];
            }
        } else {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:info.data];
        }
        
        if (IsArrEmpty(self.dataSource)) {
            self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kTabBarViewHeight-kCurrentWidth(40)];
        } else {
            self.groupTableView.tableFooterView = [UIView new];
        }
        [[RCDataManager shareManager] refreshBadgeValue];
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        if (IsArrEmpty(self.dataSource)) {
            self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kTabBarViewHeight-kCurrentWidth(40)];
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
    VisitorModel *visitor = [self.dataSource safeObjectAtIndex:indexPath.row];
    static NSString *cellStr = @"InterestFriendCell";
    InterestFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[InterestFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.sureButtonState = SureButtonStateVisitorNormal;
    cell.userModel = visitor;
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
    
    VisitorModel *visitor = [self.dataSource safeObjectAtIndex:indexPath.row];
    AccountViewController *nextCtr = [[AccountViewController alloc] init];
    nextCtr.userUid = visitor.userUid;
    if ([visitor.userStatus intValue] == 0) {
        nextCtr.accountState = AccountStateOther;
    }
    else {
        nextCtr.accountState = AccountStateDisabled;
    }
    [self.navigationController pushViewController:nextCtr animated:YES];
}

#pragma mark Event
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

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
