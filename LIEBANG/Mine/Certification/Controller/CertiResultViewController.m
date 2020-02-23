#import "EditCompanyViewController.h"

#import "CertiResultViewController.h"
#import "AddThemeViewController.h"
#import "GRCertiViewController.h"
#import "ORCertiViewController.h"
#import "SearchCompanyViewController.h"
#import "CompanyCertViewController.h"
#import "MineService.h"
#import "AccountInfo.h"

#import "AccountViewController.h"
#import "MessageViewController.h"
#import "AccountService.h"

#import "AccountViewController.h"

#import "CertiViewController.h"

#import "CompanyHomeViewController.h"

#import "CompanyDetailViewController.h"

#import "CompanyFeeViewController.h"

#import "MineViewController.h"

@interface CertiResultViewController ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation CertiResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    
    [self createSubViews];
    
}

#pragma mark - 返回点击事件，返回一级或多级
- (void)backNavItemTapped {
    if (!self.push) {
        if (self.navigationController.childViewControllers.count >= 2) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[AccountViewController class]]) {
                AccountViewController *messageVC =(AccountViewController *)controller;
                [self.navigationController popToViewController:messageVC animated:YES];
            }else if ([controller isKindOfClass:[MessageViewController class]]){
                MessageViewController *messageVC =(MessageViewController *)controller;
                [self.navigationController popToViewController:messageVC animated:YES];
            }else if ([controller isKindOfClass:[CertiViewController class]]){
                CertiViewController *messageVC =(CertiViewController *)controller;
                [self.navigationController popToViewController:messageVC animated:YES];
            }else if ([controller isKindOfClass:CompanyHomeViewController.class]){
                CompanyHomeViewController *messageVC =(CompanyHomeViewController *)controller;
                [self.navigationController popToViewController:messageVC animated:YES];
            }else if ([controller isKindOfClass:CompanyFeeViewController.class]){
                CompanyFeeViewController *messageVC =(CompanyFeeViewController *)controller;
                [self.navigationController popToViewController:messageVC animated:YES];
            }
        }
        }
    }
    else{
        [super backNavItemTapped];
    }

   
}

- (void)createSubViews {
    
    switch (self.certiResultCtrl) {
        case CertiResultCtrlNormal:
        {
            self.navigationItem.title = @"提交成功";
            [self loadNormalView];
        }
            break;
        case CertiResultCtrlFail:
        {
            self.navigationItem.title = @"未通过审核";

            [self loadFailView];
        }
            break;
        case CertiResultCtrlSuccess:
        {
            if ([self.pushType intValue] == 23) {
                [self loadCompanySuccessView];
            }
            else {
                [self loadSuccessView];
            }
        }
            break;
        case CertiResultCtrlCompanyNormal:
        {
            [self loadCompanyNormalView];
        }
            break;
        case CertiResultCtrlCompanySuccess:
        {
            [self loadCompanySuccessView];
        }
            break;
        default:
            break;
    }
}

- (void)loadNormalView {
    
    UIButton *stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stateButton.frame = CGRectMake(0, kCurrentWidth(86), kDeviceWidth, kCurrentWidth(50));
    [stateButton setTitle:@"申请提交成功，请等待审核" forState:UIControlStateNormal];
    [stateButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
    [stateButton setImage:[UIImage imageNamed:@"icon_sel.png"] forState:UIControlStateNormal];
    stateButton.titleLabel.font = kSystemBold(16);
    [stateButton setImgViewStyle:ButtonImgViewStyleLeft imageSize:CGSizeMake(45, 45) space:12];
    [self.view addSubview:stateButton];
    
    UIImageView *markImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(94))/2, kCurrentWidth(163), kCurrentWidth(94), kCurrentWidth(102))];
    markImageView.image = [UIImage imageNamed:@"icon_tijiao"];
    [self.view addSubview:markImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(15), kCurrentWidth(315), kDeviceWidth-kCurrentWidth(30), kCurrentWidth(20))];
    titleLabel.font = kSystem(15);
    titleLabel.text = [NSString stringWithFormat:@"您已于%@提交行家申请",self.message];
    titleLabel.textColor = kLBBlackColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(45), kCurrentWidth(345), kDeviceWidth-kCurrentWidth(90), 30)];
    detailLabel.font = kSystem(12);
    detailLabel.text = @"我们将在审核提交成功后的3-5个工作日通知审核结果\n感谢您的耐心等待";
    detailLabel.textColor = kLBNineColor;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.numberOfLines = 2;
    detailLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:detailLabel];
}

- (void)loadFailView {
#pragma mark - 11.14 更改行家为企业
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(53), kCurrentWidth(100), kDeviceWidth-kCurrentWidth(106), kCurrentWidth(40))];
    detailLabel.font = kSystem(16);
    if (self.pushType.intValue == 18||self.pushType.intValue == 20||self.pushType.intValue == 16 || self.certiResultCtrl == CertiResultCtrlFail) {
        detailLabel.text = @"抱歉，您的行家认证申请没有通过审核请根据审核建议进行操作";

    }else{
        detailLabel.text = @"抱歉，您的企业认证申请没有通过审核请根据审核建议进行操作";

    }
    detailLabel.textColor = [UIColor colorWithHexString:@"F66257"];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.numberOfLines = 2;
    [self.view addSubview:detailLabel];
    
    UIImageView *markImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(89))/2, kCurrentWidth(180), kCurrentWidth(89), kCurrentWidth(95))];
    markImageView.image = [UIImage imageNamed:@"icon_weitongtuo"];
    [self.view addSubview:markImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(50), kCurrentWidth(315), kDeviceWidth-kCurrentWidth(100), 0)];
    titleLabel.font = kSystem(11);
