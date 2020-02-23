//
//  LBForProject.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "LBForProject.h"

@implementation LBForProject

+ (LBForProject *)currentProject {
    static LBForProject *currentConfig = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        currentConfig = [[LBForProject alloc] init];
    });
    return currentConfig;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _mineCellTitleArray = @[@[@""],@[@"编辑资料"],@[@"订单中心",@"钱包",@"优惠券"],@[@"成为行家认证用户",@"我认领的企业名片"],@[@"影响力奖励",@"设置"]];
        _mineCellImageArray = @[@[@""],@[@"list_icon_bianji"],@[@"list_icon_dingdan",@"list_icon_qianbao.png",@"list_icon_youhuiquani"],@[@"list_icon_hangjia",@"icon_qiyemingpian"],@[@"list_icon_jianglii.png",@"list_icon_shezhi"]];
        
        _friendCellTitleArray = @[@"我的好友",@"拓展人脉"];
        _friendCellImageArray = @[@"list_btn_wodehaoyou",@"list_btn_renmai"];
        
        _setCellTitleArray = @[@[@"消息通知",@"关于猎帮",@"隐私策略"],@[@"邀请好友加入猎帮"],@[@"账号安全",@"清理缓存"],@[@"退出登录"]];
        _aboutCellTitleArray = @[@"关于猎帮",@"给猎帮好评",@"使用帮助"];
        
//        _privacyCellTitleArray = @[@[@"仅好友",@"所有人"],@[@"仅好友",@"所有人"],@[@"所有人",@"猎头",@"销售、理财、保险",@"影响力小于10的",@"未认证基本信息用户",@"未认证职业经历用户",@"未认证教育经历用户"]];
        _privacyCellTitleArray = @[@[@"允许",@"不允许"],@[@"仅好友",@"所有人"],@[@"仅好友",@"所有人"],@[@"所有人",@"影响力小于10的",@"未认证基本信息用户",@"未认证职业经历用户",@"未认证教育经历用户"]];
        
        _safeCellTitleArray = @[@"修改手机号",@"修改密码"];
        
        _editCellTitleArray = @[@[@"头像",@"真实姓名",@"行业",@"职业标签",@"所在地区",@"详细地区"],@[@"手机号",@"邮箱"]];
        
        _ORCertiCellTitleArray = @[@"* 机构名称",@"* 机构全称",@"* 联系人姓名",@"* 联系人职位",@"* 联系人手机",@"* 邮箱",@"* 所在城市",@"* 所在地区",@"* 营业执照"];
        
        _comCertiCellTitleArray = @[@"公司LOGO",@"   企业简称",@"* 企业全称",@"   融资状态",@"   人员规模",@"   所处行业",@"   官网",@"   邮箱",@"   公司电话",@"   所在城市",@"   所在地区/地址",@"* 联系人姓名",@"* 联系人职位",@"* 联系人手机"];
        
        _companyCellTitleArray = @[@[@"我的企业AI智能名片",@"我的企业员工管理"],@[@"编辑企业AI智能名片",@"建立企业AI智能名片",@"推广企业AI智能名片",@"收藏企业AI智能名片"]];
        _companyCellImageArray = @[@[@"my_company_mingpian",@"my_company_guanli"],@[@"my_company_bianji",@"my_company_jianli",@"my_company_tuiguang",@"my_company_shoucang"]];
        
        _companyInfoArray = [NSMutableArray array];
        _productServiceArray = [NSMutableArray array];
        _recruitArray = [NSMutableArray array];
    }
    return self;
}

/**
 是否登录
 */
+ (BOOL)isLogin:(UIViewController *)viewController
{
    LoginModel *account = [SDUserTool account];
    if (IsNilOrNull(account.rongCloudToken) || IsStrEmpty(account.rongCloudToken)) {
        UIAlertController *alert = [CHAlertView showMessageWith:@"去登陆" title:@"您还没有登陆" confim:^{
            LoginViewController *nextCtr = [[LoginViewController alloc] init];
            CommonNavgationViewController *nextNav = [[CommonNavgationViewController alloc] initWithRootViewController:nextCtr];
            [viewController.navigationController presentViewController:nextNav animated:YES completion:^{
                
            }];
        }];
        [viewController presentViewController:alert animated:YES completion:nil];
        return NO;
    } else {
        return YES;
    }
}

