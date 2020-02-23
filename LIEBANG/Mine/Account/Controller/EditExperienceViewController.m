//
//  EditExperienceViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/17.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "EditExperienceViewController.h"
#import "EditAccountCell.h"
#import "EditExprienceFootView.h"
#import "AccountService.h"
#import "EducationModel.h"
#import "WorkModel.h"

static NSArray *titleArray;
@interface EditExperienceViewController ()<HXCustomCameraViewControllerDelegate,HXAlbumListViewControllerDelegate,HXDatePhotoEditViewControllerDelegate>

@property (nonatomic,strong)EditExprienceFootView *footView;
@property (nonatomic,strong)NSString *headTitle;

@property (nonatomic,strong)NSData *imageData;
@property (nonatomic,strong)UIImage *image;
@property (strong, nonatomic) HXPhotoManager *manager;

@end

@implementation EditExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDataSource];
    [self createSubViews];
}

- (void)loadDataSource {
    
    if (self.experienceState == EditExperienceStateWork)
    {
        
        self.headTitle = @"我的工作经历";
        titleArray = @[@"公司LOGO",@"公司",@"职位",@"开始时间",@"结束时间"];
        if (self.isEdit)
        {
            self.navigationItem.title = @"编辑工作经历";
            [self loadWorkDataSource];
        }
        else
        {
            self.navigationItem.title = @"新增工作经历";
            _basicWorkModel = [[WorkModel alloc] init];
        }
    }
    else if (self.experienceState == EditExperienceStateEducation)
    {
        
        self.headTitle = @"我的教育经历";
        titleArray = @[@"学校LOGO",@"学校",@"专业",@"学历",@"开始时间",@"结束时间"];
        if (self.isEdit)
        {
            self.navigationItem.title = @"编辑教育经历";
            [self loadEducationSource];
        }
        else
        {
            self.navigationItem.title = @"新增教育经历";
            _basicEduModel = [[EducationModel alloc] init];
        }
    }
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    static NSString *cellStr = @"EditAccountCell";
    EditAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[EditAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    [cell setExperienceDataWith:titleArray indexPath:indexPath];
    if (self.experienceState == EditExperienceStateEducation)
    {
        cell.educationModel = _basicEduModel;
    }
    else if (self.experienceState == EditExperienceStateWork)
    {
        cell.workModel = _basicWorkModel;
    }
    cell.image = self.image;
    cell.editMessageBlock = ^(NSInteger index, NSString *content) {
        [weakSelf getContentWith:index content:content];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return kCurrentWidth(70);
    }
    return kCurrentWidth(44);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40) title:self.headTitle];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40) title:@"经历描述"];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (int i = 1; i < 10; i++) {
        UITextField *tf = [self.view viewWithTag:i];
        [tf resignFirstResponder];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [self showImageSelectController];
    }
    else if (indexPath.section == 0 && indexPath.row == 3)
    {
        if (self.experienceState == EditExperienceStateEducation)
        {
            UIAlertController *alert = [CHAlertView showSheetMessageWith:nil list:@[@"大专",@"本科",@"硕士",@"博士",@"MBA",@"EMBA",@"中专",@"中技",@"高中",@"初中",@"其他"] confim:^(NSString *returnInfo) {
                self.basicEduModel.diploma = returnInfo;
                NSLog(@"_basicEduModel.diploma == %@",self.basicEduModel.diploma);
                [self.groupTableView reloadData];
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (self.experienceState == EditExperienceStateWork)
        {
            NSDate *maxDate = nil;
            NSString *maxTime = nil;
            
            NSString *curTime = [InsureValidate getCurrentTimesTwo];
            NSString *TimeStr = [self getTimeStrWithString:curTime];
            NSInteger afterTime = [TimeStr integerValue] - (60*60*24);
            NSString *afterString = [self tuanTime:afterTime];
            NSString *year = [afterString substringToIndex:4];
            NSString *month = [afterString substringWithRange:NSMakeRange(5, 2)];
            NSString *day = [afterString substringFromIndex:8];
            NSDate *curDate = [NSDate br_setYear:[year integerValue] month:[month integerValue] day:[day integerValue]];
            
            if ([_basicWorkModel.endTime isEqualToString:@"至今"]) {
                _basicWorkModel.endTime = [InsureValidate getCurrentTimesTwo];
            }
            
            if (IsStrEmpty(_basicWorkModel.endTime) || IsNilOrNull(_basicWorkModel.endTime)) {
//                _basicWorkModel.endTime = [InsureValidate getCurrentTimesTwo];
            }
            
            if (!IsStrEmpty(_basicWorkModel.endTime) && !IsNilOrNull(_basicWorkModel.endTime)) {
                NSString *TimeStr = [self getTimeStrWithString:_basicWorkModel.endTime];
                NSInteger afterTime = [TimeStr integerValue] - (60*60*24);
                NSString *afterString = [self tuanTime:afterTime];
                
                NSString *year = [afterString substringToIndex:4];
                NSString *month = [afterString substringWithRange:NSMakeRange(5, 2)];
                NSString *day = [afterString substringFromIndex:8];
                maxDate = [NSDate br_setYear:[year integerValue] month:[month integerValue] day:[day integerValue]];
                maxTime = afterString;
            }
            
            [BRDatePickerView showDatePickerWithTitle:@"开始时间" dateType:BRDatePickerModeYMD defaultSelValue:maxTime minDate:nil maxDate:curDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
                self.basicWorkModel.beginTime = selectValue;
                [self.groupTableView reloadData];
            }];
        }
    }
    else if (indexPath.section == 0 && indexPath.row == 4)
    {
        if (self.experienceState == EditExperienceStateEducation)
        {
            NSDate *maxDate = nil;
            NSString *maxTime = nil;
            
            NSString *curTime = [InsureValidate getCurrentTimesTwo];
            NSString *TimeStr = [self getTimeStrWithString:curTime];
            NSInteger afterTime = [TimeStr integerValue] - (60*60*24);
            NSString *afterString = [self tuanTime:afterTime];
            NSString *year = [afterString substringToIndex:4];
            NSString *month = [afterString substringWithRange:NSMakeRange(5, 2)];
            NSString *day = [afterString substringFromIndex:8];
            NSDate *curDate = [NSDate br_setYear:[year integerValue] month:[month integerValue] day:[day integerValue]];
            
            if ([_basicEduModel.endTime isEqualToString:@"至今"]) {
                _basicEduModel.endTime = [InsureValidate getCurrentTimesTwo];
            }
            
            if (IsStrEmpty(_basicEduModel.endTime) || IsNilOrNull(_basicEduModel.endTime)) {
//                _basicEduModel.endTime = [InsureValidate getCurrentTimesTwo];
            }
            
            if (!IsStrEmpty(_basicEduModel.beginTime) && !IsNilOrNull(_basicEduModel.beginTime)) {
                NSString *TimeStr = [self getTimeStrWithString:_basicEduModel.beginTime];
                NSInteger afterTime = [TimeStr integerValue];// - (60*60*24);
                NSString *afterString = [self tuanTime:afterTime];
                
                NSString *year = [afterString substringToIndex:4];
                NSString *month = [afterString substringWithRange:NSMakeRange(5, 2)];
                NSString *day = [afterString substringFromIndex:8];
                maxDate = [NSDate br_setYear:[year integerValue] month:[month integerValue] day:[day integerValue]];
                maxTime = afterString;
            }
            
            [BRDatePickerView showDatePickerWithTitle:@"开始时间" dateType:BRDatePickerModeYMD defaultSelValue:maxTime minDate:nil maxDate:curDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
                self.basicEduModel.beginTime = selectValue;
                [self.groupTableView reloadData];
            }];
        }
        else if (self.experienceState == EditExperienceStateWork)
        {
            NSDate *minDate = nil;
            NSString *minTime = nil;
            
            NSString *curTime = [InsureValidate getCurrentTimesTwo];
            NSString *TimeStr = [self getTimeStrWithString:curTime];
            NSInteger afterTime = [TimeStr integerValue];
            NSString *afterString = [self tuanTime:afterTime];
            NSString *year = [afterString substringToIndex:4];
            NSString *month = [afterString substringWithRange:NSMakeRange(5, 2)];
            NSString *day = [afterString substringFromIndex:8];
            NSDate *curDate = [NSDate br_setYear:[year integerValue] month:[month integerValue] day:[day integerValue]];
            
            if ([_basicWorkModel.beginTime isEqualToString:@"至今"]) {
                _basicWorkModel.beginTime = [InsureValidate getCurrentTimesTwo];
            }
            
            if (IsStrEmpty(_basicWorkModel.beginTime) || IsNilOrNull(_basicWorkModel.beginTime)) {
                _basicWorkModel.beginTime = [InsureValidate getCurrentTimesTwo];
            }
            
            if (!IsStrEmpty(_basicWorkModel.beginTime) && !IsNilOrNull(_basicWorkModel.beginTime)) {
                NSString *TimeStr = [self getTimeStrWithString:_basicWorkModel.beginTime];
                NSInteger afterTime = [TimeStr integerValue];// + (60*60*24);
                NSString *afterString = [self tuanTime:afterTime];
                
                NSString *year = [afterString substringToIndex:4];
                NSString *month = [afterString substringWithRange:NSMakeRange(5, 2)];
                NSString *day = [afterString substringFromIndex:8];
                minDate = [NSDate br_setYear:[year integerValue] month:[month integerValue] day:[day integerValue]];
                minTime = afterString;
            }
            
            NSDate *maxDate = nil;
            NSString *maxTime = nil;
            
            if ([_basicWorkModel.endTime isEqualToString:@"至今"]) {
                _basicWorkModel.endTime = [InsureValidate getCurrentTimesTwo];
            }
            
            if (IsStrEmpty(_basicWorkModel.endTime) || IsNilOrNull(_basicWorkModel.endTime)) {
                _basicWorkModel.endTime = [InsureValidate getCurrentTimesTwo];
            }
            
            if (!IsStrEmpty(_basicWorkModel.endTime) && !IsNilOrNull(_basicWorkModel.endTime)) {
                NSString *TimeStr = [self getTimeStrWithString:_basicWorkModel.endTime];
                NSInteger afterTime = [TimeStr integerValue];// - (60*60*24);
                NSString *afterString = [self tuanTime:afterTime];
                
                NSString *year = [afterString substringToIndex:4];
                NSString *month = [afterString substringWithRange:NSMakeRange(5, 2)];
                NSString *day = [afterString substringFromIndex:8];
                maxDate = [NSDate br_setYear:[year integerValue] month:[month integerValue] day:[day integerValue]];
                maxTime = afterString;
            }
            
            [BRDatePickerView showDatePickerWithTitle:@"结束时间" dateType:BRDatePickerModeYMD defaultSelValue:maxTime minDate:nil maxDate:curDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
                self.basicWorkModel.endTime = selectValue;
                [self.groupTableView reloadData];
            } cancelBlock:^{
                self.basicWorkModel.endTime = @"至今";
                [self.groupTableView reloadData];
            }];
        }
    }
    else if (indexPath.section == 0 && indexPath.row == 5)
    {
        if (self.experienceState == EditExperienceStateEducation)
        {
            NSDate *minDate = nil;
            NSString *minTime = nil;
            
            if ([_basicEduModel.beginTime isEqualToString:@"至今"]) {
                _basicEduModel.beginTime = [InsureValidate getCurrentTimesTwo];
            }
            
            if (IsStrEmpty(_basicEduModel.beginTime) || IsNilOrNull(_basicEduModel.beginTime)) {
                _basicEduModel.beginTime = [InsureValidate getCurrentTimesTwo];
            }
            
            if (!IsStrEmpty(_basicEduModel.beginTime) && !IsNilOrNull(_basicEduModel.beginTime)) {
                NSString *TimeStr = [self getTimeStrWithString:_basicEduModel.beginTime];
                NSInteger afterTime = [TimeStr integerValue] + (60*60*24);
                NSString *afterString = [self tuanTime:afterTime];
                
                NSString *year = [afterString substringToIndex:4];
                NSString *month = [afterString substringWithRange:NSMakeRange(5, 2)];
                NSString *day = [afterString substringFromIndex:8];
                minDate = [NSDate br_setYear:[year integerValue] month:[month integerValue] day:[day integerValue]];
                minTime = afterString;
            }
            
            NSDate *maxDate = nil;
            NSString *maxTime = nil;
            
            if ([_basicEduModel.endTime isEqualToString:@"至今"]) {
                _basicEduModel.endTime = [InsureValidate getCurrentTimesTwo];
            }
            
            if (IsStrEmpty(_basicEduModel.beginTime) || IsNilOrNull(_basicEduModel.beginTime)) {
                _basicEduModel.beginTime = [InsureValidate getCurrentTimesTwo];
            }
            
            if (!IsStrEmpty(_basicEduModel.endTime) && !IsNilOrNull(_basicEduModel.endTime)) {
                NSString *TimeStr = [self getTimeStrWithString:_basicEduModel.endTime];
                NSInteger afterTime = [TimeStr integerValue];// - (60*60*24);
                NSString *afterString = [self tuanTime:afterTime];
                
                NSString *year = [afterString substringToIndex:4];
                NSString *month = [afterString substringWithRange:NSMakeRange(5, 2)];
                NSString *day = [afterString substringFromIndex:8];
                maxDate = [NSDate br_setYear:[year integerValue] month:[month integerValue] day:[day integerValue]];
                maxTime = afterString;
            }
            
            NSString *curTime = [InsureValidate getCurrentTimesTwo];
            NSString *TimeStr = [self getTimeStrWithString:curTime];
            NSInteger afterTime = [TimeStr integerValue];
            NSString *afterString = [self tuanTime:afterTime];
            NSString *year = [afterString substringToIndex:4];
            NSString *month = [afterString substringWithRange:NSMakeRange(5, 2)];
            NSString *day = [afterString substringFromIndex:8];
            NSDate *curDate = [NSDate br_setYear:[year integerValue] month:[month integerValue] day:[day integerValue]];
            
            [BRDatePickerView showDatePickerWithTitle:@"结束时间" dateType:BRDatePickerModeYMD defaultSelValue:maxTime minDate:nil maxDate:curDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
                self.basicEduModel.endTime = selectValue;
                [self.groupTableView reloadData];
            } cancelBlock:^{
                self.basicEduModel.endTime = @"至今";
                [self.groupTableView reloadData];
            }];
        }
        else if (self.experienceState == EditExperienceStateWork)
        {
            
        }
    }
    else
    {
        NSInteger selectIndex = 1+indexPath.row;
        UITextField *textField = [self.view viewWithTag:selectIndex];
        [textField becomeFirstResponder];
    }
}

