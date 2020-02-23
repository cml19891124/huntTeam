//
//  SearchQuestionViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/25.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "SearchQuestionViewController.h"
#import "QuestionDetailViewController.h"
#import "HomeQuestionCell.h"
#import "SearchService.h"
#import "QuestionClassModel.h"

@interface SearchQuestionViewController ()

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)NSInteger page;

@property (nonatomic,assign)BOOL isRefresh;
@end

@implementation SearchQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight-kCurrentWidth(40));
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (IsStrEmpty(self.questionString)) {
            [self.groupTableView.mj_header endRefreshing];
            return;
        }
        
        self.page = 1;
        self.isRefresh = NO;
        [self searchQuestionRequestWith:self.questionString];
    }];
    
    self.groupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (IsStrEmpty(self.questionString)) {
            [self.groupTableView.mj_footer endRefreshing];
            return;
        }
        
        if (self.dataSource.count < 10) {
            [self.groupTableView.mj_footer endRefreshing];
            return;
        }
        
        self.page++;
        self.isRefresh = YES;
        [self searchQuestionRequestWith:self.questionString];
    }];
}

- (void)setQuestionString:(NSString *)questionString {
    _questionString = questionString;
    
    self.page = 1;
    self.isRefresh = NO;
    [self searchQuestionRequestWith:questionString];
}

- (void)searchQuestionRequestWith:(NSString *)keyword {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:keyword forKey:@"content"];
    [postDic setValue:@"10" forKey:@"pageSize"];
    [postDic setValue:[NSNumber numberWithInteger:self.page] forKey:@"pageNow"];
    
    NSLog(@"搜索问答 = %@",postDic);
    
    [self displayOverFlowActivityView];
    [SearchService getSearchQuestionWithParameters:postDic success:^(NSArray *model) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        
        if (self.isRefresh) {
            if (IsArrEmpty(model)) {
                [self presentSheet:@"暂无更多数据"];
            } else {
                [self.dataSource addObjectsFromArray:model];
            }
        } else {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:model];
        }
        
        if (IsArrEmpty(self.dataSource)) {
            self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kViewHeight-kCurrentWidth(40)];
        } else {
            self.groupTableView.tableFooterView = [UIView new];
        }
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        if (IsArrEmpty(self.dataSource)) {
            self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kViewHeight-kCurrentWidth(40)];
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
    WeakSelf;
    QuestionClassModel *questionModel = [self.dataSource safeObjectAtIndex:indexPath.row];
    static NSString *cellStr = @"HomeQuestionCell";
    HomeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[HomeQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.questionCellState = HomeQuestionCellNormal;
    cell.questionClassModel = questionModel;
    cell.accountButtonBlock = ^{
        [weakSelf gotoAccountViewController:questionModel.dataPrivacyType userUid:questionModel.userUid];
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
    HomeQuestionCell *cell = (HomeQuestionCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
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
    nextCtr.questionUid = model.id;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

//未登陆状态
- (BOOL)gotoLoginViewController {
    LoginModel *account = [SDUserTool account];

    if (IsNilOrNull(account.rongCloudToken) || IsStrEmpty(account.rongCloudToken)) {
//        UIAlertController *alert = [CHAlertView showMessageWith:@"去登陆" title:@"您还没有登陆" confim:^{
            LoginViewController *nextCtr = [[LoginViewController alloc] init];
            CommonNavgationViewController *nextNav = [[CommonNavgationViewController alloc] initWithRootViewController:nextCtr];
            [self.navigationController presentViewController:nextNav animated:YES completion:^{
                
            }];
//        }];
//        [self presentViewController:alert animated:YES completion:nil];
        return YES;
    } else {
        return NO;
    }
}

//查看资料权限
- (void)gotoAccountViewController:(NSString *)dataPrivacyType userUid:(NSString *)userUid {
    
    if ([self gotoLoginViewController]) return;

    AccountViewController *nextCtr = [[AccountViewController alloc] init];
    if ([[Config currentConfig].userUid isEqualToString:userUid]) {
        nextCtr.accountState = AccountStateNormal;
    }
    else {
        nextCtr.accountState = AccountStateOther;
    }
    nextCtr.userUid = userUid;
    [self.navigationController pushViewController:nextCtr animated:YES];
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
