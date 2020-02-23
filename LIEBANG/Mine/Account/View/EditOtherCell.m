//
//  EditOtherCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/17.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "EditOtherCell.h"

@interface EditOtherCell ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UILabel *detailLabel;

@end

@implementation EditOtherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self createSubViews];
    }
    return self;
}

- (void)setAccountInfo:(AccountInfo *)accountInfo {
    _accountInfo = accountInfo;
    
    if (_indexPath.row == 0)
    {
        _titleLabel.text = @"家乡";
        _messageLabel.text = @"关注更多同乡人脉";
        _detailLabel.text = IsStrEmpty(accountInfo.userHometown)?@"待完善":accountInfo.userHometown;
    }
    else if (_indexPath.row == 1)
    {
        _titleLabel.text = @"生日";
        _messageLabel.text = @"生日当天可以收到红包哦";
        _detailLabel.text = IsStrEmpty(accountInfo.userBirth)?@"待完善":[self showBirth:accountInfo.userBirth];
    }
}

- (NSString *)showBirth:(NSString *)userBirth {
    
    if (userBirth.length == 10) {
        return [userBirth substringFromIndex:5];
    }
    return userBirth;
}

- (void)createSubViews {
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), kCurrentWidth(10), kCurrentWidth(100), kCurrentWidth(24))];
    _titleLabel.textColor = kLBBlackColor;
    _titleLabel.font = kSystem(15);
    [self.contentView addSubview:_titleLabel];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), _titleLabel.bottom, kCurrentWidth(150), kCurrentWidth(22))];
    _messageLabel.textColor = kLBSixColor;
    _messageLabel.font = kSystem(14);
    _messageLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_messageLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(207),0, kCurrentWidth(180), kCurrentWidth(66))];
    _detailLabel.textColor = kLBSixColor;
    _detailLabel.font = kSystem(14);
    _detailLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_detailLabel];
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
