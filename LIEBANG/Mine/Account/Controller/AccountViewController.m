//
//  AccountViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountViewController.h"
#import "ApplySuccessViewController.h"
#import "ExperienceViewController.h"
#import "EditAccountViewController.h"
#import "EditExperienceViewController.h"
#import "EducationCertiViewController.h"
#import "WorkCertiViewController.h"
#import "OrderListViewController.h"
#import "MyFriendViewController.h"
#import "EditSelfViewController.h"
#import "EditOtherViewController.h"
#import "UserCommentViewController.h"
#import "AddThemeViewController.h"
#import "CertiResultViewController.h"
#import "ThemeDetailViewController.h"
#import "ConversationViewController.h"
#import "PostQuestionViewController.h"
#import "InterestFriendViewController.h"
#import "AccoutQuestionViewController.h"
#import "CompanyCollectViewController.h"
#import "UserHelpViewController.h"
#import "WebViewController.h"
#import "AccountHeadView.h"
#import "AccountNavView.h"
#import "InterestFriendCell.h"
#import "AccountSelfCell.h"
#import "AccountOtherCell.h"
#import "AccountSchoolCell.h"
#import "AccountCell.h"
#import "AccountJobCell.h"
#import "HomeMeetCell.h"
#import "AccountVoteCell.h"
#import "AllCommentButtonCell.h"
#import "FriendService.h"
#import "MineService.h"
#import "AccountInfo.h"
#import "AccountService.h"
#import "EducationModel.h"
#import "InterestFriendModel.h"
#import "ThemeClassModel.h"
#import "ThemePickView.h"
#import "AccountBottomView.h"
#import "AddThemeCell.h"
#import "CommentButtonCell.h"
#import "MeetCell.h"
#import "MessageService.h"
#import "NoAccountView.h"

#import "CertiResultViewController.h"

@interface AccountViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)AccountHeadView *headView;
@property (nonatomic,strong)AccountNavView *navView;
@property (nonatomic,strong)AccountInfo *accountInfo;
@property (nonatomic,strong)AccountBottomView *bottomView;
@property (nonatomic,assign)BOOL isOpen;
@property (nonatomic,strong)NSArray *cellTitleArray;


@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeaderViewheight:) name:@"headViewHeight" object:nil];
    WeakSelf;
    self.view.backgroundColor = kWhiteColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, (_accountState == AccountStateOther)?(kDeviceHeight-kCurrentWidth(46)-kViewHeight):(kDeviceHeight-kViewHeight));
    self.groupTableView.backgroundColor = (_accountState == AccountStateDisabled)?kWhiteColor:kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    self.groupTableView.tableHeaderView = self.headView;
    [self.view addSubview:self.groupTableView];
    
    [self.view addSubview:self.navView];
    self.navView.backButtonBlock = ^{
//        [[LBForProject currentProject].accountCellTitleArray removeAllObjects];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.navView.detailButtonBlock = ^(UIButton *sender) {
        [weakSelf detailButtonClick:sender];
    };
    self.headView.editButtonBlock = ^{
        [weakSelf gotoEditCtrl:EditAccountCtrlStateNormal];
    };
    self.headView.confimButtonBlock = ^{
        [weakSelf gotoEditCtrl:EditAccountCtrlStateAccountVerified];
    };
    self.headView.headButtonBlock = ^(NSInteger index) {
        [weakSelf headButtonClick:index];
    };
    self.bottomView.reserveButtonBlock = ^{
        [weakSelf pickThemeListView];
    };
    self.bottomView.likeButtonBlock = ^{
        [weakSelf likeAccountRequest];
    };
    self.bottomView.messageButtonBlock = ^{
        [weakSelf getPrivateLetterRequest];
    };
    self.bottomView.questionButtonBlock = ^{
        [weakSelf postQuestionClick];
    };
    
//    [self displayOverFlowActivityView];
    self.groupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadAccountDataSource];

        });
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self displayOverFlowActivityView];

    [self loadAccountDataSource];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changeHeaderViewheight:(NSNotification *)noti
{

}

