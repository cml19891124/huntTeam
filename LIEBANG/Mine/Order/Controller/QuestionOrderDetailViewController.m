//
//  QuestionOrderDetailViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/1.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "QuestionOrderDetailViewController.h"
#import "PostMAnswerViewController.h"
#import "PostQuestionViewController.h"
#import "QuestionDetailViewController.h"
#import "AnswerDetailView.h"
#import "OrderService.h"
#import "QuestionService.h"
#import "QuestionTitleCell.h"
#import "QuestionPersonCell.h"
#import "QuestionStateCell.h"
#import "QuestionOrderDetailModel.h"
#import "OrderDetailButton.h"
#import "PostScoreView.h"
#import "HomeQuestionCell.h"

#import "ExpertListViewController.h"

#import "OrderListViewController.h"

@interface QuestionOrderDetailViewController ()

@property (nonatomic,strong)QuestionStateCell *statusCell;
@property (nonatomic,strong)QuestionOrderDetailModel *detailModel;
@property (nonatomic,strong)OrderDetailButton *detailButton;
@property (nonatomic,strong)PostScoreView *scoreView;
@property (nonatomic,assign)BOOL isShowAllTitle;
@property (nonatomic,strong)UILabel *headLabel;
@property (nonatomic,strong)CommentPickView *pickview;
@property (nonatomic,strong)NSString *titleString;
@end

@implementation QuestionOrderDetailViewController

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
    
    [self.view addSubview:self.scoreView];
    [self.view addSubview:self.detailButton];
    [self displayOverFlowActivityView];
    [self loadQuestionOrderDetailDataSource];
    
    WeakSelf;
    self.detailButton.reserveOtherButtonBlock = ^(OrderDetailButtonState buttonState) {
        [weakSelf orderButtonEvent:buttonState];
    };
    self.scoreView.scoreButtonBlock = ^{
        weakSelf.groupTableView.height = kDeviceHeight-kNavBarHeight-kCurrentWidth(114)-kViewHeight;
    };
    self.statusCell.messageButtonBlock = ^{
        [weakSelf postQuestionClick];
    };
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadQuestionOrderDetailDataSource];
    }];
}
#pragma mark - 返回时要重新请求数据，防止模型数据为空，导致操作区以外的section无数据操作区占据整个tableview，以及 点击 展开查看 和 收起全部 时会闪退的问题
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadQuestionOrderDetailDataSource];

}

- (void)backNavItemTapped {
    if (self.isPay) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
        if (self.navigationController.childViewControllers.count >= 2) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[AccountViewController class]]) {
                    AccountViewController *messageVC =(AccountViewController *)controller;
                    [self.navigationController popToViewController:messageVC animated:YES];
                }else if ([controller isKindOfClass:[ExpertListViewController class]]){
                    ExpertListViewController *messageVC =(ExpertListViewController *)controller;
                    [self.navigationController popToViewController:messageVC animated:YES];
                }else if ([controller isKindOfClass:[OrderListViewController class]]){
                    OrderListViewController *messageVC =(OrderListViewController *)controller;
                    [self.navigationController popToViewController:messageVC animated:YES];
                }
