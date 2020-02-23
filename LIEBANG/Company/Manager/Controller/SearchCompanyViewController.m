//
//  SearchCompanyViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "SearchCompanyViewController.h"
#import "SearchFriendHeadView.h"
#import "CompanyDetailViewController.h"
#import "AllPersonnelViewController.h"
#import "CompanyCell.h"
#import "CompanyModel.h"
#import "CompanyService.h"

@interface SearchCompanyViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)SearchFriendHeadView *headView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSString *keyWord;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)BOOL isRefresh;

@end

@implementation SearchCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推广企业AI智能名片";
    self.view.backgroundColor = kWhiteColor;
    
    WeakSelf;
    [self.view addSubview:self.headView];
    self.headView.searchButtonBlock = ^(NSString *keyWord) {
        
        if (IsStrEmpty(keyWord) || IsNilOrNull(keyWord)) {
            [weakSelf showAlertWithString:@"请输入搜索关键字"];
            return;
        }
        
        weakSelf.keyWord = keyWord;
        [weakSelf searchButtonClick:keyWord];
    };
    
    self.groupTableView.frame = CGRectMake(0, self.headView.bottom, kDeviceWidth, kDeviceHeight-kNavBarHeight-self.headView.height);
    self.groupTableView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.groupTableView];
    
    self.page = 1;
    self.isRefresh = NO;
    
//    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        if (IsStrEmpty(self.keyWord) || IsNilOrNull(self.keyWord)) {
//            [self.groupTableView.mj_header endRefreshing];
//            return;
//        }
//        self.page = 1;
//        self.isRefresh = NO;
//        [self searchButtonClick:self.keyWord];
//    }];
    
//    self.groupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
//        if (self.dataSource.count < 10) {
//            [self.groupTableView.mj_footer endRefreshing];
//            return;
//        }
//
//        if (IsStrEmpty(self.keyWord) || IsNilOrNull(self.keyWord)) {
//            [self.groupTableView.mj_footer endRefreshing];
//            return;
//        }
//
//        self.page++;
//        self.isRefresh = YES;
//        [self searchButtonClick:self.keyWord];
//    }];
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
    static NSString *cellStr = @"CompanyCell";
    CompanyModel *model = [self.dataSource safeObjectAtIndex:indexPath.section];
    CompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[CompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.companyState = CompanyCellStateDisable;
    cell.companyModel = model;
    cell.allPersonnelMessageBlock = ^(NSString * _Nonnull uid) {
        [weakSelf allPersonnelMessage:uid];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(227 + 35);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CompanyModel *model = [self.dataSource safeObjectAtIndex:indexPath.section];
    CompanyDetailViewController *nextCtr = [[CompanyDetailViewController alloc] init];
    nextCtr.companyUid = model.id;
    nextCtr.companyName = model.companyAbbreviation;
    if (model.isSelf.boolValue) {
        nextCtr.companyType = @"0";
        nextCtr.isSelf = [model.isSelf boolValue];
    }
    else {
        nextCtr.companyType = @"1";
        nextCtr.isSelf = [model.isSelf boolValue];

    }
    [self.navigationController pushViewController:nextCtr animated:YES];
}

#pragma mark Event
- (void)allPersonnelMessage:(NSString *)uid {
    AllPersonnelViewController *nextCtr = [[AllPersonnelViewController alloc] init];
    nextCtr.enterpriseId = uid;
    nextCtr.type = @"1";
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)searchTfCancel:(UITapGestureRecognizer *)tap {
    [self.headView resignSearchFirstResponder];
}

- (void)searchButtonClick:(NSString *)keyWord {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:keyWord forKey:@"content"];
    [postDic setValue:@"10" forKey:@"pageSize"];
    [postDic setValue:@(self.page).stringValue forKey:@"pageNow"];
    
    NSLog(@"搜索企业 == %@",postDic);
    
    [self displayOverFlowActivityView];
    [CompanyService searchCompanyListWithParameters:postDic success:^(NSArray * _Nonnull data) {
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
        self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-self.headView.height];
    } else {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(10))];
        bottomView.backgroundColor = kWhiteColor;
        self.groupTableView.tableFooterView = bottomView;
    }
}

#pragma mark UI
- (SearchFriendHeadView *)headView {
    if (!_headView) {
        _headView = [[SearchFriendHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(72))];
        _headView.placeholder = @"搜索企业名片";
    }
    return _headView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
#pragma mark - 禁止下拉
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGPoint offset = scrollView.contentOffset;
//    if (offset.y <= 0) {
//        offset.y = 0;
//    }
//    
//    scrollView.contentOffset = offset;
//    #pragma mark - 禁止上拉
//
//    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
//      scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height);
//      return;
//    }
//}

@end
