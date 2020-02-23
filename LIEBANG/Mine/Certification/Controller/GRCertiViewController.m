

#import "GRCertiViewController.h"
#import "CertiResultViewController.h"
#import "WorkCertiViewController.h"
#import "EducationCertiViewController.h"
#import "EditAccountViewController.h"
#import "CertiService.h"
#import "CertificationLogic.h"
#import "CertiHeadCell.h"
#import "CustomSegment.h"

#import "TYPagerController.h"
#import "TYTabPagerBar.h"
#import "TYCertCell.h"

#import "MessageViewController.h"
#import "AccountModel.h"

@interface GRCertiViewController ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic,strong)CustomSegment *topSegment;
@property (assign, nonatomic) NSInteger currentIndex;;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSArray *imageItems;
@property (nonatomic, strong) NSArray *selectItems;
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
@property (nonatomic,strong)EditAccountViewController *oneCtr;
@property (nonatomic,strong)WorkCertiViewController *twoCtr;
@property (nonatomic,strong)EducationCertiViewController *threeCtr;

@property (nonatomic,assign)NSInteger sourceCount;
@property (nonatomic,assign)BOOL loadStatus;


/// 基础信息ids
@property (strong, nonatomic) NSString *basicids;
/// 工作经历ids
@property (strong, nonatomic) NSString *Workids;
/// 教育经历ids
@property (strong, nonatomic) NSString *educaids;

@property (nonatomic,strong) AccountModel *accountModel;

@property (strong, nonatomic) NSMutableArray *datsSource;
@end

@implementation GRCertiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EducationCertiViewController *educavc = [[EducationCertiViewController alloc] initWithEduCertiState:EducationCertiStateVerified];
    WeakSelf;
    educavc.GetSourceBlock = ^(NSString *imageUrl) {
        [weakSelf pushToMosaicVC:imageUrl];
    };
    self.threeCtr = educavc;

    self.view.backgroundColor = kBackgroundColor;
    self.navigationItem.title = @"认证";
    self.isReUpload = NO;
    
    _datas = NSMutableArray.new;
    
    _currentIndex = 0;
    
    [self addTabPageBar];
    [self addPagerController];
    [self reloadData];
    
    [self setRightNaviBtnTitle:@"提交审核"];
    [self.rightNaviBtn addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.type intValue] == 0) {
        [self gotoCurrentIndex:0];
    }
    else if ([self.type intValue] == 1) {
        [self gotoCurrentIndex:2];
    }
    else if ([self.type intValue] == 2) {
        [self gotoCurrentIndex:1];
    }
}

- (void)dealloc {
    
    [[CertificationLogic currentCert] removeAllData];
}

- (EditAccountViewController *)oneCtr {
    if (!_oneCtr) {
        _oneCtr = [[EditAccountViewController alloc] init];
        _oneCtr.editAccountCtrlState = EditAccountCtrlStateVerified;
        
    }
    return _oneCtr;
}

- (WorkCertiViewController *)twoCtr {
    if (!_twoCtr) {
        _twoCtr = [[WorkCertiViewController alloc] init];
        _twoCtr.workCertiState = WorkCertiStateVerified;
        
        WeakSelf;
        _twoCtr.GetSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
    }
    return _twoCtr;
}

