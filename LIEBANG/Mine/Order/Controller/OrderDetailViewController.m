#import "ThemeDetailViewController.h"

#import "OrderDetailViewController.h"
#import "ThemeMessageViewController.h"
#import "AccountViewController.h"
#import "ConversationViewController.h"
#import "AllClassViewController.h"
#import "OrderQuestionCell.h"
#import "HomeMeetCell.h"
#import "OrderStatusCell.h"
#import "OrderIntroductionCell.h"
#import "OrderUidCell.h"
#import "OrderDetailButton.h"
#import "OrderService.h"
#import "ThemeOrderDetailModel.h"
#import "MemberPhoneCell.h"
#import "OrderConfimCell.h"
#import "OrderCommentCell.h"
#import "PostScoreView.h"
#import "MeetCell.h"

@interface OrderDetailViewController ()

@property (nonatomic,strong)OrderDetailButton *detailButton;
@property (nonatomic,strong)ThemeOrderDetailModel *detailModel;
@property (nonatomic,strong)UIWebView *callWebView;
@property (nonatomic,strong)PostScoreView *scoreView;
@property (nonatomic,strong)CommentPickView *pickview;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
    
    [self loadThemeOrderDetailDataSource];
    
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadThemeOrderDetailDataSource];
    }];
    
}

- (void)backNavItemTapped {
    if (self.isPay) {
        if (self.navigationController.childViewControllers.count >= 2) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[ThemeDetailViewController class]]) {
                    ThemeDetailViewController *messageVC =(ThemeDetailViewController *)controller;
                    [self.navigationController popToViewController:messageVC animated:YES];
                }
            }
                
        }else{
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
    else {
        [super backNavItemTapped];
    }
}

#pragma mark 数据源
- (void)loadThemeOrderDetailDataSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.orderUid forKey:@"id"];
    [postDic setValue:self.orderStatus forKey:@"type"];
    
    NSLog(@"话题详情 == %@",postDic);
    
    [self displayOverFlowActivityView];
    [OrderService getThemeOrderDetailWithParameters:postDic success:^(ThemeOrderDetailModel *info) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_header endRefreshing];
        self.detailModel = info;
        [LBForProject decodeThemeDetailCellTitle:self.detailModel detailType:self.detailType];
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_header endRefreshing];
        [self presentSheet:errorStr];
    }];
}

