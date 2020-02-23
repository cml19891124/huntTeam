//
//  PostCertSourceViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/3.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PostCertSourceViewController.h"
#import "PostCertiView.h"
#import "CertiService.h"
#import "CertiResultViewController.h"
#import "CertificationLogic.h"

#import "MineService.h"

@interface PostCertSourceViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,HXCustomCameraViewControllerDelegate,HXAlbumListViewControllerDelegate,HXDatePhotoEditViewControllerDelegate>

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)PostCertiView *certView;
@property (nonatomic,strong)NSString *info;

@property (nonatomic,strong)NSMutableArray *fileNameArray;

@property (nonatomic,strong)UIImageView *selectButton;

@property (nonatomic,strong)NSMutableDictionary *fileDic;
@property (nonatomic,strong)NSArray *imageArray;//默认显示的图片
@property (nonatomic,strong)NSMutableArray *showArray;//显示后台加载的图片
@property (nonatomic,strong)NSMutableArray *fileArray;//本地选中的图片
@property (nonatomic,strong)NSMutableDictionary *showDic;
@property (nonatomic,assign)BOOL isModify;
@property (strong, nonatomic) HXPhotoManager *manager;

@end

@implementation PostCertSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.navigationItem.title = @"上传证明材料";
    
    [self setRightNaviBtnTitle:self.isAccount?@"提交审核":@"保存"];
    [self.rightNaviBtn addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadDataSource];
    [self createSubViews];

}

#pragma mark Event
- (void)nextButtonClick {
    
    if (self.isAccount)
    {
        if (self.certState == PostCertSourceStateWork)
        {
            [self certiWorkRequest];
        }
        else if (self.certState == PostCertSourceStateEducation)
        {
            [self certiEducationRequest];
        }
    }
    else
    {
//        if (IsArrEmpty(self.fileArray) && self.isModify) {
//            [self presentSheet:@"您未修改证明材料"];
//            return;
//        }
        for (NSString *imageUrl in self.showArray) {
            if (![imageUrl isKindOfClass:NSNull.class] && [imageUrl hasPrefix:@"http"]) {
                [self.fileArray addObject:imageUrl];
            }
        }
        if (IsArrEmpty(self.fileArray)) {
            [self presentSheet:@"请提交任一种证明材料"];
            return;
        }
        
//        if (IsArrEmpty(self.fileArray)) {
//            [self presentSheet:@"请提交任一种证明材料"];
//            return;
//        }

        NSString *imageStr;
        NSString *imageName = [self.fileNameArray safeObjectAtIndex:0];
        if ([imageName isEqualToString:@"visitingImage"]) {
            imageStr = @"3";//工作第一张
        }
        if ([imageName isEqualToString:@"licenseImage"]) {
            imageStr = @"5";//工作第三张
        }
        if ([imageName isEqualToString:@"workCardImage"]) {
            imageStr = @"6";//工作第四张
        }
        if ([imageName isEqualToString:@"certificateImage"]) {
            imageStr = @"4";//工作第二张
        }
        if ([imageName isEqualToString:@"degreeImage"]) {
            imageStr = @"1";//教育第一张
        }
        if ([imageName isEqualToString:@"diplomaImage"]) {
            imageStr = @"2";//教育第二张
        }
        
        NSArray *nameArr = @[@"image"];
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        [postDic setValue:IsStrEmpty(self.workModel.id)?self.educationModel.id:self.workModel.id forKey:@"authenticationId"];
        [postDic setValue:imageStr forKey:@"uploadType"];

        NSLog(@"上传审核的图片 == %@",postDic);
        
        [self displayOverFlowActivityView];
        [CertiService postCertiImageWithParameters:postDic file:self.fileArray fileName:nameArr success:^(NSString *info) {
            [self removeOverFlowActivityView];
            [self backNavItemTapped];
            if (self.showSourceBlock) {
                self.showSourceBlock(nil);
            }
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:@"保存失败"];
        }];
//        [self refreshImageDataSource];
//        [self backNavItemTapped];
    }
}

