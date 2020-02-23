//
//  ORCertiViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ORCertiViewController.h"
#import "CertiResultViewController.h"
#import "PostCertiView.h"
#import "TextFieldCell.h"
#import "CertiService.h"
#import "MechanismModel.h"
#import "MechanismCityCell.h"
#import "XFTreePopupView.h"

@interface ORCertiViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)PostCertiView *certView;

@property (nonatomic,strong)MechanismModel *model;

@property (nonatomic,strong)UIImage *license;

@end

@implementation ORCertiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.navigationItem.title = @"认证";
    
    [self setRightNaviBtnTitle:@"提交审核"];
    [self.rightNaviBtn addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:self.groupTableView];
    
    [self loadMechanismCertDataSource];
}

- (void)dealloc {
    [NSObject saveObj:nil withKey:kSHENFENGZHENGICON];
}

- (void)loadMechanismCertDataSource {
    
    [self displayOverFlowActivityView];
    [CertiService getMechanismResultWithSuccess:^(MechanismModel *info) {
        [self removeOverFlowActivityView];
        if (IsNilOrNull(info)) {
            self.model = [[MechanismModel alloc] init];
        } else {
            self.model = info;
        }
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
        self.model = [[MechanismModel alloc] init];
    }];
}

#pragma mark Event
- (void)nextButtonClick {
    
    for (int i = 1; i < 10; i++) {
        UITextField *tf = [self.view viewWithTag:i];
        [tf resignFirstResponder];
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.model.mechanismName forKey:@"mechanismName"];//机构名称
    [postDic setValue:self.model.fullName forKey:@"fullName"];//机构全称
    [postDic setValue:self.model.contactsName forKey:@"contactsName"];//联系人姓名
    [postDic setValue:self.model.contactsPosition forKey:@"contactsPosition"];//联系人职位
    [postDic setValue:self.model.contactsPhone forKey:@"contactsPhone"];//联系人手机
    [postDic setValue:self.model.email forKey:@"email"];//邮箱
    [postDic setValue:self.model.city forKey:@"city"];//所在城市
    [postDic setValue:self.model.region forKey:@"region"];//所在地区
    
    NSLog(@"机构认证postDic == %@",postDic);
    if (IsStrEmpty(self.model.mechanismName) || IsNilOrNull(self.model.mechanismName)) {
        [self showAlertWithString:@"请输入机构名称"];
        return;
    }
    
    if (IsStrEmpty(self.model.fullName) || IsNilOrNull(self.model.fullName)) {
        [self showAlertWithString:@"请输入机构全称"];
        return;
    }
    
    if (IsStrEmpty(self.model.contactsName) || IsNilOrNull(self.model.contactsName)) {
        [self showAlertWithString:@"请输入联系人姓名"];
        return;
    }

    if (IsStrEmpty(self.model.contactsPosition) || IsNilOrNull(self.model.contactsPosition)) {
        [self showAlertWithString:@"请输入联系人职位"];
        return;
    }
    
    NSString *checkResult = [LBForProject isCheckPhone:self.model.contactsPhone];
    if (![checkResult isEqualToString:@""]) {
        [self showAlertWithString:checkResult];
        return;
    }
    
    if (![InsureValidate validateEmail:self.model.email]) {
        [self showAlertWithString:@"请输入正确的邮箱"];
        return;
    }
    
    if (IsStrEmpty(self.model.city) || IsNilOrNull(self.model.city)) {
        [self showAlertWithString:@"请输入所在城市"];
        return;
    }
    
    if (IsStrEmpty(self.model.region) || IsNilOrNull(self.model.region)) {
        [self showAlertWithString:@"请输入所在地区"];
        return;
    }
    
    UIImage *cellImage = (UIImage *)[NSObject readObjforKey:kSHENFENGZHENGICON];
    if (IsNilOrNull(cellImage)) {
        [self showAlertWithString:@"请上传营业执照"];
        return;
    }
    NSData *licen = UIImageJPEGRepresentation(cellImage, 0.5);
    
    [self displayOverFlowActivityView];
    [CertiService getCertiMechanismWithParameters:postDic file:licen fileName:@"license" success:^(NSString *info) {
        [self removeOverFlowActivityView];
        [self presentSheet:info];
        [self performBlock:^{
            CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
            nextCtr.certiResultCtrl = CertiResultCtrlNormal;
            nextCtr.message = [InsureValidate getCurrentTimes];
            [self.navigationController pushViewController:nextCtr animated:YES];
        } afterDelay:1.5];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LBForProject currentProject].ORCertiCellTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    
    if (indexPath.row == 6)
    {
        static NSString *cellStr = @"MechanismCityCell";
        MechanismCityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[MechanismCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.indexPath = indexPath;
        cell.model = self.model;
        cell.editCitySourceBlock = ^(NSInteger index, NSString * _Nonnull cityName) {
            [weakSelf editCitySourceWith:index cityName:cityName];
        };
        return cell;
    }
    else
    {
        static NSString *cellStr = @"TextFieldCell";
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.indexPath = indexPath;
        cell.model = self.model;
        cell.image = self.license;
        cell.editSourceBlock = ^{
            [weakSelf editSourceClick];
        };
        cell.editMessageBlock = ^(NSInteger index, NSString *content) {
            [weakSelf getContentWith:index content:content];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 8) {
        return kCurrentWidth(254);
    } else if (indexPath.row == 6) {
        MechanismCityCell *cell = (MechanismCityCell *)[self tableView:self.groupTableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    return kCurrentWidth(44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITextField *textField = [self.view viewWithTag:indexPath.row+1];
    [textField becomeFirstResponder];
}

#pragma mark Event
- (void)editCitySourceWith:(NSInteger)index cityName:(NSString *)cityName {
    
    if (index == 4)
    {
        NSString *mainBundleDirectory=[[NSBundle mainBundle] bundlePath];
        NSString *path = [mainBundleDirectory stringByAppendingPathComponent:@"province.json"];
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        NSError *err;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        
        XFTreePopupView *treeView = [[XFTreePopupView alloc]initWithDataSource:jsonArray Commit:^(NSArray *ret)
                                     {
                                         NSDictionary *dict1 = [ret safeObjectAtIndex:0];
                                         NSString *selectedStr1 = [dict1 objectForKey:@"name"];
                                         
                                         NSDictionary *dict2 = [ret safeObjectAtIndex:1];
                                         NSString *selectedStr2 = [dict2 objectForKey:@"name"];
                                         
                                         if (![selectedStr1 isEqualToString:selectedStr2]) {
                                             selectedStr1 = [selectedStr1 stringByAppendingString:selectedStr2];
                                         }
                                         
                                         self.model.city = selectedStr1;
                                         [self.groupTableView reloadData];
                                     }];
        treeView.isHidden = NO;
    }
    else
    {
        self.model.city = cityName;
        [self.groupTableView reloadData];
    }
}

- (void)getContentWith:(NSInteger)index content:(NSString *)content {
    switch (index) {
        case 1:
            self.model.mechanismName = content;
            break;
        case 2:
            self.model.fullName = content;
            break;
        case 3:
            self.model.contactsName = content;
            break;
        case 4:
            self.model.contactsPosition = content;
            break;
        case 5:
            self.model.contactsPhone = content;
            break;
        case 6:
            self.model.email = content;
            break;
        case 7:
            self.model.city = content;
            break;
        case 8:
            self.model.region = content;
            break;
        default:
            break;
    }
}

- (void)editSourceClick {
    WeakSelf;
    self.certView.postCertiViewBlock = ^(NSInteger index) {
        [weakSelf.certView removeFromSuperview];
        
        JJImagePicker *picker = [JJImagePicker sharedInstance];
        picker.customCropViewController = ^TOCropViewController *(UIImage *image) {
            if (picker.type == JJImagePickerTypePhoto) {
                return nil;
            }
            TOCropViewController  *cropController = [[TOCropViewController alloc] initWithImage:image];
            cropController.aspectRatioLockEnabled = NO;
            cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
            cropController.aspectRatioPickerButtonHidden = NO;
            cropController.rotateButtonsHidden = NO;
            cropController.cropView.cropBoxResizeEnabled = YES;
            return cropController;
        };
        picker.automaticText = @"Automatic";
        picker.closeText = @"Close";
        picker.openText = @"打开";
        
        if (index == 1)
        {
            [picker showImagePickerWithType:JJImagePickerTypeCamera InViewController:weakSelf didFinished:^(JJImagePicker *picker, UIImage *image) {
                weakSelf.license = [UIImage imageWithRightOrientation:image];
                [weakSelf.groupTableView reloadData];
            }];
        }
        else if (index == 2)
        {
            [picker showImagePickerWithType:JJImagePickerTypePhoto InViewController:weakSelf didFinished:^(JJImagePicker *picker, UIImage *image) {
                weakSelf.license = [UIImage imageWithRightOrientation:image];
                [weakSelf.groupTableView reloadData];
            }];
        }
    };
    self.certView.type = PostCertiViewLicense;
    [self.view addSubview:self.certView];
}

#pragma mark SubView
- (PostCertiView *)certView {
    if (!_certView) {
        _certView = [[PostCertiView alloc] init];
    }
    return _certView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
