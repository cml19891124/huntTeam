//
//  PostAnswerViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/3.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PostAnswerViewController.h"
#import "QuestionTitleCell.h"
#import "PostAnswerView.h"
#import "QuestionService.h"
#import "OrderListViewController.h"

#import "SDAnswerViewCell.h"

@interface PostAnswerViewController ()

@property (nonatomic,strong)UIButton *confimButton;

@property (nonatomic,strong)PostAnswerView *answerView;

@end

@implementation PostAnswerViewController

static NSString *cellStr = @"QuestionTitleCell";
static NSString *answerCell = @"SDAnswerViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"问答详情";
    self.view.backgroundColor = kWhiteColor;
    self.isShowAllTitle = NO;
    [self setRightNaviBtnTitle:@"保存"];
    [self.rightNaviBtn addTarget:self action:@selector(saveLocalBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight);
    self.groupTableView.backgroundColor = kWhiteColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
//    self.groupTableView.tableFooterView = self.answerView;
    
    [self.groupTableView registerClass:QuestionTitleCell.class forCellReuseIdentifier:cellStr];
    [self.groupTableView registerClass:SDAnswerViewCell.class forCellReuseIdentifier:answerCell];

    [self.view addSubview:self.groupTableView];
    
    [self.view addSubview:self.confimButton];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QuestionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[QuestionTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            cell.detailModel = self.detailModel;
            cell.isShowAllTitle = self.detailModel.isOpen;

            WeakSelf
            cell.questionButtonBlock = ^(BOOL isShowAllTitle) {
                weakSelf.detailModel.isOpen = isShowAllTitle;
                [weakSelf.groupTableView reloadData];
            };
            return cell;
    }else{
        SDAnswerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:answerCell];
            if (!cell) {
                cell = [[SDAnswerViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:answerCell];
            }
            cell.detailModel = self.detailModel;
        [cell layoutIfNeeded];
            return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QuestionTitleCell *cell = (QuestionTitleCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        NSLog(@"self.height: %.2lf",cell.cellHeight);
        return cell.cellHeight;
    }else{
        return 485;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

#pragma mark Event
//保存在本地
- (void)saveLocalBtnClick {
    
    if (IsStrEmpty(self.answerView.answerContent) || IsNilOrNull(self.answerView.answerContent)) {
        [self showAlertWithString:@"请输入回答内容"];
        return;
    }
    
    if (self.answerView.answerContent.length <= 10) {
        [self showAlertWithString:@"请回答10个字以上"];
        return;
    }
    [Config currentConfig].answerContent = self.answerView.answerContent;
    [Config currentConfig].answerOrderUid = self.detailModel.id;
    [self.navigationController popViewControllerAnimated:YES];
}

//回答、提交至服务器
- (void)rightNaviBtnClick {
    
    if (IsStrEmpty(self.answerView.answerContent) || IsNilOrNull(self.answerView.answerContent)) {
        [self showAlertWithString:@"请输入回答内容"];
        return;
    }
    
    if (self.answerView.answerContent.length < 10) {
        [self showAlertWithString:@"请回答10个字以上"];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.detailModel.id forKey:@"id"];
    [postDic setValue:self.answerView.price forKey:@"chargeState"];//0：免费查看，1：一元查看
    [postDic setValue:self.answerView.answerContent forKey:@"answerContent"];
    [postDic setValue:self.detailModel.answerUid forKey:@"Answerid"];
    
    [self displayOverFlowActivityView];
    [QuestionService getAnswerQuestionWithParameters:postDic success:^(NSString *info) {
        [self removeOverFlowActivityView];
        [Config currentConfig].answerContent = nil;
        [Config currentConfig].answerOrderUid = nil;
        [self presentSheet:info];
        [self performBlock:^{
            if (self.refrshDataSourceBlock) {
                self.refrshDataSourceBlock();
            }
//            [self.navigationController popViewControllerAnimated:YES];
            if (self.navigationController.childViewControllers.count >= 2) {
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[OrderListViewController class]]) {
                        OrderListViewController *messageVC =(OrderListViewController *)controller;
                        [self.navigationController popToViewController:messageVC animated:YES];
                    }
                }
                    
            }else{
                [self.navigationController popViewControllerAnimated:YES];

            }
        } afterDelay:1.5];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark UI
- (UIButton *)confimButton {
    if (!_confimButton) {
        _confimButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confimButton.frame = CGRectMake(0, kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight, kDeviceWidth, kCurrentWidth(49));
        _confimButton.backgroundColor = kLBRedColor;
        [_confimButton setTitle:@"确定回答" forState:UIControlStateNormal];
        [_confimButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_confimButton addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _confimButton.titleLabel.font = kSystem(15);
    }
    return _confimButton;
}

- (PostAnswerView *)answerView {
    if (!_answerView) {
        _answerView = [[PostAnswerView alloc] init];
        _answerView.orderUid = self.detailModel.id;
    }
    return _answerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
