//
//  MessageCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

@property (nonatomic,strong)UIImageView *mineImageView;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UILabel *timeLabel;

@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.mineImageView];
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)setModel:(SystemModel *)model {
    _model = model;
    
    self.messageLabel.text = model.content;
    self.timeLabel.text = [InsureValidate timeInStr:model.createTime];
}

#pragma mark 界面布局
- (UIImageView *)mineImageView {
    if (!_mineImageView) {
        _mineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(13), kCurrentWidth(18), kCurrentWidth(40), kCurrentWidth(40))];
        _mineImageView.image = [UIImage imageNamed:@"list_btn_xiaoxi"];
    }
    return _mineImageView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.mineImageView.right+kCurrentWidth(10), kCurrentWidth(12), kDeviceWidth-kCurrentWidth(80), kCurrentWidth(34))];
        _messageLabel.font = kSystem(kCurrentWidth(14));
        _messageLabel.textColor = kLBBlackColor;
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.mineImageView.right+kCurrentWidth(10), self.messageLabel.bottom, kDeviceWidth-kCurrentWidth(80), kCurrentWidth(20))];
        _timeLabel.font = kSystem(12);
        _timeLabel.textColor = kLBNineColor;
    }
    return _timeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
