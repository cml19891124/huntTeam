//
//  SystemViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/25.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "SystemViewController.h"
#import "QuestionOrderDetailViewController.h"
#import "OrderDetailViewController.h"
#import "CertiResultViewController.h"
#import "CouponViewController.h"
#import "PendViewController.h"
#import "WalletViewController.h"
#import "MessageCell.h"
#import "MessageService.h"
#import "MyFriendViewController.h"

#import "CompanyDetailViewController.h"

#import "EditAccountViewController.h"

@interface SystemViewController ()

@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)BOOL isRefresh;

@end

@implementation SystemViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kTabBarViewHeight-kCurrentWidth(40));
    self.groupTableView.backgroundColor = kWhiteColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isRefresh = NO;
        [self loadSystemData];
    }];
    
    self.groupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.dataArray.count < 10) {
            [self.groupTableView.mj_footer endRefreshing];
            return;
        }
        
        self.page++;
        self.isRefresh = YES;
        [self loadSystemData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.page = 1;
    self.isRefresh = NO;
    [self loadSystemData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[RCDataManager shareManager] refreshBadgeValue];
}

- (void)loadSystemData {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:[NSNumber numberWithInteger:self.page] forKey:@"pageNow"];
    [postDic setValue:@"10" forKey:@"pageSize"];
    
    [self displayOverFlowActivityView];
    [MessageService getSystemMessageWithParameters:postDic success:^(NSArray *info) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        
        if (self.isRefresh) {
            if (IsArrEmpty(info)) {
                [self presentSheet:@"暂无更多数据"];
            } else {
                [self.dataArray addObjectsFromArray:info];
            }
        } else {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:info];
        }
        
        if (IsArrEmpty(self.dataArray)) {
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
        if (IsArrEmpty(self.dataArray)) {
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellStr = @"MessageCell";
    SystemModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(76);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SystemModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
    if ([model.pushType isEqualToString:@"0"])
    {
        if (!IsStrEmpty(model.orderId) && !IsNilOrNull(model.orderId))
        {
            if ([model.orderType isEqualToString:@"0"])
            {
                QuestionOrderDetailViewController *nextCtr = [[QuestionOrderDetailViewController alloc] init];
                nextCtr.orderUid = model.orderId;
                nextCtr.orderStatus = model.type;
                if ([model.type isEqualToString:@"4"]) {
                    nextCtr.detailType = QuestionDetailTypeExpert;
                }
                else {
                    nextCtr.detailType = QuestionDetailTypeStudent;
                }
                [self.navigationController pushViewController:nextCtr animated:YES];
            }
            else if ([model.orderType isEqualToString:@"2"])
            {
                OrderDetailViewController *nextCtr = [[OrderDetailViewController alloc] init];
                nextCtr.orderUid = model.orderId;
                nextCtr.orderStatus = model.type;
                if ([model.type isEqualToString:@"4"]) {
                    nextCtr.detailType = QuestionDetailTypeExpert;
                }
                else {
                    nextCtr.detailType = QuestionDetailTypeStudent;
                }
                [self.navigationController pushViewController:nextCtr animated:YES];
            }
        }
        else
        {
            WebViewController *nextCtr = [[WebViewController alloc] init];
            nextCtr.webViewType = WebViewTypeHTML;
            nextCtr.contentString = model.content;
            nextCtr.navTitle = @"消息详情";
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
    }
    else if ([model.pushType isEqualToString:@"23"] || [model.pushType isEqualToString:@"15"] || [model.pushType isEqualToString:@"17"] || [model.pushType isEqualToString:@"19"])
    {
        CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
        nextCtr.certiResultCtrl = CertiResultCtrlSuccess;
        nextCtr.pushType = model.pushType;
        nextCtr.companyUid = model.enterpriseId;
        nextCtr.isSelf = YES;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if ([model.pushType isEqualToString:@"24"] || [model.pushType isEqualToString:@"16"] || [model.pushType isEqualToString:@"18"] || [model.pushType isEqualToString:@"20"])
    {//行家认证 18
        if ([model.pushType isEqualToString:@"24"]) {
            if (IsNilOrNull(model.enterpriseId) || IsStrEmpty(model.enterpriseId)) {
                return;
            }
        }
        
        CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
        nextCtr.companyUid = model.enterpriseId;
        nextCtr.certiResultCtrl = CertiResultCtrlFail;
        nextCtr.pushType = model.pushType;
        nextCtr.failReason = model.content;
        if ([model.pushType isEqualToString:@"16"]) {
            nextCtr.failType = @"0";
        }
        if ([model.pushType isEqualToString:@"18"]) {
            nextCtr.failType = @"1";
        }
        if ([model.pushType isEqualToString:@"20"]) {
            nextCtr.failType = @"2";
        }
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if ([model.pushType isEqualToString:@"25"] || [model.pushType isEqualToString:@"26"])//优惠券
    {
        CouponViewController *nextCtr = [[CouponViewController alloc] init];
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if ([model.pushType isEqualToString:@"21"] || [model.pushType isEqualToString:@"22"] || [model.pushType isEqualToString:@"50"] || [model.pushType isEqualToString:@"51"] || [model.pushType isEqualToString:@"52"] || [model.pushType isEqualToString:@"53"] || [model.pushType isEqualToString:@"2"] || [model.pushType isEqualToString:@"3"] || [model.pushType isEqualToString:@"4"] || [model.pushType isEqualToString:@"5"] || [model.pushType isEqualToString:@"6"] || [model.pushType isEqualToString:@"7"] || [model.pushType isEqualToString:@"8"] || [model.pushType isEqualToString:@"9"])//提现、分成
    {
        WalletViewController *nextCtr = [[WalletViewController alloc] init];
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if ([model.pushType isEqualToString:@"70"] || [model.pushType isEqualToString:@"72"])//有用户申请好友
    {
        PendViewController *nextCtr = [[PendViewController alloc] init];
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if ([model.pushType isEqualToString:@"71"])//好友申请通过
    {
        MyFriendViewController *nextCtr = [[MyFriendViewController alloc] init];
        [self.navigationController pushViewController:nextCtr animated:YES];
    }else if ([model.pushType isEqualToString:@"27"])//邀请进入企业---》进入企业详情页面，无蒙版
    {
        CompanyDetailViewController *nextCtr = [[CompanyDetailViewController alloc] init];
        nextCtr.companyUid = model.enterpriseId;
        nextCtr.isSelf = YES;
        nextCtr.companyType = @"0";
        nextCtr.companyName = model.title?:@"企业AI名片智能详情";
        [self.navigationController pushViewController:nextCtr animated:YES];
    }else if ([model.pushType isEqualToString:@"28"]){//已离开企业---》进入企业详情页面，有蒙版
        CompanyDetailViewController *nextCtr = [[CompanyDetailViewController alloc] init];
        nextCtr.companyUid = model.enterpriseId;
        nextCtr.isSelf = NO;
        nextCtr.companyType = @"1";
        nextCtr.companyName = model.title?:@"企业AI名片智能详情";
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else
    {
        WebViewController *nextCtr = [[WebViewController alloc] init];
        nextCtr.webViewType = WebViewTypeHTML;
        nextCtr.contentString = model.content;
        nextCtr.navTitle = @"消息详情";
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}

#pragma mark - 侧滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self displayOverFlowActivityView];
        SystemModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
        [MessageService getDeleteSystemMessageWithParameters:model.id success:^(NSString *info) {
            [self removeOverFlowActivityView];
            [self.dataArray removeObjectAtIndex:indexPath.row];
            
            if (self.dataArray.count) {
                self.page = 1;
                self.isRefresh = NO;
                [self loadSystemData];
            }
            
            [self.groupTableView reloadData];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
