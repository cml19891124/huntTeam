//
//  CompanyLOGOCell.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/3.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "CompanyLOGOCell.h"

@interface CompanyLOGOCell ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *LOGO;
//@property (nonatomic,strong)UIImageView *LOGO;

@end

@implementation CompanyLOGOCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self createSubViews];
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    _titleLabel.text = [[LBForProject currentProject].comCertiCellTitleArray safeObjectAtIndex:indexPath.row];
}

- (void)setCompanyModel:(CompanyModel *)companyModel {
    _companyModel = companyModel;
    
    [_LOGO sd_setImageWithURL:[NSURL URLWithString:companyModel.companyLogo] placeholderImage:[UIImage imageNamed:@"icon_liebang"]];
}

- (void)setImage:(UIImage *)image {
    
    if (!IsNilOrNull(image)) {
        _image = image;
        
        _LOGO.image = image;
    }
}

- (void)createSubViews {
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(100), kCurrentWidth(58))];
    _titleLabel.textColor = kLBBlackColor;
    _titleLabel.font = kSystem(16);
    [self.contentView addSubview:_titleLabel];

    _LOGO = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(76), kCurrentWidth(13)/2, kCurrentWidth(45), kCurrentWidth(45))];
    _LOGO.image = [UIImage imageNamed:@"icon_liebang"];
    _LOGO.layer.cornerRadius = kCurrentWidth(22.5);
    _LOGO.layer.masksToBounds = YES;
    [_LOGO setContentScaleFactor:[[UIScreen mainScreen]scale]];
    _LOGO.contentMode = UIViewContentModeScaleAspectFill;
    _LOGO.autoresizingMask = UIViewAutoresizingNone;
    [self.contentView addSubview:_LOGO];
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
