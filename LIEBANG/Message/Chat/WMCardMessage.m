//
//  WMCardMessage.m
//  RCIM
//
//  Created by 郑文明 on 16/4/20.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import "WMCardMessage.h"
#import "AccountInfo.h"

@implementation WMCardMessage

+(instancetype)messageWithContent:(FriendModel *)content {
    WMCardMessage *msg = [[WMCardMessage alloc] init];
    if (msg) {
        msg.content = content.userName;
        msg.isEducation = content.isEducation;
        msg.userUid = content.userUid;
        msg.userName = content.userName;
        msg.isBasic = content.isBasic;
        msg.isOccupation = content.isOccupation;
        msg.userHead = content.userHead;
        msg.position = content.position;
        msg.comLogo = content.comLogo;
        msg.company = content.company;
        msg.userClassify = content.userClassify;
        msg.userEmail = content.userEmail;
        msg.userWorkAddress = content.userWorkAddress;
        msg.effectSocre = content.effectSocre;
        msg.phonePrivacy = content.phonePrivacy;
        msg.userPhone = content.phone;
    }
    
    return msg;
}

+(instancetype)messageWithAccContent:(AccountInfo *)content {
    WMCardMessage *msg = [[WMCardMessage alloc] init];
    if (msg) {
        msg.content = content.userName;
        msg.isEducation = content.isEducation;
        msg.userUid = content.userUid;
        msg.userName = content.userName;
        msg.isBasic = content.isBasic;
        msg.isOccupation = content.isOccupation;
        msg.userHead = content.userHead;
        msg.position = content.position;
        msg.comLogo = content.comLogo;
        msg.company = content.position;
        
        NSMutableArray *titleArray = [NSMutableArray array];
        for (UserClassify *model in content.UserClassify) {
            [titleArray addObject:model.classify];
        }
        
        msg.userClassify = [titleArray componentsJoinedByString:@","];
        msg.userEmail = content.userEmail;
        msg.userWorkAddress = content.userWorkAddress;
        msg.effectSocre = content.effectScore;
        msg.phonePrivacy = content.phonePrivacy;
        msg.userPhone = content.phone;
    }
    
    return msg;
}

+(RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

#pragma mark – NSCoding protocol methods
#define KEY_TXTMSG_CONTENT @"content"
#define KEY_TXTMSG_POSITION @"position"
#define KEY_TXTMSG_USERHEAD @"userHead"
#define KEY_TXTMSG_ISEDUCATION @"isEducation"
#define KEY_TXTMSG_ISBASIC @"isBasic"
#define KEY_TXTMSG_ISOCCUPATION @"isOccupation"
#define KEY_TXTMSG_USERUID @"userUid"
#define KEY_TXTMSG_USERNAME @"userName"
#define KEY_TXTMSG_EXTRA @"extra"

#define KEY_TXTMSG_COMLOGO @"comLogo"
#define KEY_TXTMSG_COMPANY @"company"
#define KEY_TXTMSG_USERCLASSIFY @"userClassify"
#define KEY_TXTMSG_USEREMAIL @"userEmail"
#define KEY_TXTMSG_USERWORKADDRESS @"userWorkAddress"
#define KEY_TXTMSG_EFFECTSOCRE @"effectSocre"
#define KEY_TXTMSG_PHONEPRIVACY @"phonePrivacy"
#define KEY_TXTMSG_USERPHONE @"userPhone"

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:KEY_TXTMSG_CONTENT];
        self.position = [aDecoder decodeObjectForKey:KEY_TXTMSG_POSITION];
        self.userHead = [aDecoder decodeObjectForKey:KEY_TXTMSG_USERHEAD];
        self.isEducation = [aDecoder decodeObjectForKey:KEY_TXTMSG_ISEDUCATION];
        self.isBasic = [aDecoder decodeObjectForKey:KEY_TXTMSG_ISBASIC];
        self.isOccupation = [aDecoder decodeObjectForKey:KEY_TXTMSG_ISOCCUPATION];
        self.userUid = [aDecoder decodeObjectForKey:KEY_TXTMSG_USERUID];
        self.userName = [aDecoder decodeObjectForKey:KEY_TXTMSG_USERNAME];
        self.extra = [aDecoder decodeObjectForKey:KEY_TXTMSG_EXTRA];
        
        self.comLogo = [aDecoder decodeObjectForKey:KEY_TXTMSG_COMLOGO];
        self.company = [aDecoder decodeObjectForKey:KEY_TXTMSG_COMPANY];
        self.userClassify = [aDecoder decodeObjectForKey:KEY_TXTMSG_USERCLASSIFY];
        self.userEmail = [aDecoder decodeObjectForKey:KEY_TXTMSG_USEREMAIL];
        self.userWorkAddress = [aDecoder decodeObjectForKey:KEY_TXTMSG_USERWORKADDRESS];
        self.effectSocre = [aDecoder decodeObjectForKey:KEY_TXTMSG_EFFECTSOCRE];
        self.phonePrivacy = [aDecoder decodeObjectForKey:KEY_TXTMSG_PHONEPRIVACY];
        self.userPhone = [aDecoder decodeObjectForKey:KEY_TXTMSG_USERPHONE];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.content forKey:KEY_TXTMSG_CONTENT];
    [aCoder encodeObject:self.position forKey:KEY_TXTMSG_POSITION];
    [aCoder encodeObject:self.userHead forKey:KEY_TXTMSG_USERHEAD];
    [aCoder encodeObject:self.isEducation forKey:KEY_TXTMSG_ISEDUCATION];
    [aCoder encodeObject:self.isBasic forKey:KEY_TXTMSG_ISBASIC];
    [aCoder encodeObject:self.isOccupation forKey:KEY_TXTMSG_ISOCCUPATION];
    [aCoder encodeObject:self.userUid forKey:KEY_TXTMSG_USERUID];
    [aCoder encodeObject:self.userName forKey:KEY_TXTMSG_USERNAME];
    [aCoder encodeObject:self.extra forKey:KEY_TXTMSG_EXTRA];
    
    [aCoder encodeObject:self.comLogo forKey:KEY_TXTMSG_COMLOGO];
    [aCoder encodeObject:self.company forKey:KEY_TXTMSG_COMPANY];
    [aCoder encodeObject:self.userClassify forKey:KEY_TXTMSG_USERCLASSIFY];
    [aCoder encodeObject:self.userEmail forKey:KEY_TXTMSG_USEREMAIL];
    [aCoder encodeObject:self.userWorkAddress forKey:KEY_TXTMSG_USERWORKADDRESS];
    [aCoder encodeObject:self.effectSocre forKey:KEY_TXTMSG_EFFECTSOCRE];
    [aCoder encodeObject:self.phonePrivacy forKey:KEY_TXTMSG_PHONEPRIVACY];
    [aCoder encodeObject:self.userPhone forKey:KEY_TXTMSG_USERPHONE];
}

