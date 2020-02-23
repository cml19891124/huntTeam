//
//  ThemeClassModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/21.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeClassModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *serviceTime;
@property (nonatomic,strong)NSString *remarks;
@property (nonatomic,strong)NSString *topicPrice;
@property (nonatomic,strong)NSString *serviceType;
@property (nonatomic,strong)NSString *serviceIn;
@property (nonatomic,strong)NSString *topicName;

@property (nonatomic,strong)NSString *starLevel;
@property (nonatomic,strong)NSString *map_helpNum;//用户帮助数量
@property (nonatomic,strong)NSString *isEducation;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *isBasic;
@property (nonatomic,strong)NSString *isOccupation;
@property (nonatomic,strong)NSString *isOccupationOne;

@property (nonatomic, copy) NSString *company;
@property (nonatomic,strong)NSString *position;

@property (nonatomic,strong)NSString *startLevel;
@property (nonatomic,strong)NSString *deletedState;
@property (nonatomic,strong)NSString *isRecommend;
@property (nonatomic,strong)NSString *helpNum;//话题帮助数量
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *userHead;
@property (nonatomic,strong)NSString *isSensitiveword;
@property (nonatomic,strong)NSString *originalPrice;


#pragma mark --
@property (nonatomic,strong)NSString *userPhone;


@property (nonatomic,strong)NSString *createTime;

@property (nonatomic,strong)NSString *dataPrivacyType;
@end
