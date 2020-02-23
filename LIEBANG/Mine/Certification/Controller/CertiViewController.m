//
//  CertiViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/11.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CertiViewController.h"
#import "ORCertiViewController.h"
#import "GRCertiViewController.h"
#import "CertiResultViewController.h"
#import "PostCertSourceViewController.h"
#import "WelcomeViewController.h"
#import "CertiService.h"

@interface CertiViewController ()

@property (nonatomic,strong)UIButton *personButton;
@property (nonatomic,strong)UIButton *organizationButton;

@end

@implementation CertiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"成为行家认证用户";
    self.view.backgroundColor = kWhiteColor;
    
    [self createSubViews];
}

#pragma mark Event
- (void)personButtonClick {
    
    [self displayOverFlowActivityView];
    [CertiService getBasicCertResultWithSuccess:^(NSDictionary *info) {
        /*CertiResultCtrlNormal                             = 0,//正在审核
    CertiResultCtrlFail                               = 1,//审核失败
    CertiResultCtrlSuccess                            = 2,//审核成功
    CertiResultCtrlCompanyNormal                      = 3,//企业审核提交成功
    CertiResultCtrlCompanySuccess                     = 4,//企业审核成功*/
        [self removeOverFlowActivityView];
        if ([info[@"states"] intValue] == 0) {//正在审核
            CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
            nextCtr.certiResultCtrl = CertiResultCtrlNormal;
            if ([info[@"updateTime"] integerValue] != 0) {
                nextCtr.message = [InsureValidate timeInStr:@([info[@"updateTime"] integerValue]).stringValue];
            }
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else if ([info[@"states"] intValue] == 1) {//审核成功
            CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
            nextCtr.certiResultCtrl = CertiResultCtrlSuccess;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else if ([info[@"states"] intValue] == 2) {//审核失败
            CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
            nextCtr.certiResultCtrl = CertiResultCtrlFail;
            nextCtr.failReason = info[@"failedMessage"];
            nextCtr.failType = info[@"type"];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else if ([info[@"states"] intValue] == 3) {//未审核
            GRCertiViewController *nextCtr = [[GRCertiViewController alloc] init];
//            nextCtr.isReUpload = NO;
            //pushType;//0订单  1认证   23机构认证审核成功  24机构认证审核失败  15, "基础认证审核通过   16, "基础认证审核失败"   17, "教育认证审核成功"   18, "教育认证审核失败"   19, "工作经历认证成功"   20, "工作经历认证失败"  25 .. 26优惠券
            nextCtr.type = @"0";
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)organizationButtonClick {
    WelcomeViewController *nextCtr = [[WelcomeViewController alloc] init];
    nextCtr.isRefee = YES;
    [self.navigationController pushViewController:nextCtr animated:YES];
    
//原机构认证
//    ORCertiViewController *nextCtr = [[ORCertiViewController alloc] init];
//    [self.navigationController pushViewController:nextCtr animated:YES];
    
//    [self loadMechanismCertDataSource];
}

- (void)loadMechanismCertDataSource {
    
    [self displayOverFlowActivityView];
    [CertiService getMechanismResultWithSuccess:^(MechanismModel *info) {
        [self removeOverFlowActivityView];
        
        if ([info.status isEqualToString:@"0"])
        {
            CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
            nextCtr.certiResultCtrl = CertiResultCtrlNormal;
            nextCtr.message = info.createTime;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else if ([info.status isEqualToString:@"1"])
        {
            CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
            nextCtr.certiResultCtrl = CertiResultCtrlSuccess;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else if ([info.status isEqualToString:@"2"])
        {
            CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
            nextCtr.certiResultCtrl = CertiResultCtrlFail;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else
        {
            ORCertiViewController *nextCtr = [[ORCertiViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
 
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark 界面布局
- (void)createSubViews {
    
    _personButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _personButton.frame = CGRectMake((kDeviceWidth-kCurrentWidth(180))/2, kCurrentWidth(70), kCurrentWidth(180), kCurrentWidth(180));
    _personButton.backgroundColor = kWhiteColor;
    [_personButton setTitle:@"个人申请" forState:UIControlStateNormal];
    [_personButton setTitleColor:kLBBlackColor forState:UIControlStateNormal];
    [_personButton setImage:[UIImage imageNamed:@"btn_geren"] forState:UIControlStateNormal];
    [_personButton setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(130, 130) space:kCurrentWidth(15)];
    _personButton.titleLabel.font = kSystem(16);
    [_personButton addTarget:self action:@selector(personButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_personButton];
    
    _organizationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _organizationButton.frame = CGRectMake((kDeviceWidth-kCurrentWidth(180))/2, _personButton.bottom+kCurrentWidth(30), kCurrentWidth(180), kCurrentWidth(180));
    _organizationButton.backgroundColor = kWhiteColor;
    [_organizationButton setTitle:@"企业申请" forState:UIControlStateNormal];
    [_organizationButton setTitleColor:kLBBlackColor forState:UIControlStateNormal];
    [_organizationButton setImage:[UIImage imageNamed:@"btn_jigou"] forState:UIControlStateNormal];
    [_organizationButton setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(130, 130) space:kCurrentWidth(15)];
    _organizationButton.titleLabel.font = kSystem(16);
    [_organizationButton addTarget:self action:@selector(organizationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_organizationButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