#pragma mark – RCMessageCoding delegate methods

-(NSData *)encode {
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.content) {
        [dataDict setObject:self.content forKey:@"content"];
    }
    if (self.position) {
        [dataDict setObject:self.position forKey:@"position"];
    }
    if (self.isEducation) {
        [dataDict setObject:self.isEducation forKey:@"isEducation"];
    }
    if (self.isBasic) {
        [dataDict setObject:self.isBasic forKey:@"isBasic"];
    }
    if (self.isOccupation) {
        [dataDict setObject:self.isOccupation forKey:@"isOccupation"];
    }
    if (self.userUid) {
        [dataDict setObject:self.userUid forKey:@"userUid"];
    }
    if (self.userName) {
        [dataDict setObject:self.userName forKey:@"userName"];
    }
    if (self.userHead) {
        [dataDict setObject:self.userHead forKey:@"userHead"];
    }
    if (self.comLogo) {
        [dataDict setObject:self.comLogo forKey:@"comLogo"];
    }
    if (self.company) {
        [dataDict setObject:self.company forKey:@"company"];
    }
    if (self.userClassify) {
        [dataDict setObject:self.userClassify forKey:@"userClassify"];
    }
    if (self.userWorkAddress) {
        [dataDict setObject:self.userWorkAddress forKey:@"userWorkAddress"];
    }
    if (self.effectSocre) {
        [dataDict setObject:self.effectSocre forKey:@"effectSocre"];
    }
    if (self.userEmail) {
        [dataDict setObject:self.userEmail forKey:@"userEmail"];
    }
    if (self.phonePrivacy) {
        [dataDict setObject:self.phonePrivacy forKey:@"phonePrivacy"];
    }
    if (self.userPhone) {
        [dataDict setObject:self.userPhone forKey:@"userPhone"];
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
        [dataDict setObject:__dic forKey:@"user"];
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
        self.position = json[@"position"];
        self.userHead = json[@"userHead"];
        self.isEducation = json[@"isEducation"];
        self.isBasic = json[@"isBasic"];
        self.isOccupation = json[@"isOccupation"];
        self.userUid = json[@"userUid"];
        self.userName = json[@"userName"];
        self.extra = json[@"extra"];
        
        self.comLogo = json[@"comLogo"];
        self.company = json[@"company"];
        self.userClassify = json[@"userClassify"];
        self.userEmail = json[@"userEmail"];
        self.userWorkAddress = json[@"userWorkAddress"];
        self.effectSocre = json[@"effectSocre"];
        self.phonePrivacy = json[@"phonePrivacy"];
        self.userPhone = json[@"userPhone"];
        
        NSDictionary *userinfoDic = json[@"user"];
        [self decodeUserInfo:userinfoDic];
    }
}

- (NSString *)conversationDigest
{
    return @"个人名片";
}
+(NSString *)getObjectName {
    return RCLocalMessageTypeIdentifier;
}
#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [super dealloc];
}
#endif//__has_feature(objc_arc)
@end

