//
//  AccountQuestionCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/9/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionClassModel.h"

@interface AccountQuestionCell : UITableViewCell

@property (nonatomic,strong)QuestionClassModel *questionClassModel;

- (CGFloat)getHeight;

@end
