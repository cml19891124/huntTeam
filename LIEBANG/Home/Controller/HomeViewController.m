//
//  HomeViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/6/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "HomeViewController.h"
#import "CouponViewController.h"
#import "AllClassViewController.h"
#import "ClassListViewController.h"
#import "QuestionDetailViewController.h"
#import "PostQuestionViewController.h"
#import "ThemeDetailViewController.h"
#import "SearchViewController.h"
#import "InterestFriendViewController.h"
#import "CompanyDetailViewController.h"
#import "SearchCompanyViewController.h"
#import "HelpViewController.h"
#import "HomeHeadView.h"
#import "HomeThemeHeadView.h"
#import "HomeQuestionHeadView.h"
#import "HomeFootView.h"
#import "HomeMeetCell.h"
#import "HomeQuestionCell.h"
#import "HomeService.h"
#import "HomeModel.h"
#import "QuestionClassModel.h"
#import "ThemeClassModel.h"

@interface HomeViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)HomeHeadView *homeView;
@property (nonatomic,strong)HomeFootView *footView;
@property (nonatomic,strong)HomeModel *homeModel;
@property (nonatomic,strong)AllClassModel *allClassModel;

@property (nonatomic,assign)NSInteger classifyIndex;
@property (nonatomic,assign)NSInteger classify2Index;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadAllClassDataSource];
        [self loadHomeDataSource];
    });
    
    [self createHomeSubView];
//    [self displayOverFlowActivityView];
    
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadAllClassDataSource];
            [self loadHomeDataSource];
        });
    }];
}

#pragma mark DataSource
- (void)loadHomeDataSource {

    [HomeService getHomeWithParameters:nil success:^(HomeModel *model) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];

        self.homeModel = model;
        self.homeView.model = model;
        
        [self.groupTableView setTableHeaderView:self->_homeView];
        
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        [self presentSheet:errorStr];
    }];
}

