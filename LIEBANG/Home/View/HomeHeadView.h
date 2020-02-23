//
//  HomeHeadView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "HW3DBannerView.h"

@interface HomeHeadView : UIView

@property(nonatomic,copy)void(^homeButtonBlock)(NSInteger buttonIndex);

//@property (nonatomic,strong)HW3DBannerView *bannerView;
@property(nonatomic,copy)void(^bannerBlock)(NSInteger buttonIndex);
@property (nonatomic,strong)HomeModel *model;

@end
