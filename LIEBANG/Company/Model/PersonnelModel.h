//
//  PersonnelModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonnelModel : NSObject

@property (nonatomic,strong)NSString *userHead;
@property (nonatomic,strong)NSString *isOccupation;
@property (nonatomic,strong)NSString *isBasic;
@property (nonatomic,strong)NSString *company;
@property (nonatomic,strong)NSString *position;
@property (nonatomic,strong)NSString *comLogo;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *isApplyStatus;//（0:未通过  1：已同意  2：拒绝  3:未添加）

@end

NS_ASSUME_NONNULL_END
