//
//  EditAccountViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "EditAccountViewController.h"
#import "AllClassViewController.h"
#import "CertiResultViewController.h"
#import "EditAccountCell.h"
#import "MineService.h"

#import "AccountService.h"
#import "CertiService.h"

#import "PostCertiView.h"
#import "XFTreePopupView.h"
#import "CertiService.h"

#import "CZHAddressPickerView.h"

@interface EditAccountViewController ()<HXCustomCameraViewControllerDelegate,HXAlbumListViewControllerDelegate,HXDatePhotoEditViewControllerDelegate>

@property (nonatomic,strong)NSData *imageData;

@property (nonatomic,strong)PostCertiView *certView;

@property (nonatomic,strong)UIImage *headIcon;

@property (nonatomic,assign)BOOL type;

@property (strong, nonatomic) HXPhotoManager *manager;


@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *area;

@end

@implementation EditAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    
    if (self.editAccountCtrlState == EditAccountCtrlStateNormal)
    {
        self.navigationItem.title = @"编辑名片信息";
        self.view.backgroundColor = kBackgroundColor;
        
        [self setRightNaviBtnTitle:@"保存"];
        [self.rightNaviBtn addTarget:self action:@selector(saveDataSource) forControlEvents:UIControlEventTouchUpInside];
        
        [LBForProject currentProject].editCellTitleArray = @[@[@"头像",@"真实姓名",@"行业",@"职业标签",@"所在地区",@"详细地区"],@[@"手机号",@"邮箱"]];
        [self loadAccountDataSource];
    }
    else if (self.editAccountCtrlState == EditAccountCtrlStateVerified)
    {
        self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kCurrentWidth(105));
        WeakSelf;
        self.navigationItem.title = @"基础信息认证";
        self.view.backgroundColor = kBackgroundColor;
        self.footView = [[EditAccountFootView alloc] init];
        self.footView.isSaveButton = NO;
        self.footView.editSourceBlock = ^{
            [weakSelf editSourceClick];
        };
        self.footView.saveBasicMessageBlock = ^{
            [weakSelf saveBasicMessageToServer];
        };
        [self setRightNaviBtnTitle:@"提交审核"];
        [self.rightNaviBtn addTarget:self action:@selector(certiBasicRequestClick) forControlEvents:UIControlEventTouchUpInside];
        self.groupTableView.tableFooterView = self.footView;
        [LBForProject currentProject].editCellTitleArray = @[@[@"头像",@"真实姓名",@"行业",@"职业标签",@"所在地区",@"详细地区"],@[@"* 手机号",@"邮箱",@"微信号",@"* 身份证号"]];
        [Config currentConfig].enterAccount = @"enterAccount";
        [self loadBasicDataSource];
    }
    else if (self.editAccountCtrlState == EditAccountCtrlStateAccountVerified)
    {
        WeakSelf;
        self.navigationItem.title = @"基础信息认证";
        self.view.backgroundColor = kBackgroundColor;
        self.footView = [[EditAccountFootView alloc] init];
        self.footView.isSaveButton = YES;
        self.footView.editSourceBlock = ^{
            [weakSelf editSourceClick];
        };
        [self setRightNaviBtnTitle:@"提交审核"];
        [self.rightNaviBtn addTarget:self action:@selector(certiBasicRequestClick) forControlEvents:UIControlEventTouchUpInside];
        self.groupTableView.tableFooterView = self.footView;
        [LBForProject currentProject].editCellTitleArray = @[@[@"头像",@"真实姓名",@"行业",@"职业标签",@"所在地区",@"详细地区"],@[@"* 手机号",@"邮箱",@"微信号",@"* 身份证号"]];
        [Config currentConfig].enterAccount = nil;
        [self loadBasicDataSource];
    }
    
    [self.view addSubview:self.groupTableView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)loadBasicDataSource {
    
    [self displayOverFlowActivityView];
    [CertiService getBasicCertMessageWithSuccess:^(id info) {
        [self removeOverFlowActivityView];
        self.accountModel = info;
        
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *uidArray = [NSMutableArray array];
        for (OClassifyModel *dto in self.accountModel.classify) {
            [titleArray addObject:dto.classify];
            [uidArray addObject:dto.id];
        }
        
        if (!IsArrEmpty(titleArray)) {
            self.accountModel.userLabel = [titleArray componentsJoinedByString:@","];
        }
        if (!IsArrEmpty(uidArray)) {
            self.accountModel.userLabelUid = [uidArray componentsJoinedByString:@","];
        }
        
        if ([self.accountModel.status intValue] == 1) {
            self.footView.imageString = self.accountModel.userCardUrlmosaic;
        }
        else {
            self.footView.imageString = self.accountModel.userCardUrl;
        }
        
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)loadAccountDataSource {
    
    [self displayOverFlowActivityView];
    [MineService getAccountMessageWithSuccess:^(AccountModel *model) {
        [self removeOverFlowActivityView];
        self.accountModel = model;
        
        NSMutableArray *titleArray = [NSMutableArray array];
        NSMutableArray *uidArray = [NSMutableArray array];
        for (OClassifyModel *dto in self.accountModel.classify) {
            [titleArray addObject:dto.classify];
            [uidArray addObject:dto.id];
        }
        
        if (!IsArrEmpty(titleArray)) {
            self.accountModel.userLabel = [titleArray componentsJoinedByString:@","];
        }
        if (!IsArrEmpty(uidArray)) {
            self.accountModel.userLabelUid = [uidArray componentsJoinedByString:@","];
        }
        
        self.footView.imageString = model.userCardUrl;
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [LBForProject currentProject].editCellTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[LBForProject currentProject].editCellTitleArray safeObjectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    static NSString *cellStr = @"EditAccountCell";
    EditAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[EditAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.indexPath = indexPath;
    cell.accountModel = self.accountModel;
    cell.editMessageBlock = ^(NSInteger index, NSString *content) {
        [weakSelf getContentWith:index content:content];
    };
    cell.image = self.headIcon;
    if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 0) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.rowImage.hidden = NO;
    }else{
        cell.rowImage.hidden = YES;

        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.section == 1) {
        cell.rowImage.hidden = YES;

        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return kCurrentWidth(70);
        }
    }
    return kCurrentWidth(44);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.00001;
    }
    return 35.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 35.f) title:@"联系我们"];
        return headView;
    }
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        self.type = YES;
        self.manager.configuration.movableCropBoxCustomRatio = CGPointMake(kDeviceWidth, kDeviceWidth);
        [self showImageSelectController];
    }
    else if (indexPath.section == 0 && indexPath.row == 3)
    {
        WeakSelf;
        NSArray *titleArray = [self.accountModel.userLabel componentsSeparatedByString:@","];
        NSArray *uidArray = [self.accountModel.userLabelUid componentsSeparatedByString:@","];
        
        AllClassViewController *nextCtr = [[AllClassViewController alloc] init];
        nextCtr.classState = AllClassStateSelected;
        nextCtr.dataSource = titleArray.mutableCopy;
        nextCtr.IDdataSource = uidArray.mutableCopy;
        nextCtr.saveLabelBlock = ^(NSString *label, NSString *labelId) {
            weakSelf.accountModel.userLabelUid = labelId;
            weakSelf.accountModel.userLabel = label;
            NSLog(@" == %@ == %@",weakSelf.accountModel.userLabel,weakSelf.accountModel.userLabelUid);
            [weakSelf.groupTableView reloadData];
        };
        if (self.editAccountCtrlState == EditAccountCtrlStateVerified) {
//            [((UIViewController *)self.view.superview.nextResponder).navigationController pushViewController:nextCtr animated:YES];
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else {
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
    }
    else if (indexPath.section == 0 && indexPath.row == 4)
    {

        [CZHAddressPickerView cityPickerViewWithProvince:[[NSUserDefaults standardUserDefaults] objectForKey:@"province"]?:@"广东省" city:[[NSUserDefaults standardUserDefaults] objectForKey:@"city"]?:@"深圳市" cityBlock:^(NSString *province, NSString *city) {

                [[NSUserDefaults standardUserDefaults] setObject:province forKey:@"province"];
                [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"city"];
                [[NSUserDefaults standardUserDefaults] synchronize];;
//                [sender setTitle:[NSString stringWithFormat:@"%@%@",province,city] forState:UIControlStateNormal];
                self.accountModel.userWorkAddress = [NSString stringWithFormat:@"%@%@",province,city];
                [self.groupTableView reloadData];
            }];

        /*NSString *mainBundleDirectory=[[NSBundle mainBundle] bundlePath];
        NSString *path = [mainBundleDirectory stringByAppendingPathComponent:@"province.json"];
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        NSError *err;
        
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        
        XFTreePopupView *treeView = [[XFTreePopupView alloc] initWithDataSource:jsonArray Commit:^(NSArray *ret)
                                     {
                                         NSDictionary *dict1 = [ret safeObjectAtIndex:0];
                                         NSString *selectedStr1 = [dict1 objectForKey:@"name"];
                                         
                                         NSDictionary *dict2 = [ret safeObjectAtIndex:1];
                                         NSString *selectedStr2 = [dict2 objectForKey:@"name"];
                                         
                                         if (![selectedStr1 isEqualToString:selectedStr2]) {
                                             selectedStr1 = [selectedStr1 stringByAppendingString:selectedStr2];
                                         }
                                         self.accountModel.userWorkAddress = selectedStr1;
                                         [self.groupTableView reloadData];
                                     }];
        
        treeView.isHidden = NO;*/
    }
    else
    {
        NSInteger selectIndex = (indexPath.section)*10+indexPath.row+10;
        UITextField *textField = [self.view viewWithTag:selectIndex];
        [textField becomeFirstResponder];
    }
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
    [self reloadImageData:afterModel.previewPhoto type:self.type];
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    HXPhotoModel *model = [photoList safeObjectAtIndex:0];
    [self reloadImageData:model.previewPhoto type:self.type];
}

- (void)reloadImageData:(UIImage *)selectImage type:(BOOL)type {
    
    if (type)
    {
        UIImage *upImage = [UIImage imageWithRightOrientation:selectImage];
        self.imageData = UIImageJPEGRepresentation(upImage, 0.5);
        self.headIcon = upImage;
        [self.imageArray addObject:upImage];
        [self.fileArray addObject:@"userHead"];
        [self.groupTableView reloadData];
    }
    else
    {
        UIImage *upImage = [UIImage imageWithRightOrientation:selectImage];
        self.footView.image = upImage;
        [self.groupTableView reloadData];
    }
}

- (void)editSourceClick {
    self.type = NO;
//    self.manager.configuration.movableCropBoxCustomRatio = CGPointMake(kCurrentWidth(290), kCurrentWidth(173));
    self.manager.configuration.movableCropBoxCustomRatio = CGPointZero;
    self.manager.configuration.movableCropBox = NO;
    self.manager.configuration.movableCropBoxEditSize = NO;
    self.manager.configuration.supportRotation = YES;
    [self showImageSelectController];
}

- (void)showImageSelectController {
    UIAlertController *alert = [CHAlertView showSheetMessageWith:nil list:@[@"相机",@"相册"] confim:^(NSString *returnInfo) {
        if ([returnInfo isEqualToString:@"相机"]) {
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
        else if ([returnInfo isEqualToString:@"相册"]) {
            [self hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
        }
    }];
    if (self.editAccountCtrlState == EditAccountCtrlStateVerified) {
//        [(UIViewController *)self.view.superview.nextResponder presentViewController:alert animated:YES completion:nil];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)dealloc {
    [self.manager clearSelectedList];
    [Config currentConfig].enterAccount = nil;
}

#pragma mark Event
- (void)getContentWith:(NSInteger)index content:(NSString *)content {
    NSLog(@"index == %zd",index);
    
    switch (index) {
        case 11:
        {
            self.accountModel.userName = content;
        }
            break;
        case 12:
        {
            self.accountModel.userIndustry = content;
        }
            break;
        case 15:
        {
            self.accountModel.userDetailAddress = content;
        }
            break;
        case 20:
        {
            self.accountModel.phone = content;
        }
            break;
        case 21:
        {
            self.accountModel.userEmail = content;
        }
            break;
        case 22:
        {
            self.accountModel.weChatId = content;
        }
            break;
        case 23:
        {
            self.accountModel.userCardId = content;
        }
            break;
        default:
            break;
    }
}

- (void)saveBasicMessageToServer {
    
    for (int i = 0; i < 30; i ++) {
        UITextField *textField = [self.view viewWithTag:i];
        [textField resignFirstResponder];
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.accountModel.userName forKey:@"userName"];//
    [postDic setValue:self.accountModel.userLabelUid?:@"===" forKey:@"userLabelId"];//用户标签
    [postDic setValue:self.accountModel.userIndustry forKey:@"userIndustry"];//用户行业
    [postDic setValue:self.accountModel.userWorkAddress forKey:@"userWorkAddress"];//所在地址
    [postDic setValue:self.accountModel.userDetailAddress forKey:@"userDetailAddress"];//详细地址
    [postDic setValue:self.accountModel.userEmail forKey:@"userEmail"];//邮箱
    [postDic setValue:self.accountModel.weChatId forKey:@"weChatId"];//微信号
    [postDic setValue:self.accountModel.phone forKey:@"phone"];//微信号
    [postDic setValue:self.accountModel.userCardId forKey:@"userCardId"];//身份证号
    [postDic setValue:@"0" forKey:@"uploadType"];
    
    NSLog(@"保存基本信息提交认证 == %@",postDic);
    
    if (IsStrEmpty(self.accountModel.userName) || IsNilOrNull(self.accountModel.userName)) {
        [self showAlertWithString:@"请输入用户名"];
        return;
    }
    
    if (IsStrEmpty(self.accountModel.phone) || IsNilOrNull(self.accountModel.phone)) {
        [self showAlertWithString:@"请输入手机号"];
        return;
    }
    
    if (![InsureValidate validateMobile:self.accountModel.phone]) {
        [self showAlertWithString:@"请输入正确的手机号码"];
        return;
    }
    
    if (IsStrEmpty(self.accountModel.userCardId) || IsNilOrNull(self.accountModel.userCardId)) {
        [self showAlertWithString:@"请输入身份证号码"];
        return;
    }
    
//    if (IsStrEmpty(self.accountModel.userLabelUid) || IsNilOrNull(self.accountModel.userLabelUid)) {
//        [self showAlertWithString:@"请选择职业标签"];
//        return;
//    }
    
    if (![InsureValidate validateIDCardNumber:self.accountModel.userCardId]) {
        [self showAlertWithString:@"请输入正确身份证号码"];
        return;
    }
    
    if (!IsStrEmpty(self.accountModel.userEmail)) {
        if (![InsureValidate validateEmail:self.accountModel.userEmail]) {
            [self showAlertWithString:@"请输入正确的邮箱"];
            return;
        }
    }
    
    if (!IsNilOrNull(self.footView.image)) {
        if (![self.fileArray containsObject:@"image"]) {
            [self.imageArray addObject:self.footView.image];
            [self.fileArray addObject:@"image"];
        }
    }
    
    if (![self.accountModel.userCardUrl containsString:@"http"]) {
        if (![self.fileArray containsObject:@"image"]) {
            [self showAlertWithString:@"请上传手持身份证照片"];
            return;
        }
    }
    
    if (!IsNilOrNull(self.headIcon)) {
        if (![self.fileArray containsObject:@"userHead"]) {
            [self.imageArray addObject:self.headIcon];
            [self.fileArray addObject:@"userHead"];
        }
    }
    
    NSLog(@"self.fileArray == %@",self.fileArray);
    [self displayOverFlowActivityView];
    [CertiService postCertiImageWithParameters:postDic file:self.imageArray fileName:self.fileArray success:^(NSString *info) {
        [self removeOverFlowActivityView];
        [self presentSheet:@"保存成功"];
        
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:@"保存失败"];
    }];
}

- (void)saveDataSource {
    
    for (int i = 0; i < 30; i ++) {
        UITextField *textField = [self.view viewWithTag:i];
        [textField resignFirstResponder];
    }    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];

    [postDic setValue:IsStrEmpty(self.accountModel.userIndustry)?@"":self.accountModel.userIndustry forKey:@"userIndustry"];//用户行业
    [postDic setValue:IsStrEmpty(self.accountModel.userLabelUid)?@"":self.accountModel.userLabelUid forKey:@"userLabelId"];//用户职业标签
    [postDic setValue:IsStrEmpty(self.accountModel.userWorkAddress)?@"":self.accountModel.userWorkAddress forKey:@"userWorkAddress"];//用户所在地区
    [postDic setValue:IsStrEmpty(self.accountModel.userDetailAddress)?@"":self.accountModel.userDetailAddress forKey:@"userDetailAddress"];//用户详细地址
    [postDic setValue:IsStrEmpty(self.accountModel.userName)?@"":self.accountModel.userName forKey:@"userName"];
    [postDic setValue:IsStrEmpty(self.accountModel.userEmail)?@"":self.accountModel.userEmail forKey:@"userEmail"];
    [postDic setValue:IsStrEmpty(self.accountModel.phone)?@"":self.accountModel.phone forKey:@"phone"];//微信号
    
    if (IsStrEmpty(self.accountModel.userName) || IsNilOrNull(self.accountModel.userName)) {
        [self showAlertWithString:@"请输入用户名"];
        return;
    }
    
    if (!IsStrEmpty(self.accountModel.phone) && !IsNilOrNull(self.accountModel.phone)) {
        if (![InsureValidate validateMobile:self.accountModel.phone]) {
            [self showAlertWithString:@"请输入正确的手机号码"];
            return;
        }
    }
    
    if (!IsStrEmpty(self.accountModel.userEmail) && !IsNilOrNull(self.accountModel.userEmail)) {
        if (![InsureValidate validateEmail:self.accountModel.userEmail]) {
            [self showAlertWithString:@"请输入正确的邮箱"];
            return;
        }
    }
    
    NSLog(@"保存基本信息 == %@",postDic);
    [self displayOverFlowActivityView];
    [AccountService getEditAccountMessageWithParameters:postDic file:self.imageData fileName:@"userHead" success:^(id model) {
        [self removeOverFlowActivityView];
//        [self presentSheet:model];
//        [self performBlock:^{
            [self backNavItemTapped];
//        } afterDelay:1.5];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)certiBasicRequestClick {
    [self certiBasicRequest:YES];
}

- (void)certiBasicRequest:(BOOL)loading {

    for (int i = 0; i < 30; i ++) {
        UITextField *textField = [self.view viewWithTag:i];
        [textField resignFirstResponder];
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.accountModel.userName forKey:@"userName"];//
    [postDic setValue:self.accountModel.userLabelUid forKey:@"userLabelId"];//用户标签
    [postDic setValue:self.accountModel.userIndustry forKey:@"userIndustry"];//用户行业
    [postDic setValue:self.accountModel.userWorkAddress forKey:@"userWorkAddress"];//所在地址
    [postDic setValue:self.accountModel.userDetailAddress forKey:@"userDetailAddress"];//详细地址
    [postDic setValue:self.accountModel.userEmail forKey:@"userEmail"];//邮箱
    [postDic setValue:self.accountModel.weChatId forKey:@"weChatId"];//微信号
    [postDic setValue:self.accountModel.phone forKey:@"phone"];//微信号
    [postDic setValue:self.accountModel.userCardId forKey:@"userCardId"];//身份证号
    
    NSLog(@"基本信息提交认证 == %@",postDic);
    
    if (IsStrEmpty(self.accountModel.userName) || IsNilOrNull(self.accountModel.userName)) {
        [self showAlertWithString:@"请输入用户名"];
        return;
    }
    
    if (IsStrEmpty(self.accountModel.userLabelUid) || IsNilOrNull(self.accountModel.userLabelUid)) {
        [self showAlertWithString:@"请选择职业标签"];
        return;
    }
    
    if (IsStrEmpty(self.accountModel.phone) || IsNilOrNull(self.accountModel.phone)) {
        if (loading) {
            [self showAlertWithString:@"请输入手机号"];
        }
        else {
            if (_certErrorMessageBlock) {
                _certErrorMessageBlock(@"请输入手机号");
            }
        }
        return;
    }
    
    if (![InsureValidate validateMobile:self.accountModel.phone]) {
        if (loading) {
            [self showAlertWithString:@"请输入正确的手机号码"];
        }
        else {
            if (_certErrorMessageBlock) {
                _certErrorMessageBlock(@"请输入正确的手机号码");
            }
        }
        return;
    }
    
    if (IsStrEmpty(self.accountModel.userCardId) || IsNilOrNull(self.accountModel.userCardId)) {
        if (loading) {
            [self showAlertWithString:@"请输入身份证号码"];
        }
        else {
            if (_certErrorMessageBlock) {
                _certErrorMessageBlock(@"请输入身份证号码");
            }
        }
        return;
    }

    if (![InsureValidate validateIDCardNumber:self.accountModel.userCardId]) {
        if (loading) {
            [self showAlertWithString:@"请输入正确身份证号码"];
        }
        else {
            if (_certErrorMessageBlock) {
                _certErrorMessageBlock(@"请输入正确身份证号码");
            }
        }
        return;
    }
    
    if (!IsStrEmpty(self.accountModel.userEmail)) {
        if (![InsureValidate validateEmail:self.accountModel.userEmail]) {
            if (loading) {
                [self showAlertWithString:@"请输入正确的邮箱"];
            }
            else {
                if (_certErrorMessageBlock) {
                    _certErrorMessageBlock(@"请输入正确的邮箱");
                }
            }
            return;
        }
    }
    
    if (!IsNilOrNull(self.footView.image)) {
        if (![self.fileArray containsObject:@"userCardUrl"]) {
//            if (loading) {
//                [self showAlertWithString:@"请上传手持身份证照片"];
//            }
//            else {
//                if (_certErrorMessageBlock) {
//                    _certErrorMessageBlock(@"请上传手持身份证照片");
//                }
//            }
            [self.fileArray addObject:@"userCardUrl"];
            [self.imageArray addObject:self.footView.image];
//            [self showAlertWithString:@"请上传手持身份证照片"];
//
//            return;
        }
    }
    
    if (self.footView.image) {
        if (![self.fileArray containsObject:@"userCardUrl"]) {
            [self.imageArray addObject:self.footView.image];
            [self.fileArray addObject:@"userCardUrl"];
//            if (loading) {
//                [self showAlertWithString:@"请上传手持身份证照片"];
//            }
//            else {
//                if (_certErrorMessageBlock) {
//                    _certErrorMessageBlock(@"请上传手持身份证照片");
//                }
//            }
//            return;
        }
    }

    if (![self.accountModel.userCardUrl containsString:@"http"]) {
        if (![self.fileArray containsObject:@"userCardUrl"]) {
            if (loading) {
                [self showAlertWithString:@"请上传手持身份证照片"];
            }
            else {
                if (_certErrorMessageBlock) {
                    _certErrorMessageBlock(@"请上传手持身份证照片");
                }
            }
            return;
        }
    }

    if (loading) {
        [self displayOverFlowActivityView];
    }
    else {
        if (_certErrorMessageBlock) {
            _certErrorMessageBlock(@"displayOverFlowActivityView");
        }
    }
    [CertiService getCertiBasicWithParameters:postDic file:self.imageArray fileName:self.fileArray success:^(NSString *info) {
        [self removeOverFlowActivityView];
        
        if (loading)
        {
//            [self presentSheet:info];
            [self performBlock:^{

                CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
                nextCtr.certiResultCtrl = CertiResultCtrlNormal;

                nextCtr.message = [InsureValidate getCurrentTimes];
                [self.navigationController pushViewController:nextCtr animated:YES];
            } afterDelay:1.5];
        }
        else
        {
            if (self.certFinshMessageBlock) {
                self.certFinshMessageBlock(@"上传成功");
            }
        }
    } failure:^(NSUInteger code, NSString *errorStr) {
//        [self removeOverFlowActivityView];
        
        if (loading)
        {
            [self presentSheet:errorStr];
        }
        else
        {
            if (self.certFinshMessageBlock) {
                self.certFinshMessageBlock(@"上传失败");
            }
        }
    }];

}

#pragma mark SubView
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

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.themeColor = [UIColor blackColor];
        _manager.configuration.singleSelected = YES;
        _manager.configuration.supportRotation = NO;
        _manager.configuration.movableCropBox = YES;
        _manager.configuration.movableCropBoxEditSize = YES;
    }
    return _manager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
