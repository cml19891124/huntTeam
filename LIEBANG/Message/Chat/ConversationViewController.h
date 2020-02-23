//
//  ConversationViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "WMCompanyMessage.h"

@interface ConversationViewController : RCConversationViewController

@property (nonatomic,strong)NSString *message;

@property (nonatomic,strong)WMCardMessage *cardMessage;

@property (nonatomic,strong)WMContent *shareMessage;

@property (nonatomic,strong)WMCompanyMessage *companyMessage;

@end
