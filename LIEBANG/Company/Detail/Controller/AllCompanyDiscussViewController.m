//
//  AllCompanyDiscussViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AllCompanyDiscussViewController.h"
#import "CompanyDiscussCell.h"
#import "CompanyService.h"
#import "CompanyCommentModel.h"

@interface AllCompanyDiscussViewController ()

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)BOOL isRefresh;

@end

@implementation AllCompanyDiscussViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"全部点评";
    self.view.backgroundColor = kWhiteColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    self.page = 1;
    self.isRefresh = NO;
    [self getCommentDataSource];
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isRefresh = NO;
        [self getCommentDataSource];
    }];
    
    self.groupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.dataSource.count < 10) {
            [self.groupTableView.mj_footer endRefreshing];
            return;
        }
        
        self.page++;
        self.isRefresh = YES;
        [self getCommentDataSource];
    }];
}

- (void)getCommentDataSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:@"10" forKey:@"pageSize"];
    [postDic setValue:@(self.page).stringValue forKey:@"pageNow"];
    [postDic setValue:self.enterpriseId forKey:@"enterpriseId"];
    
    [self displayOverFlowActivityView];
    [CompanyService getCommentListCompanyWithParameters:postDic success:^(NSArray * _Nonnull data) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        if (self.isRefresh) {
            if (IsArrEmpty(data)) {
                [self presentSheet:@"暂无更多数据"];
            } else {
                [self.dataSource addObjectsFromArray:data];
            }
        } else {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:data];
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

- (void)setEmptyView {
    if (IsArrEmpty(self.dataSource)) {
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
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CompanyCommentModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    static NSString *cellStr = @"CompanyDiscussCell";
    CompanyDiscussCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[CompanyDiscussCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyDiscussCell *cell = (CompanyDiscussCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark
#pragma mark 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
