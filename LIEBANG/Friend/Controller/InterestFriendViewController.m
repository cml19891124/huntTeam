//
//  InterestFriendViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "InterestFriendViewController.h"
#import "SearchViewController.h"
#import "InterestFriendCell.h"
#import "SearchFriendHeadView.h"
#import "SearchService.h"
#import "SearchFriendModel.h"
#import "FriendService.h"
#import "InterestFriendModel.h"

@interface InterestFriendViewController ()

@property (nonatomic,strong)SearchFriendHeadView *headView;

@property (nonatomic,strong)SearchFriendModel *searchModel;

@property (nonatomic,strong)NSMutableArray *dataSource;

@property (nonatomic,strong)NSMutableArray *itemSource;

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,assign)BOOL isRefresh;
@property (nonatomic,assign)BOOL isSearch;

@end

@implementation InterestFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WeakSelf;
    self.navigationItem.title = @"拓展人脉";
    self.view.backgroundColor = kWhiteColor;
    
    [self.view addSubview:self.headView];
    self.headView.searchButtonBlock = ^(NSString *keyWord) {
        [weakSelf searchButtonClick:keyWord];
    };
    
    self.groupTableView.frame = CGRectMake(0, self.headView.bottom, kDeviceWidth, kDeviceHeight-kNavBarHeight-self.headView.height);
    self.groupTableView.backgroundColor = kWhiteColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    
    self.page = 1;
    self.isRefresh = NO;
    
    [self addInterestFriendRequest];
}

- (void)addInterestFriendRequest {
    
    [self displayOverFlowActivityView];
    [FriendService getRecommendFriendWithSuccess:^(NSArray *array) {
        [self removeOverFlowActivityView];
        [self.itemSource removeAllObjects];
        [self.itemSource addObjectsFromArray:array];
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataSource.count;
    }
    return self.itemSource.count >= 10?10:self.itemSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    
    if (indexPath.section == 0)
    {
        InterestFriendModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
        static NSString *cellStr = @"InterestFriendCellone";
        InterestFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[InterestFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.sureButtonState = SureButtonStateNormal;
        cell.friendModel = model;
        cell.sureButtonBlock = ^(InterestFriendModel *friendModel) {
            [weakSelf addFriendRequestWith:friendModel];
        };
        cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        return cell;
    }
    else if (indexPath.section == 1)
    {
        InterestFriendModel *model = [self.itemSource safeObjectAtIndex:indexPath.row];
        static NSString *cellStr = @"InterestFriendCelltwo";
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
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(70);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 32.f;
    }
    return 0.000000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (IsArrEmpty(self.dataSource) && section == 0 && self.isSearch) {
        return kCurrentWidth(350);
    }
    return 0.00000000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (IsArrEmpty(self.dataSource) && section == 0 && self.isSearch) {
        UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(350))];
        foot.backgroundColor = kWhiteColor;
        NoDataView *noView = [[NoDataView alloc] initWithHeight:kCurrentWidth(350)];
        noView.titleString = @"暂无匹配人脉";
        [foot addSubview:noView];
        return foot;
    }
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 32) title:@"你可能感兴趣的好友"];
        headView.backgroundColor = kBackgroundColor;
        return headView;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    InterestFriendModel *model = [[InterestFriendModel alloc] init];
    if (indexPath.section == 0)
    {
        model = [self.dataSource safeObjectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        model = [self.itemSource safeObjectAtIndex:indexPath.row];
    }

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

- (void)searchTfCancel:(UITapGestureRecognizer *)tap {
    [self.headView resignSearchFirstResponder];
}

- (void)searchButtonClick:(NSString *)keyWord {
    
    if (IsStrEmpty(keyWord) || IsNilOrNull(keyWord)) {
        [self showAlertWithString:@"请输入搜索关键字"];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:@"10" forKey:@"pageSize"];
    [postDic setValue:[NSNumber numberWithInteger:1] forKey:@"pageNow"];
    [postDic setValue:keyWord forKey:@"content"];
    
    [self displayOverFlowActivityView];
    [SearchService getSearchFriendWithParameters:postDic success:^(SearchFriendModel *model) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        self.isSearch = YES;
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:model.searchFriend];
//        if (self.isRefresh) {
//            if (IsArrEmpty(model.searchFriend)) {
//                [self presentSheet:@"暂无更多数据"];
//            } else {
//                [self.dataSource insertObject:model.searchFriend atIndex:0];
//            }
//        } else {
//            [self.dataSource insertObject:model.searchFriend atIndex:0];
//        }
        
//        if (IsArrEmpty(self.dataSource)) {
//            self.groupTableView.tableFooterView = [[NoDataView alloc] init];
//        } else {
//            self.groupTableView.tableFooterView = [UIView new];
//        }
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        [self presentSheet:errorStr];
    }];
}

#pragma mark UI
- (SearchFriendHeadView *)headView {
    if (!_headView) {
        _headView = [[SearchFriendHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(72))];
    }
    return _headView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)itemSource {
    if (!_itemSource) {
        _itemSource = [NSMutableArray array];
    }
    return _itemSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
