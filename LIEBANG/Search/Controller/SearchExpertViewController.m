//
//  SearchExpertViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "SearchExpertViewController.h"
#import "InterestFriendCell.h"
#import "SearchService.h"
#import "SearchFriendModel.h"
#import "QuestionService.h"

#import "MESearchTextField.h"

@interface SearchExpertViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) MESearchTextField *searchTf;

@property (nonatomic,strong)SearchFriendModel *searchFriendModel;

@property (nonatomic,strong)NSMutableArray *dataSource;

@property (nonatomic,strong)NSMutableArray *selectSource;

@property (nonatomic,strong)NSString *content;

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,assign)BOOL isRefresh;
@end

@implementation SearchExpertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavSubViews];
    self.view.backgroundColor = kWhiteColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    
    self.page = 1;
    self.isRefresh = NO;
    
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (IsStrEmpty(self.content)) {
            [self.groupTableView.mj_header endRefreshing];
            [self showAlertWithString:@"请输入搜索关键字"];
            return;
        }
        
        self.page = 1;
        self.isRefresh = NO;
        [self searchFriendRequestion:self.content];
    }];
    
    self.groupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (IsStrEmpty(self.content)) {
            [self.groupTableView.mj_footer endRefreshing];
            [self showAlertWithString:@"请输入搜索关键字"];
            return;
        }
        
        if (self.dataSource.count < 10) {
            [self.groupTableView.mj_footer endRefreshing];
            return;
        }
        
        self.page++;
        self.isRefresh = YES;
        [self searchFriendRequestion:self.content];
    }];
}

- (void)backNavItemTapped {
    
    if (!IsArrEmpty(self.selectSource)) {
        if (_selectedExpertBlock) {
            _selectedExpertBlock(self.selectSource);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    static NSString *cellStr = @"InterestFriendCell";
    InterestFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[InterestFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.sureButtonState = SureButtonStateQuestion;
//    InterestFriendModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
//    cell.friendModel = model;
    
    VisitorModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    cell.userModel = model;
    
    cell.selectButtonBlock = ^(InterestFriendModel *userModel) {
        [weakSelf.selectSource removeAllObjects];
        [weakSelf.selectSource addObject:userModel];
        [weakSelf backNavItemTapped];
        [weakSelf.groupTableView reloadData];
    };
    cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
        [weakSelf pushToMosaicVC:imageUrl];
    };
    cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
        [weakSelf pushToMosaicVC:imageUrl];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(75);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VisitorModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    
    [Config currentConfig].answerid = model.userUid;
    [self.selectSource removeAllObjects];
    [self.selectSource addObject:model];
    [self backNavItemTapped];
    [self.groupTableView reloadData];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.content = textField.text;
    [Config currentConfig].answerid = nil;
    [self searchFriendRequestion:textField.text];
    return YES;
}

- (void)searchFriendRequestion:(NSString *)keyword {
    
    if (IsStrEmpty(keyword)) {
        [self showAlertWithString:@"请输入搜索关键字"];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:@"10" forKey:@"pageSize"];
    [postDic setValue:[NSNumber numberWithInteger:self.page] forKey:@"pageNow"];
    [postDic setValue:keyword forKey:@"content"];
    
    [self displayOverFlowActivityView];
    [QuestionService getSearchUserWithParameters:postDic success:^(NSArray *array) {
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
    
//    [SearchService getSearchFriendWithParameters:postDic success:^(SearchFriendModel *model) {
//
//    } failure:^(NSUInteger code, NSString *errorStr) {
//
//    }];
}

#pragma mark UI
- (void)createNavSubViews {
    
    self.searchTf = [[MESearchTextField alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-kCurrentWidth(70), 30)];
    self.searchTf.placeholder = @" 搜索行家";
    self.searchTf.backgroundColor = [UIColor colorWithHexString:@"FAFAFA"];
    self.searchTf.font = kSystem(14);
    self.searchTf.layer.cornerRadius = 15;
    self.searchTf.layer.masksToBounds = YES;
    self.searchTf.layer.borderColor = kLBRedColor.CGColor;
    self.searchTf.layer.borderWidth = 0.5;
    self.searchTf.returnKeyType = UIReturnKeySearch;
    self.searchTf.delegate = self;
    
    UIButton *searchImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
        [searchImage setImage:IMAGE_NAMED(@"nav_button_search") forState:UIControlStateNormal];
        searchImage.contentMode = UIViewContentModeCenter;
        searchImage.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
        searchImage.contentMode = UIViewContentModeCenter;
        self.searchTf.leftView = searchImage;
        self.searchTf.leftViewMode = UITextFieldViewModeAlways;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:self.searchTf];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)selectSource {
    if (!_selectSource) {
        _selectSource = [NSMutableArray array];
    }
    return _selectSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
