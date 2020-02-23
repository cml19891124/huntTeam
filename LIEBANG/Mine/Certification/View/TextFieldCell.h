//
//  TextFieldCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MechanismModel.h"
#import "CompanyModel.h"

@interface TextFieldCell : UITableViewCell

@property (nonatomic,strong)MechanismModel *model;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,copy)void(^editSourceBlock)(void);
@property(nonatomic,copy)void(^editMessageBlock)(NSInteger index,NSString *content);
@property (nonatomic,strong)UIImage *image;

/// textfield中内容发送改变的回调
@property (nonatomic, copy) void(^SaveData)(NSString *text);

@property (strong, nonatomic) NSMutableDictionary *dataDic;


- (void)setIndex:(NSIndexPath *)indexPath companyModel:(CompanyModel *)companyModel;

@end
