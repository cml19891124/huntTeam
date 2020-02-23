//
//  SectionHeadView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/11.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 SectionButtonState的样式
 */
typedef enum{
    SectionButtonStateNormel                          = 0,//正常
    SectionButtonStateBorder                          = 1,//边框
    SectionButtonStateDisable                         = 2,//Label
}SectionButtonState;

@interface SectionHeadView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@property(nonatomic,copy)void(^detailButtonBlock)(void);
@property (nonatomic,strong)NSString *buttonTitle;

@property (nonatomic,assign)SectionButtonState buttonState;

- (void)setExperienceView;

@end
