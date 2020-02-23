//
//  CompanyCertViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/2.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "CompanyCertViewController.h"
#import "CertiResultViewController.h"
#import "CompanyFeeViewController.h"
#import "CompanyTextMessageViewController.h"
#import "TextFieldCell.h"
#import "CompanyService.h"
#import "CompanyModel.h"
#import "MechanismCityCell.h"
#import "CompanyLOGOCell.h"
#import "XFTreePopupView.h"
#import "CompanyContentCell.h"
#import "CompanyImageCell.h"
#import "PostCertiView.h"

#import "IdentifyInfoViewController.h"

@interface CompanyCertViewController ()<HXCustomCameraViewControllerDelegate,HXAlbumListViewControllerDelegate,HXDatePhotoEditViewControllerDelegate>

@property (strong, nonatomic) NSMutableDictionary *dataDict;


@property (nonatomic,strong)PostCertiView *certView;
@property (nonatomic,strong)NSIndexPath *selectIndex;
@property (nonatomic,strong)CompanyModel *companyModel;
@property (nonatomic,strong)UIImage *license;//营业执照
@property (nonatomic,strong)UIImage *comLogo;//公司logo
@property (nonatomic,strong)UIImage *background;//背景图
@property (nonatomic,strong)NSMutableArray *companyInfoArray;//公司信息组图
@property (nonatomic,strong)NSMutableArray *productServiceArray;//产品服务组图
@property (nonatomic,strong)NSMutableArray *recruitArray;//招聘组图
@property (nonatomic,strong)NSMutableArray *allImageArray;//所有组图
@property (nonatomic,strong)NSMutableArray *allImageNameArray;//所有组图分类
@property (nonatomic,assign)BOOL isCert;
@property (strong, nonatomic) HXPhotoManager *manager;

@end

@implementation CompanyCertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"认证";
    self.view.backgroundColor = kWhiteColor;
//    if (!IsStrEmpty(self.companyUid) && !IsNilOrNull(self.companyUid)) {
    [self getCompanyInfoApi];
//    }
    self.companyModel = [[CompanyModel alloc] init];
    [self setRightNaviBtnTitle:@"提交审核"];
    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.tableFooterView = [self tableFootView];
    [self.view addSubview:self.tableView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


}

- (void)getCompanyInfoApi
{
    [self displayOverFlowActivityView];
    NSMutableDictionary *dic = NSMutableDictionary.new;
    dic[@"level"] = self.level;
   

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    manager.requestSerializer.timeoutInterval = 10.f;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    LoginModel *account = [SDUserTool account];

    [manager.requestSerializer setValue:account.rongCloudToken forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"deviceMod"];
    NSString *url = [NSString stringWithFormat:@"%@%@?level=%@",kApphttp,kCOMPANY_DETAIL_URL,self.level];
    [manager GET:url parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        CompanyModel *model = [CompanyModel yy_modelWithJSON:[dict objectForKey:@"data"]];

        [self removeOverFlowActivityView];
        if (model.status.intValue != 0 && model.status.intValue != 1) {
            self.companyModel = model;//下面已经重写setter方法了
            
            [self.tableView reloadData];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self removeOverFlowActivityView];

    }];

}

- (void)dealloc {
    [self.manager clearSelectedList];
    [[LBForProject currentProject].companyInfoArray removeAllObjects];
    [[LBForProject currentProject].productServiceArray removeAllObjects];
    [[LBForProject currentProject].recruitArray removeAllObjects];
    
    [LBForProject currentProject].companyInfo = nil;
    [LBForProject currentProject].productInfo = nil;
    [LBForProject currentProject].employeeInfo = nil;

}

