
#import "PostMAnswerViewController.h"
#import "QuestionTitleCell.h"
#import "PostAnswerView.h"
#import "QuestionService.h"
#import "OrderListViewController.h"

#import "SDAnswerViewCell.h"

#import "PostAnswerView.h"

@interface PostMAnswerViewController ()

@property (nonatomic,assign) BOOL isShowAllTitle;

@property (nonatomic,strong)UILabel *headLabel;

@property (nonatomic,strong)NSString *titleString;

@property (nonatomic,strong)UIButton *confimButton;

@property (strong, nonatomic) PostAnswerView *answerView;

@end

@implementation PostMAnswerViewController

static NSString *answerCell = @"SDAnswerViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [LBForProject currentProject].detailCellTitleArray = nil;
    self.navigationItem.title = @"问答详情";
    self.view.backgroundColor = kWhiteColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
    self.groupTableView.backgroundColor = kWhiteColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    
    _confimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confimButton.frame = CGRectMake(0, kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight, kDeviceWidth, kCurrentWidth(49));
    _confimButton.backgroundColor = kLBRedColor;
    [_confimButton setTitle:@"确定回答" forState:UIControlStateNormal];
    [_confimButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_confimButton addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _confimButton.titleLabel.font = kSystem(15);
    [self.view addSubview:_confimButton];

    self.groupTableView.tableFooterView = self.answerView;

}

- (void)backNavItemTapped {
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    NSString *cellNameStr;
    if (!IsArrEmpty([LBForProject currentProject].detailCellTitleArray)) {
        cellNameStr = [[LBForProject currentProject].detailCellTitleArray safeObjectAtIndex:indexPath.section];
    }
    
    if (indexPath.row == 0) {
        static NSString *cellStr = @"QuestionTitleCell";
        QuestionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[QuestionTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.isShowAllTitle = self.isShowAllTitle;
        cell.detailModel = self.detailModel;
        cell.questionButtonBlock = ^(BOOL isShowAllTitle) {
            weakSelf.isShowAllTitle = isShowAllTitle;
            [weakSelf.groupTableView reloadData];
        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
    {
        QuestionTitleCell *cell = (QuestionTitleCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSString *cellNameStr;
    if (!IsArrEmpty([LBForProject currentProject].detailCellTitleArray)) {
        cellNameStr = [[LBForProject currentProject].detailCellTitleArray safeObjectAtIndex:section];
    }
    
    if ([cellNameStr isEqualToString:@"QuestionTitleCell"])
    {
        return 0.f;
    }
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (PostAnswerView *)answerView {
    if (!_answerView) {
        _answerView = [[PostAnswerView alloc] init];
        _answerView.orderUid = self.detailModel.id;
    }
    return _answerView;
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

@end
