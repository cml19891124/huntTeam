//
//  WebViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "WebViewController.h"
#import "LoginService.h"

@interface WebViewController ()

@property (nonatomic,strong)WKWebView *detailWebView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    
    self.navigationItem.title = self.navTitle;
    [self loadDataSource];
    [self.view addSubview:self.detailWebView];
}

- (void)backNavItemTapped {
    if (self.isPresent) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
    else {
        [super backNavItemTapped];
    }
}

#pragma mark DataSource
- (void)loadDataSource {
    
    NSLog(@"self.data = %@",self.contentString);
    
    if (self.webViewType == WebViewTypeHTML)
    {
        [self.detailWebView loadHTMLString:self.contentString baseURL:nil];
    }
    else if (self.webViewType == WebViewTypeHTTP)
    {
        if (![self.contentString containsString:@"http"]) {
            self.contentString = [NSString stringWithFormat:@"http://%@",self.contentString];
        }
        [self.detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.contentString]]];
    }
    else if (self.webViewType == WebViewTypeUserProtocol)
    {
        self.navigationItem.title = @"用户协议";
        [self getUserProtocol];
    }
}

- (void)getUserProtocol {
    
    [self displayOverFlowActivityView];
    [LoginService getUserProtocolWithParametersSuccess:^(id object) {
        [self removeOverFlowActivityView];
        [self.detailWebView loadHTMLString:object baseURL:nil];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@",error);
}

#pragma mark UI
- (WKWebView *)detailWebView {
    if (!_detailWebView) {
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *wkController = [[WKUserContentController alloc] init];
        webConfig.userContentController = wkController;
        NSString *jsStr = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkScript = [[WKUserScript alloc] initWithSource:jsStr injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [wkController addUserScript:wkScript];

        _detailWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight) configuration:webConfig];
    }
    return _detailWebView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