//                else{
//                    [self.navigationController popViewControllerAnimated:YES];
//
//                }
            }
                
        }else{
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
    else {
        [super backNavItemTapped];
    }
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [LBForProject currentProject].detailCellTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *cellNameStr;
    if (!IsArrEmpty([LBForProject currentProject].detailCellTitleArray)) {
        cellNameStr = [[LBForProject currentProject].detailCellTitleArray safeObjectAtIndex:section];
    }
    
    if ([cellNameStr isEqualToString:@"HomeQuestionCell"])
    {
        return self.detailModel.recommendedQuestion.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    NSString *cellNameStr;
    if (!IsArrEmpty([LBForProject currentProject].detailCellTitleArray)) {
        cellNameStr = [[LBForProject currentProject].detailCellTitleArray safeObjectAtIndex:indexPath.section];
    }
    
    if ([cellNameStr isEqualToString:@"QuestionTitleCell"]) {
        static NSString *cellStr = @"QuestionTitleCell";
        QuestionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[QuestionTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.isShowAllTitle = self.isShowAllTitle;
        cell.detailModel = self.detailModel;
        cell.questionButtonBlock = ^(BOOL isShowAllTitle) {
            weakSelf.isShowAllTitle = isShowAllTitle;

            [weakSelf loadQuestionOrderDetailDataSource];
        };
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"QuestionPersonCell"])
    {
        static NSString *cellStr = @"QuestionPersonCell";
        QuestionPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[QuestionPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.detailType = self.detailType;
        cell.detailModel = self.detailModel;
        cell.questionButtonBlock = ^{
            [weakSelf postButtonClick];
        };
        cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"AnswerDetailView"])
    {
        static NSString *cellStr = @"AnswerDetailView";
        AnswerDetailView *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[AnswerDetailView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.detailModel = self.detailModel;
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"HomeQuestionCell"])
    {
        RecommendQuestionModel *model = [self.detailModel.recommendedQuestion safeObjectAtIndex:indexPath.row];
        static NSString *cellStr = @"HomeQuestionCell";
        HomeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[HomeQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.questionCellState = HomeQuestionCellNormal;
        cell.recommendModel = model;
        cell.accountButtonBlock = ^{
            AccountViewController *nextCtr = [[AccountViewController alloc] init];
            nextCtr.userUid = model.answerUserUid;
            if ([model.answerUserUid isEqualToString:[Config currentConfig].userUid]) {
                nextCtr.accountState = AccountStateNormal;
            }
            else {
                nextCtr.accountState = AccountStateOther;
            }
            [self.navigationController pushViewController:nextCtr animated:YES];
        };
        cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellNameStr;
    if (!IsArrEmpty([LBForProject currentProject].detailCellTitleArray)) {
        cellNameStr = [[LBForProject currentProject].detailCellTitleArray safeObjectAtIndex:indexPath.section];
    }
    
    if ([cellNameStr isEqualToString:@"QuestionTitleCell"])
    {
        QuestionTitleCell *cell = (QuestionTitleCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    else if ([cellNameStr isEqualToString:@"QuestionPersonCell"])
    {
        return kCurrentWidth(70);
    }
    else if ([cellNameStr isEqualToString:@"AnswerDetailView"])
    {
        AnswerDetailView *cell = (AnswerDetailView *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return cell.viewHeight;
    }
    else if ([cellNameStr isEqualToString:@"HomeQuestionCell"])
    {
        HomeQuestionCell *cell = (HomeQuestionCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return [cell getHeight];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSString *cellNameStr;
    if (!IsArrEmpty([LBForProject currentProject].detailCellTitleArray)) {
        cellNameStr = [[LBForProject currentProject].detailCellTitleArray safeObjectAtIndex:section];
    }
    
    if ([cellNameStr isEqualToString:@"HomeQuestionCell"])
    {
        return 53.f;
    }
    else if ([cellNameStr isEqualToString:@"AnswerDetailView"])
    {
        return 0.000000001f;
    }
    else if ([cellNameStr isEqualToString:@"QuestionTitleCell"])
    {
        return 5.f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *cellNameStr;
    if (!IsArrEmpty([LBForProject currentProject].detailCellTitleArray)) {
        cellNameStr = [[LBForProject currentProject].detailCellTitleArray safeObjectAtIndex:section];
    }
    
    if ([cellNameStr isEqualToString:@"HomeQuestionCell"])
    {
        if ([self.orderStatus intValue] != 4) {
            if ([self.detailModel.orderStates intValue] == 2 || [self.detailModel.orderStates intValue] == 3 || [self.detailModel.orderStates intValue] == 4) {
                    _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 53)];
                    _headLabel.backgroundColor = kWhiteColor;
                    _headLabel.textColor = kLBBlackColor;
                    _headLabel.font = kSystemBold(14);
                    _headLabel.text = self.titleString;
                    _headLabel.textAlignment = NSTextAlignmentCenter;
                    return _headLabel;
            }
        }
    }
    else if ([cellNameStr isEqualToString:@"QuestionPersonCell"])
    {
        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
        head.backgroundColor = kBackgroundColor;
        return head;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *cellNameStr;
    if (!IsArrEmpty([LBForProject currentProject].detailCellTitleArray)) {
        cellNameStr = [[LBForProject currentProject].detailCellTitleArray safeObjectAtIndex:indexPath.section];
    }
    
    if ([cellNameStr isEqualToString:@"QuestionPersonCell"]) {
        AccountViewController *nextCtr = [[AccountViewController alloc] init];
        nextCtr.userUid = self.detailModel.userUid;
        nextCtr.accountState = AccountStateOther;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if ([cellNameStr isEqualToString:@"HomeQuestionCell"])
    {
        RecommendQuestionModel *model = [self.detailModel.recommendedQuestion safeObjectAtIndex:indexPath.row];
        QuestionDetailViewController *nextCtr = [[QuestionDetailViewController alloc] init];
        nextCtr.detailType = QuestionDetailTypeVisitor;
        nextCtr.questionUid = model.id;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}

#pragma mark 数据源
- (void)loadQuestionOrderDetailDataSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.orderUid forKey:@"id"];
    [postDic setValue:self.orderStatus forKey:@"type"];
    
    NSLog(@"问答详情 == %@",postDic);
    
    [OrderService getQuestionOrderDetailWithParameters:postDic success:^(QuestionOrderDetailModel *info) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_header endRefreshing];
        self.detailModel = info;
        [LBForProject decodeQuestionDetailCellTitle:info detailType:self.detailType];
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_header endRefreshing];
        [self presentSheet:errorStr];
    }];
}

- (void)setDetailModel:(QuestionOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
    if (detailModel.recommendedQuestion.count == 0) {
        self.titleString = @"暂无相关问答";
    }
    else {
        self.titleString = @"相关问答";
    }
    
    if ([detailModel.orderStates intValue] == 1 || [detailModel.orderStates intValue] == 6 || [detailModel.orderStates intValue] == 7 || [detailModel.orderStates intValue] == 5 || [detailModel.orderStates intValue] == 8) {
        self.groupTableView.tableFooterView = self.statusCell;
        self.statusCell.detailModel = detailModel;
        self.detailButton.hidden = YES;
        self.scoreView.hidden = YES;
        
        if (self.detailType == QuestionDetailTypeExpert && [detailModel.orderStates intValue] == 1) {
            NSString *string = [InsureValidate timestamp:detailModel.endTime];
            if (![string containsString:@"-"])
            {
                [self setRightNaviBtnTitle:@"无法回答/忽略"];
                [self.rightNaviBtn addTarget:self action:@selector(postCancelQuetionOrderRequest) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else
        {
            [self setRightNaviBtnTitle:@""];
        }
    }
    else if ([detailModel.orderStates intValue] == 2 || [detailModel.orderStates intValue] == 3 || [detailModel.orderStates intValue] == 4) {
        self.groupTableView.tableFooterView = [UIView new];
        [self setRightNaviBtnImage:[UIImage imageNamed:@"nav_button_share.png"]];
        [self.rightNaviBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
        self.detailButton.hidden = YES;
        self.scoreView.hidden = YES;
        
        if ([detailModel.orderStates intValue] == 2 && self.detailType == QuestionDetailTypeStudent) {
            self.detailButton.hidden = NO;
            self.scoreView.hidden = NO;
            self.detailButton.buttonState = OrderDetailButtonStatePostComment;
            self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight-kCurrentWidth(98));
        }
    }
    else
    {
        self.groupTableView.tableFooterView = [UIView new];
        self.scoreView.hidden = YES;
        self.detailButton.hidden = YES;
        [self setRightNaviBtnTitle:@""];
    }
}

- (void)shareClick {
    
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
                                     withPlatformIcon:[UIImage imageNamed:@"bar_button_haoyou"]
                                     withPlatformName:@"猎帮好友"];
    
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+3
                                     withPlatformIcon:[UIImage imageNamed:@"bar_button_link"]
                                     withPlatformName:@"获取链接"];
    
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_WechatSession
                                     withPlatformIcon:[UIImage imageNamed:@"bar_button_weixinhaoyou"]
                                     withPlatformName:@"微信好友"];
    
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_WechatTimeLine
                                     withPlatformIcon:[UIImage imageNamed:@"bar_button_pengyouquan"]
                                     withPlatformName:@"微信朋友圈"];
    
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_QQ
                                     withPlatformIcon:[UIImage imageNamed:@"bar_button_qq"]
                                     withPlatformName:@"QQ好友"];
    
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_Sina
                                     withPlatformIcon:[UIImage imageNamed:@"bar_button_xinlangweibo"]
                                     withPlatformName:@"新浪微博"];
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_UserDefine_Begin+2),
                                               @(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
//                                               @(UMSocialPlatformType_QQ),
//                                               @(UMSocialPlatformType_Sina),
                                               @(UMSocialPlatformType_UserDefine_Begin+3),
                                               ]];
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewTitleString = @"分享到";
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewFont = kSystem(14);
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.shareCancelControlText = @"取消";
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageMaxRowCountForPortraitAndBottom = 4;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndBottom = 4;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
    }];
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    NSString *url = [NSString stringWithFormat:@"http://liebangapp.com/share/#/question?id=%@&startLevel=%@&userUid=%@",self.detailModel.QuestionFormMapUid,self.detailModel.startLevel,[Config currentConfig].userUid];
    if (platformType == UMSocialPlatformType_UserDefine_Begin+2)
    {
        MyFriendViewController *nextCtr = [[MyFriendViewController alloc] init];
        WMContent *videoMessage = [WMContent messageWithContent:self.detailModel.quizcontent detailUid:self.detailModel.QuestionFormMapUid detailType:@"1" shareUid:self.detailModel.userUid];
        nextCtr.shareMessage = videoMessage;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if (platformType == UMSocialPlatformType_UserDefine_Begin+3)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = url;
        [self presentSheet:@"已获取到链接，请粘贴使用"];
    }
    else
    {
        [self shareWebPageToPlatformType:platformType withTitle:self.detailModel.quizcontent descr:@"点击查看更多内容" url:url thumb:@""];
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withTitle:(NSString *)title descr:(NSString *)descr url:(NSString *)url thumb:(id)thumb
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:[UIImage imageNamed:@"icon-60"]];
    shareObject.webpageUrl = url;
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [self presentSheet:@"分享失败"];
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

