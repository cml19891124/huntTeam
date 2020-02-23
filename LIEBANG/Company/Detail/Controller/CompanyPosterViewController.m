//
//  CompanyPosterViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/2.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "CompanyPosterViewController.h"
#import "CompanyHeadView.h"
#import "CompanyPosterCell.h"
#import "HMScannerController.h"

@interface CompanyPosterViewController ()

@property (nonatomic,strong)CompanyHeadView *headView;

@end

@implementation CompanyPosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"企业海报";
    self.view.backgroundColor = kWhiteColor;
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kWhiteColor;
    self.groupTableView.tableHeaderView = self.headView;
    [self.view addSubview:self.groupTableView];
    
    
}

#pragma mark
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    static NSString *cellStr = @"CompanyPosterCell";
    CompanyPosterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[CompanyPosterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.saveCompanyPosterBlock = ^{
        [weakSelf saveCompanyPoster];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(120);
}

#pragma mark
#pragma mark Event
- (void)saveCompanyPoster {
    [self actionForScreenShotWith:self.headView savePhoto:YES];
}

/// 截屏
- (void)actionForScreenShotWith:(UIView *)aimView savePhoto:(BOOL)savePhoto {
    
    if (!aimView) return;

    UIGraphicsBeginImageContextWithOptions(aimView.bounds.size, NO, 0.0f);
    [aimView.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (savePhoto) {
        /// 保存到本地相册
        [self displayOverFlowActivityView];
        UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    [self removeOverFlowActivityView];
    if (error) {
        [self presentSheet:@"保存失败，请重试"];
    } else {
        [self presentSheet:@"保存成功"];
    }
}

#pragma mark
#pragma mark 懒加载
- (CompanyHeadView *)headView {
    if (!_headView) {
        _headView = [[CompanyHeadView alloc] init];
        _headView.isCompanyPoster = YES;
        _headView.detailModel = self.companyModel;
    }
    return _headView;
}

@end
