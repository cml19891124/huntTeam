//
//  SystemModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/10/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SystemModel : NSObject

@property (nonatomic,strong)NSString *orderType;//0问答  2话题
@property (nonatomic,strong)NSString *orderUid;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *pushType;//0订单  1认证   23机构认证审核成功  24机构认证审核失败  15, "基础认证审核通过   16, "基础认证审核失败"   17, "教育认证审核成功"   18, "教育认证审核失败"   19, "工作经历认证成功"   20, "工作经历认证失败"  25 .. 26优惠券
@property (nonatomic,strong)NSString *enterpriseId;
@end

NS_ASSUME_NONNULL_END
