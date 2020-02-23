//
//  AllClassModel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/30.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllClassModel : NSObject

@property (nonatomic,strong)NSArray *data;

@end

@interface ClassModel : NSObject

@property (nonatomic,strong)NSMutableArray *classifyTwo;
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *icon;
@property (nonatomic,strong)NSString *classify;
@property (nonatomic,strong)NSString *type;

@end

@interface ClassifyTwoModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *icon;
@property (nonatomic,strong)NSString *classify;
@property (nonatomic,strong)NSString *pushcategory;
@property (nonatomic,strong)NSString *pid;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,assign)BOOL isClick;

@end
