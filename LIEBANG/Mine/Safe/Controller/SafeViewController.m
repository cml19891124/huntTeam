//
//  SafeViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "SafeViewController.h"
#import "EditPasswordViewController.h"
#import "EditPhoneViewController.h"
#import "SafeCell.h"

@interface SafeViewController ()

@end

@implementation SafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账号安全";
    self.view.backgroundColor = kBackgroundColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LBForProject currentProject].safeCellTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellStr = @"SafeCell";
    SafeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[SafeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(48);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            EditPhoneViewController *nextCtr = [[EditPhoneViewController alloc] init];
            nextCtr.editPhoneState = EditPhoneStateModifyOne;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        case 1:
        {
            EditPasswordViewController *nextCtr = [[EditPasswordViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
