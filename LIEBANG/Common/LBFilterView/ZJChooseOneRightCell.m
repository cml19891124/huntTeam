//
//  ZJChooseOneRightCell.m
//  ZJUIKit
//
//  Created by dzj on 2017/12/25.
//  Copyright © 2017年 kapokcloud. All rights reserved.
//

#import "ZJChooseOneRightCell.h"

@implementation ZJChooseOneRightCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpAllView];
    }
    return self;
}


-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(39), kCurrentWidth(44))];
    arrow.contentMode = UIViewContentModeCenter;
    arrow.image = [UIImage imageNamed:@"list_button_xuanze"];
    
    if (isSelected) {
        self.titleLab.font = kBoldFontWithSize(14);
        self.titleLab.textColor = kLBRedColor;
        self.accessoryView = arrow;
    }else{
        self.titleLab.font = kFontWithSize(14);
        self.titleLab.textColor = kLBBlackColor;
        self.accessoryView = nil;
    }
}


// 添加所子控件
-(void)setUpAllView{
    self.titleLab = [[UILabel alloc]init];
    _titleLab.font = kFontWithSize(14);
    _titleLab.textColor = kLBBlackColor;
    [self.contentView addSubview:self.titleLab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(44)-0.5, kDeviceWidth, 0.5)];
    line.backgroundColor = kSepparteLineColor;
    [self.contentView addSubview:line];
    
//    _arrowImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(39), 0, kCurrentWidth(39), kCurrentWidth(44))];
//    _arrowImgV.contentMode = UIViewContentModeCenter;
//    _arrowImgV.image = [UIImage imageNamed:@"list_button_xuanze"];
//    [self.contentView addSubview:self.arrowImgV];
//    self.arrowImgV.hidden = YES;
    
    self.detailLab = [[UILabel alloc]init];
    _detailLab.font = kFontWithSize(13);
    _detailLab.textColor = kLightGrayColor;
    [self.contentView addSubview:self.detailLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_lessThanOrEqualTo(-30);
    }];
    
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLab.mas_centerY);
        make.left.equalTo(_titleLab.mas_right).offset(2);
        make.right.mas_equalTo(-10);
    }];
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ZJChooseOneRightCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
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
