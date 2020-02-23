//
//  PersonnelCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PersonnelCell.h"

@interface PersonnelCell ()

@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,strong)UIImageView *headIcon;
@property (nonatomic,strong)PostionLabel *postionLabel;
@property (nonatomic,strong)NameLabel *nameLabel;

@end

@implementation PersonnelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(15), kCurrentWidth(40), kCurrentWidth(40))];
        _headIcon.layer.cornerRadius = kCurrentWidth(20);
        _headIcon.layer.masksToBounds = YES;
        _headIcon.image = [UIImage imageNamed:@"no_headIcon"];
        [_headIcon setContentScaleFactor:[[UIScreen mainScreen]scale]];
        _headIcon.contentMode = UIViewContentModeScaleAspectFill;
        _headIcon.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:_headIcon];
        
        _nameLabel = [[NameLabel alloc] initWithFrame:CGRectMake(_headIcon.right+kCurrentWidth(10), _headIcon.top+kCurrentWidth(5), kDeviceWidth-_headIcon.right-115-kCurrentWidth(20), kCurrentWidth(17))];
        _nameLabel.labelFont = kSystem(15);
        [_nameLabel setNameString:@"高雅娜" showIcon:@"0"];
        [self addSubview:_nameLabel];
        
        _postionLabel = [[PostionLabel alloc] initWithFrame:CGRectMake(_headIcon.right+kCurrentWidth(10), _nameLabel.bottom, kDeviceWidth-_headIcon.right-115-kCurrentWidth(20), kCurrentWidth(14))];
        _postionLabel.font = kSystem(12);
        _postionLabel.color = kLBSixColor;
        [_postionLabel setCompany:nil postion:@"数字100平台运营总监" showIcon:@"1"];
        [self addSubview:_postionLabel];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(40), kCurrentWidth(21), kCurrentWidth(28), kCurrentWidth(28));
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"company_cancel"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return self;
}

- (void)setModel:(PersonnelModel *)model {
    _model = model;
    
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:model.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    NSString *name = [NSString stringWithFormat:@"%@%@",model.company?:@"",model.position?:@""];
    [_nameLabel setNameString:model.userName showIcon:model.isBasic];
    [_postionLabel setCompany:nil postion:name.length>0?name:@"未完善公司和职位信息" showIcon:model.isOccupation];
    
    NSString *position = [NSString stringWithFormat:@"%@%@",model.company?:@"",model.position?:@""];
    if ([model.isOccupation isEqualToString:@"0"]) {
        self.postionLabel.width = BoundWithSize(position, kDeviceWidth, 13).size.width + 20;

    }else{
        self.postionLabel.labelWidth = kDeviceWidth-self.nameLabel.left-kCurrentWidth(12);

    }
    LoginModel *account = [SDUserTool account];
    if ([account.userUid isEqualToString:model.userUid]) {
        _cancelButton.hidden = YES;
    }
    else {
        _cancelButton.hidden = NO;
    }
}

- (void)cancelButtonClick {
    if (_deletePersonnelBlock) {
        _deletePersonnelBlock(self.model.id);
    }
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
