//
//  ZJChooseShowView.m
//  ZJUIKit
//
//  Created by dzj on 2017/12/8.
//  Copyright © 2017年 kapokcloud. All rights reserved.
//

#import "ZJChooseShowView.h"

typedef enum : NSUInteger {
    ChooseViewShowOne,
    ChooseViewShowTwo,
    ChooseViewShowThree,
    ChooseViewShowFour
} ChooseViewShow;

@interface ZJChooseShowView()<ZJOneChildViewDelegate,ZJTwoChildViewDelegate,ZJThreeChildViewDelegate,ZJFourChildViewDelegate>


@property(nonatomic ,strong) ZJTwoChildView         *twoView;
@property(nonatomic ,strong) ZJThreeChildView       *threeView;
@property(nonatomic ,strong) ZJThreeChildView       *threeViewV;
@property(nonatomic ,strong) ZJFourChildView        *fourView;
@property(nonatomic ,strong) NSArray                *viewArray;
// 记录弹出的是哪一个视图
@property(nonatomic ,assign) ChooseViewShow         chooseView;
@property(nonatomic ,strong) UIButton               *seleBtn;

//@property(nonatomic ,strong) NSArray                *twoTitleArr;
@property(nonatomic ,strong) NSArray                *threeTitleArr;
@property(nonatomic ,strong) NSArray                *threeVTitleArr;

@property(nonatomic ,strong) NSArray                *btnArr;

@end

@implementation ZJChooseShowView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpAllView];
        
    }
    return self;
}

-(void)setUpAllView{
    self.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.0];
    
    self.threeTitleArr = @[@"全部",@"全国通话",@"线下约见"];
    self.threeVTitleArr = @[@"帮助最多",@"评分最高",@"价格最低"];
    self.viewArray = @[self.oneView,self.twoView,self.threeView,self.fourView,self.threeViewV];
    [self addSubview:self.hiddenView];
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideViewAction:)];
    [self.hiddenView addGestureRecognizer:tap];
}



// set oneView leftdata
-(void)setAllMerAreaArr:(NSArray *)allMerAreaArr{
    _allMerAreaArr = allMerAreaArr;
    self.oneView.leftDataArray = allMerAreaArr;

}
// set oneView rightData
-(void)setChildMerArr:(NSArray *)childMerArr{
    _childMerArr = childMerArr;
    self.oneView.rightDataArray = childMerArr;
}

// set twoView leftData
-(void)setMerCateArray:(NSArray *)merCateArray{
    
    _merCateArray = merCateArray;
    self.twoView.dataArray = (NSMutableArray *)merCateArray;
}

// set twoView rightData
-(void)setTwoLeftIndex:(NSInteger)twoLeftIndex{
    _twoLeftIndex = twoLeftIndex;
    self.twoView.leftSeleIndex = twoLeftIndex + 1;
}

// set twoView Selected Index
-(void)setTwoRightIndex:(NSInteger)twoRightIndex{
    _twoRightIndex = twoRightIndex;
    if (twoRightIndex>0) {
        self.twoView.rightSeleIndex = twoRightIndex;
    }else{
        self.twoView.rightSeleIndex = 0;
    }
}

#pragma mark - 子视图的回调
-(void)oneViewLeftTableviewDidSelectedWithLeftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex{

}


-(void)oneViewRightTableviewDidSelectedWithLeftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex{
    
    ClassModel *model = [self.allClassModel.data safeObjectAtIndex:leftIndex];
    ClassifyTwoModel *twoModel = [model.classifyTwo safeObjectAtIndex:rightIndex];
    
    if ([twoModel.classify isEqualToString:@"全部"]) {
        [self.seleBtn setTitle:model.classify forState:UIControlStateNormal];
    }
    else {
        [self.seleBtn setTitle:twoModel.classify forState:UIControlStateNormal];
    }
    
    [self hideViewAction:nil];
    if ([self.delegate respondsToSelector:@selector(chooseOneViewWithTableLeftIndex:rightIndex:)]) {
        [self.delegate chooseOneViewWithTableLeftIndex:leftIndex rightIndex:rightIndex];
    }
}

