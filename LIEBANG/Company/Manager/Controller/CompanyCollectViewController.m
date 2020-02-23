//
//  CompanyCollectViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CompanyCollectViewController.h"
#import "CompanyDetailViewController.h"
#import "AllPersonnelViewController.h"
#import "CompanyCell.h"
#import "CompanyBottomView.h"
#import "CompanyModel.h"
#import "CompanyService.h"

@interface CompanyCollectViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)CompanyBottomView *footView;

@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)BOOL isRefresh;

@end

@implementation CompanyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.isRenLin?@"我认领的企业名片":@"收藏企业AI智能名片";
    self.view.backgroundColor = kWhiteColor;
    
    [self setRightNaviBtnTitle:@"编辑"];
    self.rightNaviBtn.hidden = YES;
    [self.rightNaviBtn setTitle:@"完成" forState:UIControlStateSelected];
    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.groupTableView];
    [self.view addSubview:self.footView];
    
    if (self.isRenLin)
    {
        self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            self.isRefresh = NO;
            [self getCompanyDataSource];
        }];
        [self getCompanyDataSource];
    }
    else
    {
        self.page = 1;
        self.isRefresh = NO;
        [self getCompanyCollectData];
        
        self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            self.isRefresh = NO;
            [self getCompanyCollectData];
        }];
        
        self.groupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            if (self.dataArray.count < 10) {
                [self.groupTableView.mj_footer endRefreshing];
                return;
            }
            
            self.page++;
            self.isRefresh = YES;
            [self getCompanyCollectData];
        }];
    }
}

- (void)getCompanyDataSource {
    [self.groupTableView.mj_header endRefreshing];

    [self displayOverFlowActivityView];
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    if ([self.userUid isEqualToString:[Config currentConfig].userUid]) {
        [postDic setValue:@"0" forKey:@"type"];//1他人  0本人
        self.navigationItem.title = @"我认领的企业名片";
    }
    else {
        [postDic setValue:@"1" forKey:@"type"];//1他人  0本人
        [postDic setValue:self.userUid forKey:@"userUid"];
        self.navigationItem.title = @"他认领的企业名片";
    }
    
    NSLog(@"认领企业列表postDic == %@",postDic);
    [CompanyService getClaimCompanyListWithParameters:postDic success:^(NSArray * _Nonnull data) {
        [self.groupTableView.mj_header endRefreshing];

        [self removeOverFlowActivityView];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:data];
        [self setEmptyView];
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self.groupTableView.mj_header endRefreshing];

        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
        [self setEmptyView];
    }];
}

- (void)getCompanyCollectData {
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:@(self.page).stringValue forKey:@"pageNow"];
    [postDic setValue:@"10" forKey:@"pageSize"];
    
    [self displayOverFlowActivityView];
    [CompanyService getCompanyCollectListWithParameters:postDic success:^(NSArray * _Nonnull data) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        if (self.isRefresh) {
            if (IsArrEmpty(data)) {
                [self presentSheet:@"暂无更多数据"];
            } else {
                [self.dataArray addObjectsFromArray:data];
            }
        } else {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:data];
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
    if (IsArrEmpty(self.dataArray)) {
        self.rightNaviBtn.hidden = YES;
        self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight];
    } else {
        if (![self.userUid isEqualToString:[Config currentConfig].userUid] && self.isRenLin) {
            self.rightNaviBtn.hidden = YES;
        }
        else {
            self.rightNaviBtn.hidden = NO;
        }
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(10))];
        bottomView.backgroundColor = kWhiteColor;
        self.groupTableView.tableFooterView = bottomView;
    }
}

