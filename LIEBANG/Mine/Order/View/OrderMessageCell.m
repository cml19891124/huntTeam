//
//  OrderMessageCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/24.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "OrderMessageCell.h"

@interface OrderMessageCell ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *messageLabel;

@end

@implementation OrderMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(65), kCurrentWidth(55))];
        _titleLabel.text = @"详细地址";
        _titleLabel.textColor = kLBBlackColor;
        _titleLabel.font = kSystem(15);
        [self.contentView addSubview:_titleLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(86), 0, kDeviceWidth-kCurrentWidth(95), kCurrentWidth(55))];
        _messageLabel.text = @"2018-4-13  14:00";
        _messageLabel.textColor = kLBFiveColor;
        _messageLabel.font = kSystem(15);
        _messageLabel.numberOfLines = 2;
        _messageLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_messageLabel];
    }
    return self;
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
