//
//  MyFriendViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "MyFriendViewController.h"
#import "AccountViewController.h"
#import "ConversationViewController.h"
#import "SearchService.h"
#import "FriendCell.h"
#import "FriendListModel.h"
#import "FriendService.h"
#import "NoDataView.h"

#import "MESearchTextField.h"

@interface MyFriendViewController ()<UITextFieldDelegate>
{
    MESearchTextField *search;
}
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *showSource;

@end

@implementation MyFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(45))];
    head.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    
    UIButton *searchImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    [searchImage setImage:IMAGE_NAMED(@"nav_button_search") forState:UIControlStateNormal];
    searchImage.contentMode = UIViewContentModeCenter;
    searchImage.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    searchImage.contentMode = UIViewContentModeCenter;
    
    search = [[MESearchTextField alloc] initWithFrame:CGRectMake(kCurrentWidth(32), 8, kDeviceWidth-kCurrentWidth(64), kCurrentWidth(30))];
    search.layer.cornerRadius = kCurrentWidth(15);
    search.layer.masksToBounds = YES;
    search.placeholder = @" 搜索人名";
    search.font = [UIFont systemFontOfSize:13];
    search.backgroundColor = kWhiteColor;
    search.returnKeyType = UIReturnKeySearch;
    search.leftView = searchImage;
    search.leftViewMode = UITextFieldViewModeAlways;
    search.delegate = self;
    [head addSubview:search];
    
    self.view.backgroundColor = kBackgroundColor;
    
    self.tableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.sectionIndexColor = [UIColor colorWithHexString:@"0F6ABF"];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];//设置选中时，索引背景颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = head;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    if (IsStrEmpty(self.userUid) || IsNilOrNull(self.userUid)) {
        [self displayOverFlowActivityView];
        [self loadFriendListDataSource];
        self.navigationItem.title = @"我的好友";
    }
    else {
        [self loadOtherFriendDataSource];
        self.navigationItem.title = @"他的好友";
    }
}

- (void)loadOtherFriendDataSource {
    
    [self displayOverFlowActivityView];
    [FriendService getOtherFriendWithParameters:self.userUid success:^(FriendListModel *model) {
        [self removeOverFlowActivityView];
        [Config currentConfig].friendCount = [NSString stringWithFormat:@"%zd",model.data.count];
        NSArray  *indexArray= [model.data arrayWithPinYinFirstLetterFormat];
        self.dataSource = [NSMutableArray arrayWithArray:indexArray];
        self.showSource = [NSMutableArray arrayWithArray:self.dataSource];
        
        if (IsArrEmpty(self.showSource)) {
            self.tableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kViewHeight];
        } else {
            self.tableView.tableFooterView = [UIView new];
        }
        
        [self.tableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
        
        if (IsArrEmpty(self.showSource)) {
            self.tableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kViewHeight];
        } else {
            self.tableView.tableFooterView = [UIView new];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (IsStrEmpty(self.userUid) || IsNilOrNull(self.userUid)) {
        [self loadFriendListDataSource];
    }
}

- (void)loadFriendListDataSource {
    
    [FriendService getFriendListWithSuccess:^(FriendListModel *model) {
        [self removeOverFlowActivityView];
        NSArray  *indexArray= [model.data arrayWithPinYinFirstLetterFormat];
        self.dataSource = [NSMutableArray arrayWithArray:indexArray];
        self.showSource = [NSMutableArray arrayWithArray:self.dataSource];
        
        if (IsArrEmpty(self.showSource)) {
            self.tableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kViewHeight];
        } else {
            self.tableView.tableFooterView = [UIView new];
        }
        
        [self.tableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
        
        if (IsArrEmpty(self.showSource)) {
            self.tableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kViewHeight];
        } else {
            self.tableView.tableFooterView = [UIView new];
        }
    }];
}

- (void)searchFriendRequestWith:(NSString *)keyword {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:@"10" forKey:@"pageSize"];
    [postDic setValue:@"1" forKey:@"pageNow"];
    [postDic setValue:keyword forKey:@"content"];
    
    NSLog(@"搜索好友 = %@",postDic);
    
    [self displayOverFlowActivityView];
    [SearchService getSearchFriendWithParameters:postDic success:^(SearchFriendModel *model) {
        [self removeOverFlowActivityView];
        NSArray  *indexArray= [model.userFriend arrayWithPinYinFirstLetterFormat];
        self.showSource = [NSMutableArray arrayWithArray:indexArray];
        
        if (IsArrEmpty(self.showSource)) {
            NoDataView *dataView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kCurrentWidth(44)-kViewHeight];
            dataView.titleString = @"无相关好友";
            self.tableView.tableFooterView = dataView;
        }
        else {
            self.tableView.tableFooterView = [UIView new];
        }
        
        [self.tableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        NoDataView *dataView = [[NoDataView alloc] init];
        dataView.titleString = errorStr;
        self.tableView.tableFooterView = dataView;
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.showSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *dict = self.showSource[section];
    NSMutableArray *array = dict[@"content"];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    NSDictionary *dict = self.showSource[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    FriendModel *model = [array safeObjectAtIndex:indexPath.row];
    static NSString *cellStr = @"FriendCell";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.friendModel = model;
    cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
        [weakSelf pushToMosaicVC:imageUrl];
    };
    cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
        [weakSelf pushToMosaicVC:imageUrl];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(60);
}

// 每个分区的页眉
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = self.showSource[section];
    NSString *title = dict[@"firstLetter"];
    return title;
}

// 索引目录
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *resultArray =[NSMutableArray arrayWithObject:UITableViewIndexSearch];
    for (NSDictionary *dict in self.showSource) {
        NSString *title = dict[@"firstLetter"];
        [resultArray addObject:title];
    }
    return resultArray;
}

