//
//  HomeModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/30.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject

@property (nonatomic,strong)NSMutableArray *appClassify;
@property (nonatomic,strong)NSArray *topicBanner;
@property (nonatomic,strong)NSArray *indexBanner;
@property (nonatomic,strong)NSArray *question;
@property (nonatomic,strong)NSArray *topic;
@property (nonatomic,strong)NSMutableArray *enterprise;

@end

//分类对象
@interface AppClassify : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *icon;
@property (nonatomic,strong)NSString *classify;
@property (nonatomic,strong)NSString *pushcategory;
@property (nonatomic,strong)NSString *pid;
@property (nonatomic,strong)NSString *type;

@end

//推荐话题轮播图
@interface TopicBanner : NSObject

@property (nonatomic,strong)NSString *id;//
@property (nonatomic,strong)NSString *content;//
@property (nonatomic,strong)NSString *createTime;//创建时间
@property (nonatomic,strong)NSString *title;//
@property (nonatomic,strong)NSString *bannerUrl;//banner链接
@property (nonatomic,strong)NSString *updateTime;//更新时间
@property (nonatomic,strong)NSString *bannerType;//banner类型
@property (nonatomic,strong)NSString *turnUrl;//跳转链接
@property (nonatomic,strong)NSString *turnType;//跳转类型 0--链接  1--用户主页
@property (nonatomic,strong)NSString *userUid;

@end

//顶部首页轮播图
@interface IndexBanner : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *createTime;//创建时间
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *bannerUrl;//banner链接
@property (nonatomic,strong)NSString *bannerType;//banner类型
@property (nonatomic,strong)NSString *turnType;//跳转类型 0--链接  1--用户主页
@property (nonatomic,strong)NSString *turnUrl;//跳转链接
@property (nonatomic,strong)NSString *updateTime;//更新时间

@end

@interface Enterprise : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *companyLogo;
@property (nonatomic,strong)NSString *isSelf;
@property (nonatomic,strong)NSString *userUid;

@end
