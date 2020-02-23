//
//  WorkCertiViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/7.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "WorkCertiViewController.h"
#import "PostCertSourceViewController.h"
#import "EditExperienceViewController.h"
#import "CertiExprienceCell.h"
#import "AccountService.h"
#import "WorkModel.h"
#import "CertiService.h"

#import "MosaicViewController.h"

@interface WorkCertiViewController ()

@property (nonatomic,strong)NSMutableArray *dataSource;

//@property (nonatomic,strong)NSMutableDictionary *sourceDic;

@end

@implementation WorkCertiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"职业经历认证";
    self.view.backgroundColor = kWhiteColor;
    
    self.tableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kCurrentWidth(105));
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = kSepparteLineColor;
    self.tableView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.tableView];
    
    if (self.workCertiState == WorkCertiStateNormal)
    {
        [self loadWorkDataSource];
    }
    else if (self.workCertiState == WorkCertiStateVerified)
    {
        [self loadAllWorkDataSource];
    }    
}

- (void)loadAllWorkDataSource {
    
    [self displayOverFlowActivityView];
    [CertiService getAllWorkResultWithSuccess:^(NSArray *info) {
        [self removeOverFlowActivityView];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:info];
        [self.tableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)loadWorkDataSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.workUid forKey:@"id"];
    
    [self displayOverFlowActivityView];
    [AccountService getWorkWithParameters:postDic success:^(WorkModel *model) {
        [self removeOverFlowActivityView];
        [self.dataSource removeAllObjects];
        [self.dataSource addObject:model];
        [self.tableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (NSMutableArray *)UidSource {
    NSMutableArray *list = [NSMutableArray array];
    for (WorkModel *model in self.dataSource) {
        if ((!IsStrEmpty(model.image) && !IsNilOrNull(model.image)) && (!IsStrEmpty(model.type) && !IsNilOrNull(model.type))) {
            if ([model.status intValue] != 1) {
                [list addObject:model.id];
            }
        }
    }
    return list;
}

- (NSMutableArray *)failSource {
    NSMutableArray *list1 = [NSMutableArray array];
    for (WorkModel *model in self.dataSource) {
        if ((!IsStrEmpty(model.image) && !IsNilOrNull(model.image)) && (!IsStrEmpty(model.type) && !IsNilOrNull(model.type))) {
            [list1 addObject:model.id];
        }
    }
    return list1;
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource.count >= 2) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (IsArrEmpty(self.dataSource)) {
        return 1;
    }
    else if (self.dataSource.count == 1) {
        return 1;
    }
    else {
        if (section == 0) {
            return 1;
        }
        else {
            return self.dataSource.count-1;
        }
    }
    
    return IsArrEmpty(self.dataSource)?1:self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    if (IsArrEmpty(self.dataSource))
    {
        static NSString *cellStr = @"CertiExprienceWorkCell";
        CertiExprienceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[CertiExprienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.certiState = CertiExprienceStateWorkNormal;
        cell.addCertiExprienceBlock = ^(CertiExprienceState certiState, NSIndexPath *indexPath) {
            [weakSelf addCertiExprienceEvent:certiState indexPath:indexPath];
        };
        return cell;
    }
    else
    {
        WorkModel *model = [WorkModel new];
        if (indexPath.section == 0) {
            model = [self.dataSource safeObjectAtIndex:indexPath.row];
        }
        else {
            model = [self.dataSource safeObjectAtIndex:indexPath.row+1];
        }

        static NSString *cellStr = @"CertiExprienceWorkCell";
        CertiExprienceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[CertiExprienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.indexPath = indexPath;
        [cell setWorkModel:model sourceDic:nil];
        cell.editCertiSourceBlock = ^(NSIndexPath *indexPath) {//更新工作经历认证材料
            [weakSelf editCertiSourceEvent:indexPath];
        };
        cell.addCertiExprienceBlock = ^(CertiExprienceState certiState, NSIndexPath *indexPath) {
            [weakSelf addCertiExprienceEvent:certiState indexPath:indexPath];
        };
        
        cell.GetCertiImageViewBlock = ^(NSString *imageUrl) {
            [weakSelf GetSourceBlockApi:imageUrl];
        };
        [cell setStatusAccess];
        UIView *lineV= UIView.new;
        
        lineV.backgroundColor = kSepparteLineColor;
        [cell.contentView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        if (indexPath.section == 0 || indexPath.row == 0) {
            lineV.hidden = YES;
        }else if(indexPath.section == 1 && indexPath.row == self.dataSource.count - 1){
            lineV.hidden = NO;
        }
        return cell;
    }
}

- (void)GetSourceBlockApi:(NSString *)imageUrl
{
//    if (self.GetSourceBlock) {
//        self.GetSourceBlock(imageUrl);
//    }
    
    MosaicViewController *nextCtr = [[MosaicViewController alloc] init];
    nextCtr.imageUrl = imageUrl;
    [self presentViewController:nextCtr animated:NO completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CertiExprienceCell *cell = (CertiExprienceCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 && self.dataSource.count >= 2) {
        return 10.f;
    }
    return 0.0000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return kCurrentWidth(34);
    return 34;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 && self.dataSource.count >= 2) {
        UIView *view = [UIView new];
        view.backgroundColor = kBackgroundColor;
        return view;
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        if (self.dataSource.count == 0 || IsArrEmpty(self.dataSource)) {
            return UIView.new;
        }else{
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(34)) title:@"当前职业"];
        headView.backgroundColor = kWhiteColor;
        return headView;
        }
    }
    else {
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(34)) title:@"工作经历"];
        headView.backgroundColor = kWhiteColor;
        return headView;
    }
}

#pragma mark Event
- (void)editCertiSourceEvent:(NSIndexPath *)indexPath {
    
    WorkModel *model = [WorkModel new];
    if (indexPath.section == 0) {
        model = [self.dataSource safeObjectAtIndex:indexPath.row];
    }
    else {
        model = [self.dataSource safeObjectAtIndex:indexPath.row+1];
    }
//    WorkModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    PostCertSourceViewController *nextCtr = [[PostCertSourceViewController alloc] init];
    nextCtr.certState = PostCertSourceStateWork;
    nextCtr.workModel = model;
    nextCtr.showSourceBlock = ^(NSDictionary *sourceDic) {
        if (self.workCertiState == WorkCertiStateNormal)
        {
            [self loadWorkDataSource];
        }
        else if (self.workCertiState == WorkCertiStateVerified)
        {
            [self loadAllWorkDataSource];
        }
//        self.sourceDic = sourceDic.mutableCopy;
//        [self.tableView reloadData];
    };
    [self pushViewController:nextCtr];
}

- (void)addCertiExprienceEvent:(CertiExprienceState)certiState indexPath:(NSIndexPath *)indexPath{
    
    
    if (certiState == CertiExprienceStateWorkNormal)
    {
        EditExperienceViewController *nextCtr = [[EditExperienceViewController alloc] init];
        nextCtr.refreshBlock = ^{
          [self loadAllWorkDataSource];
        };
        nextCtr.experienceState = EditExperienceStateWork;
        [self pushViewController:nextCtr];
    }
    else
    {
        WorkModel *model = [WorkModel new];
        if (indexPath.section == 0) {
            model = [self.dataSource safeObjectAtIndex:indexPath.row];
        }
        else {
            model = [self.dataSource safeObjectAtIndex:indexPath.row+1];
        }

        PostCertSourceViewController *nextCtr = [[PostCertSourceViewController alloc] init];
        nextCtr.certState = PostCertSourceStateWork;
        nextCtr.workModel = model;
        nextCtr.showSourceBlock = ^(NSDictionary *sourceDic) {
            if (self.workCertiState == WorkCertiStateNormal)
            {
                [self loadWorkDataSource];
            }
            else if (self.workCertiState == WorkCertiStateVerified)
            {
                [self loadAllWorkDataSource];
            }

        };
        [self pushViewController:nextCtr];
    }
}

- (void)pushViewController:(UIViewController *)ctrl {
    if (self.workCertiState == WorkCertiStateVerified) {
//        [((UIViewController *)self.view.superview.nextResponder).navigationController pushViewController:ctrl animated:YES];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else {
        if ([ctrl isKindOfClass:[PostCertSourceViewController class]]) {
            PostCertSourceViewController *nextCtr = (PostCertSourceViewController *)ctrl;
            nextCtr.isAccount = YES;
        }
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
