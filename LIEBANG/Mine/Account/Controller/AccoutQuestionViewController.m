//
//  AccoutQuestionViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/18.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccoutQuestionViewController.h"
#import "QuestionDetailViewController.h"
#import "AccountQuestionCell.h"
#import "AccountService.h"

@interface AccoutQuestionViewController ()

@property (nonatomic,strong)NSMutableArray *dataSource;

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,assign)BOOL isRefresh;

@end

@implementation AccoutQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"问答列表";
    self.view.backgroundColor = kBackgroundColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    
    self.page = 1;
    self.isRefresh = NO;
    [self loadAccountQuestionDataSource];
    
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isRefresh = NO;
        [self loadAccountQuestionDataSource];
    }];
    
    self.groupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.dataSource.count < 10) {
            [self.groupTableView.mj_footer endRefreshing];
            return;
        }
        
        self.page++;
        self.isRefresh = YES;
        [self loadAccountQuestionDataSource];
    }];
    
}

- (void)loadAccountQuestionDataSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    
    if (self.accountState == AccountStateOther)
    {
        [postDic setValue:@"1" forKey:@"type"];//0：自己问答    1：他人问答
        [postDic setValue:self.userUid forKey:@"userUid"];
    }
    else
    {
        [postDic setValue:@"0" forKey:@"type"];//0：自己问答    1：他人问答
    }
    
    [postDic setValue:[NSNumber numberWithInteger:self.page] forKey:@"pageNow"];
    [postDic setValue:@"10" forKey:@"pageSize"];
    
    NSLog(@"问答列表postDic == %@",postDic);
    
    [self displayOverFlowActivityView];
    [AccountService getAccountQuestionWithParameters:postDic success:^(NSArray *array) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        
        if (self.isRefresh) {
            if (IsArrEmpty(array)) {
                [self presentSheet:@"暂无更多数据"];
            } else {
                [self.dataSource addObjectsFromArray:array];
            }
        } else {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:array];
        }
        
        if (IsArrEmpty(self.dataSource)) {
            self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kViewHeight];
        } else {
            self.groupTableView.tableFooterView = [UIView new];
        }
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        if (IsArrEmpty(self.dataSource)) {
            self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kViewHeight];
        } else {
            self.groupTableView.tableFooterView = [UIView new];
        }
        [self presentSheet:errorStr];
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuestionClassModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    static NSString *cellStr = @"AccountQuestionCell";
    AccountQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[AccountQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.questionClassModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountQuestionCell *cell = (AccountQuestionCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
    return [cell getHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QuestionClassModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    QuestionDetailViewController *nextCtr = [[QuestionDetailViewController alloc] init];
    nextCtr.detailType = QuestionDetailTypeVisitor;
    if (self.accountState == AccountStateNormal || self.accountState == AccountStateEdit) {
        nextCtr.isMy = YES;
    }
    nextCtr.questionUid = model.id;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

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
