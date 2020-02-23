//
//  LBForProject.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeOrderDetailModel.h"
#import "QuestionOrderDetailModel.h"
#import "AccountInfo.h"

@interface LBForProject : NSObject

+ (LBForProject *)currentProject;

/**
 个人中心cell title
 */
@property (nonatomic,strong)NSArray *mineCellTitleArray;

/**
 个人中心cell image
 */
@property (nonatomic,strong)NSArray *mineCellImageArray;

/**
 人脉cell title
 */
@property (nonatomic,strong)NSArray *friendCellTitleArray;

/**
 人脉cell image
 */
@property (nonatomic,strong)NSArray *friendCellImageArray;

/**
 设置cell title
 */
@property (nonatomic,strong)NSArray *setCellTitleArray;

/**
 关于猎帮cell title
 */
@property (nonatomic,strong)NSArray *aboutCellTitleArray;


/**
 隐私政策cell title
 */
@property (nonatomic,strong)NSArray *privacyCellTitleArray;

/**
 账号安全cell title
 */
@property (nonatomic,strong)NSArray *safeCellTitleArray;

/**
 编辑名片cell title
 */
@property (nonatomic,strong)NSArray *editCellTitleArray;

/**
 机构审核cell title
 */
@property (nonatomic,strong)NSArray *ORCertiCellTitleArray;

/**
 公司认证cell title
 */
@property (nonatomic,strong)NSArray *comCertiCellTitleArray;

/**
 话题订单详情cell title
 */
@property (nonatomic,strong)NSArray *detailCellTitleArray;

/**
 个人主页cell title
 */
@property (nonatomic,strong)NSMutableArray *accountCellTitleArray;

/**
 公司主页cell title
 */
@property (nonatomic,strong)NSArray *companyCellTitleArray;

/**
 公司主页cell image
 */
@property (nonatomic,strong)NSArray *companyCellImageArray;


/**
 企业认证待上传的图片
 */
@property (nonatomic,strong)NSMutableArray *companyInfoArray;//公司信息组图
@property (nonatomic,strong)NSMutableArray *productServiceArray;//产品服务组图
@property (nonatomic,strong)NSMutableArray *recruitArray;//招聘组图

@property (nonatomic, copy) NSString *companyInfo;
@property (nonatomic, copy) NSString *productInfo;
@property (nonatomic, copy) NSString *employeeInfo;

@property (nonatomic, copy) NSString *companyUid;
/**
 
 */
@property (nonatomic,assign)BOOL isChat;

/**
 是否登录
 */
+ (BOOL)isLogin:(UIViewController *)viewController;

/**
 手机号码验证

 @return bool
 */
+ (NSString *)isCheckPhone:(NSString *)phone;

/**
 XXXX年XX月XX日 转 XXXX-XX-XX
 
 @return XXXX-XX-XX
 */
+ (NSString *)transformDate:(NSString *)date;

/**
 XXXX-XX-XX 转 XXXX年XX月XX日
 
 @return XXXX-XX-XX
 */
+ (NSString *)conversionDate:(NSString *)date;

/**
 XXXX-XX-XX 转 XXXX.XX.XX
 
 @return XXXX-XX-XX
 */
+ (NSString *)conversionDate2:(NSString *)date;

/**
 话题订单详情cell

 @param detailModel ThemeOrderDetailModel
 */
+ (void)decodeThemeDetailCellTitle:(ThemeOrderDetailModel *)detailModel detailType:(QuestionDetailType)detailType;

/**
 问答订单详情cell
 
 @param detailModel ThemeOrderDetailModel
 */
+ (void)decodeQuestionDetailCellTitle:(QuestionOrderDetailModel *)detailModel detailType:(QuestionDetailType)detailType;

/**
 个人主页cell

 @param accountInfo model
 @param accountState 个人主页类型
 */
+ (NSArray *)decodeAccountCellTitle:(AccountInfo *)accountInfo detailType:(AccountState)accountState;

@end
