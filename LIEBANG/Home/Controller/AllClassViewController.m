//
//  AllClassViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AllClassViewController.h"
#import "ClassListViewController.h"
#import "ClassCell.h"
#import "ClassHeadView.h"
#import "ClassSelectView.h"
#import "HomeService.h"
#import "AllClassModel.h"

@interface AllClassViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)AllClassModel *classModel;
@property (nonatomic,strong)AllClassModel *allClassModel;
@property (nonatomic,strong)ClassSelectView *selectView;

@end

@implementation AllClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
    [self loadAllClassDataSource];
    [self loadAllOtherClassDataSource];
    [self reloadSelectHeight];
}

#pragma mark DataSource
- (void)loadAllClassDataSource {

    [self displayOverFlowActivityView];
    [HomeService getAllClassWithParameters:nil success:^(AllClassModel *model) {
        [self removeOverFlowActivityView];
        self.classModel = model;
        
        for (ClassModel *model in self.classModel.data) {
            for (ClassifyTwoModel *twoModel in model.classifyTwo) {
                for (NSString *classify in self.IDdataSource) {
                    NSLog(@"classify = %@",classify);
                    if ([twoModel.id isEqualToString:classify]) {
                        twoModel.isClick = YES;
                    }
                }
            }
        }
        
        [self.collectionView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)loadAllOtherClassDataSource {
    
    [HomeService getAllClassWithParameters:nil success:^(AllClassModel *model) {
        self.allClassModel = model;
        
        for (ClassModel *model in self.allClassModel.data) {
            ClassifyTwoModel *dto = [[ClassifyTwoModel alloc] init];
            dto.id = nil;
            dto.classify = @"全部";
            ClassifyTwoModel *model1 = [model.classifyTwo safeObjectAtIndex:0];
            if (![model1.classify isEqualToString:@"全部"]) {
                [model.classifyTwo insertObject:dto atIndex:0];
            }
        }
        
    } failure:^(NSUInteger code, NSString *errorStr) {
        
    }];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.classModel.data.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    ClassModel *model = [self.classModel.data safeObjectAtIndex:section];
    return model.classifyTwo.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassModel *model = [self.classModel.data safeObjectAtIndex:indexPath.section];
    ClassifyTwoModel *twoModel = [model.classifyTwo safeObjectAtIndex:indexPath.row];
    ClassCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ClassCell" forIndexPath:indexPath];
    cell.classifyTwoModel = twoModel;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kDeviceWidth-kCurrentWidth(24)-1.5)/4, kCurrentWidth(40));
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, kCurrentWidth(12), 0, kCurrentWidth(12));
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    ClassModel *model = [self.classModel.data safeObjectAtIndex:indexPath.section];
    ClassHeadView* reusableView;
    if (kind==UICollectionElementKindSectionHeader)
    {
        reusableView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ClassHeadView" forIndexPath:indexPath];
    }
    reusableView.model = model;
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kDeviceWidth, kCurrentWidth(37));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.classState == AllClassStateNormal)
    {
        ClassListViewController *nextCtr = [[ClassListViewController alloc] init];
        nextCtr.isQuestion = self.isQuestion;
        nextCtr.classModel = self.allClassModel;
        nextCtr.classifyIndex = indexPath.section;
        nextCtr.classify2Index = indexPath.row;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if (self.classState == AllClassStateSelected)
    {
        
        ClassModel *model = [self.classModel.data safeObjectAtIndex:indexPath.section];
        ClassifyTwoModel *twoModel = [model.classifyTwo safeObjectAtIndex:indexPath.row];
        
        if (twoModel.isClick)
        {
            if ([self.dataSource containsObject:twoModel.classify] && [self.IDdataSource containsObject:twoModel.id]) {
                NSLog(@"移除职业标签");
                [self.dataSource removeObject:twoModel.classify];
                [self.IDdataSource removeObject:twoModel.id];
                twoModel.isClick = NO;
            }
        }
        else
        {
            if (![self.dataSource containsObject:twoModel.classify] || ![self.IDdataSource containsObject:twoModel.id]) {
                if (self.dataSource.count >= 3) {
                    [self presentSheet:@"选择标签不能超过3个"];
                    return;
                }
                
                [self.dataSource addObject:twoModel.classify];
                [self.IDdataSource addObject:twoModel.id];
                twoModel.isClick = YES;
            }
        }
        
        [self reloadSelectHeight];
    }
}

- (void)reloadSelectHeight {

    _selectView.titleArray = self.dataSource;
    
    if (self.dataSource.count == 0)
    {
        self.collectionView.top = 0;
        self.collectionView.height = kDeviceHeight-kNavBarHeight-kViewHeight;
    }
    else
    {
        self.collectionView.top = _selectView.bottom;
        self.collectionView.height = kDeviceHeight-kNavBarHeight-_selectView.bottom-kViewHeight;
    }
    [self.collectionView reloadData];
}

#pragma mark Event
- (void)saveDataSource {
    
    if (IsArrEmpty(self.dataSource))
    {
        if (_saveLabelBlock) {
            _saveLabelBlock(nil,nil);
        }
    }
    else
    {
        if (_saveLabelBlock) {
            _saveLabelBlock([self.dataSource componentsJoinedByString:@","],[self.IDdataSource componentsJoinedByString:@","]);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 界面布局
- (void)createSubViews {
    
    self.view.backgroundColor = kBackgroundColor;
    self.navigationItem.title = @"全部分类";
    
    if (self.classState == AllClassStateNormal)
    {
        self.collectionView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
    }
    else if (self.classState == AllClassStateSelected)
    {
        WeakSelf;
        _selectView = [[ClassSelectView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
        _selectView.removeObjectBlock = ^(NSInteger objectIndex) {

            for (ClassModel *model in weakSelf.classModel.data) {
                for (ClassifyTwoModel *twoModel in model.classifyTwo) {
                    NSString *classify = [weakSelf.IDdataSource safeObjectAtIndex:objectIndex];
                    if ([twoModel.id isEqualToString:classify]) {
                        twoModel.isClick = NO;
                    }
                }
            }
            [weakSelf.dataSource removeObjectAtIndex:objectIndex];
            [weakSelf.IDdataSource removeObjectAtIndex:objectIndex];
            [weakSelf reloadSelectHeight];
        };
        [self.view addSubview:_selectView];
        
        self.collectionView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
        [self setRightNaviBtnTitle:@"保存"];
        [self.rightNaviBtn addTarget:self action:@selector(saveDataSource) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:self.collectionView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 0.5;
        layout.minimumLineSpacing = 0.5;
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight) collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(kCurrentWidth(1), 0, kCurrentWidth(20), 0);
        _collectionView.backgroundColor = kBackgroundColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ClassCell class] forCellWithReuseIdentifier:@"ClassCell"];
        [_collectionView registerClass:[ClassHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ClassHeadView"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)IDdataSource {
    if (!_IDdataSource) {
        _IDdataSource = [NSMutableArray array];
    }
    return _IDdataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
