//
//  CompanyFeeViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CompanyFeeViewController.h"
#import "CompanyCertViewController.h"
#import "PayViewController.h"
#import "PaySueccssViewController.h"
#import "CompanyFootView.h"
#import "CompanyService.h"
#import "CompanyFeeModel.h"

@interface CompanyFeeViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)CompanyFootView *footView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation CompanyFeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"建立企业AI智能名片";
    self.view.backgroundColor = kWhiteColor;
    
    self.footView = [[CompanyFootView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(140)) title:@"500人以上企业AI智能名片服务" message:@"请拨打客服电话：13510019677" subMess:@"工作日09:00-18:00，我们将竭诚为您服务"];
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    self.groupTableView.tableFooterView = self.footView;
    [self.view addSubview:self.groupTableView];
    
    [self displayOverFlowActivityView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getFeeDataSource];
}

- (void)getFeeDataSource {
    
    [CompanyService getCompanyPayListWithSuccess:^(NSArray * _Nonnull data) {
        [self removeOverFlowActivityView];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:data];
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
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
    CompanyFeeModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    static NSString *cellStr = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.font = kSystem(15);
    cell.textLabel.text = model.name;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = kLBThreeColor;
    cell.textLabel.highlightedTextColor = kWhiteColor;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = kLBRedColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(92);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CompanyFeeModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    
    if (self.isContiuesII)
    {
        PayViewController *nextCtr = [[PayViewController alloc] init];
        nextCtr.isContiues = self.isContiues;
        nextCtr.isContiuesII = YES;
        nextCtr.enterpriseId = self.enterpriseId;
        nextCtr.level = model.level;
        nextCtr.serviceType = @"企业名片";
        nextCtr.questionPri = model.cost;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else
    {
        if ([self.companyUid intValue] == 0) {
            CompanyCertViewController *nextCtr = [[CompanyCertViewController alloc] init];
            nextCtr.level = model.level;
            nextCtr.payPrice = model.cost;
            nextCtr.isModify = NO;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else {
            NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
            [postDic setValue:model.level forKey:@"level"];//付费等级
            [postDic setValue:self.companyUid forKey:@"id"];//企业id
            NSLog(@"提交审核 == %@",postDic);
            
            [self displayOverFlowActivityView];
            [CompanyService postCompanyCertWithParameters:postDic success:^(NSString * _Nonnull data) {
                [self removeOverFlowActivityView];
                PayViewController *nextCtr = [[PayViewController alloc] init];
                nextCtr.level = model.level;
                nextCtr.questionPri = data;
                nextCtr.enterpriseId = self.companyUid;
                nextCtr.serviceType = @"企业名片";
                nextCtr.isContiues = YES;
                [self.navigationController pushViewController:nextCtr animated:YES];
            } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
                [self removeOverFlowActivityView];
                [self presentSheet:errorStr];
            }];
        }
    }
}

#pragma mark
#pragma mark 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
//#pragma mark - 禁止下拉
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGPoint offset = scrollView.contentOffset;
//    if (offset.y <= 0) {
//        offset.y = 0;
//    }
//    
//    scrollView.contentOffset = offset;
//
//}
@end