- (void)setDetailModel:(ThemeOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
    if (self.detailType == QuestionDetailTypeExpert)
    {
        if ([self.detailModel.orderStates intValue] == 1)
        {
            [self setRightNaviBtnTitle:@"无法回答/忽略"];
            [self.rightNaviBtn addTarget:self action:@selector(postCancelThemeOrderRequest) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [self setRightNaviBtnTitle:@""];
        }
    }
    else if (self.detailType == QuestionDetailTypeStudent)
    {
        if ([self.detailModel.orderStates intValue] == 1 || [self.detailModel.orderStates intValue] == 9)
        {
            [self setRightNaviBtnTitle:@"取消订单"];
            [self.rightNaviBtn addTarget:self action:@selector(postCancelOrderRequest) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [self setRightNaviBtnTitle:@""];
        }
    }
    
    if (!IsStrEmpty(_detailModel.mettingEdnTime) && !IsNilOrNull(_detailModel.mettingEdnTime)) {
        if (![_detailModel.mettingBeginTime containsString:@"-"]) {
            _detailModel.mettingBeginTime = [InsureValidate timeInStr:_detailModel.mettingBeginTime];
            _detailModel.mettingBeginTime = [_detailModel.mettingBeginTime substringToIndex:16];
        }
        if (![_detailModel.mettingEdnTime containsString:@"-"]) {
            _detailModel.mettingEdnTime = [InsureValidate timeInStr:_detailModel.mettingEdnTime];
            _detailModel.mettingEdnTime = [_detailModel.mettingEdnTime substringToIndex:16];
        }
    }
    
    self.detailButton.detailType = self.detailType;
    self.detailButton.detailModel = detailModel;
    
    if (self.detailButton.buttonState == OrderDetailButtonStateNOButton) {
        self.groupTableView.height = kDeviceHeight-kNavBarHeight-kViewHeight;
        self.scoreView.hidden = YES;
    }
    else if (self.detailButton.buttonState == OrderDetailButtonStatePostComment) {
        self.groupTableView.height = kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kCurrentWidth(49)-kViewHeight;
        self.scoreView.hidden = NO;
    }
    else {
        self.groupTableView.height = kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight;
        self.scoreView.hidden = YES;
    }
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [LBForProject currentProject].detailCellTitleArray.count;
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
    
    if ([cellNameStr isEqualToString:@"OrderStatusCell"]) {
        static NSString *cellStr = @"OrderStatusCell";
        OrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[OrderStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.detailType = self.detailType;
        cell.detailModel = self.detailModel;
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"HomeMeetCell"])
    {
        static NSString *cellStr = @"HomeMeetCell";
        MeetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[MeetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.detailModel = self.detailModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"MemberPhoneCell"])
    {//订单详情里含有公司和职位信息的cell
        static NSString *cellStr = @"MemberPhoneCell";
        MemberPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[MemberPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.orderStatus = self.orderStatus;
        cell.detailModel = self.detailModel;
        cell.callPhoneButtonBlock = ^{
            [weakSelf callHotLine];
        };
        cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };

        return cell;
    }
    else if ([cellNameStr isEqualToString:@"OrderConfimCell"])
    {
        static NSString *cellStr = @"OrderConfimCell";
        OrderConfimCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[OrderConfimCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.detailType = self.detailType;
        cell.detailModel = self.detailModel;
        cell.messageButtonBlock = ^{
            [weakSelf gotoThemeMeetEvent];
        };
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"OrderQuestionCell"])
    {
        static NSString *cellStr = @"OrderQuestionCell";
        OrderQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[OrderQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.detailType = self.detailType;
        cell.detailModel = self.detailModel;
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"OrderIntroductionCell"])
    {
        static NSString *cellStr = @"OrderIntroductionCell";
        OrderIntroductionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[OrderIntroductionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.detailType = self.detailType;
        cell.detailModel = self.detailModel;
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"OrderUidCell"])
    {
        static NSString *cellStr = @"OrderUidCell";
        OrderUidCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[OrderUidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.detailModel = self.detailModel;
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"OrderCommentCell"])
    {
        static NSString *cellStr = @"OrderCommentCell";
        OrderCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[OrderCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.detailModel = self.detailModel;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellNameStr;
    if (!IsArrEmpty([LBForProject currentProject].detailCellTitleArray)) {
        cellNameStr = [[LBForProject currentProject].detailCellTitleArray safeObjectAtIndex:indexPath.section];
    }
    
    if ([cellNameStr isEqualToString:@"OrderStatusCell"])
    {
        return kCurrentWidth(120);
    }
    else if ([cellNameStr isEqualToString:@"HomeMeetCell"])
    {
        MeetCell *cell = (MeetCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    else if ([cellNameStr isEqualToString:@"MemberPhoneCell"])
    {
        return kCurrentWidth(94);
    }
    else if ([cellNameStr isEqualToString:@"OrderConfimCell"])
    {
        OrderConfimCell *cell = (OrderConfimCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return [cell getCellHeight];
    }
    else if ([cellNameStr isEqualToString:@"OrderQuestionCell"])
    {
        OrderQuestionCell *cell = (OrderQuestionCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return [cell getCellHeight];
    }
    else if ([cellNameStr isEqualToString:@"OrderIntroductionCell"])
    {
        OrderIntroductionCell *cell = (OrderIntroductionCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return [cell getCellHeight];
    }
    else if ([cellNameStr isEqualToString:@"OrderUidCell"])
    {
        return kCurrentWidth(95);
    }
    else if ([cellNameStr isEqualToString:@"OrderCommentCell"])
    {
        return kCurrentWidth(255);
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *cellNameStr;
    if (!IsArrEmpty([LBForProject currentProject].detailCellTitleArray)) {
        cellNameStr = [[LBForProject currentProject].detailCellTitleArray safeObjectAtIndex:indexPath.section];
    }
    
    if ([cellNameStr isEqualToString:@"MemberPhoneCell"])
    {
        AccountViewController *nextCtr = [[AccountViewController alloc] init];
        if ([self.orderStatus intValue] == 4) {
            nextCtr.userUid = self.detailModel.StudentuserUid;
        }
        else {
            nextCtr.userUid = self.detailModel.userUid;
        }
        nextCtr.accountState = AccountStateOther;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if ([cellNameStr isEqualToString:@"HomeMeetCell"])
    {
        
    }
}

#pragma mark 打电话
- (void)callHotLine
{
    if ([self checkHardWareIsSupportCallHotLine]) {
        
        if ([self.orderStatus isEqualToString:@"4"]) {
            [self.callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.detailModel.StudentuserPhone]]]];
        }
        else {
            [self.callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.detailModel.userPhone]]]];
        }
        
    } else {
        [self showAlertWithString:[NSString stringWithFormat:@"很抱歉，您的设备不支持拨打电话！\n 客服热线：%@",self.detailModel.userPhone]];
    }
}

- (BOOL)checkHardWareIsSupportCallHotLine
{
    BOOL isSupportTel = NO;
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.detailModel.userPhone]];
    isSupportTel = [[UIApplication sharedApplication] canOpenURL:telURL];
    return isSupportTel;
}

- (UIWebView *)callWebView
{
    if (!_callWebView) {
        _callWebView = [[UIWebView alloc] init];
    }
    return _callWebView;
}

#pragma mark Event
- (void)gotoThemeMeetEvent {
    WeakSelf;
    ThemeMessageViewController *nextCtr = [[ThemeMessageViewController alloc] init];
    nextCtr.detailModel = self.detailModel;
    nextCtr.confimButtonBlock = ^(ThemeOrderDetailModel *detailModel) {
        weakSelf.detailModel.mettingBeginTime = detailModel.mettingBeginTime;
        weakSelf.detailModel.mettingEdnTime = detailModel.mettingEdnTime;
        weakSelf.detailModel.mettingAddress = detailModel.mettingAddress;
        weakSelf.detailModel.detailedAddress = detailModel.detailedAddress;
        [weakSelf.groupTableView reloadData];
    };
    [self.navigationController pushViewController:nextCtr animated:YES];
}

//忽略话题
- (void)postCancelThemeOrderRequest {
    
    UIAlertController *alert = [CHAlertView showMessageWith:@"确定" title:@"忽略该话题" confim:^{
        [self displayOverFlowActivityView];
        [OrderService getCancelThemeWithParameters:self.orderUid success:^(NSString *info) {
            [self removeOverFlowActivityView];
            [self presentSheet:@"忽略成功"];
            [self performBlock:^{
                [self backNavItemTapped];
            } afterDelay:1.5];
//            [self loadThemeOrderDetailDataSource];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

//取消订单
- (void)postCancelOrderRequest {
    
    UIAlertController *alert = [CHAlertView showMessageWith:@"确定" title:@"取消该订单" confim:^{
        [self displayOverFlowActivityView];
        [OrderService getCancelOrderWithParameters:self.orderUid success:^(NSString *info) {
            [self removeOverFlowActivityView];
            [self presentSheet:@"取消成功"];
            [self performBlock:^{
                [self backNavItemTapped];
            } afterDelay:1.5];
//            [self loadThemeOrderDetailDataSource];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

//用户确认预约话题
- (void)appointmentThemeRequest {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.orderUid forKey:@"id"];
    
    [self displayOverFlowActivityView];
    [OrderService getAppointmentThemeWithParameters:postDic success:^(NSString *info) {
        [self removeOverFlowActivityView];
        [self presentSheet:@"确认预约成功"];
        [self performBlock:^{
            [self backNavItemTapped];
        } afterDelay:1.5];
//        [self loadThemeOrderDetailDataSource];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

//行家确认预约话题
- (void)appointmentExpThemeRequest {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.orderUid forKey:@"id"];
    [postDic setValue:self.detailModel.mettingBeginTime forKey:@"mettingBeginTime"];//开始时间
    [postDic setValue:self.detailModel.mettingEdnTime forKey:@"mettingEdnTime"];//结束时间
    
    if ([self.detailModel.serviceType intValue] == 0) {
        [postDic setValue:self.detailModel.mettingAddress forKey:@"mettingAddress"];//见面地址
        [postDic setValue:self.detailModel.detailedAddress forKey:@"detailedAddress"];//详细地址
    }
    
    if ([self.detailModel.serviceType intValue] == 0) {
        if ([postDic count] != 5) {
            [self presentSheet:@"请完善预约信息"];
            return;
        }
    }
    else {
        if ([postDic count] != 3) {
            [self presentSheet:@"请完善预约信息"];
            return;
        }
    }
    
    NSLog(@"行家确认预约话题 == %@",postDic);
    
    [self displayOverFlowActivityView];
    [OrderService getExpAppointmentThemeWithParameters:postDic success:^(NSString *info) {
        [self removeOverFlowActivityView];
        [self presentSheet:@"确认预约成功"];
        [self performBlock:^{
            [self backNavItemTapped];
        } afterDelay:1.5];
//        [self loadThemeOrderDetailDataSource];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

//用户话题确认服务完成
- (void)userConfimThemeRequest {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.orderUid forKey:@"id"];
    
    [self displayOverFlowActivityView];
    [OrderService getUserConfimThemeWithParameters:postDic success:^(NSString *info) {
        [self removeOverFlowActivityView];
        [self presentSheet:@"确认成功"];
        [self performBlock:^{
            if (self.refrshDataSourceBlock) {
                self.refrshDataSourceBlock(2);
            }
            [self backNavItemTapped];
        } afterDelay:1.5];
//        [self loadThemeOrderDetailDataSource];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

//行家话题确认服务完成
- (void)expConfimThemeRequest {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.orderUid forKey:@"id"];
    
    [self displayOverFlowActivityView];
    [OrderService getExpConfimThemeWithParameters:postDic success:^(NSString *info) {
        [self removeOverFlowActivityView];
        [self presentSheet:@"确认成功"];
        [self performBlock:^{
            [self backNavItemTapped];
        } afterDelay:1.5];
//        [self loadThemeOrderDetailDataSource];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

//提醒行家
- (void)remindExpertRequest {
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.orderUid forKey:@"id"];
    
    NSLog(@"提醒行家postDic = %@",postDic);
    
    [self displayOverFlowActivityView];
    [OrderService getRemindExpertWithParameters:postDic success:^(NSString *info) {
        [self removeOverFlowActivityView];
        [self presentSheet:info];
//        [self performBlock:^{
//            [self backNavItemTapped];
//        } afterDelay:1.5];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

//评价话题订单
- (void)commentThemeOrderRequest {
    
//    if ([Config currentConfig].comment.length < 24) {
//        [self showAlertWithString:@"评论内容不能少于24字"];
//        return;
//    }
    
//    if ([InsureValidate deleteWhiteSpaceInStr:[Config currentConfig].comment].length <= 0) {
//        [self showAlertWithString:@"请输入的有效评论内容"];
//        return;
//    }
    
    if (self.scoreView.starNumber == 0) {
        [self showAlertWithString:@"请评个分儿吧!"];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.orderUid forKey:@"id"];
    [postDic setValue:[NSNumber numberWithInteger:self.scoreView.starNumber] forKey:@"score"];
    [postDic setValue:self.detailModel.userUid forKey:@"commitUserUid"];//被评论的用户uid
    [postDic setValue:[Config currentConfig].comment forKey:@"comment"];
    
    NSLog(@"评价话题订单postDic = %@",postDic);
    
    [self displayOverFlowActivityView];
    [OrderService getPostThemeOrderCommentWithParameters:postDic success:^(NSString *success) {
        [self removeOverFlowActivityView];
        
        self.pickview = [[CommentPickView alloc] init];
        self.pickview.starNumber = self.scoreView.starNumber;
        [self.view addSubview:self.pickview];
        self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
        [self performBlock:^{
            [self backNavItemTapped];
        } afterDelay:1.5];
        //10.28 为了防止“已结束”角标消失
//        [self loadThemeOrderDetailDataSource];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.pickview closeButtonClick];
}

- (void)messageEvent {
    NSLog(@"私信");
    
    ConversationViewController *_conversationVC = [[ConversationViewController alloc]init];
    _conversationVC.conversationType = ConversationType_PRIVATE;
    
    if ([self.orderStatus intValue] == 4) {
        _conversationVC.targetId = self.detailModel.StudentuserUid;
        _conversationVC.title = self.detailModel.StudentuserName;
    }
    else {
        _conversationVC.targetId = self.detailModel.userUid;
        _conversationVC.title = self.detailModel.userName;
    }
    
    RCUserInfo *user = [RCUserInfo new];
    user.name = self.detailModel.userName;
    user.userId = self.detailModel.userUid;
    user.portraitUri = self.detailModel.userHead;
    [[RCDataManager shareManager] addRCUserInfo:user];
    
    [self.navigationController pushViewController:_conversationVC animated:YES];
}

- (void)orderButtonEvent:(OrderDetailButtonState)buttonState {
    
    if (buttonState == OrderDetailButtonStateRemind)
    {
        NSLog(@"提醒行家");
        [self remindExpertRequest];
    }
    else if (buttonState == OrderDetailButtonStateSureCompleted)
    {
        NSLog(@"学员确认完成");
        [self userConfimThemeRequest];
    }
    else if (buttonState == OrderDetailButtonStateDisabled)
    {
        NSLog(@"预约其他行家");
        AllClassViewController *nextCtr = [[AllClassViewController alloc] init];
        nextCtr.classState = AllClassStateNormal;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if (buttonState == OrderDetailButtonStatePostComment)
    {
        NSLog(@"评价订单");
        [self commentThemeOrderRequest];
    }
}

- (void)confimButtonEvent:(OrderDetailButtonState)buttonState {
    
    if (buttonState == OrderDetailButtonStateNormal)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            NSLog(@"行家确认预约");
            [self appointmentExpThemeRequest];
        }
        else
        {
            NSLog(@"学员确认预约");
            if ([[Config currentConfig].isMessage isEqualToString:@"YES"]) {
                [self showAlertWithString:@"您已选择私信协商确定"];
                return;
            }
            [self appointmentThemeRequest];
        }
    }
    else if (buttonState == OrderDetailButtonStateServiceCompleted)
    {
        if (self.detailType == QuestionDetailTypeExpert)
        {
            NSLog(@"行家确认完成");
            [self expConfimThemeRequest];
        }
        else
        {
            NSLog(@"学员确认完成");
            [self userConfimThemeRequest];
        }
    }
    else if (buttonState == OrderDetailButtonStateAccount)
    {
        NSLog(@"去TA的主页");
        AccountViewController *nextCtr = [[AccountViewController alloc] init];
        
        if ([self.orderStatus intValue] == 4) {
            nextCtr.userUid = self.detailModel.StudentuserUid;
        }
        else {
            nextCtr.userUid = self.detailModel.userUid;
        }
        
        nextCtr.accountState = AccountStateOther;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}

#pragma mark 界面布局
- (void)createSubViews {
    
    WeakSelf;
    [Config currentConfig].isMessage = @"NO";
    [Config currentConfig].comment = nil;
    [LBForProject currentProject].detailCellTitleArray = nil;
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = kBackgroundColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.groupTableView];
    
    self.detailButton.reserveOtherButtonBlock = ^(OrderDetailButtonState buttonState) {
        [weakSelf orderButtonEvent:buttonState];
    };
    self.detailButton.messageButtonBlock = ^{
        [weakSelf messageEvent];
    };
    self.detailButton.confimButtonBlock = ^(OrderDetailButtonState buttonState) {
        [weakSelf confimButtonEvent:buttonState];
    };
    self.scoreView.scoreButtonBlock = ^{
        weakSelf.groupTableView.height = kDeviceHeight-kNavBarHeight-kCurrentWidth(114)-kViewHeight;
    };
    [self.view addSubview:self.scoreView];
    [self.view addSubview:self.detailButton];
}

- (OrderDetailButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [[OrderDetailButton alloc] initWithFrame:CGRectMake(0, kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight, kDeviceWidth, kCurrentWidth(49))];
    }
    return _detailButton;
}

- (PostScoreView *)scoreView {
    if (!_scoreView) {
        _scoreView = [[PostScoreView alloc] init];
        _scoreView.hidden = YES;
    }
    return _scoreView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
