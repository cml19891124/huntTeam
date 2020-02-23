//
//  EducationModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/30.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkModel.h"

@interface EducationModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *schoolName;//学习名称
@property (nonatomic,strong)NSString *subjectName;//专业名称
@property (nonatomic,strong)NSString *status;//0审核中 1已通过 2失败 3未审核
@property (nonatomic,strong)NSString *updateTime;//更新时间
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *beginTime;//开始时间
@property (nonatomic,strong)NSString *endTime;//结束时间
@property (nonatomic,strong)NSString *eduDescribe;//教育经历描述
@property (nonatomic,strong)NSString *diploma;//学历
@property (nonatomic,strong)NSString *eduLogo;//logo
@property (nonatomic,strong)NSString *type;//



@property (nonatomic,strong)NSString *image;//证明图片

@property (nonatomic,strong)NSString *degreeImage;//证明图片
@property (nonatomic,strong)NSString *diplomaImagemosaic;//证明图片
@property (nonatomic,strong)NSString *degreeImagemosaic;//证明图片
@property (nonatomic,strong)NSString *DiplomaImage;//证明图片

@end
