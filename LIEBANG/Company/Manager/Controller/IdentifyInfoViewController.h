//
//  IdentifyInfoViewController.h
//  LIEBANG
//
//  Created by caominglei on 2019/10/12.
//  Copyright © 2019  YIQI. All rights reserved.
//

#import "SDBaseTextInputController.h"

typedef void(^EditInfo)(NSArray * _Nullable infoArray,NSString *_Nullable info);

typedef enum : NSUInteger {
    CompanyInfo,
    ProductsInfo,
    Employee,
} InfoType;

NS_ASSUME_NONNULL_BEGIN

@interface IdentifyInfoViewController : SDBaseTextInputController

@property (assign, nonatomic) InfoType type;

@property (nonatomic, copy) EditInfo infoBlock;

@property (strong, nonatomic) NSArray *currentArray;

@property (nonatomic, copy) NSString *currentInfo;
@end

NS_ASSUME_NONNULL_END