//    titleLabel.text = IsStrEmpty(self.failReason)?@"您好，感谢您申请猎帮行家认证，为了方便学员更好的了解您，\n建议您尽快按要求完成基本信息认证（*为必填项）、\n职业经历认证和教育经历认证\n我们将在收到您的资料后尽快审核，期待您早日成为认证行家。":self.failReason;
    titleLabel.text = [NSString stringWithFormat:@"%@", self.failReason];

    CGSize size = [titleLabel.text sizeWithFont:kSystem(11) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(100), MAXFLOAT)];
    titleLabel.height = size.height;
    titleLabel.textColor = kLBNineColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    ConfimButton *button = [[ConfimButton alloc] initWithTop:kDeviceHeight-kNavBarHeight-kCurrentWidth(118) title:@"重新提交审核"];
    [button addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)loadSuccessView {
    
    UIImageView *markImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(72))/2, kCurrentWidth(80), kCurrentWidth(72), kCurrentWidth(72))];
    markImageView.image = [UIImage imageNamed:@"icon_tongguo"];
    [self.view addSubview:markImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCurrentWidth(188), kDeviceWidth, kCurrentWidth(20))];
    titleLabel.font = kSystemBold(16);
    titleLabel.textColor = kLBRedColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    CGFloat top = kCurrentWidth(270);
    if ([self.pushType intValue] == 15)
    {
        self.navigationItem.title = @"基本信息认证";
        titleLabel.text = @"恭喜！您已通过基本信息认证";
    }
    else if ([self.pushType intValue] == 17)
    {
        self.navigationItem.title = @"教育经历认证";
        titleLabel.text = @"恭喜！您已通过教育经历认证";
    }
    else if ([self.pushType intValue] == 19)
    {
        self.navigationItem.title = @"工作经历认证";
        titleLabel.text = @"恭喜！您已通过工作经历认证";
    }
    else if ([self.pushType intValue] == 23)
    {
        self.navigationItem.title = @"认证成功";
        titleLabel.text = @"恭喜！您已通过企业名片认证";
        top = kDeviceHeight-kNavBarHeight-kViewHeight-kCurrentWidth(92);
    }
    else {
        self.navigationItem.title = @"审核通过";
        titleLabel.text = @"恭喜！您已通过行家认证！";
    }
    
    ConfimButton *button = [[ConfimButton alloc] initWithTop:top title:@"去添加发布话题"];
    [button addTarget:self action:@selector(confimButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)loadCompanyNormalView {
    self.navigationItem.title = @"提交成功";
    UIImageView *markImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(71))/2, kCurrentWidth(176), kCurrentWidth(71), kCurrentWidth(78))];
    markImageView.image = [UIImage imageNamed:@"icon_tijiao"];
    [self.view addSubview:markImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(15), markImageView.bottom+kCurrentWidth(35), kDeviceWidth-kCurrentWidth(30), kCurrentWidth(16))];
    titleLabel.font = kSystemBold(15);
    titleLabel.text = [NSString stringWithFormat:@"您已于%@提交企业AI名片申请",self.message];
    titleLabel.textColor = kLBBlackColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(45), titleLabel.bottom+kCurrentWidth(15), kDeviceWidth-kCurrentWidth(90), 30)];
    detailLabel.font = kSystem(12);
    detailLabel.text = @"我们将在审核提交成功后的3-5个工作日通知审核结果\n感谢您的耐心等待";
    detailLabel.textColor = kLBNineColor;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.numberOfLines = 2;
    detailLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:detailLabel];
}

- (void)loadCompanySuccessView {
    UIImageView *markImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(72))/2, kCurrentWidth(164), kCurrentWidth(72), kCurrentWidth(72))];
    markImageView.image = [UIImage imageNamed:@"icon_tongguo"];
    [self.view addSubview:markImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCurrentWidth(36)+markImageView.bottom, kDeviceWidth, kCurrentWidth(20))];
    titleLabel.font = kSystemBold(16);
    titleLabel.textColor = kLBRedColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.title = @"认证成功";
    titleLabel.text = @"恭喜！您已通过企业名片认证";
    [self.view addSubview:titleLabel];
    
    ConfimButton *button = [[ConfimButton alloc] initWithTop:kDeviceHeight-kNavBarHeight-kViewHeight-kCurrentWidth(92) title:@"去推广我的企业AI智能名片"];
    [button addTarget:self action:@selector(companyConfimButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark
#pragma mark Event
- (void)companyConfimButtonClick {
//    SearchCompanyViewController *nextCtr = [[SearchCompanyViewController alloc] init];
//    [self.navigationController pushViewController:nextCtr animated:YES];
    CompanyDetailViewController *nextCtr = [[CompanyDetailViewController alloc] init];
    nextCtr.companyUid = self.companyUid;
    nextCtr.companyType = @"0";
    nextCtr.isSelf = YES;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)confimButtonClick {
    [MineService getUserMsgInfoWithSuccess:^(AccountInfo *info) {
        if ([info.isBasic intValue] == 0 || [info.isOccupation intValue] == 0 || [info.isEducation intValue] == 0) {
            [self showAlertWithString:@"您还不是行家，不能发布话题"];
        } else {
            AddThemeViewController *nextCtr = [[AddThemeViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self presentSheet:errorStr];
    }];
}

- (void)cancelButtonClick {
    if ([self.pushType intValue] == 24)
    {
        CompanyCertViewController *nextCtr = [[CompanyCertViewController alloc] init];
        nextCtr.isModify = YES;
        nextCtr.companyUid = self.companyUid;
        
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else
    {
        GRCertiViewController *nextCtr = [[GRCertiViewController alloc] init];
        nextCtr.isReUpload = YES;
        nextCtr.type = self.failType;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
