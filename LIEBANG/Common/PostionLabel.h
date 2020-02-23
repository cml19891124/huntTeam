//
//  PostionLabel.h
//  LIEBANG
//
//  Created by AUX on 2018/8/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostionLabel : UIView

@property (nonatomic,readonly)CGFloat postionWidth;

@property (nonatomic,strong)UIFont *font;

@property (nonatomic,assign) NSTextAlignment alignment;

@property (nonatomic,strong)UIColor *color;

@property (nonatomic,strong)NSString *userUid;

@property (nonatomic,assign)CGFloat labelWidth;

@property(nonatomic,copy)void(^GetWorkCertiImageViewBlock)(NSString *imageUrl);

- (void)setCompany:(NSString *)company postion:(NSString *)postion showIcon:(NSString *)showIcon;

@end
