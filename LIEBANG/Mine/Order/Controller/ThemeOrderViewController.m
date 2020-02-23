//
//  ThemeOrderViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/25.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ThemeOrderViewController.h"
#import "OrderDetailViewController.h"
#import "HomeMeetCell.h"
#import "OrderService.h"
#import "ThemeModel.h"
#import "OrderHeadView.h"

@interface ThemeOrderViewController ()

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)OrderHeadView *headView;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)NSString *orderStatus;
@property (nonatomic,assign)BOOL isRefresh;
@property (nonatomic,strong)UILabel *messageLabel;
@end

@implementation ThemeOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WeakSelf;
    self.headView.headButtonBlock = ^(NSInteger buttonIndex) {
        weakSelf.page = 1;
        weakSelf.isRefresh = NO;
        weakSelf.orderStatus = [NSString stringWithFormat:@"%zd",buttonIndex];
        if ([self.orderStatus intValue] == 4) {
            weakSelf.detailtype = QuestionDetailTypeExpert;
        }
        else {
            weakSelf.detailtype = QuestionDetailTypeStudent;
        }
        [weakSelf loadThemeDataSource];
    };
    [self.view addSubview:self.headView];
    self.groupTableView.frame = CGRectMake(0, self.headView.bottom, kDeviceWidth, kDeviceHeight-kNavBarHeight-self.headView.bottom-kViewHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    
    self.orderStatus = @"1";
    self.detailtype = QuestionDetailTypeStudent;
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isRefresh = NO;
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.page = 1;
    self.isRefresh = NO;
    [self loadThemeDataSource];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadThemeReadNumber];
    });
}

- (void)loadThemeReadNumber {
    
    [OrderService getOrderReadWithParameters:@"1" success:^(OrderReadModel *info) {
        self.headView.readModel = info;
    } failure:^(NSUInteger code, NSString *errorStr) {
        
    }];
}

- (void)loadThemeDataSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.orderStatus forKey:@"status"];//1：进行中 2：待评价 3：已结束 4:待回答订单（1-3显示支付价，4显示原价）
    [postDic setValue:@"10" forKey:@"pageSize"];
    [postDic setValue:[NSNumber numberWithInteger:self.page] forKey:@"pageNow"];
    
    NSLog(@"话题订单列表 = %@",postDic);
    [self displayOverFlowActivityView];
    [OrderService getThemeOrderWithParameters:postDic success:^(ThemeOrderModel *info) {
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
            if ([self.orderStatus intValue] == 1) {
                self.messageLabel.text = @"您还没有进行中的约见噢\n快去预约您感兴趣的话题吧";
                self.groupTableView.tableFooterView = self.messageLabel;
            }
            else if ([self.orderStatus intValue] == 2) {
                self.messageLabel.text = @"您还没有待评价的约见噢\n行家确认后待评价的约见会显示在这里";
                self.groupTableView.tableFooterView = self.messageLabel;
            }
            else if ([self.orderStatus intValue] == 3) {
                self.messageLabel.text = @"您还没有完成过的约见噢\n快去预约您感兴趣的话题吧";
                self.groupTableView.tableFooterView = self.messageLabel;
            }
            else if ([self.orderStatus intValue] == 4) {
                self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-self.headView.bottom-kViewHeight];
            }
            
        } else {
            self.groupTableView.tableFooterView = [UIView new];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadThemeReadNumber];
        });
        
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        if (IsArrEmpty(self.dataSource)) {
            if ([self.orderStatus intValue] == 1) {
                self.messageLabel.text = @"您还没有进行中的约见噢\n快去预约您感兴趣的话题吧";
                self.groupTableView.tableFooterView = self.messageLabel;
            }
            else if ([self.orderStatus intValue] == 2) {
                self.messageLabel.text = @"您还没有待评价的约见噢\n行家确认后待评价的约见会显示在这里";
                self.groupTableView.tableFooterView = self.messageLabel;
            }
            else if ([self.orderStatus intValue] == 3) {
                self.messageLabel.text = @"您还没有完成过的约见噢\n快去预约您感兴趣的话题吧";
                self.groupTableView.tableFooterView = self.messageLabel;
            }
            else if ([self.orderStatus intValue] == 4) {
                self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-self.headView.bottom-kViewHeight];
            }
            
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
    ThemeModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    static NSString *cellStr = @"HomeMeetCell";
    HomeMeetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[HomeMeetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.detailtype = self.detailtype;
    cell.homeMeetCellState = HomeMeetCellStateOrder;
    cell.themeModel = model;
    cell.accountButtonBlock = ^{
        [weakSelf gotoAccountViewController:@"0" userUid:model.userUid];
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
    HomeMeetCell *cell = (HomeMeetCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ThemeModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    OrderDetailViewController *detailVC = [[OrderDetailViewController alloc] init];
    detailVC.orderUid = model.id;//orderUid
    detailVC.orderStatus = self.orderStatus;
    if ([self.orderStatus isEqualToString:@"4"]) {
        detailVC.detailType = QuestionDetailTypeExpert;
    }
    else {
        detailVC.detailType = QuestionDetailTypeStudent;
    }
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 侧滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.orderStatus isEqualToString:@"3"]||[self.orderStatus isEqualToString:@"4"]) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UIAlertController *alert = [CHAlertView showMessageWith:@"删除" title:@"确认删除该订单？" confim:^{
            [self displayOverFlowActivityView];
            ThemeModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
            if ([self.orderStatus isEqualToString:@"3"]) {
                [OrderService getDeleteOrderWithParameters:model.id success:^(NSString *info) {
                    [self removeOverFlowActivityView];
                    [self.dataSource removeObjectAtIndex:indexPath.row];
                    [self.groupTableView reloadData];
                    [self loadThemeReadNumber];//刷新角标
                } failure:^(NSUInteger code, NSString *errorStr) {
                    [self removeOverFlowActivityView];
                    [self presentSheet:errorStr];
                }];

            }else if([self.orderStatus isEqualToString:@"4"]){
               [OrderService getDeleteSellerOrderWithParameters:model.id success:^(NSString *info) {
                    [self removeOverFlowActivityView];
                    [self.dataSource removeObjectAtIndex:indexPath.row];
                    [self.groupTableView reloadData];
                   [self loadThemeReadNumber];//刷新角标

                } failure:^(NSUInteger code, NSString *errorStr) {
                    [self removeOverFlowActivityView];
                    [self presentSheet:errorStr];
                }];
            }
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//查看资料权限
- (void)gotoAccountViewController:(NSString *)dataPrivacyType userUid:(NSString *)userUid {

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

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (OrderHeadView *)headView {
    if (!_headView) {
        _headView = [[OrderHeadView alloc] init];
    }
    return _headView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-self.headView.bottom-kViewHeight)];
        _messageLabel.textColor = kLBNineColor;
        _messageLabel.numberOfLines = 2;
        _messageLabel.font = kSystem(14);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
