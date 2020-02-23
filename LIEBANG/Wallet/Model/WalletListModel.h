//
//  WalletListModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/1.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletListModel : NSObject

@property (nonatomic,strong)NSString *balance;//余额
@property (nonatomic,strong)NSString *liebangCurrency;//猎帮币余额

@property (nonatomic,strong)NSArray *wallet;

@end

@interface WalletModel : NSObject

@property (nonatomic,strong)NSString *id;//
@property (nonatomic,strong)NSString *balance;//余额
@property (nonatomic,strong)NSString *createTime;//创建时间
@property (nonatomic,strong)NSString *payStatus;//0 支付宝 1：微信
@property (nonatomic,strong)NSString *userUid;//余额
@property (nonatomic,strong)NSString *transactionstate;//交易状态（交易付款：0，转账：1，在线支付：2，提现：3，充值）
@property (nonatomic,strong)NSString *walletUid;//交易号
@property (nonatomic,strong)NSString *realName;//提现真实姓名
@property (nonatomic,strong)NSString *statu;//0 支付未完成 1：支付已完成
@property (nonatomic,strong)NSString *totalamount;//用户总金额
@property (nonatomic,strong)NSString *updateTime;//修改时间
@property (nonatomic,strong)NSString *payeeAccount;//提现账号

@property (nonatomic,strong)NSString *transactionaMount;//交易金额
@property (nonatomic,strong)NSString *transactionStateName;//交易金额
@property (nonatomic,strong)NSString *transactionaMountNum;//交易金额
@end
