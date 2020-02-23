//
//  EducationCertiViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/7.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "EducationCertiViewController.h"
#import "PostCertSourceViewController.h"
#import "EditExperienceViewController.h"
#import "CertiExprienceCell.h"
#import "CertiService.h"
#import "AccountService.h"
#import "EducationModel.h"

#import "MosaicViewController.h"

@interface EducationCertiViewController ()

@property (nonatomic,strong)NSMutableArray *datsSource;

@end

@implementation EducationCertiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"教育经历认证";
    self.view.backgroundColor = kWhiteColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kCurrentWidth(105));
    self.groupTableView.backgroundColor = kWhiteColor;
//    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.groupTableView.separatorColor = kSepparteLineColor;
    [self.view addSubview:self.groupTableView];

}

- (instancetype)initWithEduCertiState:(EducationCertiState)eduCertiState
{
    self = [super init];
    if (self) {
        _eduCertiState = eduCertiState;

        [self loadAllEducationSource];
    }
    return self;
}

- (void)setEduCertiState:(EducationCertiState)eduCertiState
{
     if (self.eduCertiState == EducationCertiStateNormal)
    {
        [self loadEducationSource];
    }
    else if (self.eduCertiState == EducationCertiStateVerified)
    {
        [self loadAllEducationSource];
    }
}