/**
 手机号码验证
 
 @return bool
 */
+ (NSString *)isCheckPhone:(NSString *)phone;
{
    if (IsStrEmpty(phone)) {
        return @"请输入手机号码";
    }
    if (![InsureValidate validateMobile:[InsureValidate deleteWhiteSpaceInStr:phone]] || [InsureValidate deleteWhiteSpaceInStr:phone].length != 11) {
        return @"请输入正确的手机号码";
    }
    return @"";
}

/**
 XXXX年XX月XX日 转 XXXX-XX-XX
 
 @return XXXX-XX-XX
 */
+ (NSString *)transformDate:(NSString *)date {
    date = [date stringByReplacingOccurrencesOfString:@"日" withString:@""];
    date = [date stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    date = [date stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    return date;
}

/**
 XXXX-XX-XX 转 XXXX年XX月XX日
 
 @return XXXX年XX月XX日
 */
+ (NSString *)conversionDate:(NSString *)date {
    date = [date stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
    date = [date stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
//    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
//    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    date = [date stringByAppendingString:@"日"];
    return date;
}

/**
 XXXX-XX-XX 转 XXXX.XX.XX
 
 @return XXXX-XX-XX
 */
+ (NSString *)conversionDate2:(NSString *)date
{
    if ([date length] < 8) {
        return date;
    }
    date = [date stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"."];
    date = [date stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:@"."];
    //    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    //    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    return date;
}

/**
 话题订单详情cell
 
 @param detailModel ThemeOrderDetailModel
 */
+ (void)decodeThemeDetailCellTitle:(ThemeOrderDetailModel *)detailModel detailType:(QuestionDetailType)detailType {
    
    if ([detailModel.orderStates intValue] == 0)
    {
        
    }
    else if ([detailModel.orderStates intValue] == 1)
    {
        NSString *string = [InsureValidate timestamp:detailModel.endTime];
        if ([string containsString:@"-"])
        {
            if (detailType == QuestionDetailTypeExpert)
            {
                [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
            }
            else
            {
                [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
            }
        }
        else
        {
            if (detailType == QuestionDetailTypeExpert)
            {
                [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"MemberPhoneCell",@"OrderConfimCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
            }
            else
            {
                [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
            }
        }
    }
    else if ([detailModel.orderStates intValue] == 2)
    {
        [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"MemberPhoneCell",@"OrderConfimCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
    }
    else if ([detailModel.orderStates intValue] == 3)
    {
        if (!IsStrEmpty(detailModel.mettingEdnTime) && !IsNilOrNull(detailModel.mettingEdnTime))
        {
            [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"MemberPhoneCell",@"OrderConfimCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
        }
        else
        {
            [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"MemberPhoneCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
        }
    }
    else if ([detailModel.orderStates intValue] == 4)
    {
        if (detailType == QuestionDetailTypeExpert)
        {
            if (!IsStrEmpty(detailModel.mettingEdnTime) && !IsNilOrNull(detailModel.mettingEdnTime))
            {
                [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"MemberPhoneCell",@"OrderConfimCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
            }
            else
            {
                [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"MemberPhoneCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
            }
        }
        else
        {
            if (!IsStrEmpty(detailModel.mettingEdnTime) && !IsNilOrNull(detailModel.mettingEdnTime))
            {
                [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"MemberPhoneCell",@"OrderConfimCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell",@"OrderCommentCell"];
            }
            else
            {
                [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"MemberPhoneCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell",@"OrderCommentCell"];
            }
        }
    }
    else if ([detailModel.orderStates intValue] == 5)
    {
        [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
    }
    else if ([detailModel.orderStates intValue] == 6)
    {
        [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
    }
    else if ([detailModel.orderStates intValue] == 7)
    {
        [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
    }
    else if ([detailModel.orderStates intValue] == 8)
    {
        [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
    }
    else if ([detailModel.orderStates intValue] == 9)
    {
        [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"MemberPhoneCell",@"OrderConfimCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
    }
    else if ([detailModel.orderStates intValue] == 10)
    {
        [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"MemberPhoneCell",@"OrderConfimCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
    }
    else if ([detailModel.orderStates intValue] == 11)
    {
        [LBForProject currentProject].detailCellTitleArray = @[@"OrderStatusCell",@"HomeMeetCell",@"MemberPhoneCell",@"OrderConfimCell",@"OrderQuestionCell",@"OrderIntroductionCell",@"OrderUidCell"];
    }
    NSLog(@"detailCellTitleArray = %@",[LBForProject currentProject].detailCellTitleArray);
}

/**
 问答订单详情cell
 
 @param detailModel QuestionOrderDetailModel
 */
+ (void)decodeQuestionDetailCellTitle:(QuestionOrderDetailModel *)detailModel detailType:(QuestionDetailType)detailType
{
    if ([detailModel.orderStates intValue] == 0)
    {
        
    }
    else if ([detailModel.orderStates intValue] == 1)
    {
        NSString *string = [InsureValidate timestamp:detailModel.endTime];
        if ([string containsString:@"-"])
        {
            if (detailType == QuestionDetailTypeExpert)
            {
                [LBForProject currentProject].detailCellTitleArray = @[@"QuestionTitleCell",@"QuestionPersonCell"];
            }
            else
            {
                [LBForProject currentProject].detailCellTitleArray = @[@"QuestionTitleCell",@"QuestionPersonCell"];
            }
        }
        else
        {
            if (detailType == QuestionDetailTypeExpert)
            {
                [LBForProject currentProject].detailCellTitleArray = @[@"QuestionTitleCell",@"QuestionPersonCell"];
            }
            else
            {
                [LBForProject currentProject].detailCellTitleArray = @[@"QuestionTitleCell",@"QuestionPersonCell"];
            }
        }
    }
    else if ([detailModel.orderStates intValue] == 2)
    {
        if (detailType == QuestionDetailTypeExpert)
        {
            [LBForProject currentProject].detailCellTitleArray = @[@"QuestionTitleCell",@"QuestionPersonCell",@"AnswerDetailView"];//@"QuestionPersonCell",
        }
        else
        {
            [LBForProject currentProject].detailCellTitleArray = @[@"QuestionTitleCell",@"QuestionPersonCell",@"AnswerDetailView",@"HomeQuestionCell"];//,@"HomeQuestionCell"
        }
    }
    else if ([detailModel.orderStates intValue] == 3)
    {
        if (detailType == QuestionDetailTypeExpert)
        {
            [LBForProject currentProject].detailCellTitleArray = @[@"QuestionTitleCell",@"QuestionPersonCell",@"AnswerDetailView"];//@"QuestionPersonCell",
        }
        else
        {
            [LBForProject currentProject].detailCellTitleArray = @[@"QuestionTitleCell",@"QuestionPersonCell",@"AnswerDetailView",@"HomeQuestionCell"];//,@"HomeQuestionCell"
        }
    }
    else if ([detailModel.orderStates intValue] == 4)
    {
        if (detailType == QuestionDetailTypeExpert)
        {
            [LBForProject currentProject].detailCellTitleArray = @[@"QuestionTitleCell",@"QuestionPersonCell",@"AnswerDetailView"];//,@"HomeQuestionCell"
        }
        else
        {
            [LBForProject currentProject].detailCellTitleArray = @[@"QuestionTitleCell",@"QuestionPersonCell",@"AnswerDetailView",@"HomeQuestionCell"];//,@"HomeQuestionCell"
        }
    }
    else if ([detailModel.orderStates intValue] == 5)
    {
        [LBForProject currentProject].detailCellTitleArray = @[@"QuestionTitleCell",@"QuestionPersonCell"];
    }
    else if ([detailModel.orderStates intValue] == 6)
    {
        [LBForProject currentProject].detailCellTitleArray = @[@"QuestionTitleCell",@"QuestionPersonCell"];
    }
    else if ([detailModel.orderStates intValue] == 7)
    {
        [LBForProject currentProject].detailCellTitleArray = @[@"QuestionTitleCell",@"QuestionPersonCell"];
    }
    else if ([detailModel.orderStates intValue] == 8)
    {
        [LBForProject currentProject].detailCellTitleArray = @[@"QuestionTitleCell",@"QuestionPersonCell"];
    }
    NSLog(@"detailCellTitleArray = %@",[LBForProject currentProject].detailCellTitleArray);
}

/**
 个人主页cell
 
 @param accountInfo model
 @param accountState 个人主页类型
 */
+ (NSArray *)decodeAccountCellTitle:(AccountInfo *)accountInfo detailType:(AccountState)accountState
{//
    if (accountState == AccountStateNormal)
    {
        [LBForProject currentProject].accountCellTitleArray = @[@"ThemeClassModel",@"AddThemeCell",@"AccountSelfCell",@"AccountJobCell",@"AccountSchoolCell",@"AccountCell",@"AccountCellClass",@"AccountVoteCell",@"AllCommentButtonCell",@"InterestFriendCell",@"AccountOtherCell"].mutableCopy;
        
        if (accountInfo.Topic.count == 0) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"ThemeClassModel"];
        }
        if (IsStrEmpty(accountInfo.userIntroduce) || IsNilOrNull(accountInfo.userIntroduce)) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AccountSelfCell"];
        }
        if (accountInfo.OccupationAuthentication.count == 0) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AccountJobCell"];
        }
        if (accountInfo.EducationAuthentication.count == 0) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AccountSchoolCell"];
        }
        if (accountInfo.UserClassify.count == 0) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AccountCellClass"];
        }
//        if (accountInfo.UserFriend.count == 0) {
//            [[LBForProject currentProject].accountCellTitleArray removeObject:@"InterestFriendCell"];
//        }
        if (accountInfo.Comment.count <= 3) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AllCommentButtonCell"];
        }
        if (accountInfo.Comment.count == 0) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AccountVoteCell"];
        }
        if ([accountInfo.isBasic intValue] == 0 || [accountInfo.isEducation intValue] == 0 || [accountInfo.isOccupation intValue] == 0) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AddThemeCell"];
        }
        if (IsStrEmpty(accountInfo.userBirth) && IsStrEmpty(accountInfo.userHometown)) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AccountCell"];
        }
    }
    else if (accountState == AccountStateEdit)
    {
        [LBForProject currentProject].accountCellTitleArray = @[@"ThemeClassModel",@"AddThemeCell",@"AccountSelfCell",@"AccountJobCell",@"AccountSchoolCell",@"AccountCell",@"AccountCellClass",@"AccountVoteCell",@"AllCommentButtonCell",@"InterestFriendCell",@"AccountOtherCell"].mutableCopy;
        if (accountInfo.Topic.count == 0) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"ThemeClassModel"];
        }
        if (accountInfo.Comment.count <= 3) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AllCommentButtonCell"];
        }
        if (accountInfo.Comment.count == 0) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AccountVoteCell"];
        }
        if ([accountInfo.isBasic intValue] == 0 || [accountInfo.isEducation intValue] == 0 || [accountInfo.isOccupation intValue] == 0) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AddThemeCell"];
        }
    }
    else if (accountState == AccountStateOther)
    {
        [LBForProject currentProject].accountCellTitleArray = @[@"ThemeClassModel",@"AccountSelfCell",@"AccountJobCell",@"AccountSchoolCell",@"AccountCell",@"AccountCellClass",@"CommentButtonCell",@"AccountVoteCell",@"AllCommentButtonCell",@"InterestFriendCell",@"AccountOtherCell"].mutableCopy;
        if (accountInfo.Topic.count == 0) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"ThemeClassModel"];
        }
        if (IsStrEmpty(accountInfo.userIntroduce) || IsNilOrNull(accountInfo.userIntroduce)) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AccountSelfCell"];
        }
        if (accountInfo.OccupationAuthentication.count == 0) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AccountJobCell"];
        }
        if (accountInfo.EducationAuthentication.count == 0) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AccountSchoolCell"];
        }
        if (accountInfo.UserClassify.count == 0) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AccountCellClass"];
        }
//        if (accountInfo.UserFriend.count == 0) {
//            [[LBForProject currentProject].accountCellTitleArray removeObject:@"InterestFriendCell"];
//        }
        if (accountInfo.Comment.count <= 3) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AllCommentButtonCell"];
        }
        if (accountInfo.Comment.count == 0) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AccountVoteCell"];
        }
        if (IsStrEmpty(accountInfo.userBirth) && IsStrEmpty(accountInfo.userHometown)) {
            [[LBForProject currentProject].accountCellTitleArray removeObject:@"AccountCell"];
        }
    }
    else if (accountState == AccountStateDisabled)
    {
        [[LBForProject currentProject].accountCellTitleArray removeAllObjects];
    }
    NSLog(@"accountCellTitleArray = %@",[LBForProject currentProject].accountCellTitleArray);
    return [LBForProject currentProject].accountCellTitleArray;
}

@end
