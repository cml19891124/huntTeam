#import "EnterpriseCertSultViewController.h"

#import "EditCompanyViewController.h"
#import "CompanyDetailViewController.h"
#import "CompanyCertViewController.h"
#import "AllPersonnelViewController.h"
#import "WelcomeViewController.h"
#import "CertiResultViewController.h"
#import "CompanyCell.h"
#import "CompanyService.h"

#import "CertFailureViewController.h"

@interface EditCompanyViewController ()

@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation EditCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑企业AI智能名片";
    self.view.backgroundColor = kWhiteColor;
    
//    [self setRightNaviBtnImage:[UIImage imageNamed:@"company_tianjia"]];
//    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.groupTableView];
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getCompanyDataSource];
        });
    }];
    [self getCompanyDataSource];
}

- (void)getCompanyDataSource {
    
    [self displayOverFlowActivityView];
    [CompanyService getCompanyListWithParameters:@"0" success:^(NSArray * _Nonnull data) {
        [self.groupTableView.mj_header endRefreshing];
        [self removeOverFlowActivityView];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:data];
        [self setEmptyView];
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self.groupTableView.mj_header endRefreshing];

        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
        [self setEmptyView];
    }];
}

- (void)setEmptyView {
    if (IsArrEmpty(self.dataSource)) {
        self.groupTableView.tableFooterView = [[NoDataView alloc] initWithHeight:kDeviceHeight-kNavBarHeight];
    } else {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(10))];
        bottomView.backgroundColor = kWhiteColor;
        self.groupTableView.tableFooterView = bottomView;
    }
}

#pragma mark
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    static NSString *cellStr = @"CompanyCell";
    CompanyModel *model = [self.dataSource safeObjectAtIndex:indexPath.section];
    CompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[CompanyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.companyState = CompanyCellStateEdit;
    cell.companyModel = model;
    cell.allPersonnelMessageBlock = ^(NSString * _Nonnull uid) {
        [weakSelf allPersonnelMessage:uid];
    };
    cell.certiMessageBlock = ^(NSString * _Nonnull uid, NSString * _Nonnull status, NSString * _Nonnull time, NSString * _Nonnull level) {
        [weakSelf certiMessage:uid status:status time:time level:level];
    };
    [cell layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CompanyModel *model = [self.dataSource safeObjectAtIndex:indexPath.section];
    CompanyDetailViewController *nextCtr = [[CompanyDetailViewController alloc] init];
    nextCtr.companyUid = model.id;
    nextCtr.companyName = model.companyAbbreviation;
    nextCtr.companyType = @"0";
    
    switch ([model.status intValue]) {
            case 0:
            {
                CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
                nextCtr.certiResultCtrl = CertiResultCtrlCompanyNormal;
                nextCtr.message = [InsureValidate timeInStr2:model.createTime];
                nextCtr.push = YES;
                [self.navigationController pushViewController:nextCtr animated:YES];
            }
                break;
            case 1:
            {
                EnterpriseCertSultViewController *nextCtr = [[EnterpriseCertSultViewController alloc] init];
                nextCtr.ID = model.id;
                [self.navigationController pushViewController:nextCtr animated:YES];
            }
                break;
            case 2:
            {
                CertFailureViewController *nextCtr = [[CertFailureViewController alloc] init];
                nextCtr.companyUid = model.id;
                nextCtr.level = model.level;
//                nextCtr.isModify = YES;
                [self.navigationController pushViewController:nextCtr animated:YES];
            }
                break;
            case 3:
            {
                CompanyCertViewController *nextCtr = [[CompanyCertViewController alloc] init];
                nextCtr.companyUid = model.id;
                nextCtr.level = model.level;
                nextCtr.isModify = YES;
                [self.navigationController pushViewController:nextCtr animated:YES];
            }
                break;
            default:
                break;
        }
}

#pragma mark
#pragma mark Event
- (void)rightNaviBtnClick {
    WelcomeViewController *nextCtr = [[WelcomeViewController alloc] init];
    nextCtr.isRefee = YES;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)allPersonnelMessage:(NSString *)uid {
    AllPersonnelViewController *nextCtr = [[AllPersonnelViewController alloc] init];
    nextCtr.enterpriseId = uid;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)certiMessage:(NSString *)uid status:(NSString *)status time:(NSString *)time level:(NSString *)level{
    //0 认证中 1已认证 2认证失败 3.未审核
    switch ([status intValue]) {
        case 0:
        {
            CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
            nextCtr.certiResultCtrl = CertiResultCtrlCompanyNormal;
            nextCtr.message = [InsureValidate timeInStr2:time];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        case 1:
        {
            EnterpriseCertSultViewController *nextCtr = [[EnterpriseCertSultViewController alloc] init];
            nextCtr.ID = uid;
            
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        case 2:
        {
            CertFailureViewController *nextCtr = [[CertFailureViewController alloc] init];
            nextCtr.companyUid = uid;
            nextCtr.level = level;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        case 3:
        {
            CompanyCertViewController *nextCtr = [[CompanyCertViewController alloc] init];
            nextCtr.companyUid = uid;
            nextCtr.level = level;
            nextCtr.isModify = YES;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        default:
            break;
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

@end
