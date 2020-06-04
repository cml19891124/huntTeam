#import "CompanyFeeViewController.h"
#import "QuestionDetailViewController.h"
#import "PayViewController.h"
#import "CouponListViewController.h"
#import "OrderListViewController.h"
#import "OrderDetailViewController.h"
#import "QuestionOrderDetailViewController.h"
#import "CertiResultViewController.h"
#import "LBBViewController.h"
#import "PayHeadView.h"
#import "PayTypeCell.h"
#import "PayCouponCell.h"
#import "PayPriceCell.h"
#import "QuestionService.h"
#import "CouponService.h"
#import "CouponModel.h"
#import "WalletService.h"
#import "CompanyService.h"
#import "CompanyFootView.h"

#import "ExpertListViewController.h"

#import "ReserveThemeViewController.h"

#import "MyCompanyListViewController.h"

#import "PostQuestionViewController.h"

@interface PayViewController ()

@property (nonatomic,strong)PayHeadView *headView;
@property (nonatomic,strong)ConfimButton *confimButton;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)CouponListModel *couponModel;
@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,strong)NSString *payOrderUid;
@property (nonatomic,strong)CompanyFootView *footView;

@end

@implementation PayViewController

- (void)backNavItemTapped
{
    if (self.navigationController.childViewControllers.count >= 2) {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[CompanyFeeViewController class]]) {
            CompanyFeeViewController *messageVC =(CompanyFeeViewController *)controller;
            [self.navigationController popToViewController:messageVC animated:YES];
        }
        else if ([controller isKindOfClass:[ExpertListViewController class]]) {
            ExpertListViewController *messageVC =(ExpertListViewController *)controller;
            [self.navigationController popToViewController:messageVC animated:YES];
        }else if ([controller isKindOfClass:[ReserveThemeViewController class]]) {
            ReserveThemeViewController *messageVC =(ReserveThemeViewController *)controller;
            [self.navigationController popToViewController:messageVC animated:YES];
        }else if ([controller isKindOfClass:[MyCompanyListViewController class]]) {
            MyCompanyListViewController *messageVC =(MyCompanyListViewController *)controller;
            [self.navigationController popToViewController:messageVC animated:YES];
        }else if ([controller isKindOfClass:[QuestionDetailViewController class]]) {
            QuestionDetailViewController *messageVC =(QuestionDetailViewController *)controller;
            [self.navigationController popToViewController:messageVC animated:YES];
        }else if ([controller isKindOfClass:[PostQuestionViewController class]]) {
            PostQuestionViewController *messageVC =(PostQuestionViewController *)controller;
            [self.navigationController popToViewController:messageVC animated:YES];
        }
    }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收银台";
    self.view.backgroundColor = kBackgroundColor;
    [self setRightNaviBtnTitle:@"充值说明"];
    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.enterpriseId intValue] != 0)
    {
        self.footView = [[CompanyFootView alloc] initWithFrame:CGRectMake(0, kDeviceHeight-kCurrentWidth(210)-kNavBarHeight, kDeviceWidth, kCurrentWidth(100)) title:@"企业对公账户支付" message:@"客服电话：13510019677\n工作日09:00-18:00\n我们将竭诚为您服务" subMess:@""];
        self.footView.backgroundColor = kWhiteColor;
    }    
    
    self.selectIndex = 2;
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kWhiteColor;
    self.groupTableView.tableHeaderView = self.headView;
    [self.view addSubview:self.groupTableView];
    [self.groupTableView addSubview:self.footView];
    [self.groupTableView addSubview:self.confimButton];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadCouponDataSource];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResultNot:) name:@"ALI_ORDER_PAY_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResultWX:) name:@"WX_ORDER_PAY_NOTIFICATION" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadBalance];
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ALI_ORDER_PAY_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WX_ORDER_PAY_NOTIFICATION" object:nil];
}

- (void)loadCouponDataSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:@"1" forKey:@"pageNow"];
    [postDic setValue:@"10" forKey:@"pageSize"];
    [postDic setValue:@"0" forKey:@"status"];//0：未使用 1：已使用 2已过期
    [postDic setValue:self.classifyId forKey:@"classifyId"];//标签id
    if ([self.enterpriseId intValue] != 0)
    {
        [postDic setValue:@"3" forKey:@"couponType"];//企业优惠券
    }
    NSLog(@"优惠券 == %@",postDic);
    
    [CouponService getCouponListWithParameters:postDic success:^(CouponModel *model) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:model.data];
    } failure:^(NSUInteger code, NSString *errorStr) {
        
    }];
}

