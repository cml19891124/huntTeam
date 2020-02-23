//
//  FriendViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/6/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "FriendViewController.h"
#import "MyFriendViewController.h"
#import "InterestFriendViewController.h"
#import "AccountViewController.h"

#import "FriendHeadCell.h"
#import "InterestFriendCell.h"
#import "FriendService.h"
#import "SearchService.h"
#import "SearchFriendModel.h"
#import "InterestFriendModel.h"

@interface FriendViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"人脉办事";
    self.view.backgroundColor = kWhiteColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kTabBarViewHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    
    [self displayOverFlowActivityView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addInterestFriendRequest];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [FriendService getFriendListWithSuccess:^(FriendListModel *model) {
            [self.groupTableView reloadData];
        } failure:^(NSUInteger code, NSString *errorStr) {
        }];
    });
}

- (void)addInterestFriendRequest {
    
    [FriendService getRecommendFriendWithSuccess:^(NSArray *array) {
        [self removeOverFlowActivityView];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:array];
        if (IsArrEmpty(self.dataSource)) {
            self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kTabBarViewHeight];
        } else {
            self.groupTableView.tableFooterView = [UIView new];
        }
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        if (IsArrEmpty(self.dataSource)) {
            self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kTabBarViewHeight];
        } else {
            self.groupTableView.tableFooterView = [UIView new];
        }
        [self presentSheet:errorStr];
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        default:
            return self.dataSource.count >= 10?10:self.dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellStr = @"FriendHeadCell";
            FriendHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[FriendHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            cell.indexPath = indexPath;
            cell.dataSource = self.dataSource;
            return cell;
        }
            break;
        default:
        {
            InterestFriendModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
            static NSString *cellStr = @"InterestFriendCell";
            InterestFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[InterestFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            cell.sureButtonState = SureButtonStateNormal;
            cell.friendModel = model;
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
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 40.f;
    }
    return 0.000000001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40) title:@"你可能感兴趣的好友"];
        return headView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return kCurrentWidth(55);
        default:
            return kCurrentWidth(70);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            MyFriendViewController *nextCtr = [[MyFriendViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else
        {
            InterestFriendViewController *nextCtr = [[InterestFriendViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
    }
    else
    {
        InterestFriendModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
        AccountViewController *nextCtr = [[AccountViewController alloc] init];
        nextCtr.userUid = model.userUid;
        if ([model.userStatus intValue] == 0) {
            nextCtr.accountState = AccountStateOther;
        }
        else {
            nextCtr.accountState = AccountStateDisabled;
        }
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
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
//#pragma mark - 禁止下拉
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGPoint offset = scrollView.contentOffset;
//    if (offset.y <= 0) {
//        offset.y = 0;
//    }
//    scrollView.contentOffset = offset;
//    
//}

@end
