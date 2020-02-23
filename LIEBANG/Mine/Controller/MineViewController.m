//
//  MineViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/6/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "MineViewController.h"
#import "SetupViewController.h"
#import "CouponListViewController.h"
#import "CertiViewController.h"
#import "AccountViewController.h"
#import "AddThemeViewController.h"
#import "WalletViewController.h"
#import "CouponViewController.h"
#import "OrderListViewController.h"
#import "ScoreViewController.h"
#import "CompanyCollectViewController.h"

#import "CommentPickView.h"

#import "MineCell.h"
#import "MineHeadCell.h"
#import "AccountInfo.h"

@interface MineViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)AccountInfo *accountInfo;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我";
    self.view.backgroundColor = kWhiteColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kTabBarViewHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MineService getUserMsgInfoWithSuccess:^(AccountInfo *info) {
            self.accountInfo = info;
            [self.groupTableView reloadData];
        } failure:^(NSUInteger code, NSString *errorStr) {
            
        }];
    });
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [LBForProject currentProject].mineCellTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[LBForProject currentProject].mineCellTitleArray safeObjectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    switch (indexPath.section) {
        case 0:
        {//个人中心头部cell
            static NSString *cellStr = @"MineHeadCell";
            MineHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[MineHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
//            [cell loadAccountMessage:self.accountInfo];
            cell.model = self.accountInfo;
            
            cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
                [weakSelf pushToMosaicVC:imageUrl];
            };
            cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
                [weakSelf pushToMosaicVC:imageUrl];
            };
            [cell layoutIfNeeded];
            return cell;
        }
            break;
        default:
        {//个人中心非头部部分，统一的cell样式部分，接口获取的数据
            static NSString *cellStr = @"MineCell";
            MineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[MineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            cell.indexPath = indexPath;
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return kCurrentWidth(66);
        default:
            return kCurrentWidth(42);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        AccountViewController *nextCtr = [[AccountViewController alloc] init];
        nextCtr.accountState = AccountStateNormal;
        nextCtr.userUid = [Config currentConfig].userUid;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if (indexPath.section == 1)
    {
        AccountViewController *nextCtr = [[AccountViewController alloc] init];
        nextCtr.accountState = AccountStateEdit;
        nextCtr.userUid = [Config currentConfig].userUid;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            OrderListViewController *nextCtr = [[OrderListViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else if (indexPath.row == 1)
        {
            WalletViewController *nextCtr = [[WalletViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else if (indexPath.row == 2)
        {
            CouponViewController *nextCtr = [[CouponViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            CertiViewController *nextCtr = [[CertiViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else
        {
            CompanyCollectViewController *nextCtr = [[CompanyCollectViewController alloc] init];
            nextCtr.isRenLin = YES;
            nextCtr.userUid = [Config currentConfig].userUid;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
    }
    else if (indexPath.section == 4)
    {
        if (indexPath.row == 0)
        {
            ScoreViewController *nextCtr = [[ScoreViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else
        {
            SetupViewController *nextCtr = [[SetupViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
    }
}
//#pragma mark - 禁止下拉
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGPoint offset = scrollView.contentOffset;
//    if (offset.y <= 0) {
//        offset.y = 0;
//    }
//    
//    scrollView.contentOffset = offset;
//
//}

@end
