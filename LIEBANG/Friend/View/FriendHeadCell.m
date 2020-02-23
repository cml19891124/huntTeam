//
//  FriendHeadCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "FriendHeadCell.h"

@interface FriendHeadCell ()

@property (nonatomic,strong)UIImageView *mineImageView;
@property (nonatomic,strong)UILabel *mineTitleLabel;
@property (nonatomic,strong)UILabel *numberLabel;

@property (nonatomic,strong)UIView *content;

@end

@implementation FriendHeadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.mineImageView];
        [self.contentView addSubview:self.mineTitleLabel];
        [self.contentView addSubview:self.numberLabel];
//        [self.contentView addSubview:self.content];
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    self.mineTitleLabel.text = [[LBForProject currentProject].friendCellTitleArray safeObjectAtIndex:indexPath.row];
    self.mineImageView.image = [UIImage imageNamed:[[LBForProject currentProject].friendCellImageArray safeObjectAtIndex:indexPath.row]];
    
    if (indexPath.row == 0) {
        self.numberLabel.text = [NSString stringWithFormat:@"%d",[[Config currentConfig].friendCount intValue]];
        self.numberLabel.textColor = kLBSixColor;
    }
    else {
        self.numberLabel.text = @"连接千万人脉";
        self.numberLabel.textColor = kLBRedColor;
    }
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
    if (dataSource.count == 0) {
        [self.content.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        return;
    }
    
    if (self.indexPath.row == 0) {
        [self.content.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    else {
        [self.content.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSInteger b = MIN(3, dataSource.count);
        for (int i = 0; i < b; i ++) {
            InterestFriendModel *model = [dataSource safeObjectAtIndex:i];
            UIImageView *small = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(29)*i, kCurrentWidth(16), kCurrentWidth(23), kCurrentWidth(23))];
            [small sd_setImageWithURL:[NSURL URLWithString:model.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
            small.layer.cornerRadius = kCurrentWidth(23)/2;
            small.layer.masksToBounds = YES;
            [small setContentScaleFactor:[[UIScreen mainScreen]scale]];
            small.contentMode = UIViewContentModeScaleAspectFill;
            small.autoresizingMask = UIViewAutoresizingNone;
            [self.content addSubview:small];
        }
    }
}

#pragma mark 懒加载
- (UIImageView *)mineImageView {
    if (!_mineImageView) {
        _mineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(23)/2, kCurrentWidth(32), kCurrentWidth(32))];
    }
    return _mineImageView;
}

- (UILabel *)mineTitleLabel {
    if (!_mineTitleLabel) {
        _mineTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.mineImageView.right+kCurrentWidth(10), 0, kCurrentWidth(60), kCurrentWidth(55))];
        _mineTitleLabel.font = kSystem(15);
        _mineTitleLabel.textColor = kLBBlackColor;
        _mineTitleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _mineTitleLabel;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(130), 0, kCurrentWidth(100), kCurrentWidth(55))];
        _numberLabel.font = kSystem(kCurrentWidth(14));
        _numberLabel.textColor = kLBSixColor;
        _numberLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numberLabel;
}

- (UIView *)content {
    if (!_content) {
        _content = [[UIView alloc] initWithFrame:CGRectMake(self.mineTitleLabel.right, 0, kCurrentWidth(100), kCurrentWidth(55))];
        _content.backgroundColor = kWhiteColor;
    }
    return _content;
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
