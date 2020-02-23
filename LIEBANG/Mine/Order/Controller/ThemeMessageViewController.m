//
//  ThemeMessageViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/4.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ThemeMessageViewController.h"
#import "EditAccountCell.h"
#import "EditExprienceFootView.h"
#import "XFTreePopupView.h"
#import "ConversationViewController.h"
#import "UserHelpViewController.h"


static NSString *const kLBBReceiptData = @"1.为节约双方时间，建议行家拟定预约时间地点时，提前私信沟通与学员协商一致；\n2.线下约见：由行家拟定预约时间地点，或与学员协商一致后，行家可再次修改预约，由学员确认，确认后双方按确定方式约见或通话，服务完成；\n3.全国通话：须由行家主动拨打学员电话完成服务；\n4.行家应准时按约定时间地点完成约见或通话服务；\n5.在线问答：行家回答学员的在线提问时，可设置回答类型，如设置1元查看时，每当问题被查看，您将获得一部分收入；\n6.如有疑问和争议，参见使用帮助、用户协议。";
static NSString *const kLBUseHelp = @"使用帮助";
static NSString *const kLBUseProtocol = @"用户协议";

static NSArray *titleArray;
static NSArray *plTitleArray;
@interface ThemeMessageViewController ()

@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)NSString *time;

@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,strong)UIButton *saveButton;

@end

@implementation ThemeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createSubViews];
    
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellStr = @"EditAccountCell";
    EditAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[EditAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    [cell setThemeDataWith:titleArray plTitleArray:plTitleArray indexPath:indexPath];
    cell.detailModel = self.detailModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITextField *textField = [self.view viewWithTag:13];
    UITextField *textField1 = [self.view viewWithTag:12];
    [textField resignFirstResponder];
    [textField1 resignFirstResponder];
    
    //时间有---时分秒
    if (indexPath.row == 0)
    {
        NSDate *maxDate = nil;
        NSString *maxTime = nil;
        if (!IsStrEmpty(self.detailModel.mettingBeginTime) && !IsNilOrNull(self.detailModel.mettingBeginTime)) {
            NSString *TimeStr = [self getTimeStrWithString:self.detailModel.mettingBeginTime];
            NSInteger afterTime = [TimeStr integerValue];
            NSString *afterString = [self tuanTime:afterTime];
            
            NSString *year = [afterString substringToIndex:4];
            NSString *month = [afterString substringWithRange:NSMakeRange(5, 2)];
            NSString *day = [afterString substringFromIndex:8];
            NSString *hour = [afterString substringWithRange:NSMakeRange(11, 2)];
            NSString *minute = [afterString substringWithRange:NSMakeRange(14, 2)];
            maxDate = [NSDate br_setYear:[year integerValue] month:[month integerValue] day:[day integerValue]];
            maxTime = afterString;
        }
        
        [BRDatePickerView showDatePickerWithTitle:@"开始时间" dateType:BRDatePickerModeYMDHM defaultSelValue:maxTime minDate:[NSDate date] maxDate:nil isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
            self.detailModel.mettingBeginTime = selectValue;
            [self.groupTableView reloadData];
        }];
    }
    else if (indexPath.row == 1)
    {
        NSDate *maxDate = nil;
        NSString *maxTime = nil;
        if (!IsStrEmpty(self.detailModel.mettingEdnTime) && !IsNilOrNull(self.detailModel.mettingEdnTime)) {
            NSString *TimeStr = [self getTimeStrWithString:self.detailModel.mettingEdnTime];
            NSInteger afterTime = [TimeStr integerValue];
            NSString *afterString = [self tuanTime:afterTime];

            NSString *year = [afterString substringToIndex:4];
            NSString *month = [afterString substringWithRange:NSMakeRange(5, 2)];
            NSString *day = [afterString substringWithRange:NSMakeRange(8, 2)];
//            NSString *hour = [afterString substringWithRange:NSMakeRange(11, 2)];
//            NSString *minute = [afterString substringWithRange:NSMakeRange(14, 2)];
            
//            maxDate = [NSDate br_setYear:[year integerValue] month:[month integerValue] day:[day integerValue] hour:[hour integerValue] minute:[minute integerValue]];
            maxDate = [NSDate br_setYear:[year integerValue] month:[month integerValue] day:[day integerValue]];
            maxTime = afterString;
        }
        
        [BRDatePickerView showDatePickerWithTitle:@"结束时间" dateType:BRDatePickerModeYMDHM defaultSelValue:maxTime minDate:[NSDate date] maxDate:nil isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
            self.detailModel.mettingEdnTime = selectValue;
            [self.groupTableView reloadData];
        }];
    }
}

//字符串转时间戳 如：2017-4-10 17:15:10
- (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}

