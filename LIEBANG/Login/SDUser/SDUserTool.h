

#import <Foundation/Foundation.h>
#import "LoginModel.h"

@interface  SDUserTool: NSObject
/**
 5  *  存储账号信息
 6  *
 7  *  @param account 账号模型
 8  */
 +(void)saveAccount:(LoginModel *)account;
/**
    12  *  返回账号信息
    13  *
    14  *  @return 账号模型（如果账号过期，我们会返回nil）
    15  */
 +(LoginModel *)account;
/**
    19  *  删除账号信息
    22  */
 +(BOOL)deleteAccount;
@end
