//
//  MyCompanyListViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "MyCompanyListViewController.h"
#import "CompanyDetailViewController.h"
#import "AllPersonnelViewController.h"
#import "WelcomeViewController.h"
#import "CompanyCertViewController.h"
#import "PersonnelManagerViewController.h"
#import "CompanyCell.h"
#import "CompanyService.h"
#import "CompanyModel.h"

#import "CompanyFeeViewController.h"

@interface MyCompanyListViewController ()

@property (nonatomic,strong)UIButton *saveButton;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation MyCompanyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"我的企业员工管理";
    self.view.backgroundColor = kWhiteColor;
    //10.24注释
//    [self setRightNaviBtnImage:[UIImage imageNamed:@"company_tianjia"]];
//    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(10))];
    bottomView.backgroundColor = kWhiteColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kWhiteColor;
    self.groupTableView.tableFooterView = bottomView;
    [self.view addSubview:self.groupTableView];
    
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getCompanyDataSource];
        });
    }];
    [self getCompanyDataSource];
}

- (void)getCompanyDataSource {
    
    [self displayOverFlowActivityView];
    [CompanyService getCompanyListWithParameters:@"1" success:^(NSArray * _Nonnull data) {
        
        [self.groupTableView.mj_header endRefreshing];
        [self removeOverFlowActivityView];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:data];
        [self setEmptyView];
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self.groupTableView.mj_header endRefreshing];

        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
        [self setEmptyView];
    }];
}

- (void)setEmptyView {
    if (IsArrEmpty(self.dataSource)) {
        self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight];
    } else {
        if (self.isManager) {
            UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(10))];
            bottomView.backgroundColor = kWhiteColor;
            self.groupTableView.tableFooterView = bottomView;
        }
        else {
            //10.24 注释
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(128))];
//            view.backgroundColor = kWhiteColor;
//            [view addSubview:self.saveButton];
//            self.groupTableView.tableFooterView = view;
        }
    }
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    CompanyModel *model = [self.dataSource safeObjectAtIndex:indexPath.section];
    static NSString *cellStr = @"CompanyCell";
    CompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[CompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.companyState = CompanyCellStateNormal;
    cell.companyModel = model;
    cell.allPersonnelMessageBlock = ^(NSString * _Nonnull uid) {
        [weakSelf allPersonnelMessage:uid];
    };
    cell.daleyMessageBlock = ^(CompanyModel * _Nonnull companyModel) {
        [weakSelf daleyMessage:companyModel];
    };
    
    cell.HeaderPersonnelBlock = ^(NSString * _Nonnull uid) {
        AllPersonnelViewController *nextCtr = [[AllPersonnelViewController alloc] init];
        nextCtr.enterpriseId = uid;
        [weakSelf.navigationController pushViewController:nextCtr animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return kCurrentWidth(227 + 35);
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CompanyModel *model = [self.dataSource safeObjectAtIndex:indexPath.section];
    
    if (self.isManager)
    {
//        CompanyDetailViewController *nextCtr = [[CompanyDetailViewController alloc] init];
//        nextCtr.companyUid = model.id;
//        nextCtr.companyName = model.companyAbbreviation;
//        nextCtr.companyType = @"0";
//        [self.navigationController pushViewController:nextCtr animated:YES];
        [self allPersonnelMessage:model.id];
    }
    else
    {
        if ([model.validityDay intValue] > 0)
        {
            CompanyDetailViewController *nextCtr = [[CompanyDetailViewController alloc] init];
            nextCtr.companyUid = model.id;
            nextCtr.companyName = model.companyAbbreviation;
            nextCtr.companyType = @"0";
            nextCtr.isSelf = YES;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else
        {
            [self daleyMessage:model];
        }
    }
    
}

#pragma mark Event
- (void)rightNaviBtnClick {
    WelcomeViewController *nextCtr = [[WelcomeViewController alloc] init];
    nextCtr.isRefee = YES;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)allPersonnelMessage:(NSString *)uid {
    if (self.isManager) {
        PersonnelManagerViewController *nextCtr = [[PersonnelManagerViewController alloc] init];
        nextCtr.enterpriseId = uid;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else {
        AllPersonnelViewController *nextCtr = [[AllPersonnelViewController alloc] init];
        nextCtr.enterpriseId = uid;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}

#pragma mark - 续费界面入口交互事件
- (void)daleyMessage:(CompanyModel *)model {
    WelcomeViewController *nextCtr = [[WelcomeViewController alloc] init];
    nextCtr.isRefee = YES;
    nextCtr.isContiues = YES;
    nextCtr.companyUid = model.id;
    nextCtr.level = model.level;
    nextCtr.isContiuesTwo = ([model.validityDay intValue] > 0)?NO:YES;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)saveButtonClick {
    [self rightNaviBtnClick];
//    CompanyCertViewController *nextCtr = [[CompanyCertViewController alloc] init];
//    [self.navigationController pushViewController:nextCtr animated:YES];
}

#pragma mark
#pragma mark 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(kCurrentWidth(19), kCurrentWidth(44), kDeviceWidth-kCurrentWidth(38), kCurrentWidth(40));
        _saveButton.backgroundColor = kLBRedColor;
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kSystem(16);
        [_saveButton setTitle:@"我要创建企业AI智能名片" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

@end
