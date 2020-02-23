//
//  CompanyDetailViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "CompanyCertViewController.h"
#import "CompanyPosterViewController.h"
#import "AllPersonnelViewController.h"
#import "CompanyMessageViewController.h"
#import "PostCompanyCommentViewController.h"
#import "AllCompanyDiscussViewController.h"
#import "CompanyService.h"
#import "CompanyHeadView.h"
#import "CompanyModel.h"
#import "CompanyDetailCell.h"
#import "WMCompanyMessage.h"
#import "FriendService.h"
#import "NoAccountView.h"

@interface CompanyDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)CompanyHeadView *headView;
@property (nonatomic,strong)CompanyModel *detailModel;
@property (nonatomic,assign)CompanyDetailCellState detailState;

@property (assign, nonatomic) CGFloat getH;
@end

@implementation CompanyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.companyName;
    self.view.backgroundColor = kWhiteColor;

    [self setRightNaviBtnImage:[UIImage imageNamed:@"company_detail_nav_more"]];
    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kWhiteColor;
    self.groupTableView.tableHeaderView = self.headView;
    [self.view addSubview:self.groupTableView];
    self.groupTableView.showsVerticalScrollIndicator = NO;
    WeakSelf;
    self.headView.allPersonnelBlock = ^(NSString * _Nonnull uid) {
        [weakSelf allPersonnelMessage:uid];
    };
    [self displayOverFlowActivityView];
    
    [self getCompanyDetail];

}

- (void)getCompanyDetail {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.companyUid forKey:@"id"];
    [postDic setValue:self.companyType forKey:@"type"];//0:自己查看 1:他人查看
    
    [CompanyService getCompanyDetailWithParameters:postDic success:^(CompanyModel * _Nonnull data) {
        [self removeOverFlowActivityView];
        self.detailModel = data;
        self.headView.detailModel = data;
        self.navigationItem.title = self.detailModel.companyAbbreviation;
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
        NoAccountView *dataView = [[NoAccountView alloc] init];
        dataView.titleString = errorStr;
        dataView.backButtonBlock = ^{
            [self backNavItemTapped];
        };
        self.groupTableView.tableHeaderView = dataView;
        [self.groupTableView reloadData];
    }];
}

#pragma mark
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    static NSString *cellStr = @"CompanyDetailCell";
    CompanyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[CompanyDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.type = [NSString stringWithFormat:@"%@",self.isSelf?@"1":@"0"];

    cell.companyModel = self.detailModel;
    cell.detailState = self.detailState;
    //cell的信息按钮切换点击事件
    cell.refreshDetailCellBlock = ^(CompanyDetailCellState detailState) {
        weakSelf.detailState = detailState;
        [weakSelf.groupTableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.groupTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
         };
    cell.saveCompanyDetailBlock = ^(NSString * _Nonnull companyUid) {
        [weakSelf scanCompanyDetail];
    };
    //展开详情按钮点击事件
    cell.scanCompanyDetailBlock = ^(CompanyModel * _Nonnull companyModel) {
        [weakSelf saveCompanyDetail];
    };
    cell.claimCompanyDetailBlock = ^(CompanyModel * _Nonnull companyModel) {
        [weakSelf claimCompanyDetail:companyModel];
    };
    cell.sureButtonBlock = ^(InterestFriendModel *friendModel) {
        [weakSelf addFriendRequestWith:friendModel];
    };
    cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
        [weakSelf pushToMosaicVC:imageUrl];
    };
    cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
        [weakSelf pushToMosaicVC:imageUrl];
    };
//    [cell showStallMessage:YES array:self.detailModel.staff isClaim:YES];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyDetailCell *cell = (CompanyDetailCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