- (void)loadAllClassDataSource {
    
    [HomeService getAllClassWithParameters:nil success:^(AllClassModel *model) {
        self.allClassModel = model;
        
        for (ClassModel *model in self.allClassModel.data) {
            ClassifyTwoModel *dto = [[ClassifyTwoModel alloc] init];
            dto.id = nil;
            dto.classify = @"全部";
            ClassifyTwoModel *model1 = [model.classifyTwo safeObjectAtIndex:0];
            if (![model1.classify isEqualToString:@"全部"]) {
                [model.classifyTwo insertObject:dto atIndex:0];
            }
        }
        
    } failure:^(NSUInteger code, NSString *errorStr) {
//        [self loadAllClassDataSource];
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return self.homeModel.question.count;
    }
    else
    {
        return self.homeModel.topic.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    switch (indexPath.section) {
        case 0:
        {
            QuestionClassModel *model = [self.homeModel.question safeObjectAtIndex:indexPath.row];
            static NSString *cellStr = @"HomeQuestionCell";
            HomeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[HomeQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            cell.questionCellState = HomeQuestionCellNormal;
            cell.questionClassModel = model;
            cell.accountButtonBlock = ^{
                [weakSelf gotoAccountViewController:model.dataPrivacyType userUid:model.userUid];
            };
            cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
                [weakSelf pushToMosaicVC:imageUrl];
            };
            cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
                [weakSelf pushToMosaicVC:imageUrl];
            };
            return cell;
        }
            break;
        default:
        {
            ThemeClassModel *model = [self.homeModel.topic safeObjectAtIndex:indexPath.row];
            static NSString *cellStr = @"HomeMeetCell";
            HomeMeetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[HomeMeetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            cell.homeMeetCellState = HomeMeetCellStateHome;
            cell.themeClassModel = model;
            cell.accountButtonBlock = ^{
                LoginModel *account = [SDUserTool account];
                if ([model.userUid isEqualToString:account.userUid]) {
                    AccountViewController *nextCtr = [[AccountViewController alloc] init];
                    nextCtr.accountState = AccountStateNormal;
                    nextCtr.userUid = [Config currentConfig].userUid;
                    [self.navigationController pushViewController:nextCtr animated:YES];
                }else{
                    [weakSelf gotoAccountViewController:model.dataPrivacyType userUid:model.userUid];

                }
            };
            cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
                [weakSelf pushToMosaicVC:imageUrl];
            };
            cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
                [weakSelf pushToMosaicVC:imageUrl];
            };
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            HomeQuestionCell *cell = (HomeQuestionCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
            return [cell getHeight];
        }
        default:
        {
            HomeMeetCell *cell = (HomeMeetCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
            return cell.cellHeight;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WeakSelf;
    switch (section) {
        case 0:
        {
            CGFloat questionHeight = 0.f;
            if (self.homeModel.enterprise.count > 4) {
                questionHeight = kCurrentWidth(350);
            }
            else if (IsArrEmpty(self.homeModel.enterprise)) {
                questionHeight = kCurrentWidth(350)-kCurrentWidth(194);
            }
            else {
                questionHeight = kCurrentWidth(350)-kCurrentWidth(70);
            }
            HomeQuestionHeadView *questionView = [[HomeQuestionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, questionHeight)];
            questionView.model = self.homeModel;
            questionView.questionButtonBlock = ^{
                [weakSelf gotoPostQuestionCtrl];
            };
            questionView.companyBlock = ^(NSString *companyUid, BOOL isSelf) {
                if ([weakSelf gotoLoginViewController]) return;
                if (IsStrEmpty(companyUid) || IsNilOrNull(companyUid)) {
                    return ;
                }
                CompanyDetailViewController *nextCtr = [[CompanyDetailViewController alloc] init];
                nextCtr.companyUid = companyUid;
                if (isSelf) {
                    nextCtr.companyType = @"0";
                    nextCtr.isSelf = YES;
                }
                else {
                    nextCtr.companyType = @"1";
                    nextCtr.isSelf = NO;

                }
                [self.navigationController pushViewController:nextCtr animated:YES];
            };
            questionView.companyMoreBlock = ^{
                if ([weakSelf gotoLoginViewController]) return;
                SearchCompanyViewController *nextCtr = [[SearchCompanyViewController alloc] init];
                [self.navigationController pushViewController:nextCtr animated:YES];
            };
            questionView.meetButtonBlock = ^{
                if ([weakSelf gotoLoginViewController]) return;
                AllClassViewController *nextCtr = [[AllClassViewController alloc] init];
                nextCtr.classState = AllClassStateNormal;
                [weakSelf.navigationController pushViewController:nextCtr animated:YES];
            };
            questionView.moreQuestionButtonBlock = ^{
//                [weakSelf gotoMeetListCtrl];
                if ([weakSelf gotoLoginViewController]) return;
                AllClassViewController *nextCtr = [[AllClassViewController alloc] init];
                nextCtr.isQuestion = YES;
                nextCtr.classState = AllClassStateNormal;
                [weakSelf.navigationController pushViewController:nextCtr animated:YES];
            };
            return questionView;
        }
        case 1:
        {
            {//推荐话题的headview 里面是轮播图 和 点击事件
                HomeThemeHeadView *themeView = [[HomeThemeHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(239))];
                themeView.model = self.homeModel;
                themeView.bannerBlock = ^(NSInteger buttonIndex) {
                    [weakSelf scrollViewTwoImageClick:buttonIndex];
                };
                return themeView;
            }
        }
            break;
        default:
            return UIView.new;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            if (self.homeModel.enterprise.count > 4) {
                return kCurrentWidth(350)+kCurrentWidth(10);
            }
            else if (IsArrEmpty(self.homeModel.enterprise)) {
                return kCurrentWidth(350)-kCurrentWidth(194)+kCurrentWidth(10);
            }
            else {
                return kCurrentWidth(350)-kCurrentWidth(70)+kCurrentWidth(10);
            }
        }
            
        default:
            return kCurrentWidth(239);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self gotoLoginViewController]) return;
    switch (indexPath.section) {
        case 0:
        {
            QuestionClassModel *model = [self.homeModel.question safeObjectAtIndex:indexPath.row];
            QuestionDetailViewController *nextCtr = [[QuestionDetailViewController alloc] init];
            nextCtr.detailType = QuestionDetailTypeVisitor;
            nextCtr.questionUid = model.id;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        default:
        {
            ThemeClassModel *model = [self.homeModel.topic safeObjectAtIndex:indexPath.row];
            ThemeDetailViewController *nextCtr = [[ThemeDetailViewController alloc] init];
            nextCtr.themeUid = model.id;
            if ([model.userUid isEqualToString:[Config currentConfig].userUid]) {
                nextCtr.detailState = ThemeDetailStateEdit;
            }
            else {
                nextCtr.detailState = ThemeDetailStateNormal;
            }
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
    }
}

#pragma mark Event
- (void)gotoMeetListCtrl {
    
    if ([self gotoLoginViewController]) return;
    if (self.homeModel.appClassify.count == 0) {
        [self showAlertWithString:@"您的网络开小差了"];
        [self loadAllClassDataSource];
        return;
    }
    
    ClassListViewController *nextCtr = [[ClassListViewController alloc] init];
    nextCtr.classModel = self.allClassModel;
    nextCtr.classifyIndex = 0;
    nextCtr.classify2Index = -1;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)gotoPostQuestionCtrl {
    if ([self gotoLoginViewController]) return;
    PostQuestionViewController *nextCtr = [[PostQuestionViewController alloc] init];
    [Config currentConfig].answerid = nil;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)gotoOtherEvent {
    
    if ([self gotoLoginViewController]) return;
    HelpViewController *helpCtr = [[HelpViewController alloc] init];
    helpCtr.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:helpCtr animated:NO completion:nil];
    helpCtr.questionButtonBlock = ^{
        [self gotoPostQuestionCtrl];
    };
    helpCtr.friendButtonBlock = ^{
        InterestFriendViewController *allCtr = [[InterestFriendViewController alloc] init];
        [self.navigationController pushViewController:allCtr animated:YES];
    };
}

- (void)homeButtonEvent:(NSInteger)index {
    
    if ([self gotoLoginViewController]) return;
    
    if (self.homeModel.appClassify.count == 0) {
        [self showAlertWithString:@"您的网络开小差了"];
        [self loadAllClassDataSource];
        return;
    }
    
    AppClassify *dto = [self.homeModel.appClassify safeObjectAtIndex:index];
    if ([dto.id isEqualToString:@"1"] && [dto.classify containsString:@"全部"]) {
        AllClassViewController *nextCtr = [[AllClassViewController alloc] init];
        nextCtr.classState = AllClassStateNormal;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else {
        for (ClassModel *modle in self.allClassModel.data)
        {
            if ([modle.id isEqualToString:dto.id]) {
                self.classifyIndex = [self.allClassModel.data indexOfObject:modle];
                for (ClassifyTwoModel *dto2 in modle.classifyTwo)
                {
                    if ([dto.id isEqualToString:dto2.id])
                    {
                        self.classify2Index = [modle.classifyTwo indexOfObject:dto2];
                    }
                }
            }
        }
        
        ClassListViewController *nextCtr = [[ClassListViewController alloc] init];
        nextCtr.classModel = self.allClassModel;
        nextCtr.classifyIndex = self.classifyIndex;
        nextCtr.classify2Index = self.classify2Index-1;
        nextCtr.isOpen = YES;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (void)searchTfClick {
    
    if ([self gotoLoginViewController]) return;
    
    SearchViewController *nextCtr = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:nextCtr animated:NO];
}

//点击滚动图片的回调
- (void)scrollViewImageClick:(NSInteger)currentIndex {
    
    if ([self gotoLoginViewController]) return;
    
    IndexBanner *model = [self.homeModel.indexBanner safeObjectAtIndex:currentIndex];
    
    if ([model.turnType intValue] == 0)
    {
        if (IsStrEmpty(model.turnUrl) || IsNilOrNull(model.turnUrl)) {
            return;
        }
        
        WebViewController *nextCtr = [[WebViewController alloc] init];
        nextCtr.contentString = model.turnUrl;
        nextCtr.navTitle = model.title;
        nextCtr.webViewType = WebViewTypeHTTP;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if ([model.turnType intValue] == 1)
    {
        if (IsStrEmpty(model.userUid) || IsNilOrNull(model.userUid)) {
            return;
        }
        
        [self gotoAccountViewController:nil userUid:model.userUid];
    }
}

#pragma mak - 点击推荐话题 轮播图 滚动图片的回调
- (void)scrollViewTwoImageClick:(NSInteger)currentIndex {
    
    if ([self gotoLoginViewController]) return;
    
    TopicBanner *model = [self.homeModel.topicBanner safeObjectAtIndex:currentIndex];
    
    if ([model.bannerType intValue] == 3 || [model.bannerType intValue] == 4) {//新人礼包链接事件，返回非原处
        CouponViewController *nextCtr = [[CouponViewController alloc] init];
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else {
        if ([model.turnType intValue] == 0)
        {//职场进阶链接事件，返回非原处
            if (IsStrEmpty(model.turnUrl) || IsNilOrNull(model.turnUrl)) {
                return;
            }
            
            WebViewController *nextCtr = [[WebViewController alloc] init];
            nextCtr.contentString = model.turnUrl;
            nextCtr.navTitle = model.title;
            nextCtr.webViewType = WebViewTypeHTTP;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else if ([model.turnType intValue] == 1)
        {//经理人进阶指南链接事件
            if (IsStrEmpty(model.userUid) || IsNilOrNull(model.userUid)) {
                return;
            }
            
            [self gotoAccountViewController:nil userUid:model.userUid];
        }
    }
}

//未登陆状态
- (BOOL)gotoLoginViewController {
    LoginModel *account = [SDUserTool account];
    if (IsNilOrNull(account.rongCloudToken) || IsStrEmpty(account.rongCloudToken)) {
//        UIAlertController *alert = [CHAlertView showMessageWith:@"去登陆" title:@"您还没有登陆" confim:^{
            LoginViewController *nextCtr = [[LoginViewController alloc] init];
        nextCtr.loginSueccssBlock = ^{
            [self loadHomeDataSource];
        };
            CommonNavgationViewController *nextNav = [[CommonNavgationViewController alloc] initWithRootViewController:nextCtr];
            [self.navigationController presentViewController:nextNav animated:YES completion:^{
                
            }];
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

#pragma mark 界面布局
- (void)createHomeSubView {
    
    WeakSelf;
    self.view.backgroundColor = kWhiteColor;
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, kDeviceWidth-kCurrentWidth(70), 30);
    [searchButton setTitle:@"搜索行家帮手、话题或问答" forState:UIControlStateNormal];
    [searchButton setTitleColor:kLBNineColor forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"nav_button_search"] forState:UIControlStateNormal];
    searchButton.layer.cornerRadius = 15;
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.borderColor = kSepparteLineColor.CGColor;
    searchButton.layer.borderWidth = 0.5;
    searchButton.titleLabel.font = kSystem(14);
    searchButton.backgroundColor = [UIColor colorWithHexString:@"FAFAFA"];
    searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(10), 0, 0);
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(15), 0, 0);
    [searchButton addTarget:self action:@selector(searchTfClick) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    self.navigationItem.leftBarButtonItem=rightButton;
    
    [self setRightNaviBtnImage:[UIImage imageNamed:@"nav_button_eidt"]];
    [self.rightNaviBtn addTarget:self action:@selector(gotoOtherEvent) forControlEvents:UIControlEventTouchUpInside];
    
    _homeView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(443))];
    _homeView.homeButtonBlock = ^(NSInteger buttonIndex) {
        [weakSelf homeButtonEvent:buttonIndex];
    };
    _homeView.bannerBlock = ^(NSInteger buttonIndex) {
        [weakSelf scrollViewImageClick:buttonIndex];
    };
    _footView = [[HomeFootView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(90))];
    _footView.allClassBlock = ^{
        if ([weakSelf gotoLoginViewController]) return;
        AllClassViewController *nextCtr = [[AllClassViewController alloc] init];
        nextCtr.classState = AllClassStateNormal;
        [weakSelf.navigationController pushViewController:nextCtr animated:YES];
    };
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kTabBarViewHeight);
    self.groupTableView.backgroundColor = kWhiteColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    self.groupTableView.tableHeaderView = _homeView;
    self.groupTableView.tableFooterView = _footView;
    [self.view addSubview:self.groupTableView];
}

//#pragma mark - 禁止上拉
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
//          scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height);
//          return;
//        }
//}
@end
