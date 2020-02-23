//
//  WMContent.m
//  LIEBANG
//
//  Created by  YIQI on 2018/11/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "WMContent.h"

@implementation WMContent

+(instancetype)messageWithContent:(NSString *)content detailUid:(NSString *)detailUid detailType:(NSString *)detailType shareUid:(NSString *)shareUid {
    WMContent *msg = [[WMContent alloc] init];
    if (msg) {
        msg.content = content;
        msg.detailUid = detailUid;
        msg.detailType = detailType;
        msg.shareUid = shareUid;
    }
    
    return msg;
}

+(RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

#pragma mark – NSCoding protocol methods
#define KEY_TXTMSG_CONTENT @"content"
#define KEY_TXTMSG_USERWORKADDRESS @"detailUid"
#define KEY_TXTMSG_EFFECTSOCRE @"detailType"
#define KEY_TXTMSG_SHAREUID @"shareUid"
#define KEY_TXTMSG_EFFEXTRA @"extra"

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:KEY_TXTMSG_CONTENT];
        self.detailUid = [aDecoder decodeObjectForKey:KEY_TXTMSG_USERWORKADDRESS];
        self.detailType = [aDecoder decodeObjectForKey:KEY_TXTMSG_EFFECTSOCRE];
        self.shareUid = [aDecoder decodeObjectForKey:KEY_TXTMSG_SHAREUID];
        self.extra = [aDecoder decodeObjectForKey:KEY_TXTMSG_EFFEXTRA];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.content forKey:KEY_TXTMSG_CONTENT];
    [aCoder encodeObject:self.detailUid forKey:KEY_TXTMSG_USERWORKADDRESS];
    [aCoder encodeObject:self.detailType forKey:KEY_TXTMSG_EFFECTSOCRE];
    [aCoder encodeObject:self.shareUid forKey:KEY_TXTMSG_SHAREUID];
    [aCoder encodeObject:self.extra forKey:KEY_TXTMSG_EFFEXTRA];
}

#pragma mark – RCMessageCoding delegate methods

-(NSData *)encode {
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.content) {
        [dataDict setObject:self.content forKey:@"content"];
    }
    if (self.detailUid) {
        [dataDict setObject:self.detailUid forKey:@"detailUid"];
    }
    if (self.detailType) {
        [dataDict setObject:self.detailType forKey:@"detailType"];
    }
    if (self.shareUid) {
        [dataDict setObject:self.shareUid forKey:@"shareUid"];
    }
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *__dic=[[NSMutableDictionary alloc]init];
        if (self.senderUserInfo.name) {
            [__dic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [__dic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [__dic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:__dic forKey:@"detail"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

-(void)decodeWithData:(NSData *)data {
    __autoreleasing NSError* __error = nil;
    if (!data) {
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&__error];
    
    if (json) {
        self.content = json[@"content"];
        self.detailUid = json[@"detailUid"];
        self.detailType = json[@"detailType"];
        self.shareUid = json[@"shareUid"];
        self.extra = json[@"extra"];
        
        NSDictionary *userinfoDic = json[@"detail"];
        [self decodeUserInfo:userinfoDic];
    }
}

- (NSString *)conversationDigest
{
    return self.detailType;
}
+(NSString *)getObjectName {
    return RCLocalDetailMessageTypeIdentifier;
}
#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [super dealloc];
}
#endif//__has_feature(objc_arc)

@end
