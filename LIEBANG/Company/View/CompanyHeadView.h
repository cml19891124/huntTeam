//
//  CompanyHeadView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyHeadView : UIView

@property(nonatomic,copy)void(^allPersonnelBlock)(NSString *uid);
@property (nonatomic,strong)CompanyModel *detailModel;
@property (nonatomic,assign)BOOL isCompanyPoster;

@end

NS_ASSUME_NONNULL_END
