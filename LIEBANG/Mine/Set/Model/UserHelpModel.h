//
//  UserHelpModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/13.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserHelpModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *classify;
@property (nonatomic,strong)NSArray *help;

@end

@interface HelpModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *helpquestions;
@property (nonatomic,strong)NSString *helpanswers;
@property (nonatomic,strong)NSString *helpclassfiyid;
@property (nonatomic,assign)BOOL isOpen;

@end