- (void)loadAllEducationSource {
 
    [self displayOverFlowActivityView];
    [CertiService getAllEduResultWithSuccess:^(NSArray *info) {
        [self removeOverFlowActivityView];
        [self.datsSource removeAllObjects];
        [self.datsSource addObjectsFromArray:info];
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)loadEducationSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.eduUid forKey:@"id"];
    
    [self displayOverFlowActivityView];
    [AccountService getEducationWithParameters:postDic success:^(EducationModel *model) {
        [self removeOverFlowActivityView];
        [self.datsSource removeAllObjects];
        [self.datsSource addObject:model];
        
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (NSMutableArray *)UidSource {
    NSMutableArray *list = [NSMutableArray array];
    for (EducationModel *model in self.datsSource) {
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
    for (EducationModel *model in self.datsSource) {
        if ((!IsStrEmpty(model.image) && !IsNilOrNull(model.image)) && (!IsStrEmpty(model.type) && !IsNilOrNull(model.type))) {
            [list1 addObject:model.id];
        }
    }
    return list1;
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.datsSource.count >= 2) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (IsArrEmpty(self.datsSource) || self.datsSource.count == 1) {
        return 1;
    }
    else {
        if (section == 0) {
            return 1;
        }
        else {
            return self.datsSource.count-1;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        if (self.datsSource.count == 0 || IsArrEmpty(self.datsSource)) {
            return UIView.new;
        }else{
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(34)) title:@"当前教育"];
        headView.backgroundColor = kWhiteColor;
        return headView;
        }
    }
    else {
        
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(34)) title:@"教育经历"];
        headView.backgroundColor = kWhiteColor;

        return headView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kCurrentWidth(34);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 && self.datsSource.count >= 2) {
        return 10.f;
    }
    return 0.0000001;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 && self.datsSource.count >= 2) {
        UIView *view = [UIView new];
        view.backgroundColor = kBackgroundColor;
        return view;
    }
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    if (IsArrEmpty(self.datsSource))
    {
        static NSString *cellStr = @"CertiExprienceWorkCell";
        CertiExprienceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[CertiExprienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.certiState = CertiExprienceStateEduNormal;
        cell.addCertiExprienceBlock = ^(CertiExprienceState certiState, NSIndexPath *indexPath) {
            [weakSelf addCertiExprienceEvent:certiState indexPath:indexPath];
        };
        cell.indexPath = indexPath;
        return cell;
    }
    else
    {
        EducationModel *model = [self.datsSource safeObjectAtIndex:indexPath.row];
        static NSString *cellStr = @"CertiExprienceEduCell";
        CertiExprienceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[CertiExprienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        if (indexPath.section == 0) {
            model = [self.datsSource safeObjectAtIndex:indexPath.row];
        }
        else {
            model = [self.datsSource safeObjectAtIndex:indexPath.row+1];
        }
        
        cell.indexPath = indexPath;
        [cell setEducationModel:model sourceDic:nil];
        cell.editCertiSourceBlock = ^(NSIndexPath *indexPath) {
            NSIndexPath *indexP;
            if (indexPath.section != 0) {
                indexP = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
            }else{
                indexP = indexPath;
            }

            [weakSelf editCertiSourceEvent:indexP];
        };
        cell.addCertiExprienceBlock = ^(CertiExprienceState certiState, NSIndexPath *indexPath) {
            NSIndexPath *indexP;
            if (indexPath.section != 0) {
                indexP = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
            }else{
                indexP = indexPath;
            }
            [weakSelf addCertiExprienceEvent:certiState indexPath:indexP];
        };
        cell.GetCertiImageViewBlock = ^(NSString *imageUrl) {
            if (weakSelf.GetSourceBlock) {
                weakSelf.GetSourceBlock(imageUrl);
            }
            MosaicViewController *nextCtr = [[MosaicViewController alloc] init];
            nextCtr.imageUrl = imageUrl;
            [weakSelf presentViewController:nextCtr animated:NO completion:nil];
        };
        [cell setStatusAccess];
        
        UIView *lineV= UIView.new;
        lineV.backgroundColor = kSepparteLineColor;
        [cell.contentView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        if (indexPath.section == 2 || indexPath.row == self.datsSource.count - 1) {
            lineV.hidden = YES;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CertiExprienceCell *cell = (CertiExprienceCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

#pragma mark Event
- (void)editCertiSourceEvent:(NSIndexPath *)indexPath {
    EducationModel *model = [self.datsSource safeObjectAtIndex:indexPath.row];
    PostCertSourceViewController *nextCtr = [[PostCertSourceViewController alloc] init];
    nextCtr.educationModel = model;
    nextCtr.certState = PostCertSourceStateEducation;
    nextCtr.showSourceBlock = ^(NSDictionary *sourceDic) {
        if (self.eduCertiState == EducationCertiStateNormal)
        {
            [self loadEducationSource];
        }
        else if (self.eduCertiState == EducationCertiStateVerified)
        {
            [self loadAllEducationSource];
        }
//        self.sourceDic = sourceDic.mutableCopy;
//        [self.groupTableView reloadData];
    };
    [self pushViewController:nextCtr];
}

- (void)addCertiExprienceEvent:(CertiExprienceState)certiState indexPath:(NSIndexPath *)indexPath{
    
    
    if (certiState == CertiExprienceStateEduNormal)
    {
        EditExperienceViewController *nextCtr = [[EditExperienceViewController alloc] init];
        nextCtr.refreshBlock = ^{
            [self loadAllEducationSource];
        };
        nextCtr.experienceState = EditExperienceStateEducation;
        [self pushViewController:nextCtr];
    }
    else
    {
        EducationModel *model = [self.datsSource safeObjectAtIndex:indexPath.row];
        PostCertSourceViewController *nextCtr = [[PostCertSourceViewController alloc] init];
        nextCtr.certState = PostCertSourceStateEducation;
        nextCtr.educationModel = model;
        nextCtr.showSourceBlock = ^(NSDictionary *sourceDic) {
            if (self.eduCertiState == EducationCertiStateNormal)
            {
                [self loadEducationSource];
            }
            else if (self.eduCertiState == EducationCertiStateVerified)
            {
                [self loadAllEducationSource];
            }
        };
        [self pushViewController:nextCtr];
    }
}

- (void)pushViewController:(UIViewController *)ctrl {
    if (self.eduCertiState == EducationCertiStateVerified) {
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

- (NSMutableArray *)datsSource {
    if (!_datsSource) {
        _datsSource = [NSMutableArray array];
    }
    return _datsSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
