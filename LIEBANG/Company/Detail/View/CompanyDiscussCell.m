//
//  CompanyDiscussCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CompanyDiscussCell.h"

@interface CompanyDiscussCell ()

@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UIImageView *headIcon;
@property (nonatomic,strong)PostionLabel *postionLabel;
@property (nonatomic,strong)NameLabel *nameLabel;

@property (strong, nonatomic) UIButton *commentBtn;
@end

@implementation CompanyDiscussCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(10), kCurrentWidth(40), kCurrentWidth(40))];
        _headIcon.layer.cornerRadius = kCurrentWidth(20);
        _headIcon.layer.masksToBounds = YES;
        _headIcon.image = [UIImage imageNamed:@"no_headIcon"];
        [self.contentView addSubview:_headIcon];
        
        _nameLabel = [[NameLabel alloc] initWithFrame:CGRectMake(_headIcon.right+kCurrentWidth(10), _headIcon.top+kCurrentWidth(5), kDeviceWidth-_headIcon.right-115-kCurrentWidth(20), kCurrentWidth(17))];
        _nameLabel.labelFont = kSystem(15);
        [_nameLabel setNameString:@"高雅娜" showIcon:@"0"];
        [self.contentView addSubview:_nameLabel];
        
        _postionLabel = [[PostionLabel alloc] initWithFrame:CGRectMake(_headIcon.right+kCurrentWidth(10), _nameLabel.bottom, kDeviceWidth-_headIcon.right-115-kCurrentWidth(20), kCurrentWidth(14))];
        _postionLabel.font = kSystem(12);
        _postionLabel.color = kLBSixColor;
        [_postionLabel setCompany:nil postion:@"数字100平台运营总监" showIcon:@"1"];
        [self.contentView addSubview:_postionLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(15), _headIcon.bottom+kCurrentWidth(6), kDeviceWidth-kCurrentWidth(24), 0)];
        _messageLabel.font = kSystem(12);
        _messageLabel.textColor = kLBSixColor;
        _messageLabel.numberOfLines = 0;
        [self.contentView addSubview:_messageLabel];
        
        _commentBtn = UIButton.new;
        _commentBtn.frame = CGRectMake(kCurrentWidth(15), CGRectGetMaxY(_messageLabel.frame) + kCurrentWidth(100), kDeviceWidth - kCurrentWidth(30), kCurrentWidth(44));
        _commentBtn.layer.cornerRadius = 4;
        _commentBtn.layer.masksToBounds = YES;
        [_commentBtn setTitle:@"写公司点评，赢优惠券红包" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_commentBtn setBackgroundColor:kLBRedColor];
        _commentBtn.titleLabel.font = kSystem(15);
        [_commentBtn addTarget:self action:@selector(commentForCompany:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:_commentBtn];
    }
    return self;
}

- (void)commentForCompany:(UIButton *)button
{
    if (_commentBlock) {
        _commentBlock();
    }
   
}

- (void)setModel:(CompanyCommentModel *)model {
    _model = model;
    
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:model.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    [_nameLabel setNameString:model.userName showIcon:model.isBasic];
    NSString *name = [NSString stringWithFormat:@"%@%@",model.company?:@"",model.position?:@""];

    [_postionLabel setCompany:nil postion:name.length >0 ?name:@"未填写公司和职位信息" showIcon:model.isOccupation];
    _messageLabel.text = model.comment;
    
    CGSize size = [model.comment sizeWithFont:kSystem(12) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), MAXFLOAT)];
    _messageLabel.height = size.height;
    self.height = _messageLabel.bottom + kCurrentWidth(15);
}

- (CGFloat)cellHeight {
    return self.height;
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
