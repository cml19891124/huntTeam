//
//  QuestionDetailViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "PostQuestionViewController.h"
#import "PayViewController.h"
#import "OrderService.h"
#import "QuestionService.h"
#import "QuestionTitleCell.h"
#import "QuestionPersonCell.h"
#import "QuestionStateCell.h"
#import "QuestionDetailModel.h"
#import "AnswerDetailView.h"
#import "HomeQuestionCell.h"
#import "ShareModel.h"
#import "QuestionScoreView.h"

#import "QuestionRalationPersonInfoCell.h"

@interface QuestionDetailViewController ()<UMSocialShareMenuViewDelegate>

@property (nonatomic,strong)QuestionDetailModel *detailModel;

@property (nonatomic,strong)UILabel *headLabel;

@property (nonatomic,strong)NSString *titleString;

@property (nonatomic,strong)QuestionScoreView *scoreView;

@property (nonatomic,assign)BOOL isShowAllTitle;

@property (nonatomic,strong)CommentPickView *pickview;

@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"问答详情";
    self.view.backgroundColor = kBackgroundColor;
    self.titleString = @"相关问答";
    
    [self setRightNaviBtnImage:[UIImage imageNamed:@"nav_button_share.png"]];
    [self.rightNaviBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    [self.view addSubview:self.scoreView];
    
    [self displayOverFlowActivityView];
    [self loadQuestionDetailRequest];
    
    WeakSelf;
    self.scoreView.scoreButtonBlock = ^{
        weakSelf.groupTableView.height = kDeviceHeight-kNavBarHeight-kCurrentWidth(114)-kViewHeight;
    };
    self.scoreView.commentButtonBlock = ^{
        [weakSelf commentThemeOrderRequest];
    };
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
    NSString *url;
    if ([self.detailModel.chargeState intValue] == 1) {
        url = [NSString stringWithFormat:@"http://liebangapp.com/share/#/payknow?id=%@&startLevel=%@&userUid=%@",self.detailModel.id,self.detailModel.startLevel,[Config currentConfig].userUid];
    }
    else {
        url = [NSString stringWithFormat:@"http://liebangapp.com/share/#/question?id=%@&startLevel=%@&userUid=%@",self.detailModel.id,self.detailModel.startLevel,[Config currentConfig].userUid];
    }
    
    if (platformType == UMSocialPlatformType_UserDefine_Begin+2)
    {
        MyFriendViewController *nextCtr = [[MyFriendViewController alloc] init];
        WMContent *videoMessage = [WMContent messageWithContent:self.detailModel.quizcontent detailUid:self.detailModel.id detailType:@"1" shareUid:self.detailModel.userUid];
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

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 3) {
        return self.detailModel.question.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    if (indexPath.section == 0)
    {
        static NSString *cellStr = @"QuestionTitleCell";
        QuestionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[QuestionTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.isShowNum = YES;
        cell.isShowAllTitle = self.isShowAllTitle;
        cell.model = self.detailModel;
        cell.questionButtonBlock = ^(BOOL isShowAllTitle) {
            weakSelf.isShowAllTitle = isShowAllTitle;
            [weakSelf.groupTableView reloadData];
        };
        return cell;
    }
    else if (indexPath.section == 1)
    {
        static NSString *cellStr = @"QuestionRalationPersonInfoCell";
        QuestionRalationPersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[QuestionRalationPersonInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.detailType = self.detailType;
        cell.model = self.detailModel;
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
    else if (indexPath.section == 2)
    {
        static NSString *cellStr = @"AnswerDetailView";
        AnswerDetailView *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[AnswerDetailView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.isMy = self.isMy;
        cell.model = self.detailModel;
        cell.onePayBlock = ^{
            [weakSelf payOneYuanEvent];
        };
        return cell;
    }
    else
    {
        RecommendQuestionModel *model = [self.detailModel.question safeObjectAtIndex:indexPath.row];
        static NSString *cellStr = @"HomeQuestionCell";
        HomeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[HomeQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.questionCellState = HomeQuestionCellNormal;
        cell.recommendModel = model;
        cell.accountButtonBlock = ^{
            [weakSelf gotoAccountViewController:nil userUid:model.answerUserUid];
        };
        cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0)
    {
        QuestionTitleCell *cell = (QuestionTitleCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    else if (indexPath.section == 1)
    {
        return kCurrentWidth(70);
    }
    else if (indexPath.section == 2)
    {
        AnswerDetailView *cell = (AnswerDetailView *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return cell.viewHeight;
    }
    else
    {
        HomeQuestionCell *cell = (HomeQuestionCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return [cell getHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 53.f;
    }
    else if (section == 2) {
        return 0.00000001f;
    }
    else if (section == 0) {
        return 5.f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 3) {
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 53)];
        _headLabel.backgroundColor = kWhiteColor;
        _headLabel.textColor = kLBBlackColor;
        _headLabel.font = kSystemBold(14);
        _headLabel.text = self.titleString;
        _headLabel.textAlignment = NSTextAlignmentCenter;
        return _headLabel;
    }
    else if (section == 0)
    {
        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
        head.backgroundColor = kWhiteColor;
        return head;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 1:
        {
            AccountViewController *nextCtr = [[AccountViewController alloc] init];
            nextCtr.userUid = self.detailModel.userUid;
            nextCtr.accountState = AccountStateOther;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        case 3:
        {
            RecommendQuestionModel *model = [self.detailModel.question safeObjectAtIndex:indexPath.row];
            QuestionDetailViewController *nextCtr = [[QuestionDetailViewController alloc] init];
            nextCtr.detailType = QuestionDetailTypeVisitor;
            nextCtr.questionUid = model.id;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark Event
- (void)loadQuestionDetailRequest {
    
    [QuestionService getQuestionDetailWithParameters:self.questionUid success:^(QuestionDetailModel *info) {
        [self removeOverFlowActivityView];
        self.detailModel = info;
        self.orderUid = info.orderId;
        
        if (self.detailModel.question.count == 0) {
            self.titleString = @"暂无相关问答";
        }
        else {
            self.titleString = @"相关问答";
        }
        
        if ([self.detailModel.chargeState intValue] == 0)
        {
            if ([self.detailModel.orderStates intValue] == 3 || [[Config currentConfig].userUid isEqualToString:info.userUid]) {
                self.scoreView.hidden = YES;
                self.groupTableView.height = kDeviceHeight-kNavBarHeight-kViewHeight;
            }
            else {
                self.scoreView.hidden = NO;
                self.groupTableView.height = kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight;
            }
        }
        else
        {
            if ([self.detailModel.orderStates intValue] != 3 && [self.detailModel.isBuy intValue] == 1) {
                self.scoreView.hidden = NO;
                self.groupTableView.height = kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight;
            }
            else {
                self.scoreView.hidden = YES;
                self.groupTableView.height = kDeviceHeight-kNavBarHeight-kViewHeight;
            }
        }
        
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)postButtonClick {
    
    if (self.detailType == QuestionDetailTypeExpert) {
        
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

/*
 限时免费id传questionUid，一元查看传orderUid
 
 orderStates = 3 已评价
 */
//评价问答订单
- (void)commentThemeOrderRequest {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:[NSNumber numberWithInteger:self.scoreView.starNumber] forKey:@"score"];
    [postDic setValue:self.detailModel.chargeState forKey:@"chargeState"];
    [postDic setValue:self.questionUid forKey:@"questionId"];
    NSLog(@"评价问答订单postDic = %@",postDic);
    
    [self displayOverFlowActivityView];
    [OrderService getPostQuestionCommentWithParameters:postDic success:^(NSString *success) {
        [self removeOverFlowActivityView];
        
        self.pickview = [[CommentPickView alloc] init];
        self.pickview.starNumber = self.scoreView.starNumber;
        [self.view addSubview:self.pickview];
        
        [self loadQuestionDetailRequest];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.pickview closeButtonClick];
}

- (void)payOneYuanEvent {
    WeakSelf;
    [QuestionService getUserClassifyWithParameters:self.detailModel.userUid success:^(NSString *info) {
        PayViewController *nextCtr = [[PayViewController alloc] init];
        nextCtr.serviceType = @"1猎帮币查看";
        nextCtr.questionUid = self.detailModel.id;
        nextCtr.questionPri = @"1";
        nextCtr.classifyId = info;
        nextCtr.isOne = YES;
        nextCtr.onePayResultBlock = ^(NSString *orderUid) {
            weakSelf.detailModel.isBuy = @"1";
            weakSelf.scoreView.hidden = NO;
            weakSelf.orderUid = orderUid;
            weakSelf.groupTableView.height = kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight;
            [weakSelf.groupTableView reloadData];
        };
        [self.navigationController pushViewController:nextCtr animated:YES];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

//未登陆状态
- (BOOL)gotoLoginViewController {
    LoginModel *account = [SDUserTool account];

    if (IsNilOrNull(account.rongCloudToken) || IsStrEmpty(account.rongCloudToken)) {
        LoginViewController *nextCtr = [[LoginViewController alloc] init];
        CommonNavgationViewController *nextNav = [[CommonNavgationViewController alloc] initWithRootViewController:nextCtr];
        [self.navigationController presentViewController:nextNav animated:YES completion:^{
            
        }];
//        UIAlertController *alert = [CHAlertView showMessageWith:@"去登陆" title:@"您还没有登陆" confim:^{
//            LoginViewController *nextCtr = [[LoginViewController alloc] init];
//            CommonNavgationViewController *nextNav = [[CommonNavgationViewController alloc] initWithRootViewController:nextCtr];
//            [self.navigationController presentViewController:nextNav animated:YES completion:^{
//
//            }];
//        }];
//        [self presentViewController:alert animated:YES completion:nil];
        return YES;
    } else {
        return NO;
    }
}

//查看资料权限
- (void)gotoAccountViewController:(NSString *)dataPrivacyType userUid:(NSString *)userUid {
    
    if ([self gotoLoginViewController]) return;

    AccountViewController *nextCtr = [[AccountViewController alloc] init];
    if ([[Config currentConfig].userUid isEqualToString:userUid]) {
        nextCtr.accountState = AccountStateNormal;
    }
    else {
        nextCtr.accountState = AccountStateOther;
    }
    nextCtr.userUid = userUid;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (QuestionScoreView *)scoreView {
    if (!_scoreView) {
        _scoreView = [[QuestionScoreView alloc] init];
        _scoreView.hidden = YES;
    }
    return _scoreView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