-(void)twoViewLeftTableDidSelectedWithIndex:(NSInteger)index{

    
}

-(void)twoViewRightTableDidSelectedWithLeftIndex:(NSInteger)LeftIndex rightIndex:(NSInteger)rightIndex mcid:(NSString *)mc_id{

    if (rightIndex == 0) {
//        [self.seleBtn setTitle:@"" forState:UIControlStateNormal];
    }else{
//        [self.seleBtn setTitle:@"" forState:UIControlStateNormal];
    }
    [self hideViewAction:nil];
    if ([self.delegate respondsToSelector:@selector(chooseTwoViewCellDidSelectedWithLeftIndex:rightIndex:mcid:)]) {
        [self.delegate chooseTwoViewCellDidSelectedWithLeftIndex:LeftIndex rightIndex:rightIndex mcid:mc_id];
    }
}


-(void)threeViewTableviewDidSelectedWithIndex:(NSInteger)index{
    
    if (self.btnArr.count == 3) {
        if (self.seleBtn.tag == 1) {
            [self.seleBtn setTitle:self.threeTitleArr[index] forState:UIControlStateNormal];
            [self hideViewAction:nil];
            if ([self.delegate respondsToSelector:@selector(chooseThreeViewCellDidSelectedWithIndex:)]) {
                [self.delegate chooseThreeViewCellDidSelectedWithIndex:index];
            }
        } else if (self.seleBtn.tag == 2) {
            [self.seleBtn setTitle:self.threeVTitleArr[index] forState:UIControlStateNormal];
            [self hideViewAction:nil];
            if ([self.delegate respondsToSelector:@selector(chooseThreeViewVCellDidSelectedWithIndex:)]) {
                [self.delegate chooseThreeViewVCellDidSelectedWithIndex:index];
            }
        }
    } else if (self.btnArr.count == 2) {
        [self.seleBtn setTitle:self.threeVTitleArr[index] forState:UIControlStateNormal];
        [self hideViewAction:nil];
        if ([self.delegate respondsToSelector:@selector(chooseThreeViewCellDidSelectedWithIndex:)]) {
            [self.delegate chooseThreeViewCellDidSelectedWithIndex:index];
        }
    }
}

-(void)fourViewBtnSelectedWithIsProm:(BOOL)isprom isVer:(BOOL)isVer{
    [self hideViewAction:nil];
    
    if ([self.delegate respondsToSelector:@selector(chooseFourViewBtnResultWithIsProm:isVer:)]) {
        [self.delegate chooseFourViewBtnResultWithIsProm:isprom isVer:isVer];
    }
}


#pragma mark - 隐藏当前视图
-(void)hideViewAction:(UITapGestureRecognizer *)gesture{
    
    // 改变按钮的状态
    self.seleBtn.selected = !self.seleBtn.isSelected;
    // 隐藏视图
    switch (self.chooseView) {
        case 0:
            [self hideOneView];
            break;
        case 1:
            [self hideTwoView];
            break;
        case 2:
            [self hideThreeView];
            break;
        case 3:
            [self hideFourView];
            break;
        default:
            break;
    }
    
}

#pragma mark -  点击筛选按钮
-(void)chooseControlViewBtnArray:(NSArray *)btnArr Action:(UIButton *)sender{
    self.seleBtn = sender;
    self.btnArr = btnArr;
    for (int i = 0; i<btnArr.count; i++) {
        UIButton *btn = btnArr[i];
        if (btn.tag == sender.tag) {
            
        }else{
            
            btn.selected = NO;
        }
    }
    self.chooseView = sender.tag;
    switch (sender.tag) {
        case 0:
        {
            if (sender.selected) {
                [self hideOtherChilView:self.oneView];
                [self showOneView];
            }else{
                [self hideOneView];
            }
        }
            break;
        case 1:
            if (sender.selected) {
                [self hideOtherChilView:self.twoView];
                [self showTwoView];
            }else{
                [self hideTwoView];
            }
            break;
        case 2:
            if (sender.selected) {
                [self hideOtherChilView:self.threeView];
                [self showThreeView];
            }else{
                [self hideThreeView];
            }
            break;
        case 3:
            if (sender.selected) {
                [self hideOtherChilView:self.fourView];
                [self showFourView];
            }else{
                [self hideFourView];
            }
            break;
            
        default:
            break;
    }
}

