//
//  PendViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/11.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PendViewController.h"
#import "InterestFriendViewController.h"
#import "PendDetailViewController.h"
#import "InterestFriendCell.h"
#import "FriendService.h"
#import "CompanyService.h"
#import "PendModel.h"
#import "CompanyService.h"
#import "CompanyClaimCell.h"

static NSArray *sectionArray;
static NSArray *sectionButtonArray;
static NSArray *sectionHeightArray;
@interface PendViewController ()

@property (nonatomic,strong)PendModel *pendModel;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)BOOL isload;

@end

@implementation PendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"待处理事项";
    self.view.backgroundColor = kBackgroundColor;
    
    sectionArray = @[@"待处理好友申请",@"企业认领申请",@"你可能感兴趣的好友"];
    sectionButtonArray = @[@"更多好友申请>>",@"更多认领申请>>",@"更多好友推荐>>"];
    sectionHeightArray = @[[NSNumber numberWithFloat:35.f],[NSNumber numberWithFloat:35.f],[NSNumber numberWithFloat:30.f]];
    
    self.tableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.tableView];
    
    [self displayOverFlowActivityView];
    [self loadPendDataSource];
    
    [self addInterestFriendRequest];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadPendDataSource];
           
           [self addInterestFriendRequest];
           
    }];
}

- (void)loadPendDataSource {
    
    [CompanyService getTreatedMessageWithSuccess:^(PendModel * _Nonnull data) {
        [self.tableView.mj_header endRefreshing];
        [self removeOverFlowActivityView];
        self.pendModel = data;
        [self setEmptyView];
        [self.tableView reloadData];
        self.isload = YES;
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self.tableView.mj_header endRefreshing];

        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
        [self setEmptyView];
        self.isload = YES;
    }];
    
//    [FriendService getPendFriendWithSuccess:^(PendModel *model) {
//        [self removeOverFlowActivityView];
//        self.pendModel = model;
//        [self.tableView reloadData];
//    } failure:^(NSUInteger code, NSString *errorStr) {
//        [self removeOverFlowActivityView];
//        [self presentSheet:errorStr];
//    }];
}

- (void)addInterestFriendRequest {
    
    [FriendService getRecommendFriendWithSuccess:^(NSArray *array) {
        [self removeOverFlowActivityView];
        [self.tableView.mj_header endRefreshing];

        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:array];
        [self.tableView reloadData];
        [self setEmptyView];
        self.isload = YES;
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self.tableView.mj_header endRefreshing];

        [self setEmptyView];
        self.isload = YES;
    }];
}

- (void)setEmptyView {
    if (self.isload) {
        if (IsArrEmpty(self.dataSource) && IsArrEmpty(self.pendModel.applicationFriend) && IsArrEmpty(self.pendModel.applicationStaff)) {
            self.tableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight];
        } else {
            self.tableView.tableFooterView = [UIView new];
        }
    }
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0)
    {
        return self.pendModel.applicationFriend.count;
    }
    else if (section == 1)
    {
        return self.pendModel.applicationStaff.count;
    }
    else
    {
        return self.dataSource.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    
    if (indexPath.section == 1)
    {
        static NSString *cellStr = @"CompanyClaimCell";
        PendStallModel *model = [self.pendModel.applicationStaff safeObjectAtIndex:indexPath.row];
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
        cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        return cell;
    }
    else
    {
        static NSString *cellStr = @"InterestFriendCell";
        InterestFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[InterestFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        if (indexPath.section == 0) {
            PendFriendModel *model = [self.pendModel.applicationFriend safeObjectAtIndex:indexPath.row];
            cell.pendModel = model;
        }
        else if (indexPath.section == 2) {
            InterestFriendModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
            cell.sureButtonState = SureButtonStateNormal;
            cell.friendModel = model;
        }
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return kCurrentWidth(83);
    }
    return kCurrentWidth(70);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            if (IsArrEmpty(self.pendModel.applicationFriend)) {
                return 0.000000001f;
            }
            return kCurrentWidth(35);
        }
        case 1:
        {
            if (IsArrEmpty(self.pendModel.applicationStaff)) {
                return 0.000000001f;
            }
            return kCurrentWidth(35);
        }
        default:
            if (IsArrEmpty(self.dataSource)) {
                return 0.000000001f;
            }
            return kCurrentWidth(30);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    WeakSelf;
    SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth,[[sectionHeightArray safeObjectAtIndex:section] floatValue]) title:[sectionArray safeObjectAtIndex:section]];
    headView.buttonTitle = [sectionButtonArray safeObjectAtIndex:section];
    headView.buttonState = SectionButtonStateNormel;
    headView.backgroundColor = kBackgroundColor;
    headView.detailButtonBlock = ^{
        [weakSelf sectionDetailButtonClick:section];
    };
    if (section == 0 && IsArrEmpty(self.pendModel.applicationFriend)) {
        return [UIView new];
    }
    if (section == 1 && IsArrEmpty(self.pendModel.applicationStaff)) {
        return [UIView new];
    }
    else if (section == 2 && IsArrEmpty(self.dataSource)) {
        return [UIView new];
    }
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        PendFriendModel *model = [self.pendModel.applicationFriend safeObjectAtIndex:indexPath.row];
        [self gotoAccountViewController:model.userStatus userUid:model.userUid];
    }
    else if (indexPath.section == 1) {
        PendStallModel *model = [self.pendModel.applicationStaff safeObjectAtIndex:indexPath.row];
        [self gotoAccountViewController:@"0" userUid:model.userUid];
    }
    else {
        InterestFriendModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
        [self gotoAccountViewController:model.userStatus userUid:model.userUid];
    }
}

#pragma mark Event
//查看资料权限
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

- (void)sectionDetailButtonClick:(NSInteger)index {
    switch (index) {
        case 0:
        case 1:
        {
            PendDetailViewController *nextCtr = [[PendDetailViewController alloc] init];
            nextCtr.type = @(index).stringValue;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        case 2:
        {
            InterestFriendViewController *nextCtr = [[InterestFriendViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        default:
            break;
    }
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

//通过好友
- (void)passFriendRequestWith:(PendFriendModel *)friendModel {
    
    [self displayOverFlowActivityView];
    [FriendService getPassFriendWithParameters:friendModel.id success:^(NSString *success) {
        [self removeOverFlowActivityView];
        [self presentSheet:success];
        [self loadPendDataSource];
        [self addInterestFriendRequest];
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
        [self loadPendDataSource];
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

- (void)passStallClaimRequestion:(NSString *)uid {
    [self displayOverFlowActivityView];
    [CompanyService passStallCompanyWithParameters:uid success:^(NSString * _Nonnull data) {
        [self removeOverFlowActivityView];
        [self presentSheet:data];
        [self loadPendDataSource];
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
        [self loadPendDataSource];
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark
#pragma mark 懒加载
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