- (void)loadBalance {
    //获取账户余额
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:@"1" forKey:@"pageNow"];
    [postDic setValue:@"10" forKey:@"pageSize"];
    
    [WalletService getWalletWithParameters:postDic success:^(WalletListModel *model) {
        [Config currentConfig].balanceAmount = model.balance;
        [Config currentConfig].liebangCurrency = model.liebangCurrency;
        [self.groupTableView reloadData];
        
        if ([self.couponModel.couponType intValue] == 1) {
            
            if ([[Config currentConfig].liebangCurrency floatValue] >= 0.01)
            {
                self.confimButton.enabled = YES;
            }
            else
            {
                self.confimButton.enabled = NO;
            }
        }
        else {
            
            if ([[Config currentConfig].liebangCurrency floatValue] >= ([self.questionPri floatValue]-[self.couponModel.offMoney floatValue]))
            {
                self.confimButton.enabled = YES;
            }
            else
            {
                self.confimButton.enabled = NO;
            }
        }
        
    } failure:^(NSUInteger code, NSString *errorStr) {
        
    }];
}

- (void)payQuestionRequestion {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    
    if ([self.enterpriseId intValue] == 0)
    {
        if ([self.couponModel.couponType intValue] == 1) {
            if (self.selectIndex == 2 && [[Config currentConfig].liebangCurrency floatValue] < 0.01) {
                [self showAlertWithString:@"余额不足，请充值"];
                return;
            }
        }
        else {
            if (self.selectIndex == 2 && ([self.questionPri floatValue]-[self.couponModel.offMoney floatValue]) > [[Config currentConfig].liebangCurrency floatValue]) {
                [self showAlertWithString:@"余额不足，请充值"];
                return;
            }
        }
        
        [postDic setValue:[Config currentConfig].answerid forKey:@"answerUid"];//要求回答的用户id
        [postDic setValue:self.questionPri forKey:@"questionPri"];//问答价格
        [postDic setValue:[NSString stringWithFormat:@"%.2f",[self.questionPri floatValue]] forKey:@"orderPrice"];//订单价格
        [postDic setValue:self.couponModel.id forKey:@"userCouponId"];//优惠券id
        [postDic setValue:[NSNumber numberWithInteger:self.selectIndex] forKey:@"payType"];//支付方式 (0 支付宝 1：微信 2:零钱)
        
        if ([self.couponModel.couponType intValue] == 1) {
            [postDic setValue:@"0.01" forKey:@"payPrice"];//支付价格
        }
        else {
            [postDic setValue:[NSString stringWithFormat:@"%.2f",[self.questionPri floatValue]-[self.couponModel.offMoney floatValue]] forKey:@"payPrice"];//支付价格
        }
        
        if (!IsStrEmpty(self.topicId) && !IsNilOrNull(self.topicId)) {
            [postDic setValue:@"2" forKey:@"orderType"];//订单类型（0 问答 1问答围观 2话题）
            [postDic setValue:self.quizcontent forKey:@"topicAskQuestion"];//请教的话题
            [postDic setValue:self.otherString forKey:@"askIntroduction"];//请教的自我介绍
            [postDic setValue:self.topicId forKey:@"topicId"];//话题id
        }
        else {
            [postDic setValue:self.quizcontent forKey:@"quizcontent"];//问答提问内容
            [postDic setValue:@"0" forKey:@"orderType"];//订单类型（0 问答 1问答围观 2话题）
            //    [postDic setValue:@"" forKey:@"questionId"];//问答id(不用传)
        }
        
        //问答围观---1元查看
        if (!IsNilOrNull(self.questionUid) && !IsStrEmpty(self.questionUid))
        {
            [postDic removeAllObjects];
            [postDic setValue:self.questionPri forKey:@"questionPri"];//问答价格
            [postDic setValue:self.questionUid forKey:@"questionId"];////问答id
            [postDic setValue:self.couponModel.id forKey:@"userCouponId"];//优惠券id
            [postDic setValue:@"1" forKey:@"orderType"];//订单类型（0 问答 1问答围观 2话题）
            [postDic setValue:[NSNumber numberWithInteger:self.selectIndex] forKey:@"payType"];//支付方式 (0 支付宝 1：微信 2:零钱)
            
            if ([self.couponModel.couponType intValue] == 1) {
                [postDic setValue:@"0.01" forKey:@"payPrice"];//支付价格
                [postDic setValue:@"0.01" forKey:@"orderPrice"];//订单价格
            }
            else {
                [postDic setValue:[NSString stringWithFormat:@"%.2f",[self.questionPri floatValue]-[self.couponModel.offMoney floatValue]] forKey:@"payPrice"];//支付价格
                [postDic setValue:[NSString stringWithFormat:@"%.2f",[self.questionPri floatValue]-[self.couponModel.offMoney floatValue]] forKey:@"orderPrice"];//订单价格
            }
            
            NSLog(@"1元查看postDic == %@",postDic);
        }
        
        NSLog(@"下单postDic == %@",postDic);
        
        [self displayOverFlowActivityView];
        [QuestionService getPostQuestionOrderWithParameters:postDic success:^(id info) {
            [self removeOverFlowActivityView];
            self.payOrderUid = info;
            [self getOrderPayResult:info];

        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }
    else
    {
        if (self.selectIndex == 2 && ([self.questionPri floatValue]-[self.couponModel.offMoney floatValue]) > [[Config currentConfig].liebangCurrency floatValue]) {
            [self showAlertWithString:@"余额不足，请充值"];
            return;
        }
        
        [postDic setValue:self.level forKey:@"level"];//付费等级
        [postDic setValue:self.enterpriseId forKey:@"enterpriseId"];////认证的企业id
        [postDic setValue:@([self.questionPri floatValue]-[self.couponModel.offMoney floatValue]).stringValue forKey:@"payPrice"];//支付金额
        [postDic setValue:self.isContiues?@"1":@"0" forKey:@"orderType"];//0:购买企业名片 1：企业名片续费  PS:已经过期的续费按续费流程走，但实际上是按购买企业名片传0
        [postDic setValue:@"3" forKey:@"payType"];//3.猎帮币
        [postDic setValue:self.couponModel.id forKey:@"userCouponId"];//优惠券id
        NSLog(@"购买企业名片 == %@",postDic);
        
        [self displayOverFlowActivityView];
        [CompanyService payCompanyWithParameters:postDic success:^(PayModel * _Nonnull data) {
            [self removeOverFlowActivityView];
            [self getCompanyPayResult];

        } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
        {
            static NSString *cellStr = @"PayTypeCell";
            PayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[PayTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            if ([self.couponModel.couponType intValue] == 1) {
                cell.payPrice = @"0.01";
            }
            else {
                cell.payPrice = [NSString stringWithFormat:@"%f",[self.questionPri floatValue]-[self.couponModel.offMoney floatValue]];
            }
            cell.indexPath = indexPath;
            cell.selectIndex = self.selectIndex;
            cell.usePayTypeBlock = ^{
                weakSelf.selectIndex = indexPath.row;
                [weakSelf.groupTableView reloadData];
            };
            cell.rechargeButtonBlock = ^{
                [weakSelf rechargeButtonClick];
            };
            return cell;
        }
        case 3:
        {
            static NSString *cellStr = @"PayCouponCell";
            PayCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[PayCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            cell.model = self.couponModel;
            return cell;
        }
        case 4:
        {
            static NSString *cellStr = @"PayPriceCell";
            PayPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[PayPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            if ([self.couponModel.couponType intValue] == 1) {
                cell.price = @"0.01";
            }
            else {
                cell.price = [NSString stringWithFormat:@"%f",[self.questionPri floatValue]-[self.couponModel.offMoney floatValue]];
            }
            return cell;
        }
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 1) {
//        return [WXApi isWXAppInstalled]?kCurrentWidth(55):0.0000001;
//    }
    if (indexPath.row == 1 || indexPath.row == 0) {
        return 0.0000001;
    }
    return kCurrentWidth(55);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3)
    {
        if (IsArrEmpty(self.dataSource)) {
            [self showAlertWithString:@"暂无可用优惠券"];
            return;
        }
        
        WeakSelf;
        if (indexPath.row == 3) {
            CouponListViewController *nextCtr = [[CouponListViewController alloc] init];
            nextCtr.isUse = YES;
            nextCtr.status = @"0";
            nextCtr.questionPri = self.questionPri;
            nextCtr.classifyId = self.classifyId;
            nextCtr.isCompany = [self.enterpriseId intValue] != 0;
            nextCtr.userCouponBlock = ^(CouponListModel *couponModel) {
                weakSelf.couponModel = couponModel;
                
                if ([weakSelf.couponModel.couponType intValue] == 1) {
                    weakSelf.confimButton.title = @"免单(需支付0.01猎帮币)";
                    
                    if ([[Config currentConfig].liebangCurrency floatValue] >= 0.01)
                    {
                        self.confimButton.enabled = YES;
                    }
                    else
                    {
                        self.confimButton.enabled = NO;
                    }
                }
                else {
                    weakSelf.confimButton.title = [NSString stringWithFormat:@"确认支付%.2f猎帮币",[self.questionPri floatValue]-[self.couponModel.offMoney floatValue]];
                    
                    if ([[Config currentConfig].liebangCurrency floatValue] >= ([self.questionPri floatValue]-[self.couponModel.offMoney floatValue]))
                    {
                        self.confimButton.enabled = YES;
                    }
                    else
                    {
                        self.confimButton.enabled = NO;
                    }
                }
                
                [weakSelf.groupTableView reloadData];
            };
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
    }
    else if (indexPath.row == 4)
    {
        
    }
    else
    {
        self.selectIndex = indexPath.row;
        [self.groupTableView reloadData];
    }
}

#pragma mark - 收到支付成功的消息后作相应的处理
- (void)getOrderPayResult:(NSString *)orderUid {
    [self presentSheet:@"支付成功"];
    [self performBlock:^{
        if (self.isOne) {
            if (self.onePayResultBlock) {
                self.onePayResultBlock(orderUid);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            
            if (!IsStrEmpty(self.topicId) && !IsNilOrNull(self.topicId)) {
                OrderDetailViewController *nextCtr = [[OrderDetailViewController alloc] init];
                nextCtr.orderUid = self.payOrderUid;
                nextCtr.detailType = QuestionDetailTypeStudent;
                nextCtr.orderStatus = @"1";
                nextCtr.isPay = YES;
                [self.navigationController pushViewController:nextCtr animated:YES];
            }
            else {
                QuestionOrderDetailViewController *nextCtr = [[QuestionOrderDetailViewController alloc] init];
                nextCtr.orderUid = self.payOrderUid;
                nextCtr.detailType = QuestionDetailTypeStudent;
                nextCtr.orderStatus = @"1";
                nextCtr.isPay = YES;
                [self.navigationController pushViewController:nextCtr animated:YES];
            }
        }
    } afterDelay:1.5];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadBalance];
    });
}

- (void)getCompanyPayResult {
    
    if (self.isContiuesII)
    {
        [self presentSheet:@"支付成功"];
        [self performBlock:^{
//            [self.navigationController popToRootViewControllerAnimated:YES];
            if (self.navigationController.childViewControllers.count >= 2) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[MyCompanyListViewController class]]) {
                    MyCompanyListViewController *messageVC =(MyCompanyListViewController *)controller;
                    [self.navigationController popToViewController:messageVC animated:YES];
                }
            }
            }
        } afterDelay:1.5];
    }
    else
    {
        CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
        nextCtr.certiResultCtrl = CertiResultCtrlCompanyNormal;
        nextCtr.message = [InsureValidate getCurrentTimes];
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}

- (void)getOrderPayResultNot:(NSNotification *)notification {
    
    NSDictionary *resultDic = notification.object;
    if (resultDic && [resultDic objectForKey:@"resultStatus"] && ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000)) {
        if ([self.enterpriseId intValue] == 0) {
            [self getOrderPayResult:nil];
        }
        else {
            [self getCompanyPayResult];
        }
    } else {
        [self presentSheet:@"支付失败"];
    }
}

- (void)getOrderPayResultWX:(NSNotification *)notification {
    
    if ([notification.object isEqualToString:@"success"]) {
        if ([self.enterpriseId intValue] == 0) {
            [self getOrderPayResult:nil];
        }
        else {
            [self getCompanyPayResult];
        }
    } else {
        [self presentSheet:@"支付失败"];
    }
}

#pragma mark Event
- (void)confimButtonClick {
    [self payQuestionRequestion];
}

- (void)rightNaviBtnClick {
    RechargeProtrolViewController *nextCtr = [[RechargeProtrolViewController alloc] init];
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)rechargeButtonClick {
    LBBViewController *nextCtr = [[LBBViewController alloc] init];
    [self.navigationController pushViewController:nextCtr animated:YES];
}

#pragma mark UI
- (PayHeadView *)headView {
    if (!_headView) {
        _headView = [[PayHeadView alloc] init];
        _headView.price = self.questionPri;
        _headView.serviceType = self.serviceType;
    }
    return _headView;
}

- (ConfimButton *)confimButton {
    if (!_confimButton) {
        _confimButton = [[ConfimButton alloc] initWithTop:kDeviceHeight-kCurrentWidth(75)-kNavBarHeight title:[NSString stringWithFormat:@"确认支付%.2f猎帮币",[self.questionPri floatValue]]];
        if ([[Config currentConfig].liebangCurrency floatValue] >= [self.questionPri floatValue])
        {
            _confimButton.enabled = YES;
        }
        else
        {
            _confimButton.enabled = NO;
        }
        [_confimButton addTarget:self action:@selector(confimButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confimButton;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
