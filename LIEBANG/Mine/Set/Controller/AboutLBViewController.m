#import <WebKit/WebKit.h>

#import "AboutLBViewController.h"

static NSArray *messageArray;
static NSArray *imageArray;
@interface AboutLBViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UIImageView *logo;
@property (nonatomic,strong)UILabel *versionLabel;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong) WKWebView *callWebView;

@end

@implementation AboutLBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于猎帮";
    self.view.backgroundColor = kBackgroundColor;
    
    messageArray = @[@"客服邮箱 liebangapp@126.com",@"客服电话 13510019677 (工作日09:00-18:00)"];
    imageArray = @[@"icon_youxiang",@"icon_kefudianhua"];
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.tableHeaderView = self.headView;
    [self.view addSubview:self.groupTableView];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
    cell.textLabel.text = [messageArray safeObjectAtIndex:indexPath.section];
    cell.imageView.image = [UIImage imageNamed:[imageArray safeObjectAtIndex:indexPath.section]];
    cell.textLabel.textColor = kLBBlackColor;
    cell.textLabel.font = kSystem(13);
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = @"liebangapp@126.com";
            [self showAlertWithString:@"已获取到猎帮官方客服邮箱，\n请粘贴使用"];
        }
            break;
        default:
        {
            [self callHotLine];
        }
            break;
    }
}

#pragma mark 打电话
- (void)callHotLine
{
    if ([self checkHardWareIsSupportCallHotLine]) {
        [self.callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel://13510019677"]]];
    } else {
        [self showAlertWithString:@"很抱歉，您的设备不支持拨打电话！\n 客服热线：13510019677"];
    }
}

- (BOOL)checkHardWareIsSupportCallHotLine
{
    BOOL isSupportTel = NO;
    NSURL *telURL = [NSURL URLWithString:@"tel://13510019677"];
    isSupportTel = [[UIApplication sharedApplication] canOpenURL:telURL];
    return isSupportTel;
}

- (WKWebView *)callWebView
{
    if (!_callWebView) {
        _callWebView = [[WKWebView alloc] init];
        // UI代理
        _callWebView.UIDelegate = self;
        // 导航代理
        _callWebView.navigationDelegate = self;
    }
    return _callWebView;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSURL *URL = navigationAction.request.URL;

    NSString *scheme = [URL scheme];

    if ([scheme isEqualToString:@"tel"]) {

    NSString *resourceSpecifier = [URL resourceSpecifier];

    NSString *callPhone = [NSString stringWithFormat:@"telprompt:%@", resourceSpecifier];

    /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];

    });

    }

    decisionHandler(WKNavigationActionPolicyAllow);

}

#pragma mark HeadView
- (UIView *)headView {
    if (!_headView) {
        
        if (isIphone4 || isIphone5) {
            _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(550))];
        }
        else {
            _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kViewHeight-kNavBarHeight-kCurrentWidth(88))];
        }
        
        [_headView addSubview:self.logo];
        [_headView addSubview:self.versionLabel];

        [_headView addSubview:self.messageLabel];
    }
    return _headView;
}

- (UIImageView *)logo {
    if (!_logo) {
        _logo = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(100))/2, kCurrentWidth(44), kCurrentWidth(100), kCurrentWidth(100))];
        _logo.image = [UIImage imageNamed:@"icon-60"];
        _logo.layer.cornerRadius = 20;
        _logo.layer.masksToBounds = YES;
    }
    return _logo;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCurrentWidth(156), kDeviceWidth, kCurrentWidth(15))];
        _versionLabel.text = [NSString stringWithFormat:@"V%@",app_Version];
        _versionLabel.textColor = kLBSixColor;
        _versionLabel.font = kSystem(13);
        _versionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _versionLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        NSString *str = @"「猎帮」APP-一个帮你知识变现的职场问答社区。致力于帮助1万职场人知识创业，获得灵活赚取收入的机会。帮助职场行家知识变现，实现副业创业；帮助职场年轻人获得有价值的职场知识经验，成就职业梦想；使用户与行家之间深度连接。你可以在App Store应用市场搜索下载「猎帮」\n\n在我们平台上，你可以实名认证成为行家，一键即可完成“知识店铺”和“Ai智能名片”搭建，行家可以发布擅长领域话题并定价出售，感兴趣的用户将会付费约问，行家将自己的知识、经验、见解分享给需要的用户。用户可以通过对行家“Ai智能名片”职业背景的认同，付费约问感兴趣的行家，选择“在线问答、线下约见、全国通话”三种方式，一对一获取专属解答。\n\n猎帮将持续为认证行家提供更多的IP展示机会，将行家宝贵的职场经验推荐给更多需要解答的用户，并通过用户给予行家服务的评价来建立长效信任机制，建立高效连接。";
        
        CGSize size = [str sizeWithFont:kSystem(13) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), MAXFLOAT)];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(156)+ kCurrentWidth(25), kDeviceWidth-kCurrentWidth(24), size.height)];
        _messageLabel.text = str;
        _messageLabel.textColor = kLBNineColor;
        _messageLabel.font = kSystem(13);
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
