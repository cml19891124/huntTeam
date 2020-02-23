//
//  MineHeadCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "MineHeadCell.h"

#import "NameLabel.h"

@interface MineHeadCell ()

@property (nonatomic,strong)UIImageView *headIcon;
@property (nonatomic,strong) NameLabel *nameLabel;

@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong) PostionLabel *postLabel;

/**
 职位认证
 */
@property (strong, nonatomic) UIImageView *identifyIcon;

@end

@implementation MineHeadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.headIcon];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.postLabel];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setupSubviewsMasonry];

}

- (void)setupSubviewsMasonry
{
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kCurrentWidth(45));
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(kCurrentWidth(12));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kCurrentWidth(10));
        make.left.mas_equalTo(self.headIcon.mas_right).offset(kCurrentWidth(12));
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];

    [self.postLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameLabel.imageView.mas_right).mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(10);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kCurrentWidth(45));
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(kCurrentWidth(-10));
    }];
}

- (void)setModel:(AccountInfo *)model{
    _model = model;
    self.postLabel.userUid = model.userUid;
    self.nameLabel.userUid = model.userUid;
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:model.userHead] placeholderImage:IMAGE_NAMED(@"no_headIcon")];
    [self.nameLabel setNameString:[NSString stringWithFormat:@"%@",model.userName] showIcon:model.isBasic];
    CGFloat nameW = BoundWithSize(model.userName, SCREEN_WIDTH, 15).size.width + 10;

    self.nameLabel.nameWidth = nameW + 10;
    
    NSString *namePositon = [NSString stringWithFormat:@" %@%@",model.company,model.position];
    if (model.company.length == 0 && model.position.length == 0) {
        self.postLabel.hidden = YES;
        [self.postLabel setCompany:@"" postion:namePositon showIcon:model.isOccupationOne];
    }else{
        self.postLabel.hidden = NO;

        namePositon = [NSString stringWithFormat:@"· %@%@",model.company,model.position];
        [self.postLabel setCompany:@"" postion:namePositon showIcon:model.isOccupationOne];
    }

    NSString *selectText = [NSString stringWithFormat:@"%d",[model.effectScore intValue]];
    NSString *allSelectText = [NSString stringWithFormat:@"影响力%d",[model.effectScore intValue]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithHexString:@"FF9242"]
                 range:[allSelectText rangeOfString:selectText]];
    self.messageLabel.attributedText = attr;
}

#pragma mark 懒加载
- (UIImageView *)headIcon {
    if (!_headIcon) {
        _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(21)/2, kCurrentWidth(45), kCurrentWidth(45))];
        _headIcon.image = [UIImage imageNamed:@"no_headIcon"];
        _headIcon.layer.cornerRadius = kCurrentWidth(45)/2;
        _headIcon.layer.masksToBounds = YES;
        [_headIcon setContentScaleFactor:[[UIScreen mainScreen]scale]];
        _headIcon.contentMode = UIViewContentModeScaleAspectFill;
        _headIcon.autoresizingMask = UIViewAutoresizingNone;
    }
    return _headIcon;
}

- (NameLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[NameLabel alloc] init];
        [_nameLabel setNameString:[Config currentConfig].username showIcon:@"0"];
        _nameLabel.labelFont = kSystem(15);
        WeakSelf;
        _nameLabel.GetBasicCertiImageViewBlock = ^(NSString *imageUrl) {
            if (weakSelf.GetBasicSourceBlock) {
                weakSelf.GetBasicSourceBlock(imageUrl);
            }
        };
    }
    return _nameLabel;
}

- (PostionLabel *)postLabel {
    if (!_postLabel) {
        _postLabel = [[PostionLabel alloc] init];
        _postLabel.color = kLBBlackColor;
        _postLabel.font = kSystem(13);
        [_postLabel setCompany:[Config currentConfig].username postion:[Config currentConfig].company showIcon:@"0"];
        _postLabel.alignment = NSTextAlignmentLeft;
        WeakSelf;
        _postLabel.GetWorkCertiImageViewBlock = ^(NSString *imageUrl) {
            if (weakSelf.GetWorkSourceBlock) {
                weakSelf.GetWorkSourceBlock(imageUrl);
            }
        };
    }
    return _postLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headIcon.right+kCurrentWidth(12), self.nameLabel.bottom, kCurrentWidth(200), kCurrentWidth(13))];
        _messageLabel.font = kSystem(12);
        _messageLabel.textColor = kLBSixColor;
        _messageLabel.text = @"影响力0";
        _messageLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _messageLabel;
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
