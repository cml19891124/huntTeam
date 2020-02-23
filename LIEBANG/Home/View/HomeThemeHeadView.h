//
//  HomeThemeHeadView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface HomeThemeHeadView : UIView

@property (nonatomic,strong)HomeModel *model;

@property(nonatomic,copy)void(^bannerBlock)(NSInteger buttonIndex);

@end