-(void)chooseQuestionControlViewBtnArray:(NSArray *)btnArr Action:(UIButton *)sender {
    self.btnArr = btnArr;
    self.seleBtn = sender;
    for (int i = 0; i<btnArr.count; i++) {
        UIButton *btn = btnArr[i];
        if (btn.tag == sender.tag) {
            
        }else{
            btn.selected = NO;
        }
    }
    self.chooseView = sender.tag;
    
    switch (sender.tag) {
        case 0:
        {
            if (sender.selected) {
                [self hideOtherChilView:self.oneView];
                [self showOneView];
            }else{
                [self hideOneView];
            }
        }
            break;
        case 1:
        {
            if (sender.selected) {
                [self hideOtherChilView:self.threeView];
                [self showThreeViewV];
            }else{
                [self hideThreeViewV];
            }
            break;
        }
            break;
        default:
            break;
    }
}

-(void)chooseThemeControlViewBtnArray:(NSArray *)btnArr Action:(UIButton *)sender {
    self.btnArr = btnArr;
    self.seleBtn = sender;
    for (int i = 0; i<btnArr.count; i++) {
        UIButton *btn = btnArr[i];
        if (btn.tag == sender.tag) {
            
        }else{
            
            btn.selected = NO;
        }
    }
    self.chooseView = sender.tag;
    
    switch (sender.tag) {
        case 0:
        {
            if (sender.selected) {
                [self hideOtherChilView:self.oneView];
                [self showOneView];
            }else{
                [self hideOneView];
            }
        }
            break;
        case 1:
        {
            if (sender.selected) {
                [self hideOtherChilView:self.threeView];
                [self showThreeView];
            }else{
                [self hideThreeView];
            }
            break;
        }
            break;
        case 2:
        {
            if (sender.selected) {
                [self hideOtherChilView:self.threeView];
                [self showThreeViewV];
            }else{
                [self hideThreeViewV];
            }
            break;
        }
            break;
        default:
            break;
    }
}

-(void)hideOtherOneChilViewArray:(NSArray *)btnArr Action:(UIButton *)sender {
    self.btnArr = btnArr;
    self.seleBtn = sender;
    self.seleBtn.selected = YES;
    for (int i = 0; i<btnArr.count; i++) {
        UIButton *btn = btnArr[i];
        if (btn.tag == sender.tag) {
            
        }else{
            btn.selected = NO;
        }
    }
    self.chooseView = sender.tag;
    
    [self hideOtherChilView:self.oneView];
    [self showOneView];
}

#pragma mark - 隐藏其他视图
-(void)hideOtherChilView:(UIView *)view{
    
    for (int i = 0; i<self.viewArray.count; i++) {
        UIView *childView = self.viewArray[i];
        if (view == childView) {
            
        }else{
            childView.hidden = YES;
            childView.frame = CGRectMake(0, 0, kDeviceWidth, 0);
            for (UITableView *tabView in childView.subviews) {
                tabView.frame = CGRectMake(0, 0, kDeviceWidth, 0);
            }
        }
    }
    
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.oneView.isHidden) {
        CGFloat hiddY = CGRectGetMaxY(self.oneView.frame);
        self.hiddenView.frame = CGRectMake(0, hiddY, kDeviceWidth, kDeviceHeight - hiddY);
    }else if (self.twoView.isHidden){
        CGFloat hiddY = CGRectGetMaxY(self.twoView.frame);
        self.hiddenView.frame = CGRectMake(0, hiddY, kDeviceWidth, kDeviceHeight - hiddY);
    }else if (self.threeView.isHidden){
        CGFloat hiddY = CGRectGetMaxY(self.threeView.frame);
        self.hiddenView.frame = CGRectMake(0, hiddY, kDeviceWidth, kDeviceHeight - hiddY);
    }else if (self.fourView.isHidden){
        CGFloat hiddY = CGRectGetMaxY(self.fourView.frame);
        self.hiddenView.frame = CGRectMake(0, hiddY, kDeviceWidth, kDeviceHeight - hiddY);
    }else if (self.threeViewV.isHidden){
        CGFloat hiddY = CGRectGetMaxY(self.threeViewV.frame);
        self.hiddenView.frame = CGRectMake(0, hiddY, kDeviceWidth, kDeviceHeight - hiddY);
    }
}

