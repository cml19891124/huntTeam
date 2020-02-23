//
//  QuestionOrderDetailModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionOrderDetailModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *readStatus;
@property (nonatomic,strong)NSString *orderStates;//0:未支付 1:已支付 2已作答 3已评价 4.已确认 5：已取消 6：已忽略 7：已失效 8：已退款
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *payPrice;
@property (nonatomic,strong)NSString *orderUid;//订单id
@property (nonatomic,strong)NSString *orderType;//0 问答 1问答围观 2话题 3一元查看
@property (nonatomic,strong)NSString *ly_table;
@property (nonatomic,strong)NSString *payType;
@property (nonatomic,strong)NSString *orderPrice;
@property (nonatomic,strong)NSString *QuestionFormMapUid;
@property (nonatomic,strong)NSString *quizcontent;
@property (nonatomic,strong)NSString *startLevel;
@property (nonatomic,strong)NSString *answerUid;
@property (nonatomic,strong)NSString *starLevel;//用户评分
@property (nonatomic,strong)NSString *helpNum;
@property (nonatomic,strong)NSString *isEducation;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *isBasic;
@property (nonatomic,strong)NSString *isOccupation;
@property (nonatomic,strong)NSString *isOccupationOne;

@property (nonatomic,strong)NSString *userHead;
@property (nonatomic, copy) NSString *company;
@property (nonatomic,strong)NSString *position;

@property (nonatomic,strong)NSString *endTime;

@property (nonatomic,strong)NSString *answerContent;

@property (nonatomic,strong)NSString *score;//问答评分

@property (nonatomic,strong)NSArray *recommendedQuestion;
@property (nonatomic,strong)NSArray *viewUser;
@property (nonatomic,strong)NSString *viewNum;

@property (assign, nonatomic) BOOL isOpen;

@end
