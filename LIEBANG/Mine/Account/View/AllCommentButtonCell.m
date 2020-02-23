//
//  AllCommentButtonCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AllCommentButtonCell.h"

@interface AllCommentButtonCell ()

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIButton *addButton;

@end

@implementation AllCommentButtonCell

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

- (void)setAccountInfo:(AccountInfo *)accountInfo {
    _accountInfo = accountInfo;
    
    [_addButton setTitle:[NSString stringWithFormat:@"全部%zd个点评",accountInfo.Comment.count] forState:UIControlStateNormal];
    [_addButton setTitle:@"收起点评" forState:UIControlStateSelected];
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
        _addButton.frame = CGRectMake((kDeviceWidth-kCurrentWidth(140))/2, kCurrentWidth(15), kCurrentWidth(140), kCurrentWidth(36));
        [_addButton setTitle:@"全部0个点评" forState:UIControlStateNormal];
        [_addButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
        _addButton.titleLabel.font = kSystem(15);
        _addButton.layer.cornerRadius = kCurrentWidth(18);
        _addButton.layer.masksToBounds = YES;
        _addButton.layer.borderColor = kLBRedColor.CGColor;
        _addButton.layer.borderWidth = 0.5;
        [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (void)addButtonClick {
    
    _addButton.selected = !_addButton.selected;
    if (_editButtonBlock) {
        _editButtonBlock(_addButton.selected);
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