#pragma mark - OneView
-(void)showOneView{
    
    self.oneView.leftSeleIndex = self.oneLeftIndex;
    self.oneView.rightSeleIndex = self.oneRightIndex;
    self.oneView.classModel = self.allClassModel;
    [self addSubview:self.oneView];
    _oneView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
//        CGFloat height = kDeviceHeight * 0.55;
        CGFloat height = kDeviceHeight-kViewHeight-kNavBarHeight-kCurrentWidth(100);
        self.oneView.frame = CGRectMake(0, 0, kDeviceWidth, height+10);
        self.oneView.topView.frame = CGRectMake(0, 0, kDeviceWidth, 10);
        self.oneView.leftTable.frame = CGRectMake(0, 10, kCurrentWidth(115), height);
        self.oneView.rightTable.frame = CGRectMake(kCurrentWidth(115), 10, kDeviceWidth-kCurrentWidth(115), height);
        self.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.3];
        
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:self.oneRightIndex inSection:0];
        [self.oneView.rightTable scrollToRowAtIndexPath:scrollIndexPath
                               atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideOneView{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 animations:^{
        self.oneView.frame = CGRectMake(0, 0, kDeviceWidth, 0);
        self.oneView.topView.frame = CGRectMake(0, 0, kDeviceWidth, 0);
        self.oneView.leftTable.frame = CGRectMake(0, 0, kCurrentWidth(115), 0);
        self.oneView.rightTable.frame = CGRectMake(kCurrentWidth(115), 0, kDeviceWidth-kCurrentWidth(115), 0);
    } completion:^(BOOL finished) {
        self.oneView.hidden = YES;
        self.hidden = YES;
    }];
}

#pragma mark - twoView
-(void)showTwoView{
    
    [self addSubview:self.twoView];
    _twoView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat height = kDeviceHeight * 0.5;
//        CGFloat height = kDeviceHeight-kViewHeight-kNavBarHeight-kCurrentWidth(100);
        _twoView.frame = CGRectMake(0, 0, kDeviceWidth, height);
        _twoView.leftTable.frame = CGRectMake(0, 0, kDeviceWidth/2, height);
        _twoView.rightTable.frame = CGRectMake(kDeviceWidth/2, 0, kDeviceWidth/2, height);
        
        self.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.3];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideTwoView{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 animations:^{
        _twoView.frame = CGRectMake(0, 0, kDeviceWidth, 0);
        _twoView.leftTable.frame = CGRectMake(0, 0, kDeviceWidth/2, 0);
        _twoView.rightTable.frame = CGRectMake(kDeviceWidth/2, 0, kDeviceWidth/2, 0);
        
    } completion:^(BOOL finished) {
        _twoView.hidden = YES;
        self.hidden = YES;
    }];
}


#pragma mark - ThreeView
-(void)showThreeView{
    
    [self addSubview:self.threeView];
    _threeView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _threeView.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(44)*3+10);
        _threeView.topView.frame = CGRectMake(0, 0, kDeviceWidth, 10);
        _threeView.mainTable.frame = CGRectMake(0, 10, kDeviceWidth, kCurrentWidth(44)*3);
        self.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.3];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideThreeView{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 animations:^{
        _threeView.frame = CGRectMake(0, 0, kDeviceWidth, 0);
        _threeView.topView.frame = CGRectMake(0, 0, kDeviceWidth, 0);
        _threeView.mainTable.frame = CGRectMake(0, 0, kDeviceWidth, 0);
    } completion:^(BOOL finished) {
        _threeView.hidden = YES;
        self.hidden = YES;
    }];
}

