//
//  ReserveThemeViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ReserveThemeViewController.h"
#import "PayViewController.h"
#import "UserProtocolCell.h"
#import "HomeMeetCell.h"
#import "ThemeContentCell.h"
#import "QuestionService.h"
#import "DetailStatusView.h"
#import "MeetCell.h"

@interface ReserveThemeViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIButton *payButton;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UserProtocolCell *protocolView;
@property (nonatomic,strong)NSString *question;
@property (nonatomic,strong)NSString *otherString;
@property (nonatomic,strong)DetailStatusView *statusView;

@end

@implementation ReserveThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"话题详情";
    self.view.backgroundColor = kBackgroundColor;
    
    [self.view addSubview:self.priceLabel];
    [self.view addSubview:self.payButton];
    
    WeakSelf;
    _protocolView = [[UserProtocolCell alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(30))];
    _protocolView.backgroundColor = kWhiteColor;
    _protocolView.isLabelShow = NO;
    _protocolView.userProtocolBlock = ^{
        [weakSelf gotoUserProtocol];
    };
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.tableHeaderView = self.statusView;
    self.groupTableView.tableFooterView = _protocolView;
    [self.view addSubview:self.groupTableView];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellStr = @"HomeMeetCell";
            MeetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[MeetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.themeClassModel = self.themeModel;
            return cell;
        }
            break;
        case 1:
        case 2:
        {
            static NSString *cellStr = @"ThemeContentCell";
            ThemeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[ThemeContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            cell.indexPath = indexPath;
            cell.themeContentBlock = ^(NSIndexPath *indexPath, NSString *content) {
                [weakSelf sureContent:content indexPath:indexPath];
            };
            if (indexPath.section == 1) {
                cell.content = self.question;
            }
            else if (indexPath.section == 2) {
                cell.content = self.otherString;
            }
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            MeetCell *cell = (MeetCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
            return cell.cellHeight;
        }
        default:
            return kCurrentWidth(190);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}

#pragma mark Event
- (void)sureContent:(NSString *)content indexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        self.question = content;
    }
    else if (indexPath.section == 2) {
        self.otherString = content;
    }
}

- (void)gotoUserProtocol {
    WebViewController *nextCtr = [[WebViewController alloc] init];
    nextCtr.webViewType = WebViewTypeUserProtocol;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)payButtonClick {
    
    if (IsNilOrNull(self.question) || IsStrEmpty(self.question)) {
        [self showAlertWithString:@"请输入要请教的问题"];
        return;
    }
    
    if ([InsureValidate deleteWhiteSpaceInStr:self.question].length <= 0) {
        [self showAlertWithString:@"请输入的有效问题"];
        return;
    }
    
    if (IsNilOrNull(self.otherString) || IsStrEmpty(self.otherString)) {
        [self showAlertWithString:@"请输入备注信息"];
        return;
    }
    
    if ([InsureValidate deleteWhiteSpaceInStr:self.otherString].length <= 0) {
        [self showAlertWithString:@"请输入的有效备注"];
        return;
    }
    
    if (!_protocolView.isUserProtocol) {
        [self showAlertWithString:@"请阅读并同意猎帮用户协议"];
        return;
    }
    
    [self displayOverFlowActivityView];
    
    //此处应该传self.themeModel.userUid
    [QuestionService getUserClassifyWithParameters:self.themeModel.userUid success:^(NSString *info) {
        [self removeOverFlowActivityView];
        PayViewController *nextCtr = [[PayViewController alloc] init];
        nextCtr.quizcontent = self.question;
        nextCtr.otherString = self.otherString;
        nextCtr.questionPri = self.themeModel.topicPrice;
        nextCtr.topicId = self.themeModel.id;
        nextCtr.classifyId = info;
        nextCtr.serviceType = self.themeModel.serviceType;
        [Config currentConfig].answerid = self.themeModel.userUid;
        [self.navigationController pushViewController:nextCtr animated:YES];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark UI
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight, kCurrentWidth(120), kCurrentWidth(49))];
        _priceLabel.text = [NSString stringWithFormat:@"%.2f猎帮币",[self.themeModel.topicPrice floatValue]];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = kSystemBold(15);
        _priceLabel.textColor = kLBRedColor;
        _priceLabel.backgroundColor = kWhiteColor;
    }
    return _priceLabel;
}

- (UIButton *)payButton {
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.frame = CGRectMake(self.priceLabel.right, kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight, kDeviceWidth-self.priceLabel.right, kCurrentWidth(49));
        _payButton.backgroundColor = kLBRedColor;
        [_payButton setTitle:@"确认付款" forState:UIControlStateNormal];
        [_payButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _payButton.titleLabel.font = kSystem(15);
        [_payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

- (DetailStatusView *)statusView {
    if (!_statusView) {
        _statusView = [[DetailStatusView alloc] init];
        [_statusView updataDetailStatus:1];
    }
    return _statusView;
}

#pragma mark - 禁止下拉
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    scrollView.contentOffset = offset;
    
}
@end
