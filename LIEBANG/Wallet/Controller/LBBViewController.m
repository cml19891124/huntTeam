//
//  LBBViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/25.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "LBBViewController.h"
#import "UserHelpViewController.h"

#import "RMStore.h"
#import "WalletService.h"
#import "LBBFootView.h"
#import "LBBHeadView.h"

@interface LBBViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)LBBHeadView *headView;
@property (nonatomic,strong)LBBFootView *footView;

@property (nonatomic,assign)BOOL isPaying;//购买中，不能退出

@end

@implementation LBBViewController

#pragma mark 防止退出掉单
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return !self.isPaying;
}

- (void)backNavItemTapped {
    if (!self.isPaying) {
        [super backNavItemTapped];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    self.navigationItem.title = @"充值猎帮币";
    [self setRightNaviBtnTitle:@"充值说明"];
    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
    self.groupTableView.backgroundColor = kWhiteColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    self.groupTableView.tableFooterView = self.footView;
    self.groupTableView.tableHeaderView = self.headView;
    [self.view addSubview:self.groupTableView];
        
    //充值productID
    NSSet *set = [NSSet setWithObjects:@"com.yiqi.LIEBANG.chongzhibi6",
                  @"com.yiqi.LIEBANG.chongzhibi30",
                  @"com.yiqi.LIEBANG.chongzhibi60",
                  @"com.yiqi.LIEBANG.chongzhibi108",
                  @"com.yiqi.LIEBANG.chongzhibi298",
                  @"com.yiqi.LIEBANG.chongzhibi518",
                  @"com.yiqi.LIEBANG.chongzhibi998",
                  @"com.yiqi.LIEBANG.chongzhibi1998",
                  @"com.yiqi.LIEBANG.chongzhibi2998", nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    });
    [self displayOverFlowActivityView];
    [[RMStore defaultStore] requestProducts:set success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        });
        [self removeOverFlowActivityView];
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        });
        [self removeOverFlowActivityView];
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellStr = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }

    cell.textLabel.textColor = kLBNineColor;
    cell.textLabel.font = kSystem(12);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark Event
- (void)rightNaviBtnClick {
    RechargeProtrolViewController *nextCtr = [[RechargeProtrolViewController alloc] init];
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)gotoUserProtocol {
    WebViewController *nextCtr = [[WebViewController alloc] init];
    nextCtr.webViewType = WebViewTypeUserProtocol;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

//充值
- (void)nextButtonClick {
    
    if (![RMStore canMakePayments]) return;
    
    self.isPaying = YES;    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self displayOverFlowActivityView];
    [[RMStore defaultStore] addPayment:self.headView.selectProduct success:^(SKPaymentTransaction *transaction) {
        [self GetMGRMStoreWithReceipt];
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self removeOverFlowActivityView];
        self.isPaying = NO;
        [self showAlertWithString:[NSString stringWithFormat:@"充值失败\n%@",error.localizedDescription]];
    }];
}

- (NSString *)GetMGRMStoreWithReceipt
{
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString *receiptStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    [self saveReceiptData:receiptStr];
    [self verifyPurchaseForServiceWithReceipt:receiptStr];
    return receiptStr;
}

- (void)verifyPurchaseForServiceWithReceipt:(NSString *)receiptString {
    
    [WalletService appleRechargeWithParameters:[self getReceiptData] success:^(NSString *data) {
        self.isPaying = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self removeOverFlowActivityView];
        [self removeLocReceiptData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadBalance];
        });
    } failure:^(NSUInteger code, NSString *errorStr) {
        self.isPaying = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self removeOverFlowActivityView];
    }];
}

#pragma mark -- 本地保存一次支付凭证
static NSString *const kSaveReceiptData = @"kSaveReceiptData";

- (void)saveReceiptData:(NSString *)receiptData
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self getReceiptData]];
    [array addObject:receiptData];
    [[NSUserDefaults standardUserDefaults] setValue:array forKey:kSaveReceiptData];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (NSMutableArray *)getReceiptData
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kSaveReceiptData];
}

- (void)removeLocReceiptData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSaveReceiptData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//充值成功后刷新余额
- (void)loadBalance {
    //获取账户余额
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:@"1" forKey:@"pageNow"];
    [postDic setValue:@"10" forKey:@"pageSize"];
    
    [WalletService getWalletWithParameters:postDic success:^(WalletListModel *model) {
        [Config currentConfig].balanceAmount = model.balance;
        [Config currentConfig].liebangCurrency = model.liebangCurrency;
        [self.headView refreshLiebangCurrency];
    } failure:^(NSUInteger code, NSString *errorStr) {
        
    }];
}

#pragma mark 懒加载
- (LBBFootView *)footView {
    if (!_footView) {
        _footView = [[LBBFootView alloc] init];
        
        WeakSelf;
        _footView.LBBConfimBlock = ^{
            [weakSelf nextButtonClick];
        };
        _footView.useProtocolBlock = ^{
            [weakSelf gotoUserProtocol];
        };
        _footView.useHelpBlock = ^{
            UserHelpViewController *nextCtr = [[UserHelpViewController alloc] init];
            [weakSelf.navigationController pushViewController:nextCtr animated:YES];
        };
    }
    return _footView;
}

- (LBBHeadView *)headView {
    if (!_headView) {
        _headView = [[LBBHeadView alloc] init];
    }
    return _headView;
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGPoint offset = scrollView.contentOffset;
//    if (offset.y <= 0) {
//        offset.y = 0;
//    }
//
//    scrollView.contentOffset = offset;
//    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
//      scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height);
//      return;
//    }
//}
@end