-(void)showThreeViewV{
    
    [self addSubview:self.threeViewV];
    _threeViewV.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _threeViewV.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(44)*3+10);
        _threeViewV.topView.frame = CGRectMake(0, 0, kDeviceWidth, 10);
        _threeViewV.mainTable.frame = CGRectMake(0, 10, kDeviceWidth, kCurrentWidth(44)*3);
        self.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.3];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideThreeViewV{
    [self hideThreeView];
//    self.backgroundColor = [UIColor clearColor];
//    [UIView animateWithDuration:0.25 animations:^{
//        _threeViewV.frame = CGRectMake(0, 0, kDeviceWidth, 0);
//        _threeViewV.topView.frame = CGRectMake(0, 0, kDeviceWidth, 0);
//        _threeViewV.mainTable.frame = CGRectMake(0, 0, kDeviceWidth, 0);
//    } completion:^(BOOL finished) {
//        _threeViewV.hidden = YES;
//        self.hidden = YES;
//    }];
}

#pragma mark - FourView
-(void)showFourView{
    
    [self addSubview:self.fourView];
    _fourView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _fourView.frame = CGRectMake(0, 0, kDeviceWidth, 145);
        
        self.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.3];
    } completion:^(BOOL finished) {
        for (UIView *view in self.fourView.subviews) {
            view.hidden = NO;
        }
    }];
}

-(void)hideFourView{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25 animations:^{
        _fourView.frame = CGRectMake(0, 0, kDeviceWidth, 0);
        for (UIView *view in self.fourView.subviews) {
            view.hidden = YES;
        }
    } completion:^(BOOL finished) {
        _fourView.hidden = YES;
        self.hidden = YES;
    }];
}


-(ZJOneChildView *)oneView{
    if (!_oneView) {
        _oneView = [[ZJOneChildView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
        _oneView.hidden = YES;
        _oneView.backgroundColor = kWhiteColor;
        _oneView.delegate = self;
        
    }
    return _oneView;
}

-(ZJTwoChildView *)twoView{
    if (!_twoView) {
        _twoView = [[ZJTwoChildView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
        _twoView.hidden = YES;
        _twoView.delegate = self;
        _twoView.backgroundColor = kWhiteColor;
    }
    return _twoView;
}

-(ZJThreeChildView *)threeView{
    if (!_threeView) {
        _threeView = [[ZJThreeChildView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
        _threeView.hidden = YES;
        _threeView.delegate = self;
        _threeView.titleArray = self.threeTitleArr;
        _threeView.backgroundColor = kWhiteColor;
        _threeView.seleIndex = 0;
    }
    return _threeView;
}

-(ZJThreeChildView *)threeViewV{
    if (!_threeViewV) {
        _threeViewV = [[ZJThreeChildView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
        _threeViewV.hidden = YES;
        _threeViewV.delegate = self;
        _threeViewV.titleArray = self.threeVTitleArr;
        _threeViewV.backgroundColor = kWhiteColor;
        _threeViewV.seleIndex = 99;
    }
    return _threeViewV;
}

-(ZJFourChildView *)fourView{
    if (!_fourView) {
        _fourView = [[ZJFourChildView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
        _fourView.hidden = YES;
        _fourView.delegate = self;
        _fourView.backgroundColor = kWhiteColor;
    }
    return _fourView;
}
-(UIView *)hiddenView{
    if (!_hiddenView) {
        _hiddenView = [[UIView alloc]init];
    }
    return _hiddenView;
}

- (NSArray *)btnArr {
    if (!_btnArr) {
        _btnArr = [NSArray array];
    }
    return _btnArr;
}

@end
