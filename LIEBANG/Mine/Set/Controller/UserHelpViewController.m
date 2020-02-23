//
//  UserHelpViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/13.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "UserHelpViewController.h"
#import "MineService.h"
#import "UserHelpModel.h"
#import "UserHelpCell.h"

@interface UserHelpViewController ()

@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation UserHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"使用帮助";
    self.view.backgroundColor = kWhiteColor;
    
    self.tableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
    self.tableView.backgroundColor = kWhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    [self loadUserHelpDataSource];
}

- (void)loadUserHelpDataSource {
    
    [self displayOverFlowActivityView];
    [MineService getUserHelpWithSuccess:^(NSArray *array) {
        [self removeOverFlowActivityView];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:array];
        
        for (UserHelpModel *model in self.dataSource) {
            if ([model.classify isEqualToString:@"争议解决"]) {
                for (HelpModel *dto in model.help) {
                    dto.isOpen = YES;
                }
            }
        }
        
        [self.tableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UserHelpModel *model = [self.dataSource safeObjectAtIndex:section];
    return model.help.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kCurrentWidth(35);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserHelpModel *userModel = [self.dataSource safeObjectAtIndex:indexPath.section];
    HelpModel *model = [userModel.help safeObjectAtIndex:indexPath.row];
    NSString *cellStr = @"UserHelpCell";
    UserHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UserHelpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.detailModel = model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(35))];
    headView.backgroundColor = kBackgroundColor;
    
    UserHelpModel *model = [self.dataSource safeObjectAtIndex:section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kDeviceWidth-kCurrentWidth(24),kCurrentWidth(35))];
    label.font = kSystem(15);
    label.textColor = kLBBlackColor;
    label.text = model.classify;
    [headView addSubview:label];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserHelpCell *cell = (UserHelpCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserHelpModel *userModel = [self.dataSource safeObjectAtIndex:indexPath.section];
    HelpModel *model = [userModel.help safeObjectAtIndex:indexPath.row];
    model.isOpen = !model.isOpen;
    [self.tableView reloadData];
    
//    WebViewController *nextCtr = [[WebViewController alloc] init];
//    nextCtr.webViewType = WebViewTypeHTML;
//    nextCtr.contentString = model.helpanswers;
//    nextCtr.navTitle = model.helpquestions;
//    nextCtr.navigationItem.title = model.helpquestions;
//    [self.navigationController pushViewController:nextCtr animated:YES];
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
