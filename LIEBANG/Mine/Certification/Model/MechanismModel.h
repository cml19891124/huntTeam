//
//  MechanismModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MechanismModel : NSObject

@property (nonatomic,strong)NSString *mechanismName;
@property (nonatomic,strong)NSString *fullName;
@property (nonatomic,strong)NSString *contactsName;
@property (nonatomic,strong)NSString *contactsPosition;
@property (nonatomic,strong)NSString *contactsPhone;
@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *region;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *businessLicense;

@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *id;
@end