// 点击目录
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([title isEqualToString:UITableViewIndexSearch])
    {
        [tableView setContentOffset:CGPointZero animated:NO];//tabview移至顶部
        return NSNotFound;
    }
    else
    {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 添加了搜索标识
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kCurrentWidth(20);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionHeadView *sectionView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(20)) title:self.showSource[section][@"firstLetter"]];
    sectionView.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.showSource[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    FriendModel *model = [array safeObjectAtIndex:indexPath.row];
    if (IsStrEmpty(self.userUid) || IsNilOrNull(self.userUid)) {
        
        if (_messageButtonBlock)
        {
            _messageButtonBlock(model);
            [self backNavItemTapped];
        }
        else
        {
            ConversationViewController *_conversationVC = [[ConversationViewController alloc]init];
            _conversationVC.conversationType = ConversationType_PRIVATE;
            _conversationVC.targetId = model.userUid;
            _conversationVC.title = model.userName;
            _conversationVC.message = self.message;
            _conversationVC.cardMessage = self.cardMessage;
            _conversationVC.shareMessage = self.shareMessage;
            _conversationVC.companyMessage = self.companyMessage;
            
            RCUserInfo *user = [RCUserInfo new];
            user.name = model.userName;
            user.userId = model.userUid;
            user.portraitUri = model.userHead;
            [[RCDataManager shareManager] addRCUserInfo:user];
            
            [self.navigationController pushViewController:_conversationVC animated:YES];
        }
    }
    else {
        AccountViewController *nextCtr = [[AccountViewController alloc] init];
        nextCtr.accountState = AccountStateOther;
        nextCtr.userUid = model.userUid;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (IsStrEmpty(textField.text) || IsNilOrNull(textField.text)) {
        [self showAlertWithString:@"请输入关键字"];
        return NO;
    }
    [self searchFriendRequestWith:textField.text];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (IsStrEmpty(string))
    {
        self.showSource = [NSMutableArray arrayWithArray:self.dataSource];
        [self.tableView reloadData];
    }
    return YES;
}

#pragma mark 懒加载
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