- (void)setCompanyModel:(CompanyModel *)companyModel{
    _companyModel = companyModel;
    
    [self.companyInfoArray removeAllObjects];
    [self.productServiceArray removeAllObjects];
    [self.recruitArray removeAllObjects];
    [[LBForProject currentProject].companyInfoArray removeAllObjects];
    [[LBForProject currentProject].productServiceArray removeAllObjects];
    [[LBForProject currentProject].recruitArray removeAllObjects];
    [self.companyInfoArray addObjectsFromArray:companyModel.companyInfoImages];
    [self.productServiceArray addObjectsFromArray:companyModel.productServiceImages];
    [self.recruitArray addObjectsFromArray:companyModel.recruitImages];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSString *imageStr in companyModel.companyInfoImages) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]]];
            [[LBForProject currentProject].companyInfoArray addObject:image];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects: [NSIndexPath indexPathForRow:14 inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        for (NSString *imageStr in companyModel.productServiceImages) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]]];
            [[LBForProject currentProject].productServiceArray addObject:image];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects: [NSIndexPath indexPathForRow:15 inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];

        }
        for (NSString *imageStr in companyModel.recruitImages) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]]];
            [[LBForProject currentProject].recruitArray addObject:image];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects: [NSIndexPath indexPathForRow:16 inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];

        }
    });
    [self.tableView reloadData];
}

//- (void)backNavItemTapped {
//    [super backNavItemTapped];
//    [self allResignFirstResponder];
//    UIAlertController *alert = [CHAlertView showMessageWith:@"确定" title:@"是否保存企业资料？" confim:^{
//        [self displayOverFlowActivityView];
//        [self saveButtonClick];
//    }];
//    [self presentViewController:alert animated:YES completion:nil];
//}

