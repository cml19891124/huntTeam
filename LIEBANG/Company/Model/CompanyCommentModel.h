//
//  CompanyCommentModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CompanyCommentModel : NSObject

@property (nonatomic,strong)NSString *userHead;
@property (nonatomic,strong)NSString *isOccupation;
@property (strong, nonatomic) NSString *isOccupationOne;
@property (nonatomic,strong)NSString *isBasic;
@property (nonatomic,strong)NSString *comment;
@property (nonatomic,strong)NSString *company;
@property (nonatomic,strong)NSString *position;
@property (nonatomic,strong)NSString *comLogo;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *userUid;

@end

NS_ASSUME_NONNULL_END
