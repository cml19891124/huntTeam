//
//  AddThemeCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/28.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AddThemeCell.h"

@interface AddThemeCell ()

@property (nonatomic,strong)UIButton *addButton;
@property (nonatomic,strong)UIImageView *addImageView;

@end

@implementation AddThemeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kWhiteColor;
        [self.contentView addSubview:self.addImageView];
        [self.contentView addSubview:self.addButton];
    }
    return self;
}

- (UIImageView *)addImageView {
    if (!_addImageView) {
        _addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, (kCurrentWidth(44)-13)/2, 13, 13)];
        _addImageView.image = [UIImage imageNamed:@"btn_tianjiahuati"];
    }
    return _addImageView;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(self.addImageView.right+10, 0, kCurrentWidth(200), kCurrentWidth(44));
        [_addButton setTitle:@"添加话题" forState:UIControlStateNormal];
        [_addButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        _addButton.titleLabel.font = kSystem(15);
        _addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
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
