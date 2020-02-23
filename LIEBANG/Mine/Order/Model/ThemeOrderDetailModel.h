//
//  ThemeOrderDetailModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeOrderDetailModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *readStatus;
@property (nonatomic,strong)NSString *orderStates;//0:未支付 1:已支付 2已作答 3已评价  5：已取消 6：已忽略 7：已失效 8：已退款 9:行家已确定预约，待用户确定   10：用户与行家都已确认预约 4.已确认完成(用户最后确定，订单完成) 11.行家确认完成(用户未确认完成，若用户确认完成，此步骤可跳过)
@property (nonatomic,strong)NSString *createTime;//下单时间
@property (nonatomic,strong)NSString *payPrice;//支付价格
@property (nonatomic,strong)NSString *orderUid;//订单编号
@property (nonatomic,strong)NSString *orderType;//0 问答 1问答围观 2话题 3一元查看
@property (nonatomic,strong)NSString *ly_table;
@property (nonatomic,strong)NSString *endTime;
@property (nonatomic,strong)NSString *payType;//0 支付宝 1：微信
@property (nonatomic,strong)NSString *orderPrice;//订单价格
@property (nonatomic,strong)NSString *askIntroduction;//请教的自我介绍
@property (nonatomic,strong)NSString *topicAskQuestion;//请教的话题

@property (nonatomic,strong)NSString *originalPrice;
@property (nonatomic,strong)NSString *serviceTime;//服务时间
@property (nonatomic,strong)NSString *topicPrice;//话题价格
@property (nonatomic,strong)NSString *serviceType;//0:线下约见 1：全国通话
@property (nonatomic,strong)NSString *topicName;//话题名称
@property (nonatomic,strong)NSString *startLevel;//话题评分
//@property (nonatomic,strong)NSString *serviceIn;//服务介绍
//@property (nonatomic,strong)NSString *Remarks;//其他信息

@property (nonatomic,strong)NSString *company;
@property (nonatomic,strong)NSString *position;
@property (nonatomic,strong)NSString *starLevel;
@property (nonatomic,strong)NSString *helpNum;
@property (nonatomic,strong)NSString *isEducation;
@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *isBasic;
@property (nonatomic,strong)NSString *isOccupation;
@property (nonatomic,strong)NSString *isOccupationOne;

@property (nonatomic,strong)NSString *userHead;
@property (nonatomic,strong)NSString *userPhone;

#pragma mark ----
@property (nonatomic,strong)NSString *detailedAddress;//详细地址
@property (nonatomic,strong)NSString *mettingAddress;//见面地点
@property (nonatomic,strong)NSString *mettingEdnTime;//结束时间
@property (nonatomic,strong)NSString *mettingBeginTime;//开始时间


@property (nonatomic,strong)NSString *StudenthelpNum;
@property (nonatomic,strong)NSString *StudentisBasic;
@property (nonatomic,strong)NSString *StudentisEducation;
@property (nonatomic,strong)NSString *StudentisOccupation;
@property (nonatomic,strong)NSString *StudentisOccupationOne;

@property (nonatomic,strong)NSString *StudentregistrationId;
@property (nonatomic,strong)NSString *StudentuserName;
@property (nonatomic,strong)NSString *StudentuserPhone;
@property (nonatomic,strong)NSString *StudentuserUid;
@property (nonatomic,strong)NSString *StudentuserHead;
@property (nonatomic,strong)NSString *Studentcompany;
@property (nonatomic,strong)NSString *Studentposition;

@end

@interface StudentUser : NSObject



@end
