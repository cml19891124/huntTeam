//
//  ExpertViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ExpertViewController.h"
#import "InterestFriendCell.h"
#import "QuestionService.h"
#import "VisitorRecordModel.h"

@interface ExpertViewController ()

@property (nonatomic,strong)VisitorRecordModel *userModel;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)BOOL isRefresh;

@property (nonatomic,strong)NSMutableArray *showSource;
@property (nonatomic,assign)BOOL isSearch;

@end

@implementation ExpertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kCurrentWidth(83)-kViewHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isRefresh = NO;
        _isSearch = NO;
        [self loadUserDataSource];
    }];
    
    self.groupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.dataSource.count < 10) {
            [self.groupTableView.mj_footer endRefreshing];
            return;
        }
        
        self.page++;
        self.isRefresh = YES;
        _isSearch = NO;
        [self loadUserDataSource];
    }];
    
    if (!_isSearch) {
        self.page = 1;
        self.isRefresh = NO;
        [self loadUserDataSource];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([self.classifyId intValue] != 0) {
        self.groupTableView.mj_footer.hidden = NO;
    } else {
        self.groupTableView.mj_footer.hidden = YES;
    }
    
    if (!_isSearch) {
        self.page = 1;
        self.isRefresh = NO;
        [self loadUserDataSource];
    }
}

#pragma mark 数据源
- (void)setSearchArray:(NSMutableArray *)searchArray {
    _searchArray = searchArray;
    
    _isSearch = YES;
    [self.showSource removeAllObjects];
    [self.showSource addObjectsFromArray:searchArray];
    [self.groupTableView reloadData];
}
- (void)loadUserDataSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.classifyId forKey:@"classifyId"];
    [postDic setValue:@"10" forKey:@"pageSize"];
    [postDic setValue:[NSNumber numberWithInteger:self.page] forKey:@"pageNow"];
    
    NSLog(@"postDic == %@",postDic);
    
    [self displayOverFlowActivityView];
    [QuestionService getUserByClassifyWithParameters:postDic success:^(VisitorRecordModel *info) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        
        if (self.isRefresh) {
            if (IsArrEmpty(info.data)) {
                [self presentSheet:@"暂无更多数据"];
            } else {
                [self.dataSource addObjectsFromArray:info.data];
            }
        } else {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:info.data];
        }
        
        if (IsArrEmpty(self.dataSource)) {
            self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kCurrentWidth(83)-kViewHeight];
        } else {
            self.groupTableView.tableFooterView = [UIView new];
        }
        
        if (!_isSearch) {
            [self.showSource removeAllObjects];
            [self.showSource addObjectsFromArray:self.dataSource];
        }

        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        if (IsArrEmpty(self.dataSource)) {
            self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kCurrentWidth(83)-kViewHeight];
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
    return self.showSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    static NSString *cellStr = @"InterestFriendCell";
    InterestFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[InterestFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.sureButtonState = SureButtonStateQuestion;
    
    VisitorModel *model = [self.showSource safeObjectAtIndex:indexPath.row];
    cell.userModel = model;
    cell.selectButtonBlock = ^(VisitorModel *userModel) {
        [weakSelf.groupTableView reloadData];
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
    return kCurrentWidth(75);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kCurrentWidth(10);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VisitorModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    
    if ([[Config currentConfig].answerid isEqualToString:model.userUid]) {
        [Config currentConfig].answerid = nil;
    }
    else {
        [Config currentConfig].answerid = model.userUid;
    }
    [self.groupTableView reloadData];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)showSource {
    if (!_showSource) {
        _showSource = [NSMutableArray array];
    }
    return _showSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
