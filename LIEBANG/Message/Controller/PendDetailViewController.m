//
//  PendDetailViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/2.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "PendDetailViewController.h"
#import "CompanyService.h"
#import "PendModel.h"
#import "CompanyClaimCell.h"
#import "InterestFriendCell.h"
#import "FriendService.h"

@interface PendDetailViewController ()

@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)BOOL isRefresh;

@end

@implementation PendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"待处理事项";
    self.view.backgroundColor = kBackgroundColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    self.page = 1;
    self.isRefresh = NO;
    [self geMessageDetailData];
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isRefresh = NO;
        [self geMessageDetailData];
    }];
    
    self.groupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.dataArray.count < 10) {
            [self.groupTableView.mj_footer endRefreshing];
            return;
        }
        
        self.page++;
        self.isRefresh = YES;
        [self geMessageDetailData];
    }];
}

- (void)geMessageDetailData {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.type forKey:@"type"];//0 申请好友 1：认领企业
    [postDic setValue:@(self.page).stringValue forKey:@"pageNow"];
    [postDic setValue:@"10" forKey:@"pageSize"];
    
    [self displayOverFlowActivityView];
    [CompanyService getTreatedMessageDetailWithParameters:postDic success:^(NSArray * _Nonnull data) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        if (self.isRefresh) {
            if (IsArrEmpty(data)) {
                [self presentSheet:@"暂无更多数据"];
            } else {
                [self.dataArray addObjectsFromArray:data];
            }
        } else {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:data];
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

- (void)passStallClaimRequestion:(NSString *)uid {
    [self displayOverFlowActivityView];
    [CompanyService passStallCompanyWithParameters:uid success:^(NSString * _Nonnull data) {
        [self removeOverFlowActivityView];
        [self presentSheet:data];
        self.page = 1;
        self.isRefresh = NO;
        [self geMessageDetailData];
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)refuseStallClaimRequestion:(NSString *)uid {
    [self displayOverFlowActivityView];
    [CompanyService refuseStallCompanyWithParameters:uid success:^(NSString * _Nonnull data) {
        [self removeOverFlowActivityView];
        [self presentSheet:data];
        self.page = 1;
        self.isRefresh = NO;
        [self geMessageDetailData];
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)setEmptyView {
    if (IsArrEmpty(self.dataArray)) {
        self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight];
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    if ([self.type intValue] == 0)
    {
        static NSString *cellStr = @"InterestFriendCell";
        InterestFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[InterestFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        PendFriendModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
        cell.pendModel = model;
        cell.confimButtonBlock = ^(PendFriendModel *friendModel) {
            [weakSelf passFriendRequestWith:friendModel];
        };
        cell.closeButtonBlock = ^(PendFriendModel *friendModel) {
            [weakSelf refuseFriendRequestWith:friendModel];
        };
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
    else if ([self.type intValue] == 1)
    {
        static NSString *cellStr = @"CompanyClaimCell";
        PendStallModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
        CompanyClaimCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[CompanyClaimCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.stallModel = model;
        cell.confimButtonBlock = ^(PendStallModel * _Nonnull stallModel) {
            [weakSelf passStallClaimRequestion:stallModel.id];
        };
        cell.closeButtonBlock = ^(PendStallModel * _Nonnull stallModel) {
            [weakSelf refuseStallClaimRequestion:stallModel.id];
        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.type intValue] == 1) {
        return kCurrentWidth(83);
    }
    return kCurrentWidth(70);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.type intValue] == 1)
    {
        PendStallModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
        [self gotoAccountViewController:@"0" userUid:model.userUid];
    }
    else if ([self.type intValue] == 0)
    {
        PendFriendModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
        [self gotoAccountViewController:model.userStatus userUid:model.userUid];
    }
}

#pragma mark
#pragma mark Events
//通过好友
- (void)passFriendRequestWith:(PendFriendModel *)friendModel {
    
    [self displayOverFlowActivityView];
    [FriendService getPassFriendWithParameters:friendModel.id success:^(NSString *success) {
        [self removeOverFlowActivityView];
        [self presentSheet:success];
        self.page = 1;
        self.isRefresh = NO;
        [self geMessageDetailData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendPassFriendMessage:friendModel.userUid userName:friendModel.userName userHead:friendModel.userHead];
        });
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)refuseFriendRequestWith:(PendFriendModel *)friendModel {
    
    [self displayOverFlowActivityView];
    [FriendService getRefuseFriendWithParameters:friendModel.id success:^(NSString *success) {
        [self removeOverFlowActivityView];
        [self presentSheet:success];
        self.page = 1;
        self.isRefresh = NO;
        [self geMessageDetailData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)addFriendRequestWith:(InterestFriendModel *)model {
    
    [self displayOverFlowActivityView];
    [FriendService getAddFriendWithParameters:model.userUid success:^(NSString *success) {
        [self removeOverFlowActivityView];
        model.isApplyStatus = @"0";
        [self.tableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)sendPassFriendMessage:(NSString *)userUid userName:(NSString *)userName userHead:(NSString *)userHead {
    
    RCTextMessage *msg = [RCTextMessage messageWithContent:@"我已通过了好友请求，以后多多交流"];
    //    RCInformationNotificationMessage *msg = [RCInformationNotificationMessage notificationWithMessage:@"我已通过了好友请求，以后多多交流" extra:nil];
    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:userUid content:msg pushContent:[NSString stringWithFormat:@"%@已通过了好友请求，以后多多交流",userName] pushData:nil success:^(long messageId) {
        RCUserInfo *user = [RCUserInfo new];
        user.userId = userUid;
        user.name = userName;
        user.portraitUri = userHead;
        [[RCDataManager shareManager] addRCUserInfo:user];
    } error:^(RCErrorCode nErrorCode, long messageId) {
        
    }];
}

- (void)gotoAccountViewController:(NSString *)userStatus userUid:(NSString *)userUid {
    
    if ([self gotoLoginViewController]) return;
    AccountViewController *nextCtr = [[AccountViewController alloc] init];
    if ([userStatus intValue] == 0) {
        if ([[Config currentConfig].userUid isEqualToString:userUid]) {
            nextCtr.accountState = AccountStateNormal;
        }
        else {
            nextCtr.accountState = AccountStateOther;
        }
    }
    else {
        nextCtr.accountState = AccountStateDisabled;
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
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
