#import "CompanyDetailViewController.h"

#import "CommonTabBarViewController.h"
#import "CommonNavgationViewController.h"
#import "WelcomeViewController.h"
#import "InterestFriendViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"
#import "FriendViewController.h"
#import "CompanyHomeViewController.h"
#import "HelpViewController.h"
#import "OrderDetailViewController.h"
#import "QuestionOrderDetailViewController.h"
#import "CouponViewController.h"
#import "CertiResultViewController.h"
#import "WalletViewController.h"
#import "PendViewController.h"
#import "CompanyHomeViewController.h"
#import "WelcomeViewController.h"
#import "CompanyService.h"

@interface CommonTabBarViewController ()
{
    HomeViewController *oneVC;
    MessageViewController *twoVC;
    FriendViewController *fourVC;
    MineViewController *fiveVC;
    CompanyHomeViewController *threeVC1;
    WelcomeViewController *threeVC2;
    
    CommonNavgationViewController *one;
    CommonNavgationViewController *two;
    CommonNavgationViewController *four;
    CommonNavgationViewController *five;
    CommonNavgationViewController *three1;
    CommonNavgationViewController *three2;
}
@property (nonatomic,assign)BOOL isPush;

@end

@implementation CommonTabBarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushLoginViewController) name:@"CH_LOGIN_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopLoginViewController) name:@"CH_LOGIN_STOP_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderDetailResultNot:) name:@"REMOTE_ORDER_DETAIL_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrshCompanyResultNot:) name:@"IS_PAY_COMPANY_NOTIFICATION" object:nil];
    
    _tabBarView = [[CommonTabBar alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
    _tabBarView.delegate = self;
    _tabBarView.backgroundColor = [UIColor whiteColor];
    
    [self.tabBar addSubview:_tabBarView];
    
    oneVC = [[HomeViewController alloc] init];
    oneVC.isHiddenBackBtn = YES;
    one = [[CommonNavgationViewController alloc] initWithRootViewController:oneVC];

    twoVC = [[MessageViewController alloc] init];
    twoVC.isHiddenBackBtn = YES;
    two = [[CommonNavgationViewController alloc] initWithRootViewController:twoVC];
    
    fourVC = [[FriendViewController alloc] init];
    fourVC.isHiddenBackBtn = YES;
    four = [[CommonNavgationViewController alloc] initWithRootViewController:fourVC];

    fiveVC = [[MineViewController alloc] init];
    fiveVC.isHiddenBackBtn = YES;
    five = [[CommonNavgationViewController alloc] initWithRootViewController:fiveVC];
    
    threeVC1 = [[CompanyHomeViewController alloc] init];
    threeVC1.isHiddenBackBtn = YES;
    three1 = [[CommonNavgationViewController alloc] initWithRootViewController:threeVC1];
//    self.viewControllers = @[one,two,three1,four,five];
    
    threeVC2 = [[WelcomeViewController alloc] init];
    threeVC2.isRefee = NO;
    threeVC2.isHiddenBackBtn = YES;
    three2 = [[CommonNavgationViewController alloc] initWithRootViewController:threeVC2];
    self.viewControllers = @[one,two,three2,four,five];
    
    self.delegate = self;
}

- (void)refrshCompanyResultNot:(NSNotification *)notification {
    
    if ([Config currentConfig].company.boolValue)
    {
        self.viewControllers = @[one,two,three1,four,five];
    }
    else
    {
        self.viewControllers = @[one,two,three2,four,five];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)tabBarSetSelectedIndex:(NSInteger)index {
    [self setSelectedIndex:index];
    [_tabBarView setSelectedButtonIndex:index];
}

- (void)tabBar:(CommonTabBar *)tabBar didPressButton:(UIButton *)button atIndex:(NSUInteger)tabIndex {
    [self setSelectedIndex:tabIndex];
    [_tabBarView setSelectedButton:button];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getUserMessageRequestItem];
        [[RCDataManager shareManager] refreshBadgeValue];
    });
    LoginModel *account = [SDUserTool account];

    if (IsNilOrNull(account.rongCloudToken) || IsStrEmpty(account.rongCloudToken)) {
        if (viewController == [tabBarController.viewControllers objectAtIndex:0]) {
            return YES;
        }else{
            //没有token跳登陆页面
            LoginViewController *nextVC = [[LoginViewController alloc] init];
            CommonNavgationViewController *loginVC = [[CommonNavgationViewController alloc] initWithRootViewController:nextVC];
            [self presentViewController:loginVC animated:YES completion:nil];
            return NO;
        }
    }
    
