//
//  WebViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"


/**
 WebViewType的样式
 */
typedef enum{
    WebViewTypeHTTP                             = 0,//http链接
    WebViewTypeHTML                             = 1,//html字符串
    WebViewTypeUserProtocol                     = 2,//用户协议
}WebViewType;

@interface WebViewController : CommonViewController

@property (nonatomic,strong)NSString *contentString;

@property (nonatomic,strong)NSString *navTitle;

@property (nonatomic,assign)WebViewType webViewType;

@property (nonatomic,assign)BOOL isPresent;

@end
