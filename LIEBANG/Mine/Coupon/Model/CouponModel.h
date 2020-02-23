//
//  CouponModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/30.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject

@property (nonatomic,strong)NSArray *data;

@end

@interface CouponListModel : NSObject

@property (nonatomic,strong)NSString *classify;//限制类目
@property (nonatomic,strong)NSString *classifyId;//限制类目id
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *offMoney;//减多少
@property (nonatomic,strong)NSString *couponType;//0 普通满减 1免单
@property (nonatomic,strong)NSString *status;//0：未使用 1：已使用 2已过期
@property (nonatomic,strong)NSString *receiveTime;//结束时间
@property (nonatomic,strong)NSString *beginTime;//开始时间
@property (nonatomic,strong)NSString *endTime;//结束时间
@property (nonatomic,strong)NSString *fullMoney;//满多少

@end