//刷新显示的图片资料
- (void)refreshImageDataSource {
    
    for (int i = 0; i < self.fileArray.count; i ++) {
        [self.fileDic setValue:[self.fileArray safeObjectAtIndex:i] forKey:[self.fileNameArray safeObjectAtIndex:i]];
    }
    
    NSArray *showNameArray = [self.showDic allKeys];
    for (int i = 0; i < showNameArray.count; i ++) {
        NSString *showkey = [showNameArray safeObjectAtIndex:i];
        for (int j = 0; j < self.fileNameArray.count; j++) {
            NSString *postKey = [self.fileNameArray safeObjectAtIndex:j];
            if ([showkey isEqualToString:postKey]) {
                [self.showDic setValue:[self.fileArray safeObjectAtIndex:j] forKey:showkey];
            }
        }
    }
    
    if (self.certState == PostCertSourceStateWork)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:self.showDic forKey:self.workModel.id];
        [[CertificationLogic currentCert].workDic setValue:self.fileDic forKey:self.workModel.id];
        if (_showSourceBlock) {
            _showSourceBlock(dic);
        }
    }
    else if (self.certState == PostCertSourceStateEducation)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:self.showDic forKey:self.educationModel.id];
        [[CertificationLogic currentCert].eduDic setValue:self.fileDic forKey:self.educationModel.id];
        if (_showSourceBlock) {
            _showSourceBlock(dic);
        }
    }
}

