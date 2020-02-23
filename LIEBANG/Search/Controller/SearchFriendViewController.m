//
//  SearchFriendViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/25.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "SearchFriendViewController.h"
#import "MyFriendViewController.h"
#import "InterestFriendViewController.h"
#import "InterestFriendCell.h"
#import "SearchService.h"
#import "SearchFriendModel.h"
#import "InterestFriendModel.h"
#import "FriendModel.h"
#import "MoreFootView.h"
#import "FriendService.h"

@interface SearchFriendViewController ()

@property (nonatomic,strong)SearchFriendModel *searchFriendModel;
@property (nonatomic,assign)BOOL isSearch;

@end

@implementation SearchFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight-kCurrentWidth(40));
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
}

- (void)setFriendString:(NSString *)friendString {
    _friendString = friendString;
    
    [self searchFriendRequestWith:friendString];
}

- (void)searchFriendRequestWith:(NSString *)keyword {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:@"10" forKey:@"pageSize"];
    [postDic setValue:@"1" forKey:@"pageNow"];
    [postDic setValue:keyword forKey:@"content"];
    
    NSLog(@"搜索好友 = %@",postDic);
    
    [self displayOverFlowActivityView];
    [SearchService getSearchFriendWithParameters:postDic success:^(SearchFriendModel *model) {
        [self removeOverFlowActivityView];
        self.searchFriendModel = model;
        self.isSearch = YES;
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
    if (section == 0)
    {
        return self.searchFriendModel.userFriend.count;
    }
    else
    {
        return self.searchFriendModel.searchFriend.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    static NSString *cellStr = @"InterestFriendCell";
    InterestFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[InterestFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.sureButtonState = SureButtonStateSearchNormal;
    if (indexPath.section == 0)
    {
        FriendModel *model = [self.searchFriendModel.userFriend safeObjectAtIndex:indexPath.row];
        cell.sureButtonState = SureButtonStateSearchNoButton;
        cell.userFriendModel = model;
    }
    else if (indexPath.section == 1)
    {
        WeakSelf;
        InterestFriendModel *model = [self.searchFriendModel.searchFriend safeObjectAtIndex:indexPath.row];
        cell.sureButtonState = SureButtonStateNormal;
        cell.friendModel = model;
        cell.sureButtonBlock = ^(InterestFriendModel *friendModel) {
            [weakSelf addFriendRequestWith:friendModel];
        };
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        if (IsArrEmpty(self.searchFriendModel.userFriend) && self.isSearch) {
            return kCurrentWidth(350);
        }
        else {
            return kCurrentWidth(43);
        }
    }
    else {
        if (IsArrEmpty(self.searchFriendModel.searchFriend) && self.isSearch) {
            return kCurrentWidth(350);
        }
        else {
            return kCurrentWidth(43);
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    WeakSelf;
    if (section == 0)
    {
        if (IsArrEmpty(self.searchFriendModel.userFriend) && self.isSearch) {
            UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(350))];
            foot.backgroundColor = kWhiteColor;
            NoDataView *noView = [[NoDataView alloc] initWithHeight:kCurrentWidth(350)];
            noView.titleString = @"暂无好友";
            [foot addSubview:noView];
            return foot;
        }
        else {
            MoreFootView *footView = [[MoreFootView alloc] initWithTitle:@"更多好友>>"];
            footView.moreButtonBlock = ^{
                MyFriendViewController *nextCtr = [[MyFriendViewController alloc] init];
                [weakSelf.navigationController pushViewController:nextCtr animated:YES];
            };
            return footView;
        }
    }
    else if (section == 1)
    {
        if (IsArrEmpty(self.searchFriendModel.searchFriend) && self.isSearch) {
            UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(350))];
            foot.backgroundColor = kWhiteColor;
            NoDataView *noView = [[NoDataView alloc] initWithHeight:kCurrentWidth(350)];
            noView.titleString = @"暂无匹配人脉";
            [foot addSubview:noView];
            return foot;
        }
        else {
            MoreFootView *footView = [[MoreFootView alloc] initWithTitle:@"更多人脉>>"];
            footView.moreButtonBlock = ^{
                InterestFriendViewController *nextCtr = [[InterestFriendViewController alloc] init];
                [weakSelf.navigationController pushViewController:nextCtr animated:YES];
            };
            return footView;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        FriendModel *model = [self.searchFriendModel.userFriend safeObjectAtIndex:indexPath.row];
        AccountViewController *nextCtr = [[AccountViewController alloc] init];
        nextCtr.userUid = model.userUid;
        nextCtr.accountState = AccountStateOther;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if (indexPath.section == 1)
    {
        InterestFriendModel *model = [self.searchFriendModel.searchFriend safeObjectAtIndex:indexPath.row];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
