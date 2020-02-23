//
//  SDAnswerViewCell.m
//  LIEBANG
//
//  Created by caominglei on 2019/10/21.
//  Copyright © 2019  YIQI. All rights reserved.
//

#import "SDAnswerViewCell.h"

@implementation SDAnswerViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)cellHeight {
    return self.height;
}
- (PostAnswerView *)answerView {
    if (!_answerView) {
        _answerView = [[PostAnswerView alloc] init];
        _answerView.orderUid = self.detailModel.id;
    }
    return _answerView;
}

- (void)initView
{
    [self.contentView addSubview:self.answerView];
    [self.answerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setDetailModel:(QuestionOrderDetailModel *)detailModel
{
    _detailModel = detailModel;
}
@end