#pragma mark -  工作认证接口
- (void)certiWorkRequest {

    for (NSString *imageUrl in self.showArray) {
        if (![imageUrl isKindOfClass:NSNull.class] && [imageUrl hasPrefix:@"http"]) {
            [self.fileArray addObject:imageUrl];
        }
    }
    if (IsArrEmpty(self.fileArray)) {
        [self presentSheet:@"请提交任一种证明材料"];
        return;
    }
    
    NSLog(@"self.fileNameArray = %@",self.fileNameArray);
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.workModel.id forKey:@"id"];//审核的工作经历id

    [self displayOverFlowActivityView];
    [CertiService getCertiWorkWithParameters:postDic file:self.fileArray fileName:self.fileNameArray success:^(NSString *info) {
        [self removeOverFlowActivityView];
        CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
        nextCtr.certiResultCtrl = CertiResultCtrlNormal;
        nextCtr.message = [InsureValidate getCurrentTimes];
        [self.navigationController pushViewController:nextCtr animated:YES];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

//教育认证
- (void)certiEducationRequest {
    for (NSString *imageUrl in self.showArray) {
        if (![imageUrl isKindOfClass:NSNull.class] && [imageUrl hasPrefix:@"http"]) {
            [self.fileArray addObject:imageUrl];
        }
    }
    if (IsArrEmpty(self.fileArray)) {
        [self presentSheet:@"请提交任一种证明材料"];
        return;
    }
    
//    if (IsArrEmpty(self.showArray)) {
//        [self presentSheet:@"请提交任一种证明材料"];
//        return;
//    }
    
    NSLog(@"self.fileNameArray = %@",self.fileNameArray);
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.educationModel.id forKey:@"id"];//审核的教育经历id
    
    NSLog(@"教育认证postDic = %@",postDic);
    
    [self displayOverFlowActivityView];
    [CertiService getCertiEducationWithParameters:postDic file:self.fileArray fileName:self.fileNameArray success:^(NSString *info) {
        [self removeOverFlowActivityView];
        CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
        nextCtr.certiResultCtrl = CertiResultCtrlNormal;
        nextCtr.message = [InsureValidate getCurrentTimes];
        [self.navigationController pushViewController:nextCtr animated:YES];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];

}

//选择图片
- (void)PostCertiViewClick:(UITapGestureRecognizer *)sender {
    
    self.selectButton = (UIImageView *)sender.view;
    __weak typeof(self)weakSelf = self;
    self.certView.postCertiViewBlock = ^(NSInteger index) {
        [weakSelf.certView removeFromSuperview];
        [weakSelf showImageSelectController:index];
    };
    [self.view addSubview:self.certView];
    
    switch (self.selectButton.tag) {
        case 1:
        {
            if (self.certState == PostCertSourceStateWork)
            {
                self.certView.type = PostCertiViewCard;
                self.info = @"visitingImage";
            }
            else if (self.certState == PostCertSourceStateEducation)
            {
                self.certView.type = PostCertiViewDegree;
                self.info = @"degreeImage";
            }
        }
            break;
        case 2:
        {
            if (self.certState == PostCertSourceStateWork)
            {
                self.certView.type = PostCertiViewProof;
                self.info = @"certificateImage";
            }
            else if (self.certState == PostCertSourceStateEducation)
            {
                self.certView.type = PostCertiViewDiploma;
                self.info = @"diplomaImage";
            }
        }
            break;
        case 3:
        {
            self.certView.type = PostCertiViewLicense;
            self.info = @"licenseImage";
        }
            break;
        case 4:
        {
            self.certView.type = PostCertiViewWorkCard;
            self.info = @"workCardImage";
        }
            break;
        default:
            break;
    }
}

#pragma mark UI
- (void)loadDataSource {
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(49))];
    _titleLabel.textColor = kLBBlackColor;
    _titleLabel.font = kSystem(13);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    
    self.showArray = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil];
    if (self.certState == PostCertSourceStateWork)
    {
        _titleLabel.text = @"选择一下任一材料上传，证明你的职业身份";
        self.imageArray = @[@"img_mingpiancailiao",@"img_zaizhizzhengming",@"img_yingyezhizhao",@"img_gongpai"];//工作
        if ([self.workModel.visitingImage containsString:@"http"]) {
            [self.showArray replaceObjectAtIndex:0 withObject:self.workModel.visitingImage];
            [self.showDic setValue:self.workModel.visitingImage forKey:@"visitingImage"];
            self.info = @"visitingImage";
            [self.fileNameArray addObject:self.info];
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.workModel.visitingImage]]];
            [self.fileArray addObject:image];
            self.isModify = YES;
        }
        else {
            [self.showDic setValue:@"" forKey:@"visitingImage"];
            self.info = @"visitingImage";
            [self.fileNameArray addObject:self.info];
            [self.fileArray addObject:self.showDic];
        }
        if ([self.workModel.licenseImage containsString:@"http"]) {
            [self.showArray replaceObjectAtIndex:2 withObject:self.workModel.licenseImage];
            [self.showDic setValue:self.workModel.licenseImage forKey:@"licenseImage"];
            self.info = @"licenseImage";
            [self.fileNameArray addObject:self.info];
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.workModel.licenseImage]]];
            [self.fileArray addObject:image];
            self.isModify = YES;
        }
        else {
            [self.showDic setValue:@"" forKey:@"licenseImage"];
            self.info = @"licenseImage";
            [self.fileNameArray addObject:self.info];
            [self.fileArray addObject:self.showDic];
        }
        if ([self.workModel.workCardImage containsString:@"http"]) {
            [self.showArray replaceObjectAtIndex:3 withObject:self.workModel.workCardImage];
            [self.showDic setValue:self.workModel.workCardImage forKey:@"workCardImage"];
            self.info = @"workCardImage";
            [self.fileNameArray addObject:self.info];
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.workModel.workCardImage]]];
            [self.fileArray addObject:image];
            self.isModify = YES;
        }
        else {
            [self.showDic setValue:@"" forKey:@"workCardImage"];
            self.info = @"workCardImage";
            [self.fileNameArray addObject:self.info];
            [self.fileArray addObject:self.showDic];
        }
        if ([self.workModel.certificateImage containsString:@"http"]) {
            [self.showArray replaceObjectAtIndex:1 withObject:self.workModel.certificateImage];
            [self.showDic setValue:self.workModel.certificateImage forKey:@"certificateImage"];
            self.info = @"certificateImage";
            [self.fileNameArray addObject:self.info];
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.workModel.certificateImage]]];
            [self.fileArray addObject:image];
            self.isModify = YES;
        }
        else {
            [self.showDic setValue:@"" forKey:@"certificateImage"];
            self.info = @"certificateImage";
            [self.fileNameArray addObject:self.info];
            [self.fileArray addObject:self.showDic];

        }
    }
    else if (self.certState == PostCertSourceStateEducation)
    {
        _titleLabel.text = @"选择一下任一材料上传，证明你的教育经历";
        self.imageArray = @[@"img_xueweizheng",@"img_biyezheng"];//教育
        if ([self.educationModel.degreeImage containsString:@"http"]) {
            [self.showArray replaceObjectAtIndex:0 withObject:self.educationModel.degreeImage];
            [self.showDic setValue:self.educationModel.degreeImage forKey:@"degreeImage"];
            self.isModify = YES;
            self.info = @"degreeImage";
            [self.fileNameArray addObject:self.info];
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.educationModel.degreeImage]]];
            [self.fileArray addObject:image];
        }
        else {
            [self.showDic setValue:@"" forKey:@"degreeImage"];
            self.info = @"degreeImage";
            [self.fileNameArray addObject:self.info];
            [self.fileArray addObject:self.showDic];
        }
        if ([self.educationModel.DiplomaImage containsString:@"http"]) {
            [self.showArray replaceObjectAtIndex:1 withObject:self.educationModel.DiplomaImage];
            [self.showDic setValue:self.educationModel.DiplomaImage forKey:@"diplomaImage"];
            self.info = @"diplomaImage";
            [self.fileNameArray addObject:self.info];
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.educationModel.DiplomaImage]]];
            [self.fileArray addObject:image];
            self.isModify = YES;
        }
        else {
            [self.showDic setValue:@"" forKey:@"diplomaImage"];
            self.info = @"diplomaImage";
            [self.fileNameArray addObject:self.info];
            [self.fileArray addObject:self.showDic];
        }
    }
}