- (EducationCertiViewController *)threeCtr {
    if (!_threeCtr) {
        _threeCtr = [[EducationCertiViewController alloc] init];
        _threeCtr.eduCertiState = EducationCertiStateVerified;
        
        WeakSelf;
        _threeCtr.GetSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
    }
    return _threeCtr;
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

#pragma mark Event
- (void)backNavItemTapped {
    if (self.navigationController.childViewControllers.count >= 2) {
        for (UIViewController *controller in self.navigationController.childViewControllers) {
            if([controller isKindOfClass:MessageViewController.class]){
                MessageViewController *messageVC =(MessageViewController *)controller;
                [self.navigationController popToViewController:messageVC animated:YES];
            };
        }
    }
    
    if (self.isReUpload)
    {
        [super backNavItemTapped];
    }
    else
    {
        if (_currentIndex == 0) {
            [super backNavItemTapped];
        }
        _currentIndex--;

        [self.pagerController scrollToControllerAtIndex:_currentIndex animate:YES];
    }
}

- (void)gotoCurrentIndex:(NSInteger)index {
    _currentIndex = index;
    [self.pagerController scrollToControllerAtIndex:_currentIndex animate:YES];
}

#pragma mark - 提交审核
- (void)nextButtonClick {
    
    if (self.isReUpload)
    {//重新提交认证
        if (self.currentIndex == 0)
        {//基础信息提交
            [self saveBasicMessageToServer];
        }
        else if (self.currentIndex == 1)
        {//请完善教育经历认证材料
            [self commitEducaIdentifyInfo];
        }
        else if (self.currentIndex == 2)
        {//重新提交工作经历认证
            [self recommitWorkIdentify];
        }
    }
    else
    {//教育和工作经历认证提交失败后再次提交基础信息
        if (_currentIndex == 2 || _currentIndex == 1|| _currentIndex == 0)
        {
            [self saveBasicMessageToServer];
        }
        else
        {//请完善职业经历认证材料
            
            [self recommitWorkIdentify];
            
            _currentIndex++;

            [self.pagerController scrollToControllerAtIndex:_currentIndex animate:YES];
        }
    }
}

#pragma mark - 完善教育经历认证
- (void)commitEducaIdentifyInfo
{
    if (IsArrEmpty(self.threeCtr.failSource)) {
        [self showAlertWithString:@"请完善教育经历认证材料"];
//        return;
    }
    
    NSMutableDictionary *postDic1 = [NSMutableDictionary dictionary];
    [postDic1 setValue:[self.threeCtr.UidSource componentsJoinedByString:@","] forKey:@"educationId"];//教育认证
    [postDic1 setValue:[self.twoCtr.UidSource componentsJoinedByString:@","] forKey:@"occupationId"];//教育认证
    
    NSLog(@"重新提交教育经历认证postDic1 == %@",postDic1);
    [self displayOverFlowActivityView];
    [CertiService postCertiSourceWithParameters:postDic1 success:^(NSString *info) {
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

#pragma mark -重新提交职业经历认证
- (void)recommitWorkIdentify
{
    if (IsArrEmpty(self.twoCtr.failSource)) {
        [self showAlertWithString:@"请完善职业经历认证材料"];
        [self gotoCurrentIndex:1];
        return;
    }
    
    NSMutableDictionary *postDic1 = [NSMutableDictionary dictionary];
    [postDic1 setValue:[self.threeCtr.UidSource componentsJoinedByString:@","] forKey:@"educationId"];//教育认证
    [postDic1 setValue:[self.twoCtr.UidSource componentsJoinedByString:@","] forKey:@"occupationId"];//工作认证
    
    NSLog(@"重新提交职业经历认证postDic1 == %@",postDic1);
    [self displayOverFlowActivityView];
    [CertiService postCertiSourceWithParameters:postDic1 success:^(NSString *info) {
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

#pragma mark - 保存基础信息提交认证
- (void)saveBasicMessageToServer {
//教育认证和工作认证的审核通过，但是基础认证的资料需重新提交，此时educationId和occupationId需传@“”空字符串
    [self recommitBasicInfoIdentify];
}

#pragma mark - 教育认证和工作认证的审核通过，但是基础认证的资料需重新提交，此时educationId和occupationId需传@“”空字符串
- (void)recommitBasicInfoIdentify
{
    for (int i = 0; i < 30; i ++) {
         UITextField *textField = [self.view viewWithTag:i];
         [textField resignFirstResponder];
     }
     
     NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
     [postDic setValue:self.oneCtr.accountModel.userName forKey:@"userName"];//
    //用户标签 self.oneCtr.accountModel.userLabelUid 非必选项
    [postDic setValue:self.oneCtr.accountModel.userLabelUid?:@"===" forKey:@"userLabelId"];
     [postDic setValue:self.oneCtr.accountModel.userIndustry forKey:@"userIndustry"];//用户行业
     [postDic setValue:self.oneCtr.accountModel.userWorkAddress forKey:@"userWorkAddress"];//所在地址
     [postDic setValue:self.oneCtr.accountModel.userDetailAddress forKey:@"userDetailAddress"];//详细地址
     [postDic setValue:self.oneCtr.accountModel.userEmail forKey:@"userEmail"];//邮箱
     [postDic setValue:self.oneCtr.accountModel.weChatId forKey:@"weChatId"];//微信号
     [postDic setValue:self.oneCtr.accountModel.phone forKey:@"phone"];//微信号
     [postDic setValue:self.oneCtr.accountModel.userCardId forKey:@"userCardId"];//身份证号
     [postDic setValue:@"0" forKey:@"uploadType"];
     
     NSLog(@"保存基本信息提交认证 == %@",postDic);
     
     if (IsStrEmpty(self.oneCtr.accountModel.userName) || IsNilOrNull(self.oneCtr.accountModel.userName)) {
         [self showAlertWithString:@"请输入用户名"];
         [self gotoCurrentIndex:0];
         return;
     }
     //非必选项
//     if (IsStrEmpty(self.oneCtr.accountModel.userLabelUid) || IsNilOrNull(self.oneCtr.accountModel.userLabelUid)) {
//         [self showAlertWithString:@"请选择职业标签"];
//         return;
//     }
     
     if (IsStrEmpty(self.oneCtr.accountModel.phone) || IsNilOrNull(self.oneCtr.accountModel.phone)) {
         [self showAlertWithString:@"请输入手机号"];
         [self gotoCurrentIndex:0];
         return;
     }
     
     if (![InsureValidate validateMobile:self.oneCtr.accountModel.phone]) {
         [self showAlertWithString:@"请输入正确的手机号码"];
         [self gotoCurrentIndex:0];
         return;
     }
     
     if (IsStrEmpty(self.oneCtr.accountModel.userCardId) || IsNilOrNull(self.oneCtr.accountModel.userCardId)) {
         [self showAlertWithString:@"请输入身份证号码"];
         [self gotoCurrentIndex:0];
         return;
     }
     
     if (![InsureValidate validateIDCardNumber:self.oneCtr.accountModel.userCardId]) {
         [self showAlertWithString:@"请输入正确身份证号码"];
         [self gotoCurrentIndex:0];
         return;
     }
     
     if (!IsStrEmpty(self.oneCtr.accountModel.userEmail)) {
         if (![InsureValidate validateEmail:self.oneCtr.accountModel.userEmail]) {
             [self showAlertWithString:@"请输入正确的邮箱"];
             [self gotoCurrentIndex:0];
             return;
         }
     }
     
     if (!IsNilOrNull(self.oneCtr.footView.image)) {
         if (![self.oneCtr.fileArray containsObject:@"image"]) {
             [self.oneCtr.imageArray addObject:self.oneCtr.footView.image];
             [self.oneCtr.fileArray addObject:@"image"];
         }
     }
     
     if (![self.oneCtr.accountModel.userCardUrl containsString:@"http"]) {
         if (![self.oneCtr.fileArray containsObject:@"image"]) {
             [self showAlertWithString:@"请上传手持身份证照片"];
             [self gotoCurrentIndex:0];
             return;
         }
     }
     NSLog(@"self.fileArray == %@",self.oneCtr.fileArray);
     [self displayOverFlowActivityView];
    
    
    [CertiService postCertiImageWithParameters:postDic file:self.oneCtr.imageArray fileName:self.oneCtr.fileArray success:^(NSString *info) {
        
        if (self.isReUpload)
        { //教育认证和工作认证的审核通过，但是基础认证的资料需重新提交，此时educationId和occupationId需传@“”空字符串
            NSMutableDictionary *postDic1 = [NSMutableDictionary dictionary];
            [postDic1 setValue:@"" forKey:@"educationId"];//教育认证
            [postDic1 setValue:@"" forKey:@"occupationId"];//工作认证
            
            [CertiService postCertiSourceWithParameters:postDic1 success:^(NSString *info) {
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
        else
        {
            if (self.currentIndex == 2)
            {//提交工作和教育经历认证
                [self commitWorkAndEducationIdentify];
            }else if (self.currentIndex == 1)
            {//提交工作和教育经历认证
                [self commitWorkAndEducationIdentify];
            }
            else if (self.currentIndex == 0) {
                [self removeOverFlowActivityView];
                [self gotoCurrentIndex:1];
                [self commitWorkAndEducationIdentify];

            }

        }
        
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self gotoCurrentIndex:0];
        [self presentSheet:@"保存基础信息失败"];
    }];
}

#pragma mark - 提交工作和教育经历认证
- (void)commitWorkAndEducationIdentify
{

    if (IsArrEmpty(self.twoCtr.failSource)) {
        [self showAlertWithString:@"请完善职业经历认证材料"];
        [self removeOverFlowActivityView];
        [self gotoCurrentIndex:1];
        return;
    }
    
    if (IsArrEmpty(self.threeCtr.failSource)) {
        [self showAlertWithString:@"请完善教育经历认证材料"];
        [self removeOverFlowActivityView];
        [self gotoCurrentIndex:2];
        return;
    }
    
    NSMutableDictionary *postDic1 = [NSMutableDictionary dictionary];
    [postDic1 setValue:[self.threeCtr.UidSource componentsJoinedByString:@","] forKey:@"educationId"];//教育认证
    [postDic1 setValue:[self.twoCtr.UidSource componentsJoinedByString:@","] forKey:@"occupationId"];//工作认证
    
    NSLog(@"postDic1 == %@",postDic1);
    [self displayOverFlowActivityView];
    [CertiService postCertiSourceWithParameters:postDic1 success:^(NSString *info) {
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

#pragma mark TYPagerController
- (void)addTabPageBar {
    _datas = @[@"基本信息认证",@"职业经历认证",@"教育经历认证"];
    _imageItems = @[@"btn_jibenxinxi",@"btn_zhiye",@"btn_jiaoyujingli"];
    _selectItems = @[@"btn_jibenxinxixuanzhong",@"btn_zhiyexuanzhong",@"btn_jiaoyujinglixuanzhong"];
    
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc] init];
    tabBar.layout.normalTextFont = kSystem(13);
    tabBar.layout.selectedTextFont = kSystem(13);
    tabBar.layout.normalTextColor = kLBBlackColor;
    tabBar.layout.selectedTextColor = kLBRedColor;
    tabBar.layout.progressColor = kBackgroundColor;
    tabBar.layout.adjustContentCellsCenter = YES;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    tabBar.layout.cellWidth = CGRectGetWidth(self.view.frame)/3.0;
    tabBar.layout.cellSpacing = 0;
    tabBar.layout.cellEdging = 0;
    [tabBar registerClass:[TYCertCell class] forCellWithReuseIdentifier:[TYCertCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.layout.prefetchItemCount = 1;
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.scrollView.scrollEnabled = NO;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tabBar.frame = CGRectMake(0, 0 ,kDeviceWidth, kCurrentWidth(105));
    _pagerController.view.frame = CGRectMake(0, CGRectGetHeight(_tabBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetHeight(_tabBar.frame));
}

#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return _datas.count;
}

- (UICollectionViewCell *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    TYCertCell *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYCertCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = _datas[index];
    cell.redView.image = [UIImage imageNamed:_imageItems[index]];
    cell.redView.tag = 8000+index;
    
    
    if ([self.type intValue] == 0) {
        if (index == 0) {
            cell.redView.image = [UIImage imageNamed:_selectItems[index]];
        }
    }
    else if ([self.type intValue] == 1) {
        if (index == 2) {
            cell.redView.image = [UIImage imageNamed:_selectItems[index]];
        }
    }
    else if ([self.type intValue] == 2) {
        if (index == 1) {
            cell.redView.image = [UIImage imageNamed:_selectItems[index]];
        }
    }
    return cell;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = _datas[index];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return _datas.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    if (index == 0) {
        return self.oneCtr;
    } else if (index == 1) {
        return self.twoCtr;
    } else {
        return self.threeCtr;
    }
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
//    if (toIndex == 0)
//    {
//        [self setRightNaviBtnImage:[UIImage imageNamed:@"nav_button_addressbook.png"]];
//        [self.rightNaviBtn addTarget:self action:@selector(gotoAddressBook) forControlEvents:UIControlEventTouchUpInside];
//    } else if (toIndex == 1)
//    {
//        [self setRightNaviBtnImage:[UIImage imageNamed:@"nav_button_jiahaoyou.png"]];
//        [self.rightNaviBtn addTarget:self action:@selector(gotoAddFriendCtr) forControlEvents:UIControlEventTouchUpInside];
//    } else
//    {
//        [self setRightNaviBtnImage:nil];
//    }
    _currentIndex = toIndex;
    UIImageView *fromView = [self.view viewWithTag:8000+fromIndex];
    fromView.image = [UIImage imageNamed:_imageItems[fromIndex]];
    UIImageView *toView = [self.view viewWithTag:8000+toIndex];
    toView.image = [UIImage imageNamed:_selectItems[toIndex]];
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
