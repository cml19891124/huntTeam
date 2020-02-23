//
//  PayModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/8.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayModel : NSObject

@property (nonatomic,strong)NSString *alipay_url;

@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)NSString *appid;
@property (nonatomic,strong)NSString *info;
@property (nonatomic,strong)NSString *msg;
@property (nonatomic,strong)NSString *noncestr;
@property (nonatomic,strong)NSString *package;
@property (nonatomic,strong)NSString *partnerid;
@property (nonatomic,strong)NSString *prepayid;
@property (nonatomic,strong)NSString *sign;
@property (nonatomic,strong)NSString *timestamp;

@property (nonatomic,strong)NSString *id;

@end
