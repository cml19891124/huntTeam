//
//  CompanyPosterCell.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/3.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "CompanyPosterCell.h"

@interface CompanyPosterCell ()

//@property (nonatomic,strong)UIImageView *codeIcon;
@property (nonatomic,strong)UIButton *saveButton;

@end

@implementation CompanyPosterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        _codeIcon = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(105))/2, kCurrentWidth(25), kCurrentWidth(105), kCurrentWidth(105))];
//        _codeIcon.image = [UIImage imageNamed:@"erweima"];
//        [self.contentView addSubview:_codeIcon];
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(kCurrentWidth(19), kCurrentWidth(30), kDeviceWidth-kCurrentWidth(38), kCurrentWidth(40));
        _saveButton.backgroundColor = kLBRedColor;
        [_saveButton setTitle:@"保存企业名片海报" forState:UIControlStateNormal];
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kSystemBold(16);
        [_saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveButton];
    }
    return self;
}

- (void)saveButtonClick {
    if (_saveCompanyPosterBlock) {
        _saveCompanyPosterBlock();
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