- (void)loadAccountDataSource {

    [MineService getAccountInfoWithParameters:self.userUid success:^(AccountInfo *info) {
        [self removeOverFlowActivityView];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
        self.accountInfo = info;
        
        if (self.accountState == AccountStateOther) {
            [self.view addSubview:self.bottomView];
        }
        
        //若为封禁用户
        if ([self.accountInfo.userStatus intValue] == 1) {
            self.accountState = AccountStateDisabled;
            self.headView.accountState = self.accountState;
            self.bottomView.hidden = YES;
            self.groupTableView.backgroundColor = kWhiteColor;
            self.headView.hidden = YES;
            UILabel *label = UILabel.new;
            label.textColor = kBlackColor;
            label.font = kSystem(13);
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"该用户已被封禁";
//            label.center = self.tableView.center;
            label.frame = CGRectMake(0, (kDeviceHeight - kCurrentWidth(20))/2, kDeviceWidth, kCurrentWidth(20));
            [self.groupTableView addSubview:label];

        }else{
        self.cellTitleArray = [LBForProject decodeAccountCellTitle:self.accountInfo detailType:self.accountState];
        self.bottomView.likeStatus = info.isLike;
        self.headView.accountInfo = info;
        self.navView.isHidden = NO;
        self.groupTableView.backgroundColor = kLBRedColor;

        NSString *address = [NSString stringWithFormat:@"%@%@",self.accountInfo.userWorkAddress?:@"",self.accountInfo.userDetailAddress?:@""];
        CGSize addressSize = [address sizeWithFont:kSystem(12) maxSize:CGSizeMake(kDeviceWidth + kCurrentWidth(-130), CGFLOAT_MAX)];

        self.headView.frame = CGRectMake(0, 0, kDeviceWidth,addressSize.height + kCurrentWidth(10) + kCurrentWidth(250)+kNavBarHeight);

        [self.groupTableView reloadData];
        }
    } failure:^(NSUInteger code, NSString *errorStr) {
        self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
        [self removeOverFlowActivityView];
        self.cellTitleArray = nil;
        NoAccountView *dataView = [[NoAccountView alloc] init];
        if (code == 10008) {
            dataView.titleString = @"没有访问权限";
        }
        else {
            dataView.titleString = @"暂无数据哦";
        }
        dataView.backButtonBlock = ^{
            [self backNavItemTapped];
        };
        self.navView.isHidden = YES;
        self.groupTableView.tableHeaderView = dataView;
        [self.groupTableView reloadData];
        [self.groupTableView.mj_footer endRefreshing];
        [self.groupTableView.mj_header endRefreshing];
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_accountState == AccountStateDisabled) {
        return 0;
    }
    return self.cellTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    NSString *cellNameStr;
    if (!IsArrEmpty(self.cellTitleArray)) {
        cellNameStr = [self.cellTitleArray safeObjectAtIndex:section];
    }
    
    if ([cellNameStr isEqualToString:@"ThemeClassModel"])
    {
        if ([self.accountInfo.isBasic intValue] == 0 || [self.accountInfo.isEducation intValue] == 0 || [self.accountInfo.isOccupation intValue] == 0) {
            return 0;
        }
        return MIN(self.accountInfo.Topic.count, 3);
    }
    else if ([cellNameStr isEqualToString:@"AddThemeCell"])
    {
        return 1;
    }
    else if ([cellNameStr isEqualToString:@"AccountSelfCell"])
    {
        return 1;
    }
    else if ([cellNameStr isEqualToString:@"AccountJobCell"])
    {
        if (self.accountInfo.OccupationAuthentication.count == 0)
        {
            return 1;
        }
        return self.accountInfo.OccupationAuthentication.count;
    }
    else if ([cellNameStr isEqualToString:@"AccountSchoolCell"])
    {
        if (self.accountInfo.EducationAuthentication.count == 0)
        {
            return 1;
        }
        return self.accountInfo.EducationAuthentication.count;
    }
    else if ([cellNameStr isEqualToString:@"AccountCell"])
    {
        return 2;
    }
    else if ([cellNameStr isEqualToString:@"AccountCellClass"])
    {
        return self.accountInfo.UserClassify.count;
    }
    else if ([cellNameStr isEqualToString:@"AccountVoteCell"])
    {
        if (self.isOpen) {
            return self.accountInfo.Comment.count;
        }
        else {
            return MIN(self.accountInfo.Comment.count, 3);
        }
    }
    else if ([cellNameStr isEqualToString:@"InterestFriendCell"])
    {
        return self.accountInfo.UserFriend.count;
    }
    else if ([cellNameStr isEqualToString:@"AccountOtherCell"])
    {
        return 1;
    }
    else if ([cellNameStr isEqualToString:@"CommentButtonCell"])
    {
        return 1;
    }
    else if ([cellNameStr isEqualToString:@"AllCommentButtonCell"])
    {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    NSString *cellNameStr;
    if (!IsArrEmpty(self.cellTitleArray)) {
        cellNameStr = [self.cellTitleArray safeObjectAtIndex:indexPath.section];
    }
    
    if ([cellNameStr isEqualToString:@"ThemeClassModel"])
    {//约见
        ThemeClassModel *model = [self.accountInfo.Topic safeObjectAtIndex:indexPath.row];
        static NSString *cellStr = @"HomeMeetCell";
        MeetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[MeetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.ishelp = YES;
        cell.themeClassModel = model;
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"AddThemeCell"])
    {
        static NSString *cellStr = @"AddThemeCell";
        AddThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[AddThemeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.editButtonBlock = ^{//添加话题
            AddThemeViewController *nextCtr = [[AddThemeViewController alloc] init];
            [weakSelf.navigationController pushViewController:nextCtr animated:YES];
        };
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"AccountSelfCell"])
    {//自我介绍
        static NSString *cellStr = @"AccountSelfCell";
        AccountSelfCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[AccountSelfCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.model = self.accountInfo;
        cell.confimButtonBlock = ^{
            [weakSelf.groupTableView reloadData];
        };
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"AccountJobCell"])
    {
        WorkModel *model = [self.accountInfo.OccupationAuthentication safeObjectAtIndex:indexPath.row];
        static NSString *cellStr = @"AccountJobCell";
        AccountJobCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[AccountJobCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        
        if (self.accountState == AccountStateEdit)
        {
            if (!IsNilOrNull(model))
            {
                cell.jobState = AccountJobCellStateStateEdit;
            }
        }
        cell.model = model;
        cell.editButtonBlock = ^(WorkModel *model) {//工作经历编写事件
            [weakSelf EditExperienceCtrl:EditExperienceStateWork basicUid:model.id];
        };
        cell.confimButtonBlock = ^(WorkModel *model) {//工作经历认证事件
            [weakSelf gotoJobCertiCtrl:model];
        };
        cell.GetWorkCertiImageViewBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"AccountSchoolCell"])
    {
        EducationModel *model = [self.accountInfo.EducationAuthentication safeObjectAtIndex:indexPath.row];
        static NSString *cellStr = @"AccountSchoolCell";
        AccountSchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[AccountSchoolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        
        if (self.accountState == AccountStateEdit)
        {
            if (!IsNilOrNull(model))
            {
                cell.schoolState = AccountSchoolCellStateEdit;
            }
        }
        cell.model = model;
        cell.userUid = self.accountInfo.userUid;
        cell.editButtonBlock = ^(EducationModel *model) {
            [weakSelf EditExperienceCtrl:EditExperienceStateEducation basicUid:model.id];
        };
        cell.confimButtonBlock = ^(EducationModel *model) {
            [weakSelf gotoEducationCertiCtrl:model];
        };
        cell.GetEduCertiImageViewBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"AccountCell"])
    {
        static NSString *cellStr = @"AccountOneCell";
        AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[AccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.accountCellState = AccountCellStateSource;
        cell.indexPath = indexPath;
        cell.accountInfo = self.accountInfo;
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"AccountCellClass"])
    {//更多资料---家乡、生日
        static NSString *cellStr = @"AccountTwoCell";
        AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[AccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
//        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accountCellState = AccountCellStateJob;
        cell.indexPath = indexPath;
        cell.accountInfo = self.accountInfo;
        cell.voteButtonBlock = ^(UserClassify *model) {
            [weakSelf labelVoteButtonClick:model];
        };
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"AccountVoteCell"])
    {//评论区---现有逻辑是有人评论 就显示，无就隐藏
//        NSInteger Index = (self.accountState == AccountStateOther)?(indexPath.row-1):indexPath.row;
        Comment *model = [self.accountInfo.Comment safeObjectAtIndex:indexPath.row];
        static NSString *cellStr = @"AccountVoteCell";
        AccountVoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[AccountVoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.model = model;
        cell.accountState = self.accountState;
        cell.voteButtonBlock = ^(Comment *model) {
            [weakSelf voteButtonClick:model];
        };
        cell.accountButtonBlock = ^(Comment *model) {
            [weakSelf gotoAccountViewController:@"" userUid:model.userUid userStatus:nil];
        };
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"InterestFriendCell"])
    {
        InterestFriendModel *model = [self.accountInfo.UserFriend safeObjectAtIndex:indexPath.row];
        static NSString *cellStr = @"InterestFriendCell";
        InterestFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[InterestFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.sureButtonState = SureButtonStateNormal;
        cell.friendModel = model;
        cell.sureButtonBlock = ^(InterestFriendModel *friendModel) {
            [weakSelf addFriendRequest:friendModel.userUid];
        };
        cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"AccountOtherCell"])
    {
        static NSString *cellStr = @"AccountOtherCell";
        AccountOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[AccountOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.confimButtonBlock = ^{
            WebViewController *nextCtr = [[WebViewController alloc] init];
            nextCtr.webViewType = WebViewTypeUserProtocol;
            [weakSelf.navigationController pushViewController:nextCtr animated:YES];
        };
        cell.useHelpBlock = ^{
            UserHelpViewController *nextCtr = [[UserHelpViewController alloc] init];
            [weakSelf.navigationController pushViewController:nextCtr animated:YES];
        };
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"CommentButtonCell"])
    {
        static NSString *cellStr = @"CommentButtonCell";
        CommentButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[CommentButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.accountInfo = self.accountInfo;
        cell.editButtonBlock = ^{
            
            if ([self.accountInfo.isComment integerValue] == 0) {
                [self showAlertWithString:@"您暂无权限评论该用户"];
                return ;
            }
            
            UserCommentViewController *nextCtr = [[UserCommentViewController alloc] init];
            nextCtr.accountInfo = self.accountInfo;
            [weakSelf.navigationController pushViewController:nextCtr animated:YES];
        };
        return cell;
    }
    else if ([cellNameStr isEqualToString:@"AllCommentButtonCell"])
    {
        static NSString *cellStr = @"AllCommentButtonCell";
        AllCommentButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[AllCommentButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.accountInfo = self.accountInfo;
        cell.editButtonBlock = ^(BOOL isOpen) {
            weakSelf.isOpen = isOpen;
            [weakSelf.groupTableView reloadData];
        };
        return cell;
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSString *cellNameStr;
    if (!IsArrEmpty(self.cellTitleArray)) {
        cellNameStr = [self.cellTitleArray safeObjectAtIndex:section];
    }
    
    if ([cellNameStr isEqualToString:@"ThemeClassModel"])
    {
        return 0.f;
    }
    else if ([cellNameStr isEqualToString:@"AddThemeCell"])
    {
        return 0.f;
    }
    else if ([cellNameStr isEqualToString:@"AccountSelfCell"])
    {
        return 40.f;
    }
    else if ([cellNameStr isEqualToString:@"AccountJobCell"])
    {
        return 40.f;
    }
    else if ([cellNameStr isEqualToString:@"AccountSchoolCell"])
    {
        return 40.f;
    }
    else if ([cellNameStr isEqualToString:@"AccountCell"])
    {
        return 40.f;
    }
    else if ([cellNameStr isEqualToString:@"AccountCellClass"])
    {
        return 40.f;
    }
    else if ([cellNameStr isEqualToString:@"AccountVoteCell"])
    {
        if (self.accountState != AccountStateOther) {
            return 40.f;
        }
        return 0.0000001f;
    }
    else if ([cellNameStr isEqualToString:@"InterestFriendCell"])
    {//兴趣好友
        return 40.f;
    }
    else if ([cellNameStr isEqualToString:@"AccountOtherCell"])
    {
        return 0.f;
    }
    else if ([cellNameStr isEqualToString:@"CommentButtonCell"])
    {//评论区
        return 40.f;
    }
    return 0.0000001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    WeakSelf;
    NSString *cellNameStr;
    if (!IsArrEmpty(self.cellTitleArray)) {
        cellNameStr = [self.cellTitleArray safeObjectAtIndex:section];
    }
    
    if ([cellNameStr isEqualToString:@"ThemeClassModel"])
    {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 20)];
        headView.backgroundColor = kBackgroundColor;
        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 10)];
        head.backgroundColor = kWhiteColor;
        [headView addSubview:head];
        return headView;
    }
    else if ([cellNameStr isEqualToString:@"AddThemeCell"])
    {
        return [[UIView alloc] init];
    }
    else if ([cellNameStr isEqualToString:@"AccountSelfCell"])
    {
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40) title:@"自我介绍"];
        headView.backgroundColor = UIColor.groupTableViewBackgroundColor;
        if (self.accountState == AccountStateEdit)
        {
            headView.buttonTitle = @"编辑";
            headView.buttonState = SectionButtonStateBorder;
        }
        headView.detailButtonBlock = ^{
            EditSelfViewController *nextCtr = [[EditSelfViewController alloc] init];
            nextCtr.userIntroduce = self.accountInfo.userIntroduce;
            [weakSelf.navigationController pushViewController:nextCtr animated:YES];
        };
        return headView;
    }
    else if ([cellNameStr isEqualToString:@"AccountJobCell"])
    {
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40) title:@"工作经历"];
        headView.backgroundColor = UIColor.groupTableViewBackgroundColor;

        if (self.accountState == AccountStateEdit)
        {
            headView.buttonTitle = @"添加";
            headView.buttonState = SectionButtonStateBorder;
        }
        headView.detailButtonBlock = ^{
            EditExperienceViewController *nextCtr = [[EditExperienceViewController alloc] init];
            nextCtr.experienceState = EditExperienceStateWork;
            [weakSelf.navigationController pushViewController:nextCtr animated:YES];
        };
        return headView;
    }
    else if ([cellNameStr isEqualToString:@"AccountSchoolCell"])
    {
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40) title:@"教育经历"];
        headView.backgroundColor = UIColor.groupTableViewBackgroundColor;

        if (self.accountState == AccountStateEdit)
        {
            headView.buttonTitle = @"添加";
            headView.buttonState = SectionButtonStateBorder;
        }
        headView.detailButtonBlock = ^{
            EditExperienceViewController *nextCtr = [[EditExperienceViewController alloc] init];
            nextCtr.experienceState = EditExperienceStateEducation;
            [weakSelf.navigationController pushViewController:nextCtr animated:YES];
        };
        return headView;
    }
    else if ([cellNameStr isEqualToString:@"AccountCell"])
    {
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40) title:@"更多资料"];
        headView.backgroundColor = UIColor.groupTableViewBackgroundColor;

        if (self.accountState == AccountStateEdit)
        {
            headView.buttonTitle = @"编辑";
            headView.buttonState = SectionButtonStateBorder;
        }
        headView.detailButtonBlock = ^{
            EditOtherViewController *nextCtr = [[EditOtherViewController alloc] init];
            nextCtr.accountInfo = self.accountInfo;
            [weakSelf.navigationController pushViewController:nextCtr animated:YES];
        };
        return headView;
    }
    else if ([cellNameStr isEqualToString:@"AccountCellClass"])
    {
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40) title:@"职业标签"];
        headView.backgroundColor = UIColor.groupTableViewBackgroundColor;

        headView.buttonTitle = @"仅好友能认可";
        headView.buttonState = SectionButtonStateDisable;
        return headView;
    }
    else if ([cellNameStr isEqualToString:@"InterestFriendCell"])
    {
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40) title:@"你可能感兴趣的好友"];
        headView.backgroundColor = UIColor.groupTableViewBackgroundColor;

        headView.buttonTitle = @"更多好友推荐>>";
        headView.buttonState = SectionButtonStateNormel;
        headView.detailButtonBlock = ^{
            InterestFriendViewController *nextCtr = [[InterestFriendViewController alloc] init];
            [weakSelf.navigationController pushViewController:nextCtr animated:YES];
        };
        return headView;
    }
    else if ([cellNameStr isEqualToString:@"AccountOtherCell"])
    {
        return [UIView new];
    }
    else if ([cellNameStr isEqualToString:@"CommentButtonCell"])
    {
        NSString *string = [NSString stringWithFormat:@"共%zd人点评过%@",self.accountInfo.Comment.count,IsNilOrNull(self.accountInfo.userName)?@"":self.accountInfo.userName];
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40) title:string];
        headView.backgroundColor = UIColor.groupTableViewBackgroundColor;

        headView.buttonTitle = @"仅好友能点评";
        headView.buttonState = SectionButtonStateDisable;
        return headView;
    }
    else if ([cellNameStr isEqualToString:@"AccountVoteCell"])
    {
        if (self.accountState != AccountStateOther) {
            NSString *string = [NSString stringWithFormat:@"共%zd人点评过%@",self.accountInfo.Comment.count,IsNilOrNull(self.accountInfo.userName)?@"":self.accountInfo.userName];
            SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40) title:string];
            headView.backgroundColor = UIColor.groupTableViewBackgroundColor;

            headView.buttonTitle = @"仅好友能点评";
            headView.buttonState = SectionButtonStateDisable;
            return headView;
        }
        return [[UIView alloc] init];
    }
    else if ([cellNameStr isEqualToString:@"AllCommentButtonCell"])
    {
        return [UIView new];
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellNameStr;
    if (!IsArrEmpty(self.cellTitleArray)) {
        cellNameStr = [self.cellTitleArray safeObjectAtIndex:indexPath.section];
    }
    
    if ([cellNameStr isEqualToString:@"ThemeClassModel"])
    {
        MeetCell *cell = (MeetCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    else if ([cellNameStr isEqualToString:@"AddThemeCell"])
    {
        return kCurrentWidth(44);
    }
    else if ([cellNameStr isEqualToString:@"AccountSelfCell"])
    {
        AccountSelfCell *cell = (AccountSelfCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return [cell getHeight];
    }
    else if ([cellNameStr isEqualToString:@"AccountJobCell"])
    {
        AccountJobCell *cell = (AccountJobCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return [cell getHeight];
    }
    else if ([cellNameStr isEqualToString:@"AccountSchoolCell"])
    {
//        AccountSchoolCell *cell = (AccountSchoolCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
//        return [cell cellHeight];
        return kCurrentWidth(75);
    }
    else if ([cellNameStr isEqualToString:@"AccountCell"])
    {
        return kCurrentWidth(44);
    }
    else if ([cellNameStr isEqualToString:@"AccountCellClass"])
    {
        return kCurrentWidth(50);
    }
    else if ([cellNameStr isEqualToString:@"AccountVoteCell"])
    {
        AccountVoteCell *cell = (AccountVoteCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        if (cell.cellHeight >= kCurrentWidth(70)) {
            return cell.cellHeight;
        }
        return kCurrentWidth(70);
    }
    else if ([cellNameStr isEqualToString:@"InterestFriendCell"])
    {
        return kCurrentWidth(70);
    }
    else if ([cellNameStr isEqualToString:@"AccountOtherCell"])
    {
        AccountOtherCell *cell = (AccountOtherCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return [cell getHeight];
    }
    else if ([cellNameStr isEqualToString:@"CommentButtonCell"])
    {
        return kCurrentWidth(76);
    }
    else if ([cellNameStr isEqualToString:@"AllCommentButtonCell"])
    {
        return kCurrentWidth(66);
    }
    return 0.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *cellNameStr;
    if (!IsArrEmpty(self.cellTitleArray)) {
        cellNameStr = [self.cellTitleArray safeObjectAtIndex:indexPath.section];
    }
    
    if ([cellNameStr isEqualToString:@"ThemeClassModel"])
    {
        [self pickThemeListView];
    }
    else if ([cellNameStr isEqualToString:@"AddThemeCell"])
    {
        AddThemeViewController *nextCtr = [[AddThemeViewController alloc] init];
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if ([cellNameStr isEqualToString:@"AccountSelfCell"])
    {
        
    }
    else if ([cellNameStr isEqualToString:@"AccountJobCell"])
    {
        if (self.accountState == AccountStateEdit)
        {
            WorkModel *model = [self.accountInfo.OccupationAuthentication safeObjectAtIndex:indexPath.row];
            [self EditExperienceCtrl:EditExperienceStateWork basicUid:model.id];
        }
        else
        {
            if (self.accountInfo.OccupationAuthentication.count != 0 || self.accountInfo.EducationAuthentication.count != 0)
            {
                ExperienceViewController *nextCtr = [[ExperienceViewController alloc] init];
                nextCtr.accountInfo = self.accountInfo;
                [self.navigationController pushViewController:nextCtr animated:YES];
            }
        }
    }
    else if ([cellNameStr isEqualToString:@"AccountSchoolCell"])
    {
        if (self.accountState == AccountStateEdit)
        {
            EducationModel *model = [self.accountInfo.EducationAuthentication safeObjectAtIndex:indexPath.row];
            [self EditExperienceCtrl:EditExperienceStateEducation basicUid:model.id];
        }
        else
        {
            if (self.accountInfo.OccupationAuthentication.count != 0 || self.accountInfo.EducationAuthentication.count != 0)
            {
                ExperienceViewController *nextCtr = [[ExperienceViewController alloc] init];
                nextCtr.accountInfo = self.accountInfo;
                [self.navigationController pushViewController:nextCtr animated:YES];
            }
        }
    }
    else if ([cellNameStr isEqualToString:@"AccountCell"])
    {
        
    }
    else if ([cellNameStr isEqualToString:@"AccountCellClass"])
    {
        
    }
    else if ([cellNameStr isEqualToString:@"AccountVoteCell"])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if ([cellNameStr isEqualToString:@"InterestFriendCell"])
    {
        InterestFriendModel *model = [self.accountInfo.UserFriend safeObjectAtIndex:indexPath.row];
        [self gotoAccountViewController:model.dataPrivacyType userUid:model.userUid userStatus:model.userStatus];
    }
    else if ([cellNameStr isEqualToString:@"AccountOtherCell"])
    {
        
    }
}

//查看资料权限
- (void)gotoAccountViewController:(NSString *)dataPrivacyType userUid:(NSString *)userUid userStatus:(NSString *)userStatus {
    
    AccountViewController *nextCtr = [[AccountViewController alloc] init];
    if ([[Config currentConfig].userUid isEqualToString:userUid]) {
        nextCtr.accountState = AccountStateNormal;
    }
    else {
        if ([userStatus intValue] == 0) {
            nextCtr.accountState = AccountStateOther;
        }
        else {
            nextCtr.accountState = AccountStateDisabled;
        }
    }
    nextCtr.userUid = userUid;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

#pragma mark Event
- (void)labelVoteButtonClick:(UserClassify *)model {
    
    if (self.accountState != AccountStateOther) {
        return;
    }
    
    if ([self.accountInfo.isComment integerValue] == 0) {
        [self showAlertWithString:@"您暂无权限点赞该用户"];
        return ;
    }
    
    [self displayOverFlowActivityView];
    [AccountService getUPClassifyWithParameters:model.id success:^(id model) {
        [self removeOverFlowActivityView];
        [self loadAccountDataSource];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)voteButtonClick:(Comment *)model {
    
    if (self.accountState != AccountStateOther) {
        return;
    }
    
    if ([self.accountInfo.isComment integerValue] == 0) {
        [self showAlertWithString:@"您暂无权限点赞该用户"];
        return ;
    }
    
    [self displayOverFlowActivityView];
    [AccountService getUPCommentWithParameters:model.id success:^(id model) {
        [self removeOverFlowActivityView];
        [self presentSheet:model];
        [self loadAccountDataSource];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)EditExperienceCtrl:(EditExperienceState)experienceState basicUid:(NSString *)basicUid {
    EditExperienceViewController *nextCtr = [[EditExperienceViewController alloc] init];
    nextCtr.isEdit = YES;
    nextCtr.basicID = basicUid;
    nextCtr.experienceState = experienceState;
    [self.navigationController pushViewController:nextCtr animated:YES];
}
#pragma mark - 教育经历认证跳转
- (void)gotoEducationCertiCtrl:(EducationModel *)model {
    if (model.status.integerValue == 0) {
        CertiResultViewController *resultvc = [CertiResultViewController new];
        resultvc.certiResultCtrl = CertiResultCtrlNormal;
        resultvc.message = [InsureValidate timeInStr:model.updateTime];
        [self.navigationController pushViewController:resultvc animated:YES];
        
    }else{
        EducationCertiViewController *nextCtr = [[EducationCertiViewController alloc] init];
        nextCtr.eduUid = model.id;

        nextCtr.eduCertiState = EducationCertiStateNormal;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}
#pragma mark - 工作经历认证跳转
- (void)gotoJobCertiCtrl:(WorkModel *)model {//0审核中 1已通过 2失败 3未审核 4已取消
    if (model.status.integerValue == 0) {
        CertiResultViewController *resultvc = [CertiResultViewController new];
        resultvc.certiResultCtrl = CertiResultCtrlNormal;
        resultvc.message = [InsureValidate timeInStr:model.updateTime];
        [self.navigationController pushViewController:resultvc animated:YES];

    }
    else{
        WorkCertiViewController *nextCtr = [[WorkCertiViewController alloc] init];
        nextCtr.workCertiState = WorkCertiStateNormal;
        nextCtr.workUid = model.id;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}
#pragma mark - 个人信息编辑和认证事件
- (void)gotoEditCtrl:(EditAccountCtrlState)editAccountCtrlState {
    
    if (editAccountCtrlState == EditAccountCtrlStateNormal) {
        EditAccountViewController *nextCtr = [[EditAccountViewController alloc] init];
        nextCtr.editAccountCtrlState = editAccountCtrlState;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }else{
        if (self.accountInfo.userBasic.integerValue == 0) {
            CertiResultViewController *result = CertiResultViewController.new;
            result.certiResultCtrl = CertiResultCtrlNormal;
            result.message = [InsureValidate timeInStr:self.accountInfo.updateTime];
            [self.navigationController pushViewController:result animated:YES];
            
        }else{
            EditAccountViewController *nextCtr = [[EditAccountViewController alloc] init];
            nextCtr.editAccountCtrlState = editAccountCtrlState;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
    }
}

- (void)headButtonClick:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            [self pickThemeListView];
        }
            break;
        case 1:
        {
            AccoutQuestionViewController *nextCtr = [[AccoutQuestionViewController alloc] init];
            nextCtr.accountState = self.accountState;
            nextCtr.userUid = self.userUid;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        case 2:
        {
            MyFriendViewController *nextCtr = [[MyFriendViewController alloc] init];
            if (self.accountState == AccountStateOther) {
                nextCtr.userUid = self.userUid;
            }
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        case 3:
        {
            OrderListViewController *nextCtr = [[OrderListViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)pickThemeListView {
    
    if ([self.accountInfo.isBasic intValue] == 0 || [self.accountInfo.isOccupation intValue] == 0 || [self.accountInfo.isEducation intValue] == 0) {
        
        if (self.accountState == AccountStateOther) {
            [self showAlertWithString:@"TA暂时没有话题商品"];
        }
        else {
            [self showAlertWithString:@"成为行家认证用户后，再来发布话题商品"];
        }
    } else {
        
        if (self.accountInfo.Topic.count == 0)
        {
            if (self.accountState == AccountStateEdit || self.accountState == AccountStateNormal) {
                AddThemeViewController *nextCtr = [[AddThemeViewController alloc] init];
                [self.navigationController pushViewController:nextCtr animated:YES];
            }
        }
        else
        {
            [ThemePickView showThemePickViewWithAnimation:YES accountState:self.accountState dataSource:self.accountInfo.Topic pickBlock:^(ThemeClassModel *model) {
                
                ThemeDetailViewController *nextCtr = [[ThemeDetailViewController alloc] init];
                nextCtr.themeUid = model.id;
                if (self.accountState == AccountStateEdit || self.accountState == AccountStateNormal)
                {
                    nextCtr.detailState = ThemeDetailStateEdit;
                }
                else
                {
                    nextCtr.detailState = ThemeDetailStateNormal;
                }
                [self.navigationController pushViewController:nextCtr animated:YES];
            }];
        }        
    }
}

- (void)detailButtonClick:(UIButton *)sender {
    
    YCMenuAction *action = [YCMenuAction actionWithTitle:@"分享Ai名片" image:nil handler:^(YCMenuAction *action) {
        [self shareClick];
    }];
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"拉黑/屏蔽" image:nil handler:^(YCMenuAction *action) {
        [self addBlackFriendRequest];
    }];
    YCMenuAction *action2 = [YCMenuAction actionWithTitle:@"加为好友" image:nil handler:^(YCMenuAction *action) {
        [self addFriendRequest:self.userUid];
    }];
    YCMenuAction *action3 = [YCMenuAction actionWithTitle:@"解除好友关系" image:nil handler:^(YCMenuAction *action) {
        [self deleteFriendEvent];
    }];
    
    
    switch (self.accountState) {
        case AccountStateEdit:
        {
            [self backNavItemTapped];
        }
            break;
        case AccountStateOther:
        {
            [self displayOverFlowActivityView];
            [MessageService isFriendWithParameters:self.accountInfo.userUid success:^(NSString *info) {
                [self removeOverFlowActivityView];
                if (info.boolValue) {
                    YCMenuView *view = [YCMenuView menuWithActions:@[action,action1,action3] width:140 relyonView:sender];
                    view.maxDisplayCount = 10;
                    [view show];
                }
                else {
                    YCMenuView *view = [YCMenuView menuWithActions:@[action,action1,action2] width:140 relyonView:sender];
                    view.maxDisplayCount = 10;
                    [view show];
                }
            } failure:^(NSUInteger code, NSString *errorStr) {
                [self removeOverFlowActivityView];
                [self presentSheet:errorStr];
            }];
        }
            break;
        case AccountStateNormal:
        {
            YCMenuView *view = [YCMenuView menuWithActions:@[action] width:140 relyonView:sender];
            view.maxDisplayCount = 10;
            [view show];
        }
            break;
        case AccountStateDisabled:
        {
            [self showAlertWithString:@"该账户为封禁账户"];
        }
            break;
        default:
            break;
    }
}

- (void)postQuestionClick {
    
    if ([self.accountInfo.isBasic intValue] == 0 || [self.accountInfo.isEducation intValue] == 0 || [self.accountInfo.isOccupation intValue] == 0) {
        [self showAlertWithString:@"TA还不是行家，不能向TA提问"];
        return;
    }
    
    PostQuestionViewController *nextCtr = [[PostQuestionViewController alloc] init];
    [Config currentConfig].answerid = self.userUid;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

//申请好友
- (void)addFriendRequest:(NSString *)userUid {
    
    [self displayOverFlowActivityView];
    [FriendService getAddFriendWithParameters:userUid success:^(NSString *success) {
        [self removeOverFlowActivityView];
        ApplySuccessViewController *nextCtr = [[ApplySuccessViewController alloc] init];
        [self.navigationController pushViewController:nextCtr animated:YES];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

//添加黑名单
- (void)addBlackFriendRequest {
    
    UIAlertController *alert = [CHAlertView showMessageWith:@"确定" title:@"确定将该用户移至黑名单?" confim:^{
        [self displayOverFlowActivityView];
        [FriendService getAddBlackFriendWithParameters:self.userUid success:^(NSString *success) {
            [self removeOverFlowActivityView];
            [self presentSheet:success];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }];
    [self presentViewController:alert animated:YES completion:nil];
    
}

//删除好友
- (void)deleteFriendEvent {
    
    [self displayOverFlowActivityView];
    [FriendService getDeleteFriendWithParameters:self.userUid success:^(NSString *success) {
        [self removeOverFlowActivityView];
        [self presentSheet:success];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FriendService getFriendListWithSuccess:^(FriendListModel *model) {
            } failure:^(NSUInteger code, NSString *errorStr) {
            }];
        });
        
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

//喜欢用户
- (void)likeAccountRequest {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.userUid forKey:@"likeUserUid"];
    [postDic setValue:self.bottomView.likeStatus forKey:@"type"];//0 取消喜欢 1喜欢
    
    NSLog(@"喜欢用户postDic = %@",postDic);
    
    [self displayOverFlowActivityView];
    [AccountService getLikeWithParameters:postDic success:^(id model) {
        [self removeOverFlowActivityView];
        [self presentSheet:model];
        self.bottomView.likeStatus = self.bottomView.likeStatus;
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

//点赞评价
- (void)upCommentRequest {
    
    [self displayOverFlowActivityView];
    [AccountService getUPCommentWithParameters:nil success:^(id model) {
        [self removeOverFlowActivityView];
        [self presentSheet:model];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

//私信权限
- (void)getPrivateLetterRequest {
    
    [self displayOverFlowActivityView];
    [AccountService getPrivateLetterWithParameters:self.userUid success:^(id model) {
        [self removeOverFlowActivityView];
        if ([model intValue] == 0) {//0 不可以发送  1：可以发送
            [self showAlertWithString:[NSString stringWithFormat:@"%@已设置私信权限:\n仅好友可私信",self.accountInfo.userName]];
        }
        else {
            [self gotoConversationEvent];
        }
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)gotoConversationEvent {
    ConversationViewController *_conversationVC = [[ConversationViewController alloc]init];
    _conversationVC.conversationType = ConversationType_PRIVATE;
    _conversationVC.targetId = self.accountInfo.userUid;
    _conversationVC.title = self.accountInfo.userName;
    
    RCUserInfo *user = [RCUserInfo new];
    user.name = self.accountInfo.userName;
    user.userId = self.accountInfo.userUid;
    user.portraitUri = self.accountInfo.userHead;
    [[RCDataManager shareManager] addRCUserInfo:user];
    
    [self.navigationController pushViewController:_conversationVC animated:YES];
}

- (void)gotoClaimCompanyWith:(NSString *)userUid {
    CompanyCollectViewController *nextCtr = [[CompanyCollectViewController alloc] init];
    nextCtr.isRenLin = YES;
    nextCtr.userUid = self.accountInfo.userUid;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

#pragma mark 分享
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
    NSString *url = [NSString stringWithFormat:@"http://liebangapp.com/share/#/card?id=%@&userUid=%@",self.accountInfo.userUid,[Config currentConfig].userUid];
    if (platformType == UMSocialPlatformType_UserDefine_Begin+2)
    {
        MyFriendViewController *nextCtr = [[MyFriendViewController alloc] init];
        WMCardMessage *videoMessage = [WMCardMessage messageWithAccContent:self.accountInfo];
        nextCtr.cardMessage = videoMessage;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if (platformType == UMSocialPlatformType_UserDefine_Begin+3)
    {
        UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = url;
        [self presentSheet:@"已获取到链接，请粘贴使用"];
    }
    else
    {
        NSString *company = (IsNilOrNull(self.accountInfo.company) || IsStrEmpty(self.accountInfo.company))?@"":self.accountInfo.company;
        NSString *position = (IsNilOrNull(self.accountInfo.position) || IsStrEmpty(self.accountInfo.position))?@"":self.accountInfo.position;
        NSString *phone = (IsNilOrNull(self.accountInfo.phone) || IsStrEmpty(self.accountInfo.phone))?@"":self.accountInfo.phone;
        [self shareWebPageToPlatformType:platformType withTitle:[NSString stringWithFormat:@"hi，这是%@的名片",self.accountInfo.userName] descr:[NSString stringWithFormat:@"公司:%@\n职位:%@\n点击查看更多Al智能名片信息",company,position] url:url thumb:@""];
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withTitle:(NSString *)title descr:(NSString *)descr url:(NSString *)url thumb:(id)thumb
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:self.accountInfo.userHead];//[UIImage imageNamed:@"icon-60"]
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

#pragma mark 界面布局
- (AccountHeadView *)headView {
    if (!_headView) {

        _headView = [[AccountHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(270)+kNavBarHeight + kCurrentWidth(15))];
        _headView.accountState = _accountState;
        
        WeakSelf;
        _headView.GetWorkSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        _headView.GetBasicSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        _headView.accountButtonBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        _headView.companyButtonBlock = ^(NSString *userUid) {
            [weakSelf gotoClaimCompanyWith:userUid];
        };
    }
    return _headView;
}

- (AccountNavView *)navView {
    if (!_navView) {
        _navView = [[AccountNavView alloc] init];
        _navView.accountState = _accountState;
    }
    return _navView;
}

- (AccountBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[AccountBottomView alloc] init];
    }
    return _bottomView;
}

#pragma mark - 禁止上拉
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
          scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height);
          return;
        }
}

@end