- (void)removeCompanyCollection:(NSString *)ids {
    [self displayOverFlowActivityView];
    [CompanyService removeCompanyCollectWithParameters:ids success:^(NSString * _Nonnull data) {
        [self removeOverFlowActivityView];
        [self backNavItemTapped];
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)removeCompanyClaim:(NSString *)ids {
    [self displayOverFlowActivityView];
    [CompanyService removeCompanyClaimWithParameters:ids success:^(NSString * _Nonnull data) {
        [self removeOverFlowActivityView];
        [self backNavItemTapped];
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    static NSString *cellStr = @"CompanyCell";
    CompanyModel *model = [self.dataArray safeObjectAtIndex:indexPath.section];
    CompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[CompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    if (self.isRenLin) {
        cell.daleyButton.hidden = YES;

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
    return kCurrentWidth(227 + 35 + 21);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CompanyModel *model = [self.dataArray safeObjectAtIndex:indexPath.section];
    if (tableView.isEditing)
    {
        model.isDelete = !model.isDelete;
        [self.groupTableView reloadData];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        CompanyDetailViewController *nextCtr = [[CompanyDetailViewController alloc] init];
        nextCtr.companyUid = model.id;
        nextCtr.companyName = model.companyAbbreviation;
        nextCtr.companyType = @"1";
        if ([self.userUid isEqualToString:[Config currentConfig].userUid]) {
            nextCtr.isSelf = YES;
            nextCtr.isMine = YES;
        }else{
            nextCtr.isSelf = NO;
            nextCtr.isMine = NO;

        }
        nextCtr.companyName = model.companyAbbreviation?:@"企业AI智能名片";
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark Event---查看全部员工事件
- (void)allPersonnelMessage:(NSString *)uid {
    AllPersonnelViewController *nextCtr = [[AllPersonnelViewController alloc] init];
    nextCtr.enterpriseId = uid;
    nextCtr.type = @"1";
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)rightNaviBtnClick {

    if (![self.userUid isEqualToString:[Config currentConfig].userUid] && self.isRenLin) {
        return;
    }
    
    WeakSelf;
    self.rightNaviBtn.selected = !self.rightNaviBtn.selected;
    [self.groupTableView setEditing:self.rightNaviBtn.selected animated:YES];
    if (self.rightNaviBtn.selected)
    {
        self.footView.selectButtonBlock = ^(BOOL select) {
            [weakSelf reloadTableViewSelect:select];
        };
        self.footView.editButtonBlock = ^{
            [weakSelf callbackEvent];
        };
        self.footView.footHidden = NO;
        self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-40);
    }
    else
    {
        self.footView.footHidden = YES;
        [self reloadTableViewSelect:NO];
        self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    }
}

- (void)reloadTableViewSelect:(BOOL)isSelect {
    
    for (CompanyModel *model in self.dataArray) {
        model.isDelete = isSelect;
    }
    [self.groupTableView reloadData];
}

- (void)callbackEvent {
    
    if (self.isRenLin)
    {
        NSMutableArray *selectArray = [NSMutableArray array];
        for (CompanyModel *model in self.dataArray) {
            if (model.isDelete) {
                [selectArray addObject:model.id];
            }
        }
        if (IsArrEmpty(selectArray)) {
            [self showAlertWithString:@"请选择要删除的名片"];
            return;
        }
        NSString *ids = [selectArray componentsJoinedByString:@","];
        [self removeCompanyClaim:ids];
    }
    else
    {
        NSMutableArray *selectArray = [NSMutableArray array];
        for (CompanyModel *model in self.dataArray) {
            if (model.isDelete) {
                [selectArray addObject:model.collectionId];
            }
        }
        if (IsArrEmpty(selectArray)) {
            [self showAlertWithString:@"请选择要删除的名片"];
            return;
        }
        NSString *ids = [selectArray componentsJoinedByString:@","];
        [self removeCompanyCollection:ids];
    }
}

#pragma mark
#pragma mark UI
- (CompanyBottomView *)footView {
    if (!_footView) {
        _footView = [[CompanyBottomView alloc] initWith:kDeviceHeight-40-kViewHeight-kNavBarHeight];
        _footView.hidden = YES;
    }
    return _footView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
//#pragma mark - 禁止上拉
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
//          scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height);
//          return;
//        }
//}
@end
