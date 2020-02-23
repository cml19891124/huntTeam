//
//  PrivacyCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PrivacyCell.h"

@interface PrivacyCell ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *chooseButton;

@end

@implementation PrivacyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.chooseButton];
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    self.titleLabel.text = [[[LBForProject currentProject].privacyCellTitleArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
}

- (void)setPrivacyModel:(PrivacyModel *)privacyModel {
    _privacyModel = privacyModel;
    
    if (_indexPath.section == 0)
    {
        if (_indexPath.row == 0)
        {
            if ([privacyModel.phonePrivacy_type isEqualToString:@"0"])
            {
                self.chooseButton.selected = NO;
            }
            else if ([privacyModel.phonePrivacy_type isEqualToString:@"1"])
            {
                self.chooseButton.selected = YES;
            }
        }
        else
        {
            if ([privacyModel.phonePrivacy_type isEqualToString:@"0"])
            {
                self.chooseButton.selected = YES;
            }
            else if ([privacyModel.phonePrivacy_type isEqualToString:@"1"])
            {
                self.chooseButton.selected = NO;
            }
        }
    }
    else if (_indexPath.section == 1)
    {
        if (_indexPath.row == 0)
        {
            if ([privacyModel.userDataPrivacy_type isEqualToString:@"0"])
            {
                self.chooseButton.selected = NO;
            }
            else if ([privacyModel.userDataPrivacy_type isEqualToString:@"1"])
            {
                self.chooseButton.selected = YES;
            }
        }
        else
        {
            if ([privacyModel.userDataPrivacy_type isEqualToString:@"0"])
            {
                self.chooseButton.selected = YES;
            }
            else if ([privacyModel.userDataPrivacy_type isEqualToString:@"1"])
            {
                self.chooseButton.selected = NO;
            }
        }
    }
    else if (_indexPath.section == 2)
    {
        if (_indexPath.row == 0)
        {
            if ([privacyModel.userMessagePrivacy_type isEqualToString:@"0"])
            {
                self.chooseButton.selected = NO;
            }
            else if ([privacyModel.userMessagePrivacy_type isEqualToString:@"1"])
            {
                self.chooseButton.selected = YES;
            }
        }
        else
        {
            if ([privacyModel.userMessagePrivacy_type isEqualToString:@"0"])
            {
                self.chooseButton.selected = YES;
            }
            else if ([privacyModel.userMessagePrivacy_type isEqualToString:@"1"])
            {
                self.chooseButton.selected = NO;
            }
        }
    }
    else if (_indexPath.section == 3)
    {
        NSArray *typeArr = [privacyModel.userFriendPrivacy_type componentsSeparatedByString:@","];
        
        BOOL select = NO;
        for (NSString *index in typeArr) {
            if ([index intValue] == _indexPath.row) {
                select = YES;
            }
        }
        self.chooseButton.selected = select;
    }
    
}

#pragma mark Event
- (void)chooseButtonClick {
    
    if (_chooseButtonBlock) {
        _chooseButtonBlock(_indexPath);
    }
}

#pragma mark 界面布局
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), 0, kCurrentWidth(200), kCurrentWidth(47))];
        _titleLabel.textColor = kLBBlackColor;
        _titleLabel.font = kSystem(14);
    }
    return _titleLabel;
}

- (UIButton *)chooseButton {
    if (!_chooseButton) {
        _chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(44), 0, kCurrentWidth(44), kCurrentWidth(47));
        [_chooseButton setImage:[UIImage imageNamed:@"list_btn_meixuanzhong"] forState:UIControlStateNormal];
        [_chooseButton setImage:[UIImage imageNamed:@"icon_yanzheng"] forState:UIControlStateSelected];
        [_chooseButton addTarget:self action:@selector(chooseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseButton;
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
