//
//  QuestionModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/15.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

@property (nonatomic,strong)NSString *readStatus;//0:未读 1已读
@property (nonatomic,strong)NSString *orderUid;
@property (nonatomic,strong)NSString *orderStates;//0:已支付 1已作答 2已评价 3.已确认 5：已取消 6：已忽略 7：已失效 8：已退款
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *quizcontent;
@property (nonatomic,strong)NSString *startLevel;
@property (nonatomic,strong)NSString *endTime;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *starLevel;//星级
@property (nonatomic,strong)NSString *isOccupation;
@property (nonatomic,strong)NSString *isOccupationOne;

@property (nonatomic,strong)NSString *isEducation;
@property (nonatomic,strong)NSString *isBasic;
@property (nonatomic,strong)NSString *helpNum;

@property (nonatomic,strong)NSString *userHead;
@property (nonatomic,strong)NSString *remainingTime;

@property (nonatomic,strong)NSString *orderPrice;
@property (nonatomic,strong)NSString *payPrice;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic, copy) NSString *company;
@property (nonatomic,strong)NSString *position;

@property (nonatomic,strong)NSString *type;//查看资料权限

@end
