//
//  CommentButtonCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommentButtonCell.h"

@interface CommentButtonCell ()

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIButton *addButton;

@end

@implementation CommentButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kWhiteColor;
        //        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.addButton];
    }
    return self;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(10))];
        _lineView.backgroundColor = kBackgroundColor;
    }
    return _lineView;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake((kDeviceWidth-kCurrentWidth(140))/2, kCurrentWidth(20), kCurrentWidth(140), kCurrentWidth(36));
        [_addButton setTitle:@"我要点评" forState:UIControlStateNormal];
        [_addButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _addButton.titleLabel.font = kSystem(15);
        _addButton.layer.cornerRadius = kCurrentWidth(18);
        _addButton.layer.masksToBounds = YES;
        _addButton.backgroundColor = kLBRedColor;
//        _addButton.titleLabel.numberOfLines = 0;
//        _addButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//        _addButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (void)setAccountInfo:(AccountInfo *)accountInfo {
    _accountInfo = accountInfo;
    
    NSString *string = [NSString stringWithFormat:@"我要点评%@",self.accountInfo.userName];
    CGSize size = [string sizeWithFont:kSystem(15) maxSize:CGSizeMake(MAXFLOAT, kCurrentWidth(36))];
    _addButton.frame = CGRectMake((kDeviceWidth-(kCurrentWidth(20)+size.width))/2, kCurrentWidth(20), kCurrentWidth(20)+size.width, kCurrentWidth(36));
    [_addButton setTitle:string forState:UIControlStateNormal];
}

- (void)addButtonClick {
    if (_editButtonBlock) {
        _editButtonBlock();
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
