//
//  ExperienceViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/13.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ExperienceViewController.h"
#import "AccountJobCell.h"
#import "AccountSchoolCell.h"

@interface ExperienceViewController ()

@property (nonatomic,strong)NSMutableArray *titleArray;

@end

@implementation ExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"背景经历";
    self.view.backgroundColor = kBackgroundColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    
    if (!IsArrEmpty(self.accountInfo.OccupationAuthentication)) {
        [self.titleArray addObject:@"工作经历"];
    }
    if (!IsArrEmpty(self.accountInfo.EducationAuthentication)) {
        [self.titleArray addObject:@"教育经历"];
    }
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *cellNameStr;
    if (!IsArrEmpty(self.titleArray)) {
        cellNameStr = [self.titleArray safeObjectAtIndex:section];
    }
    
    if ([cellNameStr isEqualToString:@"工作经历"])
    {
        return self.accountInfo.OccupationAuthentication.count;
    }
    else if ([cellNameStr isEqualToString:@"教育经历"])
    {
        return self.accountInfo.EducationAuthentication.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    NSString *cellNameStr;
    if (!IsArrEmpty(self.titleArray)) {
        cellNameStr = [self.titleArray safeObjectAtIndex:indexPath.section];
    }
    
    if ([cellNameStr isEqualToString:@"工作经历"])
    {
        WorkModel *workModel = [self.accountInfo.OccupationAuthentication safeObjectAtIndex:indexPath.row];
        static NSString *cellStr = @"AccountJobCell";
        AccountJobCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[AccountJobCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.jobState = AccountJobCellStateStateBackGround;
        cell.model = workModel;
        cell.GetWorkCertiImageViewBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"教育经历"])
    {
        EducationModel *educationModel = [self.accountInfo.EducationAuthentication safeObjectAtIndex:indexPath.row];
        static NSString *cellStr = @"AccountSchoolCell";
        AccountSchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[AccountSchoolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.schoolState = AccountSchoolCellStateBackGround;
        cell.model = educationModel;
        cell.userUid = self.accountInfo.userUid;
        cell.GetEduCertiImageViewBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30.f) title:[self.titleArray safeObjectAtIndex:section]];
    [headView setExperienceView];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellNameStr;
    if (!IsArrEmpty(self.titleArray)) {
        cellNameStr = [self.titleArray safeObjectAtIndex:indexPath.section];
    }
    
    if ([cellNameStr isEqualToString:@"工作经历"])
    {
        AccountJobCell *cell = (AccountJobCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return [cell getHeight];
    }
    else if ([cellNameStr isEqualToString:@"教育经历"])
    {
        AccountSchoolCell *cell = (AccountSchoolCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark
#pragma mark 懒加载
- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
