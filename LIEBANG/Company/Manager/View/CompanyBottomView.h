//
//  CompanyFootView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CompanyBottomView : UIView

@property(nonatomic,copy)void(^editButtonBlock)(void);
@property(nonatomic,copy)void(^selectButtonBlock)(BOOL select);

- (instancetype)initWith:(CGFloat)top;

@property (nonatomic,assign)BOOL footHidden;

@end

NS_ASSUME_NONNULL_END
