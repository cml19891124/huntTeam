//
//  WorkModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/30.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *position;//职位
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *status;//0审核中 1已通过 2失败 3未审核
@property (nonatomic,strong)NSString *updateTime;//更新时间
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *company;//公司名称
@property (nonatomic,strong)NSString *beginTime;//开始时间
@property (nonatomic,strong)NSString *endTime;//结束时间
@property (nonatomic,strong)NSString *describeInfo;//经历描述
@property (nonatomic,strong)NSString *comLogo;//logo
@property (nonatomic,strong)NSString *type;//



@property (nonatomic,strong)NSString *image;//认证的图片材料


@property (nonatomic,strong)NSString *certificateImagemosaic;//认证的图片材料
@property (nonatomic,strong)NSString *workCardImagemosaic;//认证的图片材料
@property (nonatomic,strong)NSString *workCardImage;//认证的图片材料
@property (nonatomic,strong)NSString *visitingImage;//认证的图片材料
@property (nonatomic,strong)NSString *visitingImagemosaic;//认证的图片材料
@property (nonatomic,strong)NSString *licenseImagemosaic;//认证的图片材料
@property (nonatomic,strong)NSString *certificateImage;//认证的图片材料
@property (nonatomic,strong)NSString *licenseImage;//认证的图片材料
@end

@interface WorkImgModel : NSObject

@property (nonatomic,strong)NSString *createTime;//
@property (nonatomic,strong)NSString *type;//
@property (nonatomic,strong)NSString *wuma;//
@property (nonatomic,strong)NSString *youma;//

@end
