//
//  CompanyHomeViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CompanyHomeViewController.h"
#import "MyCompanyListViewController.h"
#import "CompanyCollectViewController.h"
#import "EditCompanyViewController.h"
#import "CompanyFeeViewController.h"
#import "SearchCompanyViewController.h"
#import "WelcomeViewController.h"
#import "CompanyHomeCell.h"
#import "CompanyFootView.h"
#import "CompanyService.h"

@interface CompanyHomeViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)CompanyFootView *footView;
@property (nonatomic,strong)NSDictionary *dataDic;

@end

@implementation CompanyHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"企业AI智能名片";
    self.view.backgroundColor = kWhiteColor;
    
    self.footView = [[CompanyFootView alloc] initWithFrame:CGRectMake(0, kDeviceHeight-kNavBarHeight-kTabBarViewHeight-kCurrentWidth(100), kDeviceWidth, kCurrentWidth(100)) title:@"" message:@"客服电话：13510019677\n工作日09:00-18:00，我们将竭诚为您服务" subMess:@""];
    self.footView.backgroundColor = kBackgroundColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kTabBarViewHeight);
    self.groupTableView.backgroundColor = kWhiteColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    [self.view addSubview:self.footView];
    [self displayOverFlowActivityView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getCompanyNumber];
}

- (void)getCompanyNumber {
    
    [CompanyService getCompanyNumberWithSuccess:^(NSDictionary * _Nonnull data) {
        [self removeOverFlowActivityView];
        self.dataDic = [NSDictionary dictionaryWithDictionary:data];
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [LBForProject currentProject].companyCellTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[LBForProject currentProject].companyCellTitleArray safeObjectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellStr = @"CompanyHomeCell";
    CompanyHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[CompanyHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.indexPath = indexPath;
    cell.dic = self.dataDic;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10.f;
    }
    return 0.0000000001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10.f)];
        foot.backgroundColor = kBackgroundColor;
        return foot;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            MyCompanyListViewController *nextCtr = [[MyCompanyListViewController alloc] init];
            nextCtr.title = @"我的企业AI智能名片";
//            nextCtr.isManager = NO;

            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else if (indexPath.row == 1)
        {
            MyCompanyListViewController *nextCtr = [[MyCompanyListViewController alloc] init];
            nextCtr.isManager = YES;
            nextCtr.title = @"我的企业员工管理";

            [self.navigationController pushViewController:nextCtr animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            EditCompanyViewController *nextCtr = [[EditCompanyViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else if (indexPath.row == 1)
        {
            WelcomeViewController *nextCtr = [[WelcomeViewController alloc] init];
            nextCtr.isRefee = YES;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else if (indexPath.row == 2)
        {
            SearchCompanyViewController *nextCtr = [[SearchCompanyViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else if (indexPath.row == 3)
        {
            CompanyCollectViewController *nextCtr = [[CompanyCollectViewController alloc] init];
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