//    if (viewController == [tabBarController.viewControllers objectAtIndex:2]) {
//
////        HelpViewController *helpCtr = [[HelpViewController alloc] init];
////        helpCtr.modalPresentationStyle = UIModalPresentationOverFullScreen;
////        [tabBarController.selectedViewController presentViewController:helpCtr animated:YES completion:nil];
////        helpCtr.questionButtonBlock = ^{
//
//        CompanyHomeViewController *allCtr = [[CompanyHomeViewController alloc] init];
////            WelcomeViewController *allCtr = [[WelcomeViewController alloc] init];
//            [Config currentConfig].answerid = nil;
//            [((CommonNavgationViewController *)tabBarController.selectedViewController) pushViewController:allCtr animated:YES];
////        };
////        helpCtr.friendButtonBlock = ^{
////            InterestFriendViewController *allCtr = [[InterestFriendViewController alloc] init];
////            [((CommonNavgationViewController *)tabBarController.selectedViewController) pushViewController:allCtr animated:YES];
////        };
//        return NO;
//    }
    return YES;
}

- (void)getUserMessageRequestItem {
    
    [CompanyService getIsPayCompanyWithSuccess:^(BOOL data) {
        
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        
    }];
}

- (void)pushLoginViewController {
    LoginViewController *nextVC = [[LoginViewController alloc] init];
    CommonNavgationViewController *loginVC = [[CommonNavgationViewController alloc] initWithRootViewController:nextVC];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)stopLoginViewController {
    
    UIAlertController *alert = [CHAlertView showMessageWith:@"确定" title:@"该账号已被停用" confim:^{
        [self pushLoginViewController];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [_tabBarView setSelectedButtonIndex:tabBarController.selectedIndex];
}

- (void)popToRootViewController:(BOOL)animate {
    [self setSelectedIndex:0];
    [_tabBarView setSelectedButtonIndex:0];
}

/*
 推送跳转
 orderType:0问答  2话题
 orderUid:订单id
 type:4y收到的订单
 */
- (void)getOrderDetailResultNot:(NSNotification *)notification {
    
    NSDictionary *resultDic = notification.object;
    if (resultDic)
    {
        if ([resultDic[@"pushType"] intValue] == 26 || [resultDic[@"pushType"] intValue] == 25)//优惠券
        {
            if (!self.isPush)
            {
                self.isPush = YES;
                UIAlertController *alert = [CHAlertView showMessageWith:@"去查看" title:@"您收到一张优惠券" confim:^{
                    self.isPush = NO;
                    CouponViewController *nextCtr = [[CouponViewController alloc] init];
                    [((CommonNavgationViewController *)self.selectedViewController) pushViewController:nextCtr animated:YES];
                }];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        else if ([resultDic[@"pushType"] intValue] == 23 || [resultDic[@"pushType"] intValue] == 15 || [resultDic[@"pushType"] intValue] == 17 || [resultDic[@"pushType"] intValue] == 19)
        {//19-工作审核通过的状态
            CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
            nextCtr.certiResultCtrl = CertiResultCtrlSuccess;
            nextCtr.pushType = resultDic[@"pushType"];
            nextCtr.push = YES;
            [((CommonNavgationViewController *)self.selectedViewController) pushViewController:nextCtr animated:YES];
        }
        else if ([resultDic[@"pushType"] intValue] == 24 || [resultDic[@"pushType"] intValue] == 16 || [resultDic[@"pushType"] intValue] == 18 || [resultDic[@"pushType"] intValue] == 20)
        {
            if ([resultDic[@"pushType"] intValue] == 24) {
                if (IsNilOrNull(resultDic[@"enterpriseId"]) || IsStrEmpty(resultDic[@"enterpriseId"])) {
                    return;
                }
            }
            
            CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
            nextCtr.certiResultCtrl = CertiResultCtrlFail;
            nextCtr.companyUid = resultDic[@"enterpriseId"];
            nextCtr.pushType = resultDic[@"pushType"];
            nextCtr.push = YES;

            if ([resultDic[@"pushType"] intValue] == 16) {
                nextCtr.failType = @"0";
            }
            if ([resultDic[@"pushType"] intValue] == 18) {
                nextCtr.failType = @"1";
            }
            if ([resultDic[@"pushType"] intValue] == 20) {
                nextCtr.failType = @"2";
            }
            [((CommonNavgationViewController *)self.selectedViewController) pushViewController:nextCtr animated:YES];
        }
        else if ([resultDic[@"pushType"] intValue] == 21 || [resultDic[@"pushType"] intValue] == 22 || [resultDic[@"pushType"] intValue] == 50 || [resultDic[@"pushType"] intValue] == 51 || [resultDic[@"pushType"] intValue] == 52 || [resultDic[@"pushType"] intValue] == 53 || [resultDic[@"pushType"] intValue] == 2 || [resultDic[@"pushType"] intValue] == 3 || [resultDic[@"pushType"] intValue] == 4 || [resultDic[@"pushType"] intValue] == 5 || [resultDic[@"pushType"] intValue] == 6 || [resultDic[@"pushType"] intValue] == 7 || [resultDic[@"pushType"] intValue] == 8 || [resultDic[@"pushType"] intValue] == 9)//提现、分成
        {
            WalletViewController *nextCtr = [[WalletViewController alloc] init];
            [((CommonNavgationViewController *)self.selectedViewController) pushViewController:nextCtr animated:YES];
        }
        else if ([resultDic[@"pushType"] intValue] == 70 || [resultDic[@"pushType"] intValue] == 72)//有用户申请好友
        {
            PendViewController *nextCtr = [[PendViewController alloc] init];
            [((CommonNavgationViewController *)self.selectedViewController) pushViewController:nextCtr animated:YES];
        }
        else if ([resultDic[@"pushType"] intValue] == 71)//好友申请通过
        {
            MyFriendViewController *nextCtr = [[MyFriendViewController alloc] init];
            [((CommonNavgationViewController *)self.selectedViewController) pushViewController:nextCtr animated:YES];
        }
        else if ([resultDic[@"pushType"] intValue] == 99)
        {
            WebViewController *nextCtr = [[WebViewController alloc] init];
            nextCtr.webViewType = WebViewTypeHTML;
            nextCtr.contentString = resultDic[@"content"];
            nextCtr.navTitle = @"消息详情";
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else if ( [resultDic[@"pushType"] intValue] == 27)
               {
                   if (IsNilOrNull(resultDic[@"enterpriseId"]) || IsStrEmpty(resultDic[@"enterpriseId"])) {
                       return;
                   }
                   
                   CompanyDetailViewController *nextCtr = [[CompanyDetailViewController alloc] init];
                   nextCtr.companyUid = resultDic[@"enterpriseId"];
                   nextCtr.isSelf = YES;
                   nextCtr.companyType = @"0";
                   nextCtr.companyName = @"企业AI名片智能详情";
                   
                   [((CommonNavgationViewController *)self.selectedViewController) pushViewController:nextCtr animated:YES];
               }
        else if ([resultDic[@"pushType"] intValue] == 28){
            if (IsNilOrNull(resultDic[@"enterpriseId"]) || IsStrEmpty(resultDic[@"enterpriseId"])) {
                return;
            }
            
            CompanyDetailViewController *nextCtr = [[CompanyDetailViewController alloc] init];
            nextCtr.companyUid = resultDic[@"enterpriseId"];
            nextCtr.isSelf = NO;
            nextCtr.companyType = @"0";
            nextCtr.companyName = @"企业AI名片智能详情";
            
            [((CommonNavgationViewController *)self.selectedViewController) pushViewController:nextCtr animated:YES];
        }
        else{
            if ([resultDic[@"orderType"] intValue] == 0)
            {
                QuestionOrderDetailViewController *nextCtr = [[QuestionOrderDetailViewController alloc] init];
                nextCtr.orderUid = resultDic[@"id"];
                nextCtr.orderStatus = resultDic[@"type"];
                if ([resultDic[@"type"] isEqualToString:@"4"]) {
                    nextCtr.detailType = QuestionDetailTypeExpert;
                }
                else {
                    nextCtr.detailType = QuestionDetailTypeStudent;
                }
                [((CommonNavgationViewController *)self.selectedViewController) pushViewController:nextCtr animated:YES];
            }
            else if ([resultDic[@"orderType"] intValue] == 2)
            {
                OrderDetailViewController *nextCtr = [[OrderDetailViewController alloc] init];
                nextCtr.orderUid = resultDic[@"id"];
                nextCtr.orderStatus = resultDic[@"type"];
                if ([resultDic[@"type"] isEqualToString:@"4"]) {
                    nextCtr.detailType = QuestionDetailTypeExpert;
                }
                else {
                    nextCtr.detailType = QuestionDetailTypeStudent;
                }
                [((CommonNavgationViewController *)self.selectedViewController) pushViewController:nextCtr animated:YES];
            }
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REMOTE_ORDER_DETAIL_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CH_LOGIN_STOP_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IS_PAY_COMPANY_NOTIFICATION" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
