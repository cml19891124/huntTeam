//
//  ShareModel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ShareModel.h"

@implementation ShareModel

/**
 分享
 */
+ (void)shareWithMessageObject:(UMSocialMessageObject *)messageObject
                       success:(void (^)(NSString *success))success
                       failure:(void (^)(NSString *errorStr))failure
{
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
//        [self shareWebPageToPlatformType:platformType];
        [self shareWebPageToPlatformType:platformType messageObject:messageObject];
    }];
}

+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType messageObject:(UMSocialMessageObject *)messageObject
{
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"22222222");
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                NSLog(@"11111111");
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

@end
