//
//  AccountInfo.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/2.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkModel.h"
#import "EducationModel.h"
#import "InterestFriendModel.h"
#import "ThemeClassModel.h"

@interface AccountInfo : NSObject

@property (nonatomic,strong)NSArray *OccupationAuthentication;//工作经历列表
@property (nonatomic,strong)NSArray *UserFriend;//推荐用户列表
@property (nonatomic,strong)NSArray *Comment;//评论列表
@property (nonatomic,strong)NSArray *Topic;//话题列表
@property (nonatomic,strong)NSArray *EducationAuthentication;//教育经历列表
@property (nonatomic,strong)NSArray *UserClassify;//用户标签列表

@property (nonatomic,assign)BOOL isOpen;

@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *updateTime;

@property (nonatomic,strong)NSString *helpNum;
@property (nonatomic,strong)NSString *registrationId;
@property (nonatomic,strong)NSString *userPassword;

/**
 职位认证标识
 */
@property (nonatomic,strong)NSString *status;//0审核中 1已通过 2失败 3未审核

@property (nonatomic,strong)NSString *isBasic;//0审核中 1已通过 2失败 3未审核
@property (nonatomic,strong)NSString *isFriend;
@property (nonatomic,strong)NSString *isComment;
@property (nonatomic,strong)NSString *isLike;
@property (nonatomic,strong)NSString *isOccupation;
@property (nonatomic, copy) NSString *isOccupationOne;
@property (nonatomic,strong)NSString *starLevel;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *effectScore;
@property (nonatomic,strong)NSString *likeNum;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *isEducation;
@property (nonatomic,strong)NSString *userStatus;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *userPhone;
@property (nonatomic,strong)NSString *isRecommend;
@property (nonatomic,strong)NSString *userIntroduce;
@property (nonatomic,strong)NSString *mechanism;
@property (nonatomic,strong)NSString *position;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *phonePrivacy;
@property (nonatomic,strong)NSString *company;
@property (nonatomic,strong)NSString *comLogo;
@property (nonatomic,strong)NSString *userHometown;
@property (nonatomic,strong)NSString *userBirth;
@property (nonatomic,strong)NSString *userHead;
@property (nonatomic,strong)NSString *userEmail;
@property (nonatomic,strong)NSString *userDetailAddress;
@property (nonatomic,strong)NSString *userWorkAddress;
@property (nonatomic,strong)NSString *userIndustry;

/**
 跳转认证界面的字段 不是0 你都进认证的可编辑页面
 */
@property (nonatomic, copy) NSString *userBasic;
@end

@interface Comment : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *num;//点赞数量
@property (nonatomic,strong)NSString *userIndustry;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *comment;//评论内容
@property (nonatomic,strong)NSString *userHead;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *position;
@property (nonatomic,strong)NSString *company;
@property (nonatomic,strong)NSString *isBasic;
@property (nonatomic,strong)NSString *isOccupation;
@property (nonatomic,strong)NSString *commentIsRecord;

@end

//@interface Topic : NSObject
//
//@property (nonatomic,strong)NSString *id;
//@property (nonatomic,strong)NSString *createTime;
//@property (nonatomic,strong)NSString *helpNum;//帮助人数
//@property (nonatomic,strong)NSString *serviceTime;//服务时间
//@property (nonatomic,strong)NSString *userUid;
//@property (nonatomic,strong)NSString *Remarks;//其他信息
//@property (nonatomic,strong)NSString *topicPrice;//话题价格
//@property (nonatomic,strong)NSString *serviceType;//0:线下约见 1：全国通话
//@property (nonatomic,strong)NSString *serviceIn;//服务介绍
//@property (nonatomic,strong)NSString *topicName;//话题名称
//
//@end

@interface UserClassify : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *classify;//标签
@property (nonatomic,strong)NSString *acceptNum;//点赞数量
@property (nonatomic,strong)NSString *userHead;//用户头像
@property (nonatomic,strong)NSString *classifyIsRecord;

@end