//字符串转时间戳 如：2017-4-10 17:15:10
- (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}

- (NSString *)tuanTime:(NSInteger)time {
    
    // iOS 生成的时间戳是10位
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
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
    self.imageData = UIImageJPEGRepresentation(upImage, 0.5);
    self.image = upImage;
    [self.groupTableView reloadData];
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

- (void)dealloc {
    [self.manager clearSelectedList];
}

#pragma mark 教育经历
- (void)loadEducationSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.basicID forKey:@"id"];
    
    [self displayOverFlowActivityView];
    [AccountService getEducationWithParameters:postDic success:^(EducationModel *model) {
        [self removeOverFlowActivityView];
        self.basicEduModel = model;
        self.footView.describeInfo = model.eduDescribe;
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

//新增教育经历
- (void)addEducationExperience {
    
    _basicEduModel.eduDescribe = _footView.describeInfo;
    
//    if (IsNilOrNull(_basicEduModel.eduDescribe) || IsStrEmpty(_basicEduModel.eduDescribe)) {
//        [self presentSheet:@"请完善信息"];
//        self.rightNaviBtn.selected = NO;
//        return;
//    }
    
    NSLog(@"_footView.describeInfo = %@",_footView.describeInfo);
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:_basicEduModel.schoolName forKey:@"schoolName"];//学习名称
    [postDic setValue:_basicEduModel.subjectName  forKey:@"subjectName"];//专业名称
    [postDic setValue:_basicEduModel.beginTime  forKey:@"beginTime"];//开始时间
    [postDic setValue:_basicEduModel.endTime  forKey:@"endTime"];//结束时间
    if (IsNilOrNull(_basicEduModel.eduDescribe) || IsStrEmpty(_basicEduModel.eduDescribe)) {
        [postDic setValue:@""  forKey:@"eduDescribe"];//描述
    }
    else {
        [postDic setValue:_basicEduModel.eduDescribe  forKey:@"eduDescribe"];//描述
    }
    [postDic setValue:_basicEduModel.diploma  forKey:@"diploma"];//学历
    
    NSLog(@"新增教育经历 postDic== == %@",postDic);

    if (postDic.count != 6) {
        [self showAlertWithString:@"请完善信息"];
        self.rightNaviBtn.selected = NO;
        return;
    }
    
    if (_basicEduModel.schoolName.length > 20) {
        [self showAlertWithString:@"学校名称不能超过20字"];
        self.rightNaviBtn.selected = NO;
        return;
    }
    if (_basicEduModel.subjectName.length > 10) {
        [self showAlertWithString:@"专业名称不能超过10字"];
        self.rightNaviBtn.selected = NO;
        return;
    }
    
    if (![[InsureValidate compareDate:[LBForProject transformDate:_basicEduModel.beginTime] withDate:[LBForProject transformDate:_basicEduModel.endTime]] isEqualToString:@"-1"]) {
        [self showAlertWithString:@"开始时间不能晚于结束时间"];
        self.rightNaviBtn.selected = NO;
        return;
    }
    
//    if (IsNilOrNull(self.image)) {
//        [self showAlertWithString:@"请上传LOGO"];
//        return;
//    }
    
    NSLog(@"新增一次教育经历");
    
    [self displayOverFlowActivityView];
    [AccountService getAddEducationWithParameters:postDic file:self.imageData fileName:@"eduLogo" success:^(id model) {
        [self removeOverFlowActivityView];
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        [self backNavItemTapped];
        self.rightNaviBtn.selected = NO;
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
        self.rightNaviBtn.selected = NO;
    }];
}

//编辑教育经历
- (void)editEducationExperience {
    
    _basicEduModel.eduDescribe = _footView.describeInfo;
    
//    if (IsNilOrNull(_basicEduModel.eduDescribe) || IsStrEmpty(_basicEduModel.eduDescribe)) {
//        [self presentSheet:@"请完善信息"];
//        self.rightNaviBtn.selected = NO;
//        return;
//    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:_basicEduModel.id forKey:@"id"];//教育经历的id
    [postDic setValue:_basicEduModel.schoolName  forKey:@"schoolName"];//学习名称
    [postDic setValue:_basicEduModel.subjectName  forKey:@"subjectName"];//专业名称
    [postDic setValue:_basicEduModel.beginTime  forKey:@"beginTime"];//开始时间
    [postDic setValue:_basicEduModel.endTime  forKey:@"endTime"];//结束时间
    
    [postDic setValue:_basicEduModel.diploma  forKey:@"diploma"];//学历
    
    if (IsNilOrNull(_basicEduModel.eduDescribe) || IsStrEmpty(_basicEduModel.eduDescribe)) {
        [postDic setValue:@""  forKey:@"eduDescribe"];//描述
    }
    else {
        [postDic setValue:_basicEduModel.eduDescribe  forKey:@"eduDescribe"];//描述
    }

    NSLog(@"编辑教育经历 postDic== == %@",postDic);
    if (postDic.count != 7) {
        [self showAlertWithString:@"请完善信息"];
        self.rightNaviBtn.selected = NO;
        return;
    }

    if (_basicEduModel.schoolName.length > 20) {
        [self showAlertWithString:@"学校名称不能超过20字"];
        self.rightNaviBtn.selected = NO;
        return;
    }
    if (_basicEduModel.subjectName.length > 10) {
        [self showAlertWithString:@"专业名称不能超过10字"];
        self.rightNaviBtn.selected = NO;
        return;
    }
    
    if (![[InsureValidate compareDate:[LBForProject transformDate:_basicEduModel.beginTime] withDate:[LBForProject transformDate:_basicEduModel.endTime]] isEqualToString:@"-1"]) {
        [self showAlertWithString:@"开始时间不能晚于结束时间"];
        self.rightNaviBtn.selected = NO;
        return;
    }
    
//    if (IsNilOrNull(self.image)) {
//        [self showAlertWithString:@"请上传LOGO"];
//        return;
//    }
    
    [self displayOverFlowActivityView];
    [AccountService getEditEducationWithParameters:postDic file:self.imageData fileName:@"eduLogo" success:^(id model) {
        [self removeOverFlowActivityView];
        [self backNavItemTapped];
        self.rightNaviBtn.selected = NO;
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
        self.rightNaviBtn.selected = NO;
    }];
}

//删除教育经历
- (void)deleteEducationExperience {
    
    UIAlertController *alert = [CHAlertView showMessageWith:@"确定" title:@"确定删除该教育经历?" confim:^{
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        [postDic setValue:self.basicEduModel.id forKey:@"id"];
        [postDic setValue:self.isFirst?@"1":@"0" forKey:@"sign"];//是否是最新的经历 1 是 0 否
        
        NSLog(@"删除教育经历 postDic== == %@",postDic);
        
        [self displayOverFlowActivityView];
        [AccountService getDeleteEducationWithParameters:postDic success:^(id model) {
            [self removeOverFlowActivityView];
            [self backNavItemTapped];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 工作经历
- (void)loadWorkDataSource {
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.basicID forKey:@"id"];
    
    [self displayOverFlowActivityView];
    [AccountService getWorkWithParameters:postDic success:^(WorkModel *model) {
        [self removeOverFlowActivityView];
        self.basicWorkModel = model;
        self.footView.describeInfo = model.describeInfo;
        [self.groupTableView reloadData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

//新增工作经历
- (void)addWorkExperience {
    
    _basicWorkModel.describeInfo = _footView.describeInfo;
    
//    if (IsNilOrNull(_basicWorkModel.describeInfo) || IsStrEmpty(_basicWorkModel.describeInfo)) {
//        [self presentSheet:@"请完善信息"];
//        self.rightNaviBtn.selected = NO;
//        return;
//    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:[Config currentConfig].userUid forKey:@"userUid"];//用户uid
    [postDic setValue:self.image forKey:@"comLogo"];//公司logo
    [postDic setValue:_basicWorkModel.company forKey:@"company"];//公司名称
    [postDic setValue:_basicWorkModel.position forKey:@"position"];//职位
    [postDic setValue:_basicWorkModel.beginTime forKey:@"beginTime"];//开始时间
    [postDic setValue:_basicWorkModel.endTime forKey:@"endTime"];//结束时间
    [postDic setValue:_basicWorkModel.describeInfo forKey:@"describeInfo"];//经历描述
    
    NSLog(@"新增工作经历 postDic== == %@",postDic);
    if (postDic.count != 7) {
        
        [self showAlertWithString:@"请完善信息"];
        self.rightNaviBtn.selected = NO;
        return;
    }
    
    if (_basicWorkModel.company.length > 20) {
        [self showAlertWithString:@"公司名称不能超过20字"];
        self.rightNaviBtn.selected = NO;
        return;
    }
    if (_basicWorkModel.position.length > 10) {
        [self showAlertWithString:@"职位不能超过10字"];
        self.rightNaviBtn.selected = NO;
        return;
    }

    if (![[InsureValidate compareDate:[LBForProject transformDate:_basicWorkModel.beginTime] withDate:[LBForProject transformDate:_basicWorkModel.endTime]] isEqualToString:@"-1"]) {
        [self showAlertWithString:@"开始时间不能晚于结束时间"];
        self.rightNaviBtn.selected = NO;
        return;
    }
    
    if (IsNilOrNull(self.image)) {
        [self showAlertWithString:@"请上传LOGO"];
        return;
    }
    
    NSLog(@"新增一次教育经历");
    
    [self displayOverFlowActivityView];
    [AccountService getAddWorkWithParameters:postDic file:self.imageData fileName:@"comLogo" success:^(id model) {
        [self removeOverFlowActivityView];
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        [self backNavItemTapped];
        self.rightNaviBtn.selected = NO;
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
        self.rightNaviBtn.selected = NO;
    }];
}

//编辑工作经历
- (void)editWorkExperience {
    
    _basicWorkModel.describeInfo = _footView.describeInfo;
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:_basicWorkModel.id forKey:@"id"];//教育经历的id
    [postDic setValue:self.basicWorkModel.comLogo forKey:@"comLogo"];//公司logo
    [postDic setValue:_basicWorkModel.company  forKey:@"company"];//公司名称
    [postDic setValue:_basicWorkModel.position  forKey:@"position"];//职位
    [postDic setValue:_basicWorkModel.beginTime  forKey:@"beginTime"];//开始时间
    [postDic setValue:_basicWorkModel.endTime  forKey:@"endTime"];//结束时间
    [postDic setValue:_basicWorkModel.describeInfo  forKey:@"describeInfo"];//经历描述
    
    NSLog(@"编辑工作经历postDic == %@",postDic);
    
    if (postDic.count != 7) {
        [self showAlertWithString:@"请完善信息"];
        self.rightNaviBtn.selected = NO;
        return;
    }

    if (_basicWorkModel.company.length > 20) {
        [self showAlertWithString:@"公司名称不能超过20字"];
        self.rightNaviBtn.selected = NO;
        return;
    }
    if (_basicWorkModel.position.length > 10) {
        [self showAlertWithString:@"职位不能超过10字"];
        self.rightNaviBtn.selected = NO;
        return;
    }
    
    if (![[InsureValidate compareDate:[LBForProject transformDate:_basicWorkModel.beginTime] withDate:[LBForProject transformDate:_basicWorkModel.endTime]] isEqualToString:@"-1"]) {
        [self showAlertWithString:@"开始时间不能晚于结束时间"];
        self.rightNaviBtn.selected = NO;
        return;
    }
    
    if (IsNilOrNull(self.basicWorkModel.comLogo)) {
        [self showAlertWithString:@"请上传LOGO"];
        return;
    }
    
    [self displayOverFlowActivityView];
    [AccountService getEditWorkWithParameters:postDic file:self.imageData fileName:@"comLogo" success:^(id model) {
        [self removeOverFlowActivityView];
        [self backNavItemTapped];
        self.rightNaviBtn.selected = NO;
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
        self.rightNaviBtn.selected = NO;
    }];
}

//删除工作经历
- (void)deleteWorkExperience {
    
    UIAlertController *alert = [CHAlertView showMessageWith:@"确定" title:@"确定删除该工作经历?" confim:^{
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        [postDic setValue:self.basicWorkModel.id forKey:@"id"];
        [postDic setValue:self.isFirst?@"1":@"0" forKey:@"sign"];//是否是最新的经历 1 是 0 否
        
        [self displayOverFlowActivityView];
        [AccountService getDeleteWorkWithParameters:postDic success:^(id model) {
            [self removeOverFlowActivityView];
            [self backNavItemTapped];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark Event
- (void)getContentWith:(NSInteger)index content:(NSString *)content {
    
    switch (index) {
        case 2:
        {
            if (self.experienceState == EditExperienceStateEducation)
            {
                _basicEduModel.schoolName = content;
            }
            else if (self.experienceState == EditExperienceStateWork)
            {
                _basicWorkModel.company = content;
            }
        }
            break;
        case 3:
        {
            if (self.experienceState == EditExperienceStateEducation)
            {
                _basicEduModel.subjectName = content;
            }
            else if (self.experienceState == EditExperienceStateWork)
            {
                _basicWorkModel.position = content;
            }
        }
            break;
        default:
            break;
    }
}

- (void)rightNaviBtnClick {
    [self saveExperienceClick];
}

- (void)deleteExperienceClick {
    
    if (self.experienceState == EditExperienceStateEducation)
    {
        [self deleteEducationExperience];
    }
    else if (self.experienceState == EditExperienceStateWork)
    {
        [self deleteWorkExperience];
    }
}

- (void)saveExperienceClick {
    
    for (int i = 1; i < 10; i++) {
        UITextField *tf = [self.view viewWithTag:i];
        [tf resignFirstResponder];
    }
    
    if (self.rightNaviBtn.selected) {
        NSLog(@"防止重复提交数据");
        return;
    }
    self.rightNaviBtn.selected = YES;
    
    if (self.experienceState == EditExperienceStateEducation)
    {
        if (self.isEdit)
        {
            [self editEducationExperience];
        }
        else
        {
            [self addEducationExperience];
        }
    }
    else if (self.experienceState == EditExperienceStateWork)
    {
        if (self.isEdit)
        {
            [self editWorkExperience];
        }
        else
        {
            [self addWorkExperience];
        }
    }
}

#pragma mark 界面布局
- (void)createSubViews {
    
    WeakSelf;
    self.view.backgroundColor = kBackgroundColor;
    
    [self setRightNaviBtnTitle:@"保存"];
    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _footView = [[EditExprienceFootView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, (self.experienceState == EditExperienceStateWork)?kCurrentWidth(295):kCurrentWidth(250)) isEdit:self.isEdit];
    _footView.experienceState = self.experienceState;
    _footView.deleteExperienceBlock = ^{
        [weakSelf deleteExperienceClick];
    };
    _footView.saveExperienceBlock = ^{
        [weakSelf saveExperienceClick];
    };
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    self.groupTableView.tableFooterView = _footView;
    [self.view addSubview:self.groupTableView];
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
        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(kDeviceWidth, kDeviceWidth);
    }
    return _manager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
