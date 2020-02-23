//
//  EditExprienceFootView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/17.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditExprienceFootView : UIView

@property(nonatomic,copy)void(^deleteExperienceBlock)(void);
@property(nonatomic,copy)void(^saveExperienceBlock)(void);
@property (nonatomic,assign)EditExperienceState experienceState;

- (instancetype)initWithFrame:(CGRect)frame isEdit:(BOOL)isEdit;

@property (nonatomic,strong)NSString *describeInfo;

@end
