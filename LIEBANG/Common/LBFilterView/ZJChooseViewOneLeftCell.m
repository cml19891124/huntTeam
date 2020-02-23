//
//  ZJChooseViewOneLeftCell.m
//  ZJUIKit
//
//  Created by dzj on 2017/12/25.
//  Copyright © 2017年 kapokcloud. All rights reserved.
//

#import "ZJChooseViewOneLeftCell.h"



@implementation ZJChooseViewOneLeftCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpAllView];
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        self.arrowImgV.hidden = NO;
        self.titleLab.textColor = kLBRedColor;
        _titleLab.font = kSystemBold(14);
    }else{
        self.arrowImgV.hidden = YES;
        self.titleLab.textColor = kLBBlackColor;
        _titleLab.font = kSystem(14);
    }
}

-(void)setThreeIsSelected:(BOOL)threeIsSelected{
    _threeIsSelected = threeIsSelected;
    if (threeIsSelected) {
        self.titleLab.textColor = kLBRedColor;
        _titleLab.font = kSystemBold(14);
    }else{
        self.titleLab.textColor = kLBBlackColor;
        _titleLab.font = kSystem(14);
    }
}

- (void)setShowLine:(BOOL)showLine {
    self.line.hidden = !showLine;
}

// 添加所子控件
-(void)setUpAllView{
    self.titleLab = [[UILabel alloc]init];
    _titleLab.textColor = kLBBlackColor;
    _titleLab.font = kSystem(14);
    _titleLab.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.titleLab];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(44)-0.5, kDeviceWidth, 0.5)];
    self.line.backgroundColor = kSepparteLineColor;
    [self.contentView addSubview:self.line];
    
    self.arrowImgV = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(39), 0, kCurrentWidth(39), kCurrentWidth(44))];
    _arrowImgV.contentMode = UIViewContentModeCenter;
    _arrowImgV.image = [UIImage imageNamed:@"list_button_xuanze"];
    [self.contentView addSubview:self.arrowImgV];
    self.arrowImgV.hidden = YES;
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_lessThanOrEqualTo(-30);
    }];
    
//    [self.arrowImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_titleLab.mas_centerY);
//        make.left.equalTo(_titleLab.mas_right).offset(4);
//        make.width.mas_equalTo(6);
//        make.height.mas_equalTo(9);
//    }];
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ZJChooseViewOneLeftCell";
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
