#import "SDCleanCaches.h"

#import "SetupViewController.h"
#import "AboutUsViewController.h"
#import "PrivacyViewController.h"
#import "SafeViewController.h"
#import "SDImageCache.h"
#import "MineService.h"
#import "SetClearCell.h"

@interface SetupViewController ()

@property (nonatomic,strong)UISwitch *notSwitch;
@property (nonatomic,strong)NSString *currentVolum;
@property (nonatomic,strong)UIButton *switchBtn;

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = kBackgroundColor;
    
    // 计算缓存大小
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    float size = [SDCleanCaches folderSizeAtPath:cachesDir];
    
    self.currentVolum = [NSString stringWithFormat:@"%@",[self fileSizeWithInterge:size]];
    NSLog(@"currentVolum == %@",self.currentVolum);
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [LBForProject currentProject].setCellTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[LBForProject currentProject].setCellTitleArray safeObjectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2 && indexPath.row == 1)
    {
        static NSString *cellStr = @"SetClearCell";
        SetClearCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[SetClearCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.currentVolum = self.currentVolum;
        return cell;
    }
    else
    {
        static NSString *cellStr = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.textLabel.text = [[[LBForProject currentProject].setCellTitleArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
        cell.textLabel.textColor = kLBBlackColor;
        cell.textLabel.font = kSystem(15);
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            cell.accessoryView = self.notSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
            _notSwitch.on = (setting.types != UIUserNotificationTypeNone);
            [self.notSwitch addSubview:self.switchBtn];
            self.switchBtn.frame = self.notSwitch.bounds;
            /*点击switch-->跳转到设置页 -->改变通知状态-->返回app刷新switch状态

            用户点击开关，switch的状态切换动画会与跳转到设置页的转场动画同时进行，而且会看到switch的状态切换，体验很不好。
            解决方案：
            在switch上放一个透明button，由button来处理用户事件，而switch只用于展示通知开闭状态*/
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            
        }
        else if (indexPath.row == 1)
        {
            AboutUsViewController *nextCtr = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else if (indexPath.row == 2)
        {
            PrivacyViewController *nextCtr = [[PrivacyViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
        [self shareClick];
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            SafeViewController *nextCtr = [[SafeViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else
        {
            UIAlertController *alert = [CHAlertView showMessageWith:@"确定" title:@"确定清除缓存数据?" confim:^{
//                [self displayOverFlowActivityView];
                [[SDWebImageManager sharedManager] cancelAll];
                #warning TODO
                // 计算缓存大小
                 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                 NSString *cachesDir = [paths objectAtIndex:0];
                  // 清理缓存
                 [SDCleanCaches clearCache:cachesDir];
                [self presentSheet:@"清除成功"];
                self.currentVolum = @"0k";
                [self.groupTableView reloadData];
//                [[SDWebImageManager sharedManager].imageCache clearMemory];
//                [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:^{
//                    [self removeOverFlowActivityView];
//                    [self presentSheet:@"清除成功"];
//                    self.currentVolum = @"0k";
//                    [self.groupTableView reloadData];
//                }];
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if (indexPath.section == 3)
    {
        UIAlertController *alert = [CHAlertView showMessageWith:@"退出登录" title:@"确定要退出登录?" confim:^{

            [self displayOverFlowActivityView];
            [MineService getLoginOutWithSuccess:^(NSString *info) {
                [self removeOverFlowActivityView];
                [SDUserTool deleteAccount];//清除本地数据
//                [self showAlertWithString:info];
                [Config currentConfig].balanceAmount = nil;
                [Config currentConfig].liebangCurrency = nil;
                [Config currentConfig].friendCount = nil;
                [Config currentConfig].userUid = nil;
                [Config currentConfig].username = nil;
                [Config currentConfig].headIcon = nil;
                [Config currentConfig].company = nil;
                [Config currentConfig].registrationID = nil;

                [[RCIM sharedRCIM] logout];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IS_PAY_COMPANY_NOTIFICATION" object:nil];
                
                LoginViewController *loginCtr = [[LoginViewController alloc] init];
                CommonNavgationViewController *loginNav = [[CommonNavgationViewController alloc] initWithRootViewController:loginCtr];
                [self.navigationController presentViewController:loginNav animated:YES completion:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [[AppDelegate currentAppDelegate].tabBarCtr tabBarSetSelectedIndex:0];
                }];
            } failure:^(NSUInteger code, NSString *errorStr) {
                [self removeOverFlowActivityView];
                [self presentSheet:errorStr];
            }];
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//计算出大小
- (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

#pragma mark 分享
- (void)shareClick {
    
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
    
    [UMSocialUIManager removeCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2];
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
//                                               @(UMSocialPlatformType_QQ),
//                                               @(UMSocialPlatformType_Sina),
                                               @(UMSocialPlatformType_UserDefine_Begin+3),
                                               ]];
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewTitleString = @"邀请好友加入猎帮";
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.shareTitleViewFont = kSystem(14);
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.shareCancelControlText = @"取消";
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageMaxRowCountForPortraitAndBottom = 3;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndBottom = 3;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
    }];
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    if (platformType == UMSocialPlatformType_UserDefine_Begin+3)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = kLIEBANGHTML;
        [self presentSheet:@"已获取到链接，请粘贴使用"];
    }
    else
    {
        [self shareWebPageToPlatformType:platformType withTitle:@"" descr:@"" url:kLIEBANGHTML thumb:@""];
    }
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withTitle:(NSString *)title descr:(NSString *)descr url:(NSString *)url thumb:(id)thumb
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"「猎帮」互联网知识分享平台，一个帮你赚钱的知识分享APP" descr:nil thumImage:[UIImage imageNamed:@"icon-60"]];
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


//iOS技术点:判断用户是否开启推送开关／是否允许推送
- (void)switchButtonClicked
{
    // 跳转到系统设置
    NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:settingURL options:[NSDictionary dictionary] completionHandler:nil];
    } else {//iOS10之前
        [[UIApplication sharedApplication] openURL:settingURL];
    }
}

#pragma mark UISwitch
- (UISwitch *)notSwitch {
    if (!_notSwitch) {
        _notSwitch = [[UISwitch alloc] init];
    }
    return _notSwitch;
}

- (UIButton *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [[UIButton alloc] initWithFrame:self.notSwitch.bounds];
        [_switchBtn addTarget:self action:@selector(switchButtonClicked) forControlEvents:UIControlEventTouchUpInside];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSwitch) name:UIApplicationWillEnterForegroundNotification object:nil];

    }
    return _switchBtn;
}
#pragma mark - 刷新通知显示状态
- (void) refreshSwitch {
  UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
  _notSwitch.on = (setting.types != UIUserNotificationTypeNone);
}
@end
