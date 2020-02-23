//
//  SDAnswerViewCell.h
//  LIEBANG
//
//  Created by caominglei on 2019/10/21.
//  Copyright © 2019  YIQI. All rights reserved.
//

#import "SDTableViewCell.h"

#import "PostAnswerView.h"

#import "QuestionOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDAnswerViewCell : SDTableViewCell

@property (nonatomic,strong)PostAnswerView *answerView;

@property (nonatomic,strong)QuestionOrderDetailModel *detailModel;

@property (nonatomic,assign)CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
