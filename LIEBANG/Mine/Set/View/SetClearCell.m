//
//  SetClearCell.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/17.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "SetClearCell.h"

@interface SetClearCell ()

@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UILabel *detailLabel;

@end

@implementation SetClearCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kDeviceWidth-kCurrentWidth(40),kCurrentWidth(44))];
        _contentLabel.font = kSystem(15);
        _contentLabel.textColor = kLBBlackColor;
        _contentLabel.text = @"清理缓存";
        [self.contentView addSubview:_contentLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(130), 0, kCurrentWidth(100),kCurrentWidth(44))];
        _detailLabel.font = kSystem(14);
        _detailLabel.textColor = kLBSixColor;
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_detailLabel];
        
    }
    return self;
}

- (void)setCurrentVolum:(NSString *)currentVolum {
    _currentVolum = currentVolum;
    
    _detailLabel.text = currentVolum;
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
