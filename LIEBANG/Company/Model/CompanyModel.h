//
//  CompanyModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyModel : NSObject

@property (nonatomic,strong)NSArray *staff;

@property (nonatomic,strong)NSString *companyPelephone;//公司电话

@property (nonatomic,strong)NSString *businessLicense;//营业执照
@property (nonatomic,strong)NSString *city;//所在城市
@property (nonatomic,strong)NSString *friendNum;//有几个好友在此公司
@property (nonatomic,strong)NSString *industry;//所处行业
@property (nonatomic,strong)NSString *contactsName;//联系人姓名
@property (nonatomic,strong)NSString *productService;//产品服务
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *beginTime;//开始时间
@property (nonatomic,strong)NSString *email;//邮箱
@property (nonatomic,strong)NSString *validityDay;//有效期
@property (nonatomic,strong)NSString *companyInfo;//公司信息
@property (nonatomic,strong)NSString *fullName;//公司全称
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *businessLicensemosaic;//营业执照马赛克
@property (nonatomic,strong)NSString *officialWebsite;//官网
@property (nonatomic,strong)NSString *contactsPhone;//联系人手机
@property (nonatomic,strong)NSString *createTime;//开始时间
@property (nonatomic,strong)NSString *contactsPosition;//联系人职位
@property (nonatomic,strong)NSString *recruit;//招聘
@property (nonatomic,strong)NSString *background;//背景图
@property (nonatomic,strong)NSString *financingStatus;//融资状态
@property (nonatomic,strong)NSString *endTime;//‘到期时间
@property (nonatomic,strong)NSString *region;//所在地区
@property (nonatomic,strong)NSString *companyAbbreviation;//公司名称
@property (nonatomic,strong)NSString *status;//0 认证中 1已认证 2认证失败 3.未审核
@property (nonatomic,strong)NSString *userUid;

@property (nonatomic,strong)NSString *isSelf;//true 是自己企业 false不是

#pragma mark 公司名片详情
@property (nonatomic,strong)NSArray *companyInfoImages;//企业信息图
@property (nonatomic,strong)NSArray *productServiceImages;//产品介绍组图
@property (nonatomic,strong)NSArray *recruitImages;//招聘组图
@property (nonatomic,strong)NSString *companyLogo;//公司LOGO

@property (nonatomic,strong)NSString *updateTime;//更新时间
@property (nonatomic,strong)NSString *level;//企业名片付费等级
//@property (nonatomic,strong)NSString *commentUserHead;
//@property (nonatomic,strong)NSString *commentUserUid;
//@property (nonatomic,strong)NSString *commentUserName;
@property (nonatomic,strong)NSString *personnelScale;//人员规模

@property (nonatomic,strong)NSString *collectionId;//收藏ID
@property (nonatomic,strong)NSString *collectionStates;//是否收藏  0:未收藏 1:已收藏
@property (nonatomic,strong)NSString *commentJurisdiction;//评论权限(包含认领)  0:无 1:可以
#pragma mark 评论
@property (nonatomic,strong)NSString *comLogo;
@property (nonatomic,strong)NSString *comment;
@property (nonatomic,strong)NSString *commentUserHead;
@property (nonatomic,strong)NSString *commentUserName;
@property (nonatomic,strong)NSString *company;
@property (nonatomic,strong)NSString *isOccupation;
@property (nonatomic,strong)NSString *isBasic;
@property (nonatomic,strong)NSString *position;
@property (nonatomic,strong)NSString *commentUserUid;

#pragma mark 扩展 ---------------
@property (nonatomic,assign)BOOL isDelete;

@end

@interface StaffModel : NSObject

@property (nonatomic,strong)NSString *userHead;
@property (nonatomic,strong)NSString *isFriend;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *isBasic;
@property (nonatomic,strong)NSString *comLogo;
@property (nonatomic,strong)NSString *company;
@property (nonatomic,strong)NSString *isOccupation;
@property (nonatomic,strong)NSString *position;
@property (nonatomic,strong)NSString *userName;

@end

NS_ASSUME_NONNULL_END
