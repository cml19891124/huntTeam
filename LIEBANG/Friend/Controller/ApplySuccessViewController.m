//
//  ApplySuccessViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/24.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ApplySuccessViewController.h"
#import "ApplySuccessViewController.h"
#import "InterestFriendCell.h"
#import "InterestFriendModel.h"
#import "FriendService.h"

@interface ApplySuccessViewController ()

@property (nonatomic,strong)SectionHeadView *titleView;
@property (nonatomic,strong)UIButton *statusButton;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation ApplySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
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
    cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
        [weakSelf pushToMosaicVC:imageUrl];
    };
    cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
        [weakSelf pushToMosaicVC:imageUrl];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(70);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

#pragma mark Event
- (void)backNavItemTapped {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addFriendRequestWith:(InterestFriendModel *)model {
    
    [self displayOverFlowActivityView];
    [FriendService getAddFriendWithParameters:model.userUid success:^(NSString *success) {
        [self removeOverFlowActivityView];
        [self presentSheet:success];
        model.isApplyStatus = @"0";
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark UI
- (void)createSubViews {
    
    self.view.backgroundColor = kWhiteColor;
    self.navigationItem.title = @"申请成功";
    
    [self setRightNaviBtnTitle:@"完成"];
    [self.rightNaviBtn addTarget:self action:@selector(backNavItemTapped) forControlEvents:UIControlEventTouchUpInside];
    
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusButton.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(100));
    [_statusButton setTitle:@"申请成功，请等待通过" forState:UIControlStateNormal];
    [_statusButton setTitleColor:kLBBlackColor forState:UIControlStateNormal];
    _statusButton.titleLabel.font = kSystem(16);
    [_statusButton setImage:[UIImage imageNamed:@"list_icon_sel.png"] forState:UIControlStateNormal];
    [_statusButton setImgViewStyle:ButtonImgViewStyleLeft imageSize:CGSizeMake(48, 48) space:10];
    [self.view addSubview:_statusButton];
    
    _titleView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, _statusButton.bottom, kDeviceWidth, kCurrentWidth(40)) title:@"你可能感兴趣的好友"];
    _titleView.backgroundColor = kBackgroundColor;
    [self.view addSubview:_titleView];
    
    self.groupTableView.frame = CGRectMake(0, _titleView.bottom, kDeviceWidth, kDeviceHeight-kNavBarHeight-_titleView.bottom);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    
    [self addInterestFriendRequest];
}

- (void)addInterestFriendRequest {
    
    [self displayOverFlowActivityView];
    [FriendService getRecommendFriendWithSuccess:^(NSArray *array) {
        [self removeOverFlowActivityView];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:array];
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
