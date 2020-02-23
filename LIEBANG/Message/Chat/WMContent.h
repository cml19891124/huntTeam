//
//  WMContent.h
//  LIEBANG
//
//  Created by  YIQI on 2018/11/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
//#import <RongIMLib/RCMessageContentView.h>

NS_ASSUME_NONNULL_BEGIN

#define RCLocalDetailMessageTypeIdentifier @"APP:SimpleMsg"
@interface WMContent : RCMessageContent<NSCoding,RCMessageContentView>

@property(nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *detailUid;
@property (nonatomic,strong)NSString *detailType;
@property (nonatomic,strong)NSString *shareUid;


@property(nonatomic, strong) NSString* extra;
+(instancetype)messageWithContent:(NSString *)content detailUid:(NSString *)detailUid detailType:(NSString *)detailType shareUid:(NSString *)shareUid;

@end

NS_ASSUME_NONNULL_END