#pragma mark
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LBForProject currentProject].comCertiCellTitleArray.count+5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    if (indexPath.row == 9)
    {
        static NSString *cellStr = @"MechanismCityCell";
        MechanismCityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[MechanismCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.indexPath = indexPath;
        cell.companyModel = self.companyModel;
        cell.editCitySourceBlock = ^(NSInteger index, NSString * _Nonnull cityName) {
            [weakSelf editCitySourceWith:index cityName:cityName];
        };
        return cell;
    }
    else if (indexPath.row == 0)
    {
        static NSString *cellStr = @"CompanyLOGOCell";
        CompanyLOGOCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[CompanyLOGOCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.indexPath = indexPath;
        cell.companyModel = self.companyModel;
        cell.image = self.comLogo;
        return cell;
    }
    else if (indexPath.row == 14 || indexPath.row == 15 || indexPath.row == 16)
    {
        static NSString *cellStr = @"CompanyContentCell";
        CompanyContentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[CompanyContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.indexPath = indexPath;
        cell.companyModel = self.companyModel;
        if (indexPath.row == 14) {
            cell.imageArray = [LBForProject currentProject].companyInfoArray;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        else if (indexPath.row == 15) {
            cell.imageArray = [LBForProject currentProject].productServiceArray;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        else if (indexPath.row == 16) {
            cell.imageArray = [LBForProject currentProject].recruitArray;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

        }
        cell.editMessageBlock = ^(NSInteger index, NSString * _Nonnull content) {
            [weakSelf getCompanyMessageWith:index content:content];
        };
        cell.editSourceBlock = ^(NSIndexPath * _Nonnull indexPath) {
            [weakSelf editCompanyImage:indexPath];
        };
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

        cell.reloadImageSourceBlock = ^(NSIndexPath * _Nonnull indexPath, NSMutableArray * _Nonnull imageArray, BOOL isreload) {

            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    }
    else if (indexPath.row == 17 || indexPath.row == 18)
    {
        static NSString *cellStr = @"CompanyImageCell";
        CompanyImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[CompanyImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.indexPath = indexPath;
        cell.companyModel = self.companyModel;
        if (indexPath.row == 17) {
            cell.image = self.license;
        }
        else if (indexPath.row == 18) {
            cell.image = self.background;
        }
        cell.editSourceBlock = ^(NSIndexPath * _Nonnull indexPath) {
            [weakSelf editCompanyImage:indexPath];
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
        [cell setIndex:indexPath companyModel:self.companyModel];
        cell.editMessageBlock = ^(NSInteger index, NSString *content) {
            [weakSelf getContentWith:index content:content];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 9)
    {
        MechanismCityCell *cell = (MechanismCityCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    else if (indexPath.row == 0)
    {
        return kCurrentWidth(58);
    }
    else if (indexPath.row == 14 || indexPath.row == 15 || indexPath.row == 16)
    {
        CompanyContentCell *cell = (CompanyContentCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    else if (indexPath.row == 17 || indexPath.row == 18)
    {
        return kCurrentWidth(260);
    }
    else
    {
        return kCurrentWidth(44);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kCurrentWidth(5);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 11)
    {
        
    }
    else if (indexPath.row == 0)
    {
        [self editCompanyImage:indexPath];
    }
    else if (indexPath.row == 14 || indexPath.row == 15 || indexPath.row == 16)
    {
        IdentifyInfoViewController *info = IdentifyInfoViewController.new;
        NSArray *titleArr = @[@"公司信息",@"产品服务",@"招聘"];
        info.title = titleArr[indexPath.row - 14];
        if (indexPath.row == 14) {
            info.type = CompanyInfo;
            
            info.currentInfo = self.companyModel.companyInfo?:[LBForProject currentProject].companyInfo;

            info.currentArray = [LBForProject currentProject].companyInfoArray;
            WeakSelf
            info.infoBlock = ^(NSArray *infoArray,NSString *info) {
                [LBForProject currentProject].companyInfo = info;
                weakSelf.companyModel.companyInfo = info;
                [[LBForProject currentProject].companyInfoArray removeAllObjects];
                [[LBForProject currentProject].companyInfoArray addObjectsFromArray:infoArray];
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:14 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };
        }else if (indexPath.row == 15){
            info.type = ProductsInfo;
            
            info.currentArray = [LBForProject currentProject].productServiceArray;

            info.currentInfo = self.companyModel.productService?:[LBForProject currentProject].productInfo;

            WeakSelf
            info.infoBlock = ^(NSArray *infoArray,NSString *info) {
                [LBForProject currentProject].productInfo = info;
                weakSelf.companyModel.productService = info;

                [[LBForProject currentProject].productServiceArray removeAllObjects];
                [[LBForProject currentProject].productServiceArray addObjectsFromArray:infoArray];                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:15 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];

            };
        }else if (indexPath.row == 16){
            info.type = Employee;
            
            info.currentArray = [LBForProject currentProject].recruitArray;
            info.currentInfo = self.companyModel.recruit?:[LBForProject currentProject].employeeInfo;
            WeakSelf
            info.infoBlock = ^(NSArray *infoArray,NSString *info) {
                [LBForProject currentProject].employeeInfo = info;
                weakSelf.companyModel.recruit = info;

                [[LBForProject currentProject].recruitArray removeAllObjects];
                [[LBForProject currentProject].recruitArray addObjectsFromArray:infoArray];                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:16 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];

            };
        }
        [self.navigationController pushViewController:info animated:YES];
    }
    else if (indexPath.row == 17 || indexPath.row == 18)
    {
        
    }
    else
    {
        UITextField *textField = [self.view viewWithTag:indexPath.row+1];
        [textField becomeFirstResponder];
    }
}

#pragma mark
#pragma mark Events
- (void)getCompanyMessageWith:(NSInteger)index content:(NSString *)content {
    
    CompanyTextMessageViewController *nextCtr = [[CompanyTextMessageViewController alloc] init];
    nextCtr.titleString = content;
    switch (index) {
        case 14:
            nextCtr.contentString = self.companyModel.companyInfo;
            break;
        case 15:
            nextCtr.contentString = self.companyModel.productService;
            break;
        case 16:
            nextCtr.contentString = self.companyModel.recruit;
            break;
        default:
            break;
    }
    nextCtr.editMessageBlock = ^(NSInteger msgIndex, NSString * _Nonnull message) {
        switch (index) {
            case 14:
                self.companyModel.companyInfo = message;
                break;
            case 15:
                self.companyModel.productService = message;
                break;
            case 16:
                self.companyModel.recruit = message;
                break;
            default:
                break;
        }
    };
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)getContentWith:(NSInteger)index content:(NSString *)content {
    
    index = index - 1;
    switch (index) {
        case 1:
            self.companyModel.companyAbbreviation = content;
            break;
        case 2:
            self.companyModel.fullName = content;
            break;
        case 3:
            self.companyModel.financingStatus = content;
            break;
        case 4:
            self.companyModel.personnelScale = content;
            break;
        case 5:
            self.companyModel.industry = content;
            break;
        case 6:
            self.companyModel.officialWebsite = content;
            break;
        case 7:
            self.companyModel.email = content;
            break;
        case 8:
            self.companyModel.companyPelephone = content;
            break;
        case 9:
            self.companyModel.city = content;
            break;
        case 10:
            self.companyModel.region = content;
            break;
        case 11://姓名
            self.companyModel.contactsName = content;
            break;
        case 12://职位
            self.companyModel.contactsPosition = content;
            break;
        case 13://手机
            self.companyModel.contactsPhone = content;
        break;
        default:
            break;
    }
}

- (void)editCompanyImage:(NSIndexPath *)indexPath {
    
    self.selectIndex = indexPath;
    if (indexPath.row == 17)
    {
        WeakSelf;
        self.certView.postCertiViewBlock = ^(NSInteger index) {
            [weakSelf.certView removeFromSuperview];
            weakSelf.manager.configuration.supportRotation = YES;
            weakSelf.manager.configuration.movableCropBox = NO;
            weakSelf.manager.configuration.movableCropBoxEditSize = NO;
            weakSelf.manager.configuration.movableCropBoxCustomRatio = CGPointZero;
            [weakSelf showLisencecImageSelectController:index];
        };
        self.certView.type = PostCertiViewLicense;
        [self.view addSubview:self.certView];
    }
    else
    {
        if (indexPath.row == 0)
        {
            self.manager.configuration.supportRotation = NO;
            self.manager.configuration.movableCropBox = YES;
            self.manager.configuration.movableCropBoxEditSize = YES;
            self.manager.configuration.movableCropBoxCustomRatio = CGPointMake(kDeviceWidth, kDeviceWidth);
        }
        else
        {
            self.manager.configuration.supportRotation = NO;
            self.manager.configuration.movableCropBox = YES;
            self.manager.configuration.movableCropBoxEditSize = YES;
            self.manager.configuration.movableCropBoxCustomRatio = CGPointMake(16, 9);
        }
        [self showImageSelectController];
    }
}

- (void)rightNaviBtnClick {
    
    [self allResignFirstResponder];
    self.rightNaviBtn.enabled = NO;
    if (IsStrEmpty(self.companyUid) || IsNilOrNull(self.companyUid))
    {
        self.isCert = YES;
        [self saveButtonClick];
    }
    else
    {
        if (self.companyUid) {
            NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
            [postDic setValue:self.companyModel.level forKey:@"level"];//付费等级
            [postDic setValue:self.companyUid forKey:@"id"];//企业id
            NSLog(@"提交审核 == %@",postDic);
            
            [self displayOverFlowActivityView];
            [CompanyService postCompanyCertWithParameters:postDic success:^(NSString * _Nonnull data) {
                [self removeOverFlowActivityView];
                
                CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
                nextCtr.certiResultCtrl = CertiResultCtrlCompanyNormal;
                nextCtr.message = [InsureValidate getCurrentTimes];
                [self.navigationController pushViewController:nextCtr animated:YES];
            } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
                [self removeOverFlowActivityView];
                self.rightNaviBtn.enabled = YES;
                [self presentSheet:errorStr];
            }];
            return;
        }
        if (IsStrEmpty(self.level) || IsNilOrNull(self.level))
        {
            self.isCert = YES;
            [self saveButtonClick];
        }
        else
        {
            if (self.isModify)
            {
                self.isCert = YES;
                [self saveButtonClick];
            }
            else
            {
                NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
                [postDic setValue:self.level forKey:@"level"];//付费等级
                [postDic setValue:self.companyModel.id forKey:@"id"];//企业id
                NSLog(@"提交审核 == %@",postDic);
                
                [self displayOverFlowActivityView];
                [CompanyService postCompanyCertWithParameters:postDic success:^(NSString * _Nonnull data) {
                    [self removeOverFlowActivityView];
                    
                    if (IsStrEmpty(self.companyModel.endTime) || IsNilOrNull(self.companyModel.endTime))
                    {
                        PayViewController *nextCtr = [[PayViewController alloc] init];
                        nextCtr.level = self.level;
                        nextCtr.questionPri = data;
                        nextCtr.serviceType = @"企业名片";
                        nextCtr.enterpriseId = self.companyModel.id;
                        self.rightNaviBtn.enabled = YES;
                        [self.navigationController pushViewController:nextCtr animated:YES];
                    }
                    else
                    {
                        CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
                        nextCtr.certiResultCtrl = CertiResultCtrlCompanyNormal;
                        nextCtr.message = [InsureValidate getCurrentTimes];
                        [self.navigationController pushViewController:nextCtr animated:YES];
                    }
                } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
                    [self removeOverFlowActivityView];
                    self.rightNaviBtn.enabled = YES;
                    [self presentSheet:errorStr];
                }];
            }            
        }
    }
}

- (void)saveButtonClick {
    
    [self allResignFirstResponder];
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:@(self.level.intValue) forKey:@"level"];//

    [postDic setValue:self.companyModel.companyAbbreviation forKey:@"companyAbbreviation"];//机构名称
    [postDic setValue:self.companyModel.fullName forKey:@"fullName"];//机构全称
    [postDic setValue:self.companyModel.financingStatus forKey:@"financingStatus"];//融资状态
    [postDic setValue:self.companyModel.personnelScale forKey:@"personnelScale"];//人员规模
    [postDic setValue:self.companyModel.industry forKey:@"industry"];//所处行业
    [postDic setValue:self.companyModel.officialWebsite forKey:@"officialWebsite"];//官网
    [postDic setValue:self.companyModel.contactsName forKey:@"contactsName"];//联系人姓名
    [postDic setValue:self.companyModel.contactsPosition forKey:@"contactsPosition"];//联系人职位
    [postDic setValue:self.companyModel.contactsPhone forKey:@"contactsPhone"];//联系人手机号
    [postDic setValue:self.companyModel.companyPelephone forKey:@"companyPelephone"];//公司电话
    [postDic setValue:self.companyModel.email forKey:@"email"];//邮箱
    [postDic setValue:self.companyModel.city forKey:@"city"];//所在城市
    [postDic setValue:self.companyModel.region forKey:@"region"];//所在地区
    [postDic setValue:self.companyModel.companyInfo?:[LBForProject currentProject].companyInfo forKey:@"companyInfo"];//公司信息
    [postDic setValue:self.companyModel.productService?:[LBForProject currentProject].productInfo forKey:@"productService"];//产品服务
    [postDic setValue:self.companyModel.recruit?:[LBForProject currentProject].employeeInfo forKey:@"recruit"];//招聘
    [postDic setValue:self.companyModel.id forKey:@"id"];//企业id
    NSLog(@"保存公司资料 == %@",postDic);
    [self encodeAllUploadImage];
    
    if (IsStrEmpty(self.companyModel.fullName) || IsNilOrNull(self.companyModel.fullName)) {
        [self showAlertWithString:@"请输入企业全称"];
        self.rightNaviBtn.enabled = YES;
        self.isCert = NO;
        return;
    }
     
    if (IsStrEmpty(self.companyModel.contactsName) || IsNilOrNull(self.companyModel.contactsName)) {
        [self showAlertWithString:@"请输入联系人姓名"];
        self.rightNaviBtn.enabled = YES;
        self.isCert = NO;
        return;
    }
    
    if (IsStrEmpty(self.companyModel.contactsPosition) || IsNilOrNull(self.companyModel.contactsPosition)) {
        [self showAlertWithString:@"请输入联系人职位"];
        self.rightNaviBtn.enabled = YES;
        self.isCert = NO;
        return;
    }
    
    NSString *checkResult = [LBForProject isCheckPhone:self.companyModel.contactsPhone];
    if (![checkResult isEqualToString:@""]) {
        [self showAlertWithString:checkResult];
        self.rightNaviBtn.enabled = YES;
        self.isCert = NO;
        return;
    }
    
    if (![self.allImageNameArray containsString:@"businessLicense"] && self.companyModel.id.intValue == 0) {//
        [self showAlertWithString:@"请上传营业执照"];
        self.rightNaviBtn.enabled = YES;
        self.isCert = NO;
        return;
    }
    
    [self encodeAllUploadImage];
    [self displayOverFlowActivityView];
    [CompanyService saveCompanyCertWithParameters:postDic file:self.allImageArray fileName:self.allImageNameArray success:^(NSString * _Nonnull data) {
        [self removeOverFlowActivityView];
        self.rightNaviBtn.enabled = YES;
        self.companyModel.id = data;
        if (!self.isCert)
        {
            [self showAlertWithString:@"保存成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            if (IsStrEmpty(self.level) || IsNilOrNull(self.level))
            {
                CompanyFeeViewController *nextCtr = [[CompanyFeeViewController alloc] init];
                nextCtr.companyUid = self.companyModel.id;
                [self.navigationController pushViewController:nextCtr animated:YES];
            }
            else
            {
                NSString *saveCompanyUid = data;
                NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
                [postDic setValue:self.level forKey:@"level"];//付费等级
                [postDic setValue:saveCompanyUid forKey:@"id"];//企业id
                NSLog(@"提交审核 == %@",postDic);
                
                [self displayOverFlowActivityView];
                [CompanyService postCompanyCertWithParameters:postDic success:^(NSString * _Nonnull data) {
                    [self removeOverFlowActivityView];
                    
                    if (self.isModify) {
                        
                        if (IsStrEmpty(self.companyModel.endTime) || IsNilOrNull(self.companyModel.endTime))
                        {
                            PayViewController *nextCtr = [[PayViewController alloc] init];
                            nextCtr.level = self.level;
                            nextCtr.questionPri = data;
                            nextCtr.serviceType = @"企业名片";
                            self.rightNaviBtn.enabled = YES;
                            nextCtr.enterpriseId = self.companyModel.id;
                            [self.navigationController pushViewController:nextCtr animated:YES];
                        }
                        else
                        {
                            CertiResultViewController *nextCtr = [[CertiResultViewController alloc] init];
                            nextCtr.certiResultCtrl = CertiResultCtrlCompanyNormal;
                            nextCtr.message = [InsureValidate getCurrentTimes];
                            [self.navigationController pushViewController:nextCtr animated:YES];
                        }
                    }
                    else {
                        PayViewController *nextCtr = [[PayViewController alloc] init];
                        nextCtr.level = self.level;
                        nextCtr.questionPri = self.payPrice;
                        nextCtr.serviceType = @"企业名片";
                        nextCtr.enterpriseId = saveCompanyUid;
                        [self.navigationController pushViewController:nextCtr animated:YES];
                    }
                    
                } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
                    [self removeOverFlowActivityView];
                    [self presentSheet:errorStr];
                }];
            }
            
        }
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        self.rightNaviBtn.enabled = YES;
        [self presentSheet:errorStr];
    }];
}

//重排所有上传图片
- (void)encodeAllUploadImage {
    [self.allImageArray removeAllObjects];
    [self.allImageNameArray removeAllObjects];
    for (int i = 0; i < 10; i++) {
        [self.allImageArray addObject:[NSNull null]];
        [self.allImageNameArray addObject:[NSNull null]];
    }
    
    if (!IsNilOrNull(self.comLogo)) {
        [self.allImageArray replaceObjectAtIndex:0 withObject:self.comLogo];
        [self.allImageNameArray replaceObjectAtIndex:0 withObject:@"companyLogo"];
    }
    if (!IsNilOrNull(self.license)) {
        [self.allImageArray replaceObjectAtIndex:1 withObject:self.license];
        [self.allImageNameArray replaceObjectAtIndex:1 withObject:@"businessLicense"];
    }
    if (!IsNilOrNull(self.background)) {
        [self.allImageArray replaceObjectAtIndex:2 withObject:self.background];
        [self.allImageNameArray replaceObjectAtIndex:2 withObject:@"background"];
    }
    for (UIImage *image in [LBForProject currentProject].recruitArray) {
        if (!IsNilOrNull(image)) {
            [self.allImageArray replaceObjectAtIndex:3 withObject:image];
            [self.allImageNameArray replaceObjectAtIndex:3 withObject:@"recruitImgs"];
        }
    }
    int a = 3;
    for (UIImage *image in [LBForProject currentProject].companyInfoArray) {
        a++;
        if (!IsNilOrNull(image)) {
            [self.allImageArray replaceObjectAtIndex:a withObject:image];
            [self.allImageNameArray replaceObjectAtIndex:a withObject:@"companyInfoImgs"];
        }
    }
    int b = 5;
    for (UIImage *image in [LBForProject currentProject].productServiceArray) {
        b++;
        if (!IsNilOrNull(image)) {
            [self.allImageArray replaceObjectAtIndex:b withObject:image];
            [self.allImageNameArray replaceObjectAtIndex:b withObject:@"productServiceImgs"];
        }
    }
    NSLog(@"allImageNameArray = %@\n allImageArray = %@",self.allImageNameArray,self.allImageArray);
}

//结束编辑
- (void)allResignFirstResponder {
    
    for (int i = 0; i < 30; i ++) {
        UITextField *textField = [self.view viewWithTag:i];
        [textField resignFirstResponder];
    }
    for (int i = 0; i < 3; i ++) {
        UITextView *textView = [self.view viewWithTag:43+i];
        [textView resignFirstResponder];
    }
}

//选择城市
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
                                         
                                         self.companyModel.city = selectedStr1;
                                         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:9 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                                     }];
        treeView.isHidden = NO;
    }
    else
    {
        self.companyModel.city = cityName;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:9 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark SubView
- (PostCertiView *)certView {
    if (!_certView) {
        _certView = [[PostCertiView alloc] init];
    }
    return _certView;
}

- (UIView *)tableFootView {
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(90))];
    foot.backgroundColor = kWhiteColor;
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(10), kDeviceWidth-kCurrentWidth(24), kCurrentWidth(49));
    saveButton.layer.cornerRadius = 3;
    saveButton.layer.masksToBounds = YES;
    saveButton.backgroundColor = kLBRedColor;
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    saveButton.titleLabel.font = kSystemBold(16);
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:saveButton];
    return foot;
}

- (NSMutableArray *)companyInfoArray {
    if (!_companyInfoArray) {
        _companyInfoArray = [NSMutableArray array];
    }
    return _companyInfoArray;
}

- (NSMutableArray *)productServiceArray {
    if (!_productServiceArray) {
        _productServiceArray = [NSMutableArray array];
    }
    return _productServiceArray;
}

- (NSMutableArray *)recruitArray {
    if (!_recruitArray) {
        _recruitArray = [NSMutableArray array];
    }
    return _recruitArray;
}

- (NSMutableArray *)allImageArray {
    if (!_allImageArray) {
        _allImageArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _allImageArray;
}

- (NSMutableArray *)allImageNameArray {
    if (!_allImageNameArray) {
        _allImageNameArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _allImageNameArray;
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
    
    if (self.selectIndex.row == 0) {
        self.comLogo = [UIImage imageWithRightOrientation:selectImage];
    }
    else if (self.selectIndex.row == 18) {
        self.background = [UIImage imageWithRightOrientation:selectImage];
    }
    else if (self.selectIndex.row == 14) {
        [self.companyInfoArray addObject:[UIImage imageWithRightOrientation:selectImage]];
        [[LBForProject currentProject].companyInfoArray addObject:[UIImage imageWithRightOrientation:selectImage]];
    }
    else if (self.selectIndex.row == 15) {
        [self.productServiceArray addObject:[UIImage imageWithRightOrientation:selectImage]];
        [[LBForProject currentProject].productServiceArray addObject:[UIImage imageWithRightOrientation:selectImage]];
    }
    else if (self.selectIndex.row == 16) {
        [self.recruitArray addObject:[UIImage imageWithRightOrientation:selectImage]];
        [[LBForProject currentProject].recruitArray addObject:[UIImage imageWithRightOrientation:selectImage]];
    }
    else if (self.selectIndex.row == 17) {
        self.license = [UIImage imageWithRightOrientation:selectImage];
    }
//    [self.tableView reloadData];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.selectIndex.row inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
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
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showLisencecImageSelectController:(NSInteger)index {
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

@end
