//
//  EditOtherViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/17.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "EditOtherViewController.h"
#import "EditOtherCell.h"
#import "AccountService.h"
#import "XFTreePopupView.h"

#import "CZHAddressPickerView.h"

@interface EditOtherViewController ()



@end

@implementation EditOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"EditOtherCell";
    EditOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[EditOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.indexPath = indexPath;
    cell.accountInfo = self.accountInfo;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(66);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0:
        {
            /*NSString *mainBundleDirectory=[[NSBundle mainBundle] bundlePath];
            NSString *path = [mainBundleDirectory stringByAppendingPathComponent:@"province.json"];
            NSData *data = [[NSData alloc]initWithContentsOfFile:path];
            NSError *err;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            
            XFTreePopupView *treeView = [[XFTreePopupView alloc]initWithDataSource:jsonArray Commit:^(NSArray *ret)
                                         {
                                             NSDictionary *dict1 = [ret safeObjectAtIndex:0];
                                             NSString *selectedStr1 = [dict1 objectForKey:@"name"];
                                             
                                             NSDictionary *dict2 = [ret safeObjectAtIndex:1];
                                             NSString *selectedStr2 = [dict2 objectForKey:@"name"];
                                             
                                             if (![selectedStr1 isEqualToString:selectedStr2]) {
                                                 selectedStr1 = [selectedStr1 stringByAppendingString:selectedStr2];
                                             }

                                             self.accountInfo.userHometown = selectedStr1;
                                             [self.groupTableView reloadData];
                                         }];
            treeView.isHidden = NO;*/
            [CZHAddressPickerView cityPickerViewWithProvince:[[NSUserDefaults standardUserDefaults] objectForKey:@"homeprovince"]?:@"广东省" city:[[NSUserDefaults standardUserDefaults] objectForKey:@"homecity"]?:@"深圳市" cityBlock:^(NSString *province, NSString *city) {

                            [[NSUserDefaults standardUserDefaults] setObject:province forKey:@"homeprovince"];
                            [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"homecity"];
                            [[NSUserDefaults standardUserDefaults] synchronize];;
                            self.accountInfo.userHometown = [NSString stringWithFormat:@"%@%@",province,city];
                            [self.groupTableView reloadData];
                        }];
        }
            break;
        case 1:
        {
            NSString *time = self.accountInfo.userBirth;
            if (self.accountInfo.userBirth.length != 10) {
                time = nil;
            }
            
            [BRDatePickerView showDatePickerWithTitle:@"生日" dateType:BRDatePickerModeYMD defaultSelValue:time minDate:nil maxDate:nil isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
                self.accountInfo.userBirth = selectValue;
                [self.groupTableView reloadData];
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark Event
- (void)rightNaviBtnClick {
    
    if (IsStrEmpty(self.accountInfo.userHometown) || IsNilOrNull(self.accountInfo.userHometown)) {
        [self presentSheet:@"请选择家乡"];
        return;
    }
    
    if (IsStrEmpty(self.accountInfo.userBirth) || IsNilOrNull(self.accountInfo.userBirth)) {
        [self presentSheet:@"请填写生日"];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.accountInfo.userHometown forKey:@"userHometown"];//家乡
    [postDic setValue:self.accountInfo.userBirth forKey:@"userBirth"];//生日(XX-XX)
    
    [self displayOverFlowActivityView];
    [AccountService editHomeTownWithParameters:postDic success:^(NSString *info) {
        [self removeOverFlowActivityView];
        [self backNavItemTapped];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark 界面布局
- (void)createSubViews {
    self.navigationItem.title = @"编辑其他信息";
    self.view.backgroundColor = kWhiteColor;
    
    [self setRightNaviBtnTitle:@"保存"];
    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kWhiteColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