- (void)createSubViews {
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(285)+(self.imageArray.count/4)*kCurrentWidth(243), kDeviceWidth-kCurrentWidth(24), kCurrentWidth(49))];
    _detailLabel.text = @"注：上传材料，首次认证成功即可获得相应影响力";
    _detailLabel.textColor = kLBFiveColor;
    _detailLabel.font = kSystem(13);
    [self.view addSubview:_detailLabel];
    
    [self createButtonWithArray];
}

- (void)createButtonWithArray {
    
    CGFloat spaceWidth = kDeviceWidth - kCurrentWidth(364);
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView *sender = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12)+(kCurrentWidth(170)+spaceWidth)*(i%2), kCurrentWidth(55)+(i/2)*kCurrentWidth(243), kCurrentWidth(170), kCurrentWidth(230))];
        sender.contentMode = UIViewContentModeScaleAspectFit;
        sender.tag = 1+i;
        
        sender.userInteractionEnabled = YES;
        UITapGestureRecognizer *r5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PostCertiViewClick:)];
        [sender addGestureRecognizer:r5];
        [self.view addSubview:sender];
        
        NSString *imageString = [self.showArray safeObjectAtIndex:i];
        NSLog(@"imageString == %@",imageString);
        if (!IsStrEmpty(imageString) && !IsNilOrNull(imageString)) {
            [sender sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:[self.imageArray safeObjectAtIndex:i]]];
        }
        else {
            sender.image = [UIImage imageNamed:[self.imageArray safeObjectAtIndex:i]];
        }
    }
}

//refresh图片
- (void)refreshButtonImageView:(UIImage *)image {
    
    [self.fileNameArray removeAllObjects];
    [self.fileArray removeAllObjects];
    [self.fileNameArray addObject:self.info];
    [self.fileArray addObject:image];
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView *sender = [self.view viewWithTag:1+i];
        sender.image = [UIImage imageNamed:[self.imageArray safeObjectAtIndex:i]];
    }
    self.selectButton.image = image;
}

#pragma mark
#pragma mark 懒加载
- (PostCertiView *)certView {
    if (!_certView) {
        _certView = [[PostCertiView alloc] init];
    }
    return _certView;
}

- (NSMutableArray *)fileArray {
    if (!_fileArray) {
        _fileArray = [NSMutableArray array];
    }
    return _fileArray;
}

- (NSMutableArray *)fileNameArray {
    if (!_fileNameArray) {
        _fileNameArray = [NSMutableArray array];
    }
    return _fileNameArray;
}

- (NSMutableDictionary *)fileDic {
    if (!_fileDic) {
        _fileDic = [NSMutableDictionary dictionary];
    }
    return _fileDic;
}

- (NSMutableDictionary *)showDic {
    if (!_showDic) {
        _showDic = [NSMutableDictionary dictionary];
    }
    return _showDic;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.themeColor = [UIColor blackColor];
        _manager.configuration.singleSelected = YES;
    }
    return _manager;
}

#pragma mark 图片上传处理
- (void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model {
    if (self.manager.configuration.singleSelected) {
        if (model.type == HXPhotoModelMediaTypeCameraPhoto) {
            HXDatePhotoEditViewController *vc = [[HXDatePhotoEditViewController alloc] init];
            vc.delegate = self;
            vc.manager = self.manager;
            vc.model = model;
            [self.navigationController pushViewController:vc animated:NO];
        }
        return;
    }
}

#pragma mark - < HXDatePhotoEditViewControllerDelegate >
- (void)datePhotoEditViewControllerDidClipClick:(HXDatePhotoEditViewController *)datePhotoEditViewController beforeModel:(HXPhotoModel *)beforeModel afterModel:(HXPhotoModel *)afterModel
{
    [self reloadImageData:afterModel.previewPhoto];
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    HXPhotoModel *model = [photoList safeObjectAtIndex:0];
    [self reloadImageData:model.previewPhoto];
}

- (void)reloadImageData:(UIImage *)selectImage {
    
    UIImage *upImage = [UIImage imageWithRightOrientation:selectImage];
    [self refreshButtonImageView:upImage];
}

- (void)showImageSelectController:(NSInteger)index {
    if (index == 1) {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self showAlertWithString:@"此设备不支持相机!"];
            return;
        }
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在设置-隐私-相机中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
            return;
        }
        
        [self hx_presentCustomCameraViewControllerWithManager:self.manager delegate:self];
    }
    else if (index == 2) {
        [self hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
    }
}

- (void)dealloc {
    [self.manager clearSelectedList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