#pragma mark Event
- (void)orderButtonEvent:(OrderDetailButtonState)buttonState {
    
    [self commentThemeOrderRequest];
}

- (void)postButtonClick {
    WeakSelf;
    if (self.detailType == QuestionDetailTypeExpert) {
        PostMAnswerViewController *nextCtr = [[PostMAnswerViewController alloc] init];
        nextCtr.detailModel = self.detailModel;
        nextCtr.refrshDataSourceBlock = ^{
            [weakSelf displayOverFlowActivityView];
            [weakSelf loadQuestionOrderDetailDataSource];
        };
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else {
        
        if ([self.detailModel.isBasic intValue] != 1 || [self.detailModel.isEducation intValue] != 1 || [self.detailModel.isOccupation intValue] != 1) {
            [self showAlertWithString:@"TA还不是行家"];
            return;
        }
        
        if ([self.detailModel.userUid isEqualToString:[Config currentConfig].userUid]) {
            [self showAlertWithString:@"不能向自己提问"];
            return;
        }
        
        PostQuestionViewController *nextCtr = [[PostQuestionViewController alloc] init];
        [Config currentConfig].answerid = self.detailModel.userUid;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}

//忽略问题
- (void)postCancelQuetionOrderRequest {
    
    UIAlertController *alert = [CHAlertView showMessageWith:@"确定" title:@"忽略该问题" confim:^{
        [self displayOverFlowActivityView];
        [OrderService getCancelQuestionWithParameters:self.orderUid success:^(NSString *info) {
            [self removeOverFlowActivityView];
            [self presentSheet:@"忽略成功"];
            [self performBlock:^{
                [self backNavItemTapped];
            } afterDelay:1.5];
//            [self loadQuestionOrderDetailDataSource];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

//评价问答订单
- (void)commentThemeOrderRequest {
    
    if (self.scoreView.starNumber == 0) {
        [self showAlertWithString:@"请评个分儿吧!"];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.orderUid forKey:@"id"];
    [postDic setValue:[NSNumber numberWithInteger:self.scoreView.starNumber] forKey:@"score"];
    
    NSLog(@"评价问答订单postDic = %@",postDic);
    
    [self displayOverFlowActivityView];
    [OrderService getPostOrderCommentWithParameters:postDic success:^(NSString *success) {
        [self removeOverFlowActivityView];
        
        self.pickview = [[CommentPickView alloc] init];
        self.pickview.starNumber = self.scoreView.starNumber;
        [self.view addSubview:self.pickview];
        self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
        [self performBlock:^{
            [self backNavItemTapped];
        } afterDelay:1.5];
//        [self loadQuestionOrderDetailDataSource];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.pickview closeButtonClick];
}

- (void)postQuestionClick {
    
    PostQuestionViewController *nextCtr = [[PostQuestionViewController alloc] init];
    [Config currentConfig].answerid = nil;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

#pragma mark UI
- (QuestionStateCell *)statusCell {
    if (!_statusCell) {
        _statusCell = [[QuestionStateCell alloc] init];
        _statusCell.detailType = self.detailType;
    }
    return _statusCell;
}

- (OrderDetailButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [[OrderDetailButton alloc] initWithFrame:CGRectMake(0, kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight, kDeviceWidth, kCurrentWidth(49))];
        _detailButton.hidden = YES;
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
