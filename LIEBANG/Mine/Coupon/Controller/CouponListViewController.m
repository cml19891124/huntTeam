//
//  CouponListViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/11.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CouponListViewController.h"
#import "CouponCell.h"
#import "CouponService.h"
#import "HomeService.h"
#import "AllClassModel.h"
#import "ClassListViewController.h"
#import "AllClassViewController.h"
#import "WelcomeViewController.h"

@interface CouponListViewController ()

@property (nonatomic,strong)CouponModel *model;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)AllClassModel *allClassModel;
@property (nonatomic,assign)BOOL isRefresh;
@property (nonatomic,assign)NSInteger classifyIndex;
@property (nonatomic,assign)NSInteger classify2Index;

@end

@implementation CouponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"可用优惠券";
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight-(self.isUse?0:kCurrentWidth(43)));
    self.groupTableView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.groupTableView];
    
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isRefresh = NO;
        [self loadCouponDataSource];
    }];
    
    self.groupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.dataSource.count < 10) {
            [self.groupTableView.mj_footer endRefreshing];
            return;
        }
        
        self.page++;
        self.isRefresh = YES;
        [self loadCouponDataSource];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.page = 1;
    self.isRefresh = NO;
    [self loadCouponDataSource];
}

#pragma mark DataSource
- (void)loadCouponDataSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:[NSNumber numberWithInteger:self.page] forKey:@"pageNow"];
    [postDic setValue:@"10" forKey:@"pageSize"];
    [postDic setValue:self.status forKey:@"status"];//0：未使用 1：已使用 2已过期
    
    if (!IsStrEmpty(self.classifyId) && !IsNilOrNull(self.classifyId)) {
        [postDic setValue:self.classifyId forKey:@"classifyId"];
    }
    if (self.isCompany)
    {
        [postDic setValue:@"3" forKey:@"couponType"];//企业优惠券
    }
    
    NSLog(@"优惠券 == %@",postDic);
    
    [self displayOverFlowActivityView];
    [CouponService getCouponListWithParameters:postDic success:^(CouponModel *model) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        
        if (self.isRefresh) {
            if (IsArrEmpty(model.data)) {
                [self presentSheet:@"暂无更多数据"];
            } else {
                [self.dataSource addObjectsFromArray:model.data];
            }
        } else {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:model.data];
        }
        
        if (IsArrEmpty(self.dataSource)) {
            self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kViewHeight-(self.isUse?0:kCurrentWidth(43))];
        } else {
            self.groupTableView.tableFooterView = [UIView new];
        }
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        if (IsArrEmpty(self.dataSource)) {
            self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight-kViewHeight-(self.isUse?0:kCurrentWidth(43))];
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
    CouponListModel *couponModel = [self.dataSource safeObjectAtIndex:indexPath.row];
    static NSString *cellStr = @"CouponCell";
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[CouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.couponModel = couponModel;
    if ([self.status intValue] == 0)
    {
        cell.couponState = SureButtonStateNormal;
    }
    else
    {
        cell.couponState = SureButtonStateDisabled;
    }
    cell.sureButtonBlock = ^(CouponListModel *couponModel) {
        [weakSelf useCouponWithModel:couponModel];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(80);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kCurrentWidth(15);
}

#pragma mark Event
- (void)useCouponWithModel:(CouponListModel *)couponModel {
    
    if (_isUse) {
        
        if ([couponModel.couponType intValue] == 1) {
            if ([self.questionPri floatValue] > [couponModel.fullMoney floatValue]) {
                [self showAlertWithString:[NSString stringWithFormat:@"订单金额少于%.2f猎帮币才可使用该优惠券",[couponModel.fullMoney floatValue]]];
                return;
            }
        }
        else {
            if ([self.questionPri floatValue] < [couponModel.fullMoney floatValue]) {
                [self showAlertWithString:[NSString stringWithFormat:@"满%.2f猎帮币才可使用该优惠券",[couponModel.fullMoney floatValue]]];
                return;
            }
            
            if ([self.questionPri floatValue] <= [couponModel.offMoney floatValue]) {
                [self showAlertWithString:[NSString stringWithFormat:@"订单金额超过%.2f猎帮币才可使用该优惠券",[couponModel.offMoney floatValue]]];
                return;
            }
        }        
        
        if (_userCouponBlock) {
            _userCouponBlock(couponModel);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        
        if ([couponModel.couponType intValue] == 3 || [couponModel.couponType intValue] == 4)
        {
            WelcomeViewController *nextCtr = [[WelcomeViewController alloc] init];
            nextCtr.isRefee = YES;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else
        {
            [self displayOverFlowActivityView];
            [HomeService getAllClassWithParameters:nil success:^(AllClassModel *model) {
                self.allClassModel = model;
                [self removeOverFlowActivityView];
                for (ClassModel *model in self.allClassModel.data) {
                    ClassifyTwoModel *dto = [[ClassifyTwoModel alloc] init];
                    dto.id = nil;
                    dto.classify = @"全部";
                    ClassifyTwoModel *model1 = [model.classifyTwo safeObjectAtIndex:0];
                    if (![model1.classify isEqualToString:@"全部"]) {
                        [model.classifyTwo insertObject:dto atIndex:0];
                    }
                }
                
                if ([couponModel.classifyId intValue] == 1)
                {
                    ClassListViewController *nextCtr = [[ClassListViewController alloc] init];
                    nextCtr.classModel = self.allClassModel;
                    nextCtr.classifyIndex = 0;
                    nextCtr.classify2Index = -1;
                    [self.navigationController pushViewController:nextCtr animated:YES];
                }
                else
                {
                    for (ClassModel *modleOne in self.allClassModel.data)
                    {
                        if ([couponModel.classify isEqualToString:modleOne.classify])
                        {
                            self.classifyIndex = [self.allClassModel.data indexOfObject:modleOne];
                            self.classify2Index = 0;
                        }
                    }
                    
                    ClassListViewController *nextCtr = [[ClassListViewController alloc] init];
                    nextCtr.classModel = self.allClassModel;
                    nextCtr.classifyIndex = self.classifyIndex;
                    nextCtr.classify2Index = self.classify2Index-1;
                    [self.navigationController pushViewController:nextCtr animated:YES];
                }
                
            } failure:^(NSUInteger code, NSString *errorStr) {
                [self removeOverFlowActivityView];
                [self presentSheet:errorStr];
            }];
        }
    }
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
