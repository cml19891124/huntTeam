//
//  CompanyContentCell.h
//  LIEBANG
//
//  Created by  YIQI on 2019/1/2.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyContentCell : SDTableViewCell

@property(nonatomic,copy)void(^editMessageBlock)(NSInteger index,NSString *content);
@property(nonatomic,copy)void(^editSourceBlock)(NSIndexPath *indexPath);
@property(nonatomic,copy)void(^reloadImageSourceBlock)(NSIndexPath *indexPath,NSMutableArray *imageArray,BOOL isreload);
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)CompanyModel *companyModel;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,assign)NSInteger maxImageNum;
@property (nonatomic,assign,readonly)CGFloat cellHeight;

@property (assign, nonatomic) BOOL isReload;


@end

NS_ASSUME_NONNULL_END
