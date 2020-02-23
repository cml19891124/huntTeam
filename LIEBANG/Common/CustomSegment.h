//
//  CustomSegment.h
//  Storm
//
//  Created by 朱攀峰 on 15/12/18.
//  Copyright (c) 2015年 MCDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomSegment;
@protocol CustomSegmentDelegate <NSObject>

@optional
- (void)segment:(CustomSegment *)segment didSelectedAtIndex:(NSInteger)index;

@end

@interface CustomSegment : UIView

@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,weak)id<CustomSegmentDelegate>delegate;
@property (nonatomic,strong)NSArray *items;
@property (nonatomic,strong)NSArray *imageItems;
@property (nonatomic,strong)NSArray *selectItems;
@property (nonatomic,strong)UIColor *settingColor;
@property (nonatomic,assign)CGFloat selectedFont;
@property (nonatomic,assign)BOOL hasCenterLine;

@property (nonatomic,strong)UIImageView *bottomLine;

//有几个button可用，从左到右
- (void)setButtonsEnable:(NSInteger)count enable:(BOOL)enable;

- (void)setButtonTitle:(NSInteger)index title:(NSString *)title;
- (void)setinitCurrentIndex;

@end
