//
//  Config.m
//  Storm
//
//  Created by 朱攀峰 on 15/12/5.
//  Copyright (c) 2015年 MCDS. All rights reserved.
//

#import "Config.h"

@implementation Config

@synthesize defaults;
@dynamic token;
@dynamic mobile;
@dynamic password;
@dynamic effectSocre;
@dynamic username;
@dynamic headIcon;
@dynamic qiniu;
@dynamic userUid;
@dynamic balanceAmount;
@dynamic availableAmount;
@dynamic remeberPassword;
@dynamic answerid;
@dynamic position;
@dynamic isMessage;
@dynamic comment;
@dynamic friendCount;
@dynamic registrationID;
@dynamic answerOrderUid;
@dynamic answerContent;
@dynamic company;
@dynamic liebangCurrency;
@dynamic enterAccount;

- (instancetype)init
{
    if (!(self = [super init])) {
       return self;
    }
    self.defaults = [NSUserDefaults standardUserDefaults];

    [self.defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                     @"",NSStringFromSelector(@selector(token)),
                                     @"",NSStringFromSelector(@selector(mobile)),
                                     @"",NSStringFromSelector(@selector(effectSocre)),
                                     @"",NSStringFromSelector(@selector(username)),
                                     @"",NSStringFromSelector(@selector(headIcon)),
                                     @"",NSStringFromSelector(@selector(password)),
                                     @"",NSStringFromSelector(@selector(qiniu)),
                                     @"",NSStringFromSelector(@selector(userUid)),
                                     @"",NSStringFromSelector(@selector(balanceAmount)),
                                     @"",NSStringFromSelector(@selector(availableAmount)),
                                     @"",NSStringFromSelector(@selector(remeberPassword)),
                                     @"",NSStringFromSelector(@selector(answerid)),
                                     @"",NSStringFromSelector(@selector(position)),
                                     @"",NSStringFromSelector(@selector(isMessage)),
                                     @"",NSStringFromSelector(@selector(comment)),
                                     @"",NSStringFromSelector(@selector(friendCount)),
                                     @"",NSStringFromSelector(@selector(registrationID)),
                                     @"",NSStringFromSelector(@selector(answerOrderUid)),
                                     @"",NSStringFromSelector(@selector(answerContent)),
                                     @"",NSStringFromSelector(@selector(company)),
                                     @"",NSStringFromSelector(@selector(liebangCurrency)),
                                     @"",NSStringFromSelector(@selector(enterAccount)),
                                     nil]];
    return self;
    
}

- (void)dealloc
{
    self.defaults = nil;
    self.token = nil;
    self.mobile = nil;
    self.password = nil;
    self.effectSocre = nil;
    self.username = nil;
    self.headIcon = nil;
    self.qiniu = nil;
    self.userUid = nil;
    self.balanceAmount = nil;
    self.availableAmount = nil;
    self.remeberPassword = nil;
    self.answerid = nil;
    self.position = nil;
    self.isMessage = nil;
    self.comment = nil;
    self.friendCount = nil;
    self.registrationID = nil;
    self.answerOrderUid = nil;
    self.answerContent = nil;
    self.company = nil;
    self.liebangCurrency = nil;
    self.enterAccount = nil;
}

+ (Config *)currentConfig
{
    static Config *currentConfig = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        currentConfig = [[Config alloc] init];
    });
    return currentConfig;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([NSStringFromSelector(aSelector) hasPrefix:@"set"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSString *selector = NSStringFromSelector(anInvocation.selector);
    if ([selector hasPrefix:@"set"]) {
        NSRange firstChar,rest;
        firstChar.location = 3;
        firstChar.length = 1;
        rest.location = 4;
        rest.length = selector.length-5;
        
        selector = [NSString stringWithFormat:@"%@%@",[[selector substringWithRange:firstChar] lowercaseString],[selector substringWithRange:rest]];
        
        __autoreleasing id value;
        [anInvocation getArgument:&value atIndex:2];
        
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSSet class]]) {
            [self.defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:selector];
        }
        else
        {
            [self.defaults setObject:value forKey:selector];
        }
    }
    else
    {
        __autoreleasing id value = [self.defaults objectForKey:selector];
        if ([value isKindOfClass:[NSData class]]) {
            value = [NSKeyedUnarchiver unarchiveObjectWithData:value];
        }
        [anInvocation setReturnValue:&value];
    }
}
@end
