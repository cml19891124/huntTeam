//
//  ThemeDetailViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ThemeDetailViewController.h"
#import "ReserveThemeViewController.h"
#import "AddThemeViewController.h"
#import "HomeMeetCell.h"
#import "ClassService.h"
#import "MeetCell.h"

@interface ThemeDetailViewController ()

@property (nonatomic,strong)UIButton *reserveButton;

@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIView *footView;

@end

@implementation ThemeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadThemeDataSource];
}

- (void)loadThemeDataSource {
    
    [self displayOverFlowActivityView];
    [ClassService getThemeDetailWithParameters:self.themeUid success:^(ThemeClassModel *model) {
        [self removeOverFlowActivityView];
        self.themeModel = model;
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)setThemeModel:(ThemeClassModel *)themeModel {
    _themeModel = themeModel;
    
    NSString *string = [NSString stringWithFormat:@"服务介绍:\n\n         %@",self.themeModel.serviceIn];
//    if (!IsNilOrNull(self.themeModel.remarks) && !IsStrEmpty(self.themeModel.remarks)) {
//        string = [NSString stringWithFormat:@"%@\n\n\n我想了解的学员信息:\n\n         %@",string,self.themeModel.remarks];
//    }
    CGSize size = [string sizeWithFont:kSystem(13) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(26), MAXFLOAT)];
    _label.text = string;
    
    _label.height = size.height;
    _footView.height = size.height+kCurrentWidth(30);
    
//    if ([themeModel.deletedState intValue] == 0) {
//        self.reserveButton.hidden = NO;
//    }
//    else {
//        self.reserveButton.hidden = YES;
//    }
}

#pragma mark Event
- (void)reserveButtonClick {
    
    if (self.detailState == ThemeDetailStateEdit)
    {
        AddThemeViewController *nextCtr = [[AddThemeViewController alloc] init];
        nextCtr.themeModel = self.themeModel;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if (self.detailState == ThemeDetailStateNormal)
    {
        if ([self.themeModel.isBasic intValue] != 1 || [self.themeModel.isEducation intValue] != 1 || [self.themeModel.isOccupation intValue] != 1) {
            [self showAlertWithString:@"TA还不是行家"];
            return;
        }
        ReserveThemeViewController *nextCtr = [[ReserveThemeViewController alloc] init];
        nextCtr.themeModel = self.themeModel;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}

#pragma mark UI
- (void)createSubViews {
    
    self.navigationItem.title = @"话题详情";
    self.view.backgroundColor = kBackgroundColor;
    
    [self setRightNaviBtnImage:[UIImage imageNamed:@"nav_button_share.png"]];
    [self.rightNaviBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    
    _reserveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _reserveButton.frame = CGRectMake(0, kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight, kDeviceWidth, kCurrentWidth(49));
    _reserveButton.backgroundColor = kLBRedColor;
    [_reserveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _reserveButton.titleLabel.font = kSystemBold(15);
    [_reserveButton addTarget:self action:@selector(reserveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_reserveButton];

    if (self.detailState == ThemeDetailStateEdit) {
        [_reserveButton setTitle:@"修改话题" forState:UIControlStateNormal];
    }
    else if (self.detailState == ThemeDetailStateNormal) {
        [_reserveButton setTitle:@"立即预约" forState:UIControlStateNormal];
    }
    
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), kCurrentWidth(15), kDeviceWidth-kCurrentWidth(26), 0)];
    _label.numberOfLines = 0;
    _label.font = kSystem(13);
    _label.textColor = kLBFiveColor;
    [_footView addSubview:_label];
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.tableFooterView = _footView;
    [self.view addSubview:self.groupTableView];
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
    NSString *url = [NSString stringWithFormat:@"http://liebangapp.com/share/#/topic?id=%@&userUid=%@",self.themeModel.id,[Config currentConfig].userUid];
    if (platformType == UMSocialPlatformType_UserDefine_Begin+2)
    {
        MyFriendViewController *nextCtr = [[MyFriendViewController alloc] init];
        WMContent *videoMessage = [WMContent messageWithContent:self.themeModel.topicName detailUid:self.themeModel.id detailType:@"2" shareUid:self.themeModel.userUid];
        nextCtr.shareMessage = videoMessage;
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
        if ([self.themeModel.serviceType intValue] == 0) {//0:线下约见 1：全国通话
            [self shareWebPageToPlatformType:platformType withTitle:self.themeModel.topicName descr:@"线下约见\n点击查看更多信息" url:url thumb:@""];
        }
        else {
            [self shareWebPageToPlatformType:platformType withTitle:self.themeModel.topicName descr:@"全国通话\n点击查看更多信息" url:url thumb:@""];
        }
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellStr = @"HomeMeetCell";
    MeetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[MeetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.themeClassModel = self.themeModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeetCell *cell = (MeetCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
