//
//  CompanyDiscussCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyCommentModel.h"

typedef void(^CommentForCompanyBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface CompanyDiscussCell : UITableViewCell

@property (nonatomic,strong)CompanyCommentModel *model;

@property (nonatomic,readonly)CGFloat cellHeight;

@property (nonatomic, copy) CommentForCompanyBlock commentBlock;

@end

NS_ASSUME_NONNULL_END
