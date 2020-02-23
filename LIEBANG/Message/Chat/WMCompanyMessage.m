//
//  WMCompanyMessage.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/11.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "WMCompanyMessage.h"

@implementation WMCompanyMessage

+(instancetype)messageWithContent:(CompanyModel *)content {
    WMCompanyMessage *msg = [[WMCompanyMessage alloc] init];
    if (msg) {
        msg.id = content.id;
        msg.userUid = content.userUid;
        msg.userName = [Config currentConfig].username;
        msg.isBasic = content.isBasic;
        msg.isOccupation = content.isOccupation;
        msg.userHead = [Config currentConfig].headIcon;
        msg.position = content.position;
        msg.companyLogo = content.companyLogo;
        msg.officialWebsite = content.officialWebsite;
        msg.fullName = content.fullName;
        msg.city = content.city;
        msg.region = content.region;
        msg.financingStatus = content.financingStatus;
        msg.industry = content.industry;
        msg.contactsPhone = content.contactsPhone;
        msg.email = content.email;
        msg.personnelScale = content.personnelScale;
        msg.companyAbbreviation = content.companyAbbreviation;
    }
    return msg;
}

+(RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

#pragma mark – NSCoding protocol methods
#define KEY_TXTMSG_ID @"id"
#define KEY_TXTMSG_USERUID @"userUid"
#define KEY_TXTMSG_USERNAME @"userName"
#define KEY_TXTMSG_ISBASIC @"isBasic"
#define KEY_TXTMSG_ISOCCUPATION @"isOccupation"
#define KEY_TXTMSG_USERHEAD @"userHead "
#define KEY_TXTMSG_POSITTION @"position"
#define KEY_TXTMSG_COMPANYLOGO @"companyLogo"
#define KEY_TXTMSG_OFFICIALWEBSITE @"officialWebsite"
#define KEY_TXTMSG_FULLNAME @"fullName"
#define KEY_TXTMSG_CITY @"city"
#define KEY_TXTMSG_REGION @"region"
#define KEY_TXTMSG_FINANCINGSTATUS @"financingStatus"
#define KEY_TXTMSG_INDUSTRY @"industry"
#define KEY_TXTMSG_CONTACTSPHONE @"contactsPhone"
#define KEY_TXTMSG_PERSONNELSCALE @"personnelScale"
#define KEY_TXTMSG_EMAIL @"email"
#define KEY_TXTMSG_COMPANYABBREVIATION @"companyAbbreviation"
#define KEY_TXTMSG_EXTRA @"extra"

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.id = [aDecoder decodeObjectForKey:KEY_TXTMSG_ID];
        self.userUid = [aDecoder decodeObjectForKey:KEY_TXTMSG_USERUID];
        self.userName = [aDecoder decodeObjectForKey:KEY_TXTMSG_USERNAME];
        self.isBasic = [aDecoder decodeObjectForKey:KEY_TXTMSG_ISBASIC];
        self.isOccupation = [aDecoder decodeObjectForKey:KEY_TXTMSG_ISOCCUPATION];
        self.userHead = [aDecoder decodeObjectForKey:KEY_TXTMSG_USERHEAD];
        self.position = [aDecoder decodeObjectForKey:KEY_TXTMSG_POSITTION];
        self.companyLogo = [aDecoder decodeObjectForKey:KEY_TXTMSG_COMPANYLOGO];
        self.officialWebsite = [aDecoder decodeObjectForKey:KEY_TXTMSG_OFFICIALWEBSITE];
        self.fullName = [aDecoder decodeObjectForKey:KEY_TXTMSG_FULLNAME];
        self.city = [aDecoder decodeObjectForKey:KEY_TXTMSG_CITY];
        self.region = [aDecoder decodeObjectForKey:KEY_TXTMSG_REGION];
        self.financingStatus = [aDecoder decodeObjectForKey:KEY_TXTMSG_FINANCINGSTATUS];
        self.industry = [aDecoder decodeObjectForKey:KEY_TXTMSG_INDUSTRY];
        self.contactsPhone = [aDecoder decodeObjectForKey:KEY_TXTMSG_CONTACTSPHONE];
        self.personnelScale = [aDecoder decodeObjectForKey:KEY_TXTMSG_PERSONNELSCALE];
        self.email = [aDecoder decodeObjectForKey:KEY_TXTMSG_EMAIL];
        self.companyAbbreviation = [aDecoder decodeObjectForKey:KEY_TXTMSG_COMPANYABBREVIATION];
        self.extra = [aDecoder decodeObjectForKey:KEY_TXTMSG_EXTRA];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.id forKey:KEY_TXTMSG_ID];
    [aCoder encodeObject:self.userUid forKey:KEY_TXTMSG_USERUID];
    [aCoder encodeObject:self.userHead forKey:KEY_TXTMSG_USERHEAD];
    [aCoder encodeObject:self.userName forKey:KEY_TXTMSG_USERNAME];
    [aCoder encodeObject:self.isBasic forKey:KEY_TXTMSG_ISBASIC];
    [aCoder encodeObject:self.isOccupation forKey:KEY_TXTMSG_ISOCCUPATION];
    [aCoder encodeObject:self.position forKey:KEY_TXTMSG_POSITTION];
    [aCoder encodeObject:self.companyLogo forKey:KEY_TXTMSG_COMPANYLOGO];
    [aCoder encodeObject:self.officialWebsite forKey:KEY_TXTMSG_OFFICIALWEBSITE];
    [aCoder encodeObject:self.fullName forKey:KEY_TXTMSG_FULLNAME];
    [aCoder encodeObject:self.city forKey:KEY_TXTMSG_CITY];
    [aCoder encodeObject:self.region forKey:KEY_TXTMSG_REGION];
    [aCoder encodeObject:self.financingStatus forKey:KEY_TXTMSG_FINANCINGSTATUS];
    [aCoder encodeObject:self.industry forKey:KEY_TXTMSG_INDUSTRY];
    [aCoder encodeObject:self.companyAbbreviation forKey:KEY_TXTMSG_COMPANYABBREVIATION];
    [aCoder encodeObject:self.contactsPhone forKey:KEY_TXTMSG_CONTACTSPHONE];
    [aCoder encodeObject:self.personnelScale forKey:KEY_TXTMSG_PERSONNELSCALE];
    [aCoder encodeObject:self.email forKey:KEY_TXTMSG_EMAIL];
    
    [aCoder encodeObject:self.extra forKey:KEY_TXTMSG_EXTRA];
}

