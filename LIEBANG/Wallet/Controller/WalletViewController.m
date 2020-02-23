//
//  WalletViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/24.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "WalletViewController.h"
#import "RechargeViewController.h"
#import "ExtractViewController.h"
#import "LBBViewController.h"
//#import "WalletHeadView.h"
#import "BilldetailCell.h"
#import "WalletService.h"
#import "WalletHeadCell.h"

@interface WalletViewController ()

//@property (nonatomic,strong)WalletHeadView *headView;

@property (nonatomic,strong)NSMutableArray *dataSource;

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,assign)BOOL isRefresh;

@property (nonatomic,strong)NSString *yuer; // 余额

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackgroundColor;
    self.navigationItem.title = @"我的钱包";
    [self setRightNaviBtnTitle:@"充值说明"];
    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:self.headView];
//    self.headView.backButtonBlock = ^{
//        [weakSelf.navigationController popViewControllerAnimated:YES];
//    };
//
//    self.headView.rechargeButtonBlock = ^{
//        LBBViewController *nextCtr = [[LBBViewController alloc] init];
//        [weakSelf.navigationController pushViewController:nextCtr animated:YES];
//    };
//
//    self.headView.forwardButtonBlock = ^{
//        ExtractViewController *nextCtr = [[ExtractViewController alloc] init];
//        nextCtr.yuer = weakSelf.yuer;
//        [weakSelf.navigationController pushViewController:nextCtr animated:YES];
//    };
    
    self.tableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);//kCurrentWidth(290)
    self.tableView.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isRefresh = NO;
        [self loadWalletDetailDataSource];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.dataSource.count < 10) {
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        
        self.page++;
        self.isRefresh = YES;
        [self loadWalletDetailDataSource];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.page = 1;
    self.isRefresh = NO;
    [self loadWalletDetailDataSource];
}

- (void)loadWalletDetailDataSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:[NSNumber numberWithInteger:self.page] forKey:@"pageNow"];
    [postDic setValue:@"10" forKey:@"pageSize"];
    
    [self displayOverFlowActivityView];
    [WalletService getWalletWithParameters:postDic success:^(WalletListModel *model) {
        [self removeOverFlowActivityView];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
//        self.headView.balance = [NSString stringWithFormat:@"%@ - %@",model.balance,model.liebangCurrency];
        [Config currentConfig].balanceAmount = model.balance;
        [Config currentConfig].liebangCurrency = model.liebangCurrency;
        self.yuer = model.balance;
        
        if (self.isRefresh) {
            if (IsArrEmpty(model.wallet)) {
                [self presentSheet:@"暂无更多数据"];
            } else {
                [self.dataSource addObjectsFromArray:model.wallet];
            }
        } else {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:model.wallet];
        }
        
        if (IsArrEmpty(self.dataSource)) {
            self.tableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kCurrentWidth(120)-kViewHeight];
        } else {
            self.tableView.tableFooterView = [UIView new];
        }
        
        [self.tableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (IsArrEmpty(self.dataSource)) {
            self.tableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kCurrentWidth(120)-kViewHeight];
        } else {
            self.tableView.tableFooterView = [UIView new];
        }
        [self presentSheet:errorStr];
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    if (indexPath.section == 0 || indexPath.section == 1)
    {
        static NSString *cellStr = @"WalletHeadCell";
        WalletHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[WalletHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.indexPath = indexPath;
        cell.rechargeButtonBlock = ^{
            [weakSelf rechargeButtonClick];
        };
        cell.forwardButtonBlock = ^{
            [weakSelf forwardButtonClick];
        };
        return cell;
    }
    else
    {
        WalletModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
        static NSString *cellStr = @"BilldetailCell";
        BilldetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[BilldetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.walletModel = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(60);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.000001;
    }
    else if (section == 1) {
        return 0.5f;
    }
    return kCurrentWidth(40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [UIView new];
    }
    else if (section == 1) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5f)];
        headView.backgroundColor = kSepparteLineColor;
        return headView;
    }
    SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(40)) title:@"收支明细"];
    headView.backgroundColor = kBackgroundColor;
    return headView;
}

#pragma mark Event
- (void)rightNaviBtnClick {
    RechargeProtrolViewController *nextCtr = [[RechargeProtrolViewController alloc] init];
    [self.navigationController pushViewController:nextCtr animated:YES];
}

#pragma mark -- 充值
- (void)rechargeButtonClick {
    LBBViewController *nextCtr = [[LBBViewController alloc] init];
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)forwardButtonClick {
    ExtractViewController *nextCtr = [[ExtractViewController alloc] init];
    nextCtr.yuer = self.yuer;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

#pragma mark 界面布局
//- (WalletHeadView *)headView {
//    if (!_headView) {
//        _headView = [[WalletHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(290))];
//    }
//    return _headView;
//}

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
