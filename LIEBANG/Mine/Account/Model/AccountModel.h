//
//  AccountModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/30.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject

@property (nonatomic,strong)NSString *createTime;//
@property (nonatomic,strong)NSString *userWorkAddress;//用户工作地区
@property (nonatomic,strong)NSString *registrationId;//极光推送设备id
@property (nonatomic,strong)NSString *userPassword;//用户登录密码
@property (nonatomic,strong)NSString *userIndustry;//用户行业
@property (nonatomic,strong)NSString *userCom;//用户公司
@property (nonatomic,strong)NSString *userEmail;//用户邮箱
@property (nonatomic,strong)NSString *id;//
//@property (nonatomic,strong)NSString *classify;//标签
@property (nonatomic,strong)NSString *userDetailAddress;//用户详细地址
@property (nonatomic,strong)NSString *effectSocre;//影响力分数
@property (nonatomic,strong)NSString *userLogo;//用户公司logo
@property (nonatomic,strong)NSString *isEducation;//教育经历认证（0 未认证 1已认证）
@property (nonatomic,strong)NSString *userCardId;//身份证号
@property (nonatomic,strong)NSString *userName;//用户姓名
@property (nonatomic,strong)NSString *userPhone;//用户手机号
@property (nonatomic,strong)NSString *userHead;//用户头像
@property (nonatomic,strong)NSString *isRecommend;//0 不推荐 1：推荐
@property (nonatomic,strong)NSString *status;//0审核中 1已通过 2失败 3未审核
@property (nonatomic,strong)NSString *userCardUrl;//用户身份证图片
@property (nonatomic,strong)NSString *userCardUrlmosaic;//用户身份证图片
@property (nonatomic,strong)NSString *helpNum;//帮助人数
@property (nonatomic,strong)NSString *phone;//显示的手机
@property (nonatomic,strong)NSString *isBasic;//基本信息认证（0：未认证 1：已认证）
@property (nonatomic,strong)NSString *isOccupation;//职业精力认证（0 未认证 1已认证）
@property (nonatomic,strong)NSString *weChatId;//
@property (nonatomic,strong)NSString *starLevel;//用户星级
@property (nonatomic,strong)NSString *likeNum;//喜欢人数
@property (nonatomic,strong)NSString *userBirth;//
@property (nonatomic,strong)NSString *userUid;//
@property (nonatomic,strong)NSString *userIntroduce;//自我介绍
@property (nonatomic,strong)NSString *userStatus;//0 正常 1停用
@property (nonatomic,strong)NSString *userHometown;//家乡
@property (nonatomic,strong)NSString *userPosition;//用户职位

@property (nonatomic,strong)NSString *mechanism;//机构信息认证（0：未认证 1：已认证）


@property (nonatomic,strong)NSString *userWechat;//微信号
@property (nonatomic,strong)NSString *userThirdId;//第三方授权账号id


@property (nonatomic,strong)NSArray *classify;

#pragma mark 自定义
@property (nonatomic,strong)NSString *userLabel;//用户职业标签
@property (nonatomic,strong)NSString *userLabelUid;//用户职业标签

@end

@interface OClassifyModel : NSObject

@property (nonatomic,strong)NSString *classify;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *type;

@end