#pragma mark – RCMessageCoding delegate methods

-(NSData *)encode {
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.id) {
        [dataDict setObject:self.id forKey:@"id"];
    }
    if (self.position) {
        [dataDict setObject:self.position forKey:@"position"];
    }
    if (self.userName) {
        [dataDict setObject:self.userName forKey:@"userName"];
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
    if (self.email) {
        [dataDict setObject:self.email forKey:@"email"];
    }
    if (self.userHead) {
        [dataDict setObject:self.userHead forKey:@"userHead"];
    }
    if (self.companyLogo) {
        [dataDict setObject:self.companyLogo forKey:@"companyLogo"];
    }
    if (self.officialWebsite) {
        [dataDict setObject:self.officialWebsite forKey:@"officialWebsite"];
    }
    if (self.companyAbbreviation) {
        [dataDict setObject:self.companyAbbreviation forKey:@"companyAbbreviation"];
    }
    if (self.fullName) {
        [dataDict setObject:self.fullName forKey:@"fullName"];
    }
    if (self.city) {
        [dataDict setObject:self.city forKey:@"city"];
    }
    if (self.region) {
        [dataDict setObject:self.region forKey:@"region"];
    }
    if (self.financingStatus) {
        [dataDict setObject:self.financingStatus forKey:@"financingStatus"];
    }
    if (self.industry) {
        [dataDict setObject:self.industry forKey:@"industry"];
    }
    if (self.contactsPhone) {
        [dataDict setObject:self.contactsPhone forKey:@"contactsPhone"];
    }
    if (self.personnelScale) {
        [dataDict setObject:self.personnelScale forKey:@"personnelScale"];
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
        self.id = json[@"id"];
        self.position = json[@"position"];
        self.userHead = json[@"userHead"];
        self.companyLogo = json[@"companyLogo"];
        self.isBasic = json[@"isBasic"];
        self.isOccupation = json[@"isOccupation"];
        self.userUid = json[@"userUid"];
        self.userName = json[@"userName"];
        self.email = json[@"email"];
        self.officialWebsite = json[@"officialWebsite"];
        self.fullName = json[@"fullName"];
        self.companyAbbreviation = json[@"companyAbbreviation"];
        self.city = json[@"city"];
        self.region = json[@"region"];
        self.financingStatus = json[@"financingStatus"];
        self.industry = json[@"industry"];
        self.contactsPhone = json[@"contactsPhone"];
        self.personnelScale = json[@"personnelScale"];
        
        self.extra = json[@"extra"];
        NSDictionary *userinfoDic = json[@"user"];
        [self decodeUserInfo:userinfoDic];
    }
}

- (NSString *)conversationDigest
{
    return @"企业名片";
}
+(NSString *)getObjectName {
    return RCLocalCompanyMessageTypeIdentifier;
}
#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [super dealloc];
}
#endif//__has_feature(objc_arc)

@end
