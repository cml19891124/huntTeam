//
//  HomeQuestionHeadView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface HomeQuestionHeadView : UIView

@property(nonatomic,copy)void(^meetButtonBlock)(void);
@property(nonatomic,copy)void(^questionButtonBlock)(void);
@property(nonatomic,copy)void(^moreQuestionButtonBlock)(void);
@property(nonatomic,copy)void(^companyMoreBlock)(void);
@property(nonatomic,copy)void(^companyBlock)(NSString *companyUid,BOOL isSelf);

@property (nonatomic,strong)HomeModel *model;

@end