#pragma mark Event
- (void)addFriendRequestWith:(InterestFriendModel *)model {
    
    [self displayOverFlowActivityView];
    [FriendService getAddFriendWithParameters:model.userUid success:^(NSString *success) {
        [self removeOverFlowActivityView];
        model.isApplyStatus = @"0";
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)rightNaviBtnClick:(UIButton *)sender {
    YCMenuAction *action = [YCMenuAction actionWithTitle:@"分享企业名片" image:nil handler:^(YCMenuAction *action) {
        [self shareClick];
    }];
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"保存生成海报" image:nil handler:^(YCMenuAction *action) {
        [self companyPoster];
    }];
    YCMenuAction *action2 = [YCMenuAction actionWithTitle:@"收藏企业名片" image:nil handler:^(YCMenuAction *action) {
        [self postCompanyCollect:self.companyUid];
    }];
    YCMenuAction *action3 = [YCMenuAction actionWithTitle:@"取消收藏" image:nil handler:^(YCMenuAction *action) {
        [self removeCompanyCollection:self.detailModel.collectionId];
    }];
    
    if ([self.companyType intValue] == 0) {
        YCMenuView *view = [YCMenuView menuWithActions:@[action,action1] width:140 relyonView:sender];
        view.maxDisplayCount = 10;
        [view show];
    }
    else {
        YCMenuView *view = [YCMenuView menuWithActions:@[action,action1,self.detailModel.collectionStates.boolValue?action3:action2] width:140 relyonView:sender];
        view.maxDisplayCount = 10;
        [view show];
    }
}

//取消收藏
- (void)removeCompanyCollection:(NSString *)ids {
    [self displayOverFlowActivityView];
    [CompanyService removeCompanyCollectWithParameters:ids success:^(NSString * _Nonnull data) {
        [self removeOverFlowActivityView];
        [self presentSheet:data];
        self.detailModel.collectionStates = @"0";
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

//收藏企业
- (void)postCompanyCollect:(NSString *)uid {
    [self displayOverFlowActivityView];
    [CompanyService addCollectCompanyWithParameters:uid success:^(NSString * _Nonnull data) {
        [self removeOverFlowActivityView];
        [self presentSheet:data];
        [self getCompanyDetail];
        self.detailModel.collectionStates = @"1";
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

//企业海报
- (void)companyPoster {
    CompanyPosterViewController *nextCtr = [[CompanyPosterViewController alloc] init];
    nextCtr.companyModel = self.detailModel;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

//全部员工
- (void)allPersonnelMessage:(NSString *)uid {
    
    if ([self.detailModel.commentJurisdiction intValue] == 0 && [self.companyType intValue] == 1) {
        [self showAlertWithString:@"您不是该企业员工，请先认领该企业"];
        return;
    }
    
    AllPersonnelViewController *nextCtr = [[AllPersonnelViewController alloc] init];
    nextCtr.enterpriseId = uid;
    nextCtr.type = self.companyType;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)saveCompanyDetail {
    switch (self.detailState) {
        case CompanyDetailCellCompanyDiscuss:
        {
            AllCompanyDiscussViewController *nextCtr = [[AllCompanyDiscussViewController alloc] init];
            nextCtr.enterpriseId = self.detailModel.id;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        default:
        {//详情页点击查看页面
            CompanyMessageViewController *nextCtr = [[CompanyMessageViewController alloc] init];
            nextCtr.detailModel = self.detailModel;
            nextCtr.detailState = self.detailState;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
    }
}

- (void)scanCompanyDetail {
    switch (self.detailState) {
        case CompanyDetailCellCompanyDiscuss:
        {
            PostCompanyCommentViewController *nextCtr = [[PostCompanyCommentViewController alloc] init];
            nextCtr.enterpriseId = self.detailModel.id;
            nextCtr.enterpriseName = self.detailModel.companyAbbreviation;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        default:
        {
            CompanyCertViewController *nextCtr = [[CompanyCertViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
    }
}

//去认领企业
- (void)claimCompanyDetail:(CompanyModel *)companyModel{
    
    if ([self.detailModel.commentJurisdiction intValue] == 0 && self.isSelf) {
        [self showAlertWithString:@"您已经是该企业员工，无需认领"];
        return;
    }
    
    if (!self.isSelf) {
        [self displayOverFlowActivityView];

        [self getCompany];
    }
    
//    if (self.isSelf) {//[self.detailModel.commentJurisdiction intValue] == 0 &&
//        if (self.detailModel.commentJurisdiction.intValue  == 1) {
//            [self displayOverFlowActivityView];
//
//            [self getCompany];
//            return;
//        }
//        [self showAlertWithString:@"您已经是该企业员工，无需认领"];
//            return;
//        }
//    [self getCompany];
}
#pragma mark - 企业认领接口申请
- (void)getCompany
{
    //企业认领接口申请
    [CompanyService getStallCompanyWithParameters:self.companyUid success:^(NSString * _Nonnull data) {
        [self removeOverFlowActivityView];
        [self showAlertWithString:data];
        
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self showAlertWithString:errorStr];
    }];
}

#pragma mark 懒加载
- (CompanyHeadView *)headView {
    if (!_headView) {
        _headView = [[CompanyHeadView alloc] init];
        _headView.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(456+35));

    }
    return _headView;
}

#pragma mark
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
    NSString *url = [NSString stringWithFormat:@"http://liebangapp.com/share/#/company?id=%@&userUid=%@",self.companyUid,[Config currentConfig].userUid];
    if (platformType == UMSocialPlatformType_UserDefine_Begin+2)
    {
        MyFriendViewController *nextCtr = [[MyFriendViewController alloc] init];
        WMCompanyMessage *message = [WMCompanyMessage messageWithContent:self.detailModel];
        nextCtr.companyMessage = message;
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
        NSString *shareStr = [NSString stringWithFormat:@"公司:%@\n电话:%@\n点击查看更多企业Al智能名片信息",self.detailModel.fullName,self.detailModel.contactsPhone];
        [self shareWebPageToPlatformType:platformType withTitle:self.detailModel.companyAbbreviation descr:shareStr url:url thumb:@""];
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withTitle:(NSString *)title descr:(NSString *)descr url:(NSString *)url thumb:(id)thumb
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:self.detailModel.companyLogo];
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

//#pragma mark - 禁止下拉
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGPoint offset = scrollView.contentOffset;
//    if (offset.y <= 0) {
//        offset.y = 0;
//    }
//    
//    scrollView.contentOffset = offset;
//    #pragma mark - 禁止上拉
//
//    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
//      scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height);
//      return;
//    }
//}
@end
