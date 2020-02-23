//
//  PrivacyViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PrivacyViewController.h"
#import "AccountViewController.h"
#import "PrivacyCell.h"
#import "AccountService.h"
#import "PrivacyModel.h"
#import "BlackFriendCell.h"
#import "VisitorRecordModel.h"

@interface PrivacyViewController ()

@property (nonatomic,strong)PrivacyModel *privacyModel;

@end

@implementation PrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"隐私策略";
    self.view.backgroundColor = kBackgroundColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    
    [self displayOverFlowActivityView];
    [self loadPrivacyDataSource];
}

//加载权限
- (void)loadPrivacyDataSource {
    
    [AccountService getPrivacyWithSuccess:^(PrivacyModel *model) {
        [self removeOverFlowActivityView];
        self.privacyModel = model;
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

/*
 type额外说明
 editType的值       相对应的type
    0               0 所有人 1：仅好友
    1               0 所有人 1：仅好友
    2               0：全部 1：影响力低于**分 2未认证基本 3未认证教育
    3               不用传
    4               0 不允许 1：允许
 */
//修改权限
- (void)postPrivacyDataSource:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:[NSNumber numberWithInteger:indexPath.section] forKey:@"editType"];//修改类型 0：修改查看资料 1：修改发送消息权限 2：修改添加好友权限 3：移除黑名单  4:手机号查看
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [postDic setValue:@"1" forKey:@"type"];
        }
        else if (indexPath.row == 1)
        {
            [postDic setValue:@"0" forKey:@"type"];
        }
        [postDic setValue:@"4" forKey:@"editType"];
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            [postDic setValue:@"1" forKey:@"type"];
        }
        else if (indexPath.row == 1)
        {
            [postDic setValue:@"0" forKey:@"type"];
        }
        [postDic setValue:@"0" forKey:@"editType"];
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            [postDic setValue:@"1" forKey:@"type"];
        }
        else if (indexPath.row == 1)
        {
            [postDic setValue:@"0" forKey:@"type"];
        }
        [postDic setValue:@"1" forKey:@"editType"];
    }
    else if (indexPath.section == 3)
    {
        NSMutableArray *typeArr = [self.privacyModel.userFriendPrivacy_type componentsSeparatedByString:@","].mutableCopy;
        
        if (indexPath.row == 0)
        {
            if ([typeArr containsObject:@"0"]) {
                [typeArr removeAllObjects];
            } else {
                [typeArr removeAllObjects];
                [typeArr addObject:[NSString stringWithFormat:@"%zd",indexPath.row]];
            }
        }
        else
        {
            if ([typeArr containsString:@"0"])
            {
                [typeArr removeObject:@"0"];
            }
            if ([typeArr containsString:[NSString stringWithFormat:@"%zd",indexPath.row]]) {
                [typeArr removeObject:[NSString stringWithFormat:@"%zd",indexPath.row]];
            }
            else {
                [typeArr addObject:[NSString stringWithFormat:@"%zd",indexPath.row]];
            }
        }
        
        [postDic setValue:[typeArr componentsJoinedByString:@","] forKey:@"type"];
        [postDic setValue:@"2" forKey:@"editType"];
    }
    
    NSLog(@"修改权限postDic = %@",postDic);
    
    [self displayOverFlowActivityView];
    [AccountService editPrivacyWithParameters:postDic success:^(id model) {
        [self removeOverFlowActivityView];
        [self presentSheet:model];
        [self loadPrivacyDataSource];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)deleteBlackEvent:(VisitorModel *)model {
    UIAlertController *alert = [CHAlertView showMessageWith:@"确定" title:@"确定从黑名单中移除该用户?" confim:^{
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        [postDic setValue:@"3" forKey:@"editType"];//修改类型 0：修改查看资料 1：修改发送消息权限 2：修改添加好友权限 3：移除黑名单
        [postDic setValue:model.userUid forKey:@"blackUserUid"];//editType为3时，移除的黑名单userUid
        
        NSLog(@"移除黑名单postDic = %@",postDic);
        [self displayOverFlowActivityView];
        [AccountService editPrivacyWithParameters:postDic success:^(id model) {
            [self removeOverFlowActivityView];
            [self presentSheet:@"移除黑名单成功"];
            [self loadPrivacyDataSource];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (IsArrEmpty(self.privacyModel.user)) {
        return [LBForProject currentProject].privacyCellTitleArray.count;
    }
    return [LBForProject currentProject].privacyCellTitleArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 4) {
        return self.privacyModel.user.count;
    }
    return [[[LBForProject currentProject].privacyCellTitleArray safeObjectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    if (indexPath.section == 4)
    {
        VisitorModel *model = [self.privacyModel.user safeObjectAtIndex:indexPath.row];
        static NSString *cellStr = @"BlackFriendCell";
        BlackFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[BlackFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.model = model;
        cell.sureButtonBlock = ^(VisitorModel *friendModel) {
            [weakSelf deleteBlackEvent:friendModel];
        };
        cell.accountButtonBlock = ^(VisitorModel *friendModel) {
            [weakSelf gotoAccountViewController:nil userUid:friendModel.userUid userStatus:friendModel.userStatus];
        };
        cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        return cell;
    }
    else
    {
        static NSString *cellStr = @"PrivacyCell";
        PrivacyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[PrivacyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.indexPath = indexPath;
        cell.privacyModel = self.privacyModel;
        cell.chooseButtonBlock = ^(NSIndexPath *indexPath) {
            [weakSelf postPrivacyDataSource:indexPath];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2) {
        return 44.f;
    }
    return 35.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
        {
            SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44) title:@"是否在个人名片中展示手机号码（单选）"];
            return headView;
        }
        case 1:
        {
            SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44) title:@"谁可以看我的资料（单选）"];
            return headView;
        }
        case 2:
        {
            SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44) title:@"谁可以给我发消息（单选）"];
            return headView;
        }
        case 3:
        {
            SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 35) title:@"不接受以下用户添加我为好友（多选）"];
            return headView;
        }
        case 4:
        {
            SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 35) title:@"黑名单"];
            return headView;
        }
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        return kCurrentWidth(80);
    }
    return kCurrentWidth(47);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section != 4) {
        [self postPrivacyDataSource:indexPath];
    }
}

//查看资料权限
- (void)gotoAccountViewController:(NSString *)dataPrivacyType userUid:(NSString *)userUid userStatus:(NSString *)userStatus {
    
    AccountViewController *nextCtr = [[AccountViewController alloc] init];
    if ([[Config currentConfig].userUid isEqualToString:userUid]) {
        nextCtr.accountState = AccountStateNormal;
    }
    else {
        if ([userStatus intValue] == 0) {
            nextCtr.accountState = AccountStateOther;
        }
        else {
            nextCtr.accountState = AccountStateDisabled;
        }
    }
    nextCtr.userUid = userUid;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
