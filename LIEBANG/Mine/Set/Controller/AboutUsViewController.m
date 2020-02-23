//
//  AboutUsViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UserHelpViewController.h"
#import "AboutLBViewController.h"
#import<StoreKit/StoreKit.h>

@interface AboutUsViewController ()

@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UIImageView *logo;
@property (nonatomic,strong)UILabel *versionLabel;

@property (nonatomic,strong)YYLabel *useLabel;
@property (nonatomic,strong)YYLabel *webLabel;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于猎帮";
    self.view.backgroundColor = kBackgroundColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    self.groupTableView.tableHeaderView = self.headView;
    [self.view addSubview:self.groupTableView];
    
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSString *title = @"官方网站";
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
//    [text yy_setUnderlineStyle:NSUnderlineStyleSingle range:[title rangeOfString:title]];
//    [text yy_setUnderlineColor:kLBRedColor range:[title rangeOfString:title]];
    [text yy_setFont:kSystem(14) range:[title rangeOfString:title]];
    [text yy_setTextHighlightRange:[title rangeOfString:title] color:kLBRedColor backgroundColor:kClearColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        WebViewController *nextCtr = [[WebViewController alloc] init];
        nextCtr.webViewType = WebViewTypeHTTP;
        nextCtr.contentString = @"http://www.liebangapp.com";
        nextCtr.navTitle = @"猎帮官网";
        [self.navigationController pushViewController:nextCtr animated:YES];
    }];
    
    _webLabel = [YYLabel new];
    _webLabel.userInteractionEnabled = YES;
    _webLabel.numberOfLines = 0;
    _webLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _webLabel.frame = CGRectMake(0, kDeviceHeight-kNavBarHeight-kCurrentWidth(40)-kViewHeight, kDeviceWidth/2-3, kCurrentWidth(15));
    _webLabel.font = kSystem(15);
    _webLabel.textColor = kLBRedColor;
    _webLabel.attributedText = text;
    _webLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_webLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((kDeviceWidth-0.5)/2, kDeviceHeight-kNavBarHeight-kCurrentWidth(40)-kViewHeight, 1, kCurrentWidth(15))];
    lineView.backgroundColor = kLBRedColor;
    [self.view addSubview:lineView];
    
    NSMutableAttributedString *text1 = [NSMutableAttributedString new];
    NSString *title1 = @"用户协议";
    [text1 appendAttributedString:[[NSAttributedString alloc] initWithString:title1 attributes:nil]];
//    [text1 yy_setUnderlineStyle:NSUnderlineStyleSingle range:[title1 rangeOfString:title1]];
//    [text1 yy_setUnderlineColor:kLBRedColor range:[title1 rangeOfString:title1]];
    [text1 yy_setFont:kSystem(14) range:[title rangeOfString:title]];
    [text1 yy_setTextHighlightRange:[title1 rangeOfString:title1] color:kLBRedColor backgroundColor:kClearColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        WebViewController *nextCtr = [[WebViewController alloc] init];
        nextCtr.webViewType = WebViewTypeUserProtocol;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }];
    
    _useLabel = [YYLabel new];
    _useLabel.userInteractionEnabled = YES;
    _useLabel.numberOfLines = 0;
    _useLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _useLabel.frame = CGRectMake(kDeviceWidth/2+3, kDeviceHeight-kNavBarHeight-kCurrentWidth(40)-kViewHeight, kDeviceWidth/2-3, kCurrentWidth(15));
    _useLabel.font = kSystem(15);
    _useLabel.textColor = kLBRedColor;
    _useLabel.attributedText = text1;
    [self.view addSubview:_useLabel];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LBForProject currentProject].aboutCellTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellStr = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.text = [[LBForProject currentProject].aboutCellTitleArray safeObjectAtIndex:indexPath.row];
    cell.textLabel.textColor = kLBBlackColor;
    cell.textLabel.font = kSystem(15);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            AboutLBViewController *nextCtr = [[AboutLBViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        case 1:
        {
//            [self presentSheet:@"开发中"];
            [self addAppReview];
        }
            break;
        case 2:
        {
            UserHelpViewController *nextCtr = [[UserHelpViewController alloc] init];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 给应用好评
- (void)addAppReview{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"喜欢APP 么?给个五星好评吧亲!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //跳转APPStore 中应用的撰写评价页面
    UIAlertAction *review = [UIAlertAction actionWithTitle:@"我要吐槽" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *appReviewUrl = [NSURL URLWithString:[NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",kAppId]];//换成你应用的 APPID
        CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
        if (version >= 10.0) {
            /// 大于等于10.0系统使用此openURL方法
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:appReviewUrl options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
            }
        }else{
            [[UIApplication sharedApplication] openURL:appReviewUrl];
        }
    }];
    //不做任何操作
    UIAlertAction *noReview = [UIAlertAction actionWithTitle:@"用用再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertVC removeFromParentViewController];
    }];
    
    [alertVC addAction:review];
    [alertVC addAction:noReview];
    //判断系统,是否添加五星好评的入口
    if (@available(iOS 10.3, *)) {
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
            UIAlertAction *fiveStar = [UIAlertAction actionWithTitle:@"五星好评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication].keyWindow endEditing:YES];
                [SKStoreReviewController requestReview];
                NSURL *appReviewUrl = [NSURL URLWithString:[NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",kAppId]];//换成你应用的 APPID
                CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
                if (version >= 10.0) {
                    /// 大于等于10.0系统使用此openURL方法
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:appReviewUrl options:@{} completionHandler:nil];
                    } else {
                        // Fallback on earlier versions
                    }
                }else{
                    [[UIApplication sharedApplication] openURL:appReviewUrl];
                }
            }];
            [alertVC addAction:fiveStar];
        }
    } else {
        // Fallback on earlier versions
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertVC animated:YES completion:nil];
    });
}

#pragma mark HeadView
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(204))];
        [_headView addSubview:self.logo];
        [_headView addSubview:self.versionLabel];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
