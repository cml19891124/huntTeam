//
//  QuestionDetailModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/4.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionDetailModel : NSObject

@property (nonatomic,strong)NSString *answer;//是否失效
@property (nonatomic,strong)NSString *answerContent;
@property (nonatomic,strong)NSString *startLevel;
@property (nonatomic,strong)NSString *answerUid;
@property (nonatomic,strong)NSString *chargeState;//是否免费查看（0：免费查看，1：一元查看）
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *Endtime;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *isBuy;////是否购买（0：未购买，1：已购买）
@property (nonatomic,strong)NSString *isRecommend;
@property (nonatomic,strong)NSString *isSensitive;
@property (nonatomic,strong)NSString *quizcontent;
@property (nonatomic,strong)NSString *state;//0:未回答，1：已回答

@property (nonatomic,strong)NSString *orderId;//一元查看
@property (nonatomic,strong)NSString *orderStates;//3：已评价


@property (nonatomic,strong)NSString *helpNum;
@property (nonatomic,strong)NSString *isOccupation;
@property (nonatomic,strong)NSString *isOccupationOne;

@property (nonatomic,strong)NSString *isBasic;
@property (nonatomic,strong)NSString *isEducation;
@property (nonatomic,strong)NSString *starLevel;
@property (nonatomic,strong)NSString *company;

@property (nonatomic,strong)NSString *position;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *userHead;

@property (nonatomic,strong)NSString *viewNum;
@property (nonatomic,strong)NSArray *question;
@property (nonatomic,strong)NSArray *viewUser;
@end

/**
 相关问答
 */
@interface RecommendQuestionModel : NSObject

@property (nonatomic,strong)NSString *state;
@property (nonatomic,strong)NSString *quizcontent;
@property (nonatomic,strong)NSString *isSensitive;
@property (nonatomic,strong)NSString *isRecommend;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *answer;//是否失效
@property (nonatomic,strong)NSString *Endtime;

@property (nonatomic,strong)NSString *chargeState;
@property (nonatomic,strong)NSString *startLevel;
@property (nonatomic,strong)NSString *answerContent;


@property (nonatomic,strong)NSString *answerUserUid;
@property (nonatomic,strong)NSString *answerUserName;
@property (nonatomic,strong)NSString *answerUserPhone;
@property (nonatomic,strong)NSString *answerisOccupation;
@property (nonatomic,strong)NSString *answerid;

@property (nonatomic,strong)NSString *answerCompany;
@property (nonatomic,strong)NSString *answerHelpNum;
@property (nonatomic,strong)NSString *answerIsBasic;
@property (nonatomic,strong)NSString *answerIsEducation;
@property (nonatomic,strong)NSString *answerPosition;
@property (nonatomic,strong)NSString *answerUserHead;



@property (nonatomic,strong)NSString *questionUserUid;
@property (nonatomic,strong)NSString *questionUserName;
@property (nonatomic,strong)NSString *questionUserPhone;
@property (nonatomic,strong)NSString *questionid;
@property (nonatomic,strong)NSString *questionisOccupation;

@end