- (NSString *)tuanTime:(NSInteger)time {
    
    // iOS 生成的时间戳是10位
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

#pragma mark Event
- (void)cancelButtonClick {
    ConversationViewController *_conversationVC = [[ConversationViewController alloc]init];
    _conversationVC.conversationType = ConversationType_PRIVATE;
    _conversationVC.targetId = self.detailModel.StudentuserUid;
    _conversationVC.title = self.detailModel.StudentuserName;
    
    RCUserInfo *user = [RCUserInfo new];
    user.name = self.detailModel.StudentuserName;
    user.userId = self.detailModel.StudentuserUid;
    user.portraitUri = self.detailModel.StudentuserHead;
    [[RCDataManager shareManager] addRCUserInfo:user];
    
    [self.navigationController pushViewController:_conversationVC animated:YES];
}

- (void)saveButtonClick {
    
    UITextField *textField = [self.view viewWithTag:13];
    self.detailModel.detailedAddress = textField.text;
    
    UITextField *textField1 = [self.view viewWithTag:12];
    self.detailModel.mettingAddress = textField1.text;
    
    if ([self.detailModel.serviceType intValue] == 0)
    {
        if (IsNilOrNull(self.detailModel.mettingBeginTime) || IsStrEmpty(self.detailModel.mettingBeginTime) || IsNilOrNull(self.detailModel.mettingEdnTime) || IsStrEmpty(self.detailModel.mettingEdnTime) ||
            IsNilOrNull(self.detailModel.mettingAddress) || IsStrEmpty(self.detailModel.mettingAddress) ||
            IsNilOrNull(self.detailModel.detailedAddress) || IsStrEmpty(self.detailModel.detailedAddress)) {
            [self showAlertWithString:@"请完善信息"];
            return;
        }
    }
    else
    {
        if (IsNilOrNull(self.detailModel.mettingBeginTime) || IsStrEmpty(self.detailModel.mettingBeginTime) || IsNilOrNull(self.detailModel.mettingEdnTime) || IsStrEmpty(self.detailModel.mettingEdnTime)) {
            [self showAlertWithString:@"请完善信息"];
            return;
        }
    }

    if (![[InsureValidate compareDate:self.detailModel.mettingBeginTime withDate:self.detailModel.mettingEdnTime] isEqualToString:@"-1"]) {
        [self showAlertWithString:@"开始时间不能晚于结束时间"];
        return;
    }
    
    if (_confimButtonBlock) {
        _confimButtonBlock(self.detailModel);
    }
    [self backNavItemTapped];
}

#pragma mark 界面布局
- (void)createSubViews {
    
    self.view.backgroundColor = kBackgroundColor;
    
    if ([self.detailModel.serviceType intValue] == 0)
    {
        titleArray = @[@"开始时间",@"结束时间",@"地点",@"详细地址"];
        plTitleArray = @[@"请选择开始时间",@"请选择结束时间",@"请选择地点",@"请填写详细地址"];
        self.navigationItem.title = @"预约时间地点";
    }
    else
    {
        titleArray = @[@"开始时间",@"结束时间"];
        plTitleArray = @[@"请选择开始时间",@"请选择结束时间"];
        self.navigationItem.title = @"预约时间";
    }
    
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), kCurrentWidth(15), kDeviceWidth-kCurrentWidth(26), kCurrentWidth(40))];
    _label.numberOfLines = 0;
    _label.font = kSystem(15);
    _label.textColor = kLBThreeColor;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"行家服务须知";
    [_footView addSubview:_label];
    
    CGSize size = [kLBBReceiptData sizeWithFont:kSystem(13) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(26), MAXFLOAT)];
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:kLBBReceiptData attributes:nil]];
    text.yy_font = [UIFont systemFontOfSize:14];
    text.yy_color = kLBSixColor;
    [text yy_setColor:kLBRedColor range:[kLBBReceiptData rangeOfString:kLBUseProtocol]];
    [text yy_setTextHighlightRange:[kLBBReceiptData rangeOfString:kLBUseProtocol] color:kLBRedColor backgroundColor:kLBRedColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        WebViewController *nextCtr = [[WebViewController alloc] init];
        nextCtr.webViewType = WebViewTypeUserProtocol;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }];
    
    [text yy_setColor:kLBRedColor range:[kLBBReceiptData rangeOfString:kLBUseHelp]];
    [text yy_setTextHighlightRange:[kLBBReceiptData rangeOfString:kLBUseHelp] color:kLBRedColor backgroundColor:kLBRedColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        UserHelpViewController *nextCtr = [[UserHelpViewController alloc] init];
        [self.navigationController pushViewController:nextCtr animated:YES];
    }];
    
    YYLabel *messageLabel = [[YYLabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), _label.bottom, kDeviceWidth-kCurrentWidth(24), size.height+20)];
    messageLabel.numberOfLines = 0;
    messageLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.attributedText = text;
    [_footView addSubview:messageLabel];
    
    _footView.height = size.height+kCurrentWidth(60);
    
    self.groupTableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
    self.groupTableView.backgroundColor = kBackgroundColor;
    self.groupTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.groupTableView.separatorInset = UIEdgeInsetsZero;
    self.groupTableView.tableFooterView = _footView;
    [self.view addSubview:self.groupTableView];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(kCurrentWidth(12), kDeviceHeight-kNavBarHeight-kCurrentWidth(70), (kDeviceWidth-kCurrentWidth(36))/2, kCurrentWidth(40));
    [_cancelButton setTitle:@"私信" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _cancelButton.backgroundColor = kLBRedColor;
    _cancelButton.titleLabel.font = kSystem(15);
    _cancelButton.layer.cornerRadius = kCurrentWidth(20);
    _cancelButton.layer.masksToBounds = YES;
    [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveButton.frame = CGRectMake(kDeviceWidth/2+kCurrentWidth(6), kDeviceHeight-kNavBarHeight-kCurrentWidth(70), (kDeviceWidth-kCurrentWidth(36))/2, kCurrentWidth(40));
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _saveButton.backgroundColor = kLBRedColor;
    _saveButton.titleLabel.font = kSystem(15);
    _saveButton.layer.cornerRadius = kCurrentWidth(20);
    _saveButton.layer.masksToBounds = YES;
    [_saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
