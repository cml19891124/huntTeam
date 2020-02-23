//
//  ZJChooseShowView.h
//  ZJUIKit
//
//  Created by dzj on 2017/12/8.
//  Copyright © 2017年 kapokcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllClassModel.h"
#import "ZJOneChildView.h"
#import "ZJTwoChildView.h"
#import "ZJThreeChildView.h"
#import "ZJFourChildView.h"
#import "ZJChooseModel.h"

/**
 *  ZJKitTool
 *
 *  GitHub地址：https://github.com/Dzhijian/ZJKitTool
 *
 *  本库会不断更新工具类，以及添加一些模块案例，请各位大神们多多指教，支持一下。😆
 */


@protocol ZJChooseShowViewDelegate <NSObject>

@optional

/**
 * 第一个View的选中事件

 @param leftIndex 选中的索引
 @param rightIndex 选中的索引
 */
-(void)chooseOneViewWithTableLeftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex;
/**
 * 第二个View的选中事件
 
 @param leftindex 选中的索引
 @param rightIndex 选中的索引
 */
-(void)chooseTwoViewCellDidSelectedWithLeftIndex:(NSInteger)leftindex rightIndex:(NSInteger)rightIndex mcid:(NSString *)mc_id;
/**
 * 第三个View的选中事件
 
 @param index 选中的索引
 */
-(void)chooseThreeViewCellDidSelectedWithIndex:(NSInteger)index;

/**
 * 第三个View的选中事件(副本)
 
 @param index 选中的索引
 */
-(void)chooseThreeViewVCellDidSelectedWithIndex:(NSInteger)index;

/**
 * 第四个View的选中事件

 */
-(void)chooseFourViewBtnResultWithIsProm:(BOOL)isprom isVer:(BOOL)isver;

@end

@interface ZJChooseShowView : UIView
@property(nonatomic ,strong) ZJOneChildView         *oneView;

// 按钮数组
@property(nonatomic ,strong) NSArray        *btnArray;
@property(nonatomic ,strong) UIView         *hiddenView;
@property(nonatomic ,strong) NSArray        *allMerAreaArr;
@property(nonatomic ,strong) NSArray        *childMerArr;
@property(nonatomic ,strong) NSArray        *merCateArray;
@property(nonatomic ,strong) NSArray        *childCateArr;
@property(nonatomic ,strong) AllClassModel  *allClassModel;

// 索引
@property(nonatomic ,assign) NSInteger      twoLeftIndex;
@property(nonatomic ,assign) NSInteger      twoRightIndex;

@property(nonatomic ,assign) NSInteger      oneLeftIndex;
@property(nonatomic ,assign) NSInteger      oneRightIndex;


@property(nonatomic ,weak) id<ZJChooseShowViewDelegate> delegate;

- (void)hideOtherOneChilViewArray:(NSArray *)btnArr Action:(UIButton *)sender;

/**
 * 初始化筛选View

 @param btnArr 标题数组
 @param sender 辩题按钮
 */
-(void)chooseControlViewBtnArray:(NSArray *)btnArr Action:(UIButton *)sender;

-(void)chooseQuestionControlViewBtnArray:(NSArray *)btnArr Action:(UIButton *)sender;

-(void)chooseThemeControlViewBtnArray:(NSArray *)btnArr Action:(UIButton *)sender;

@end
