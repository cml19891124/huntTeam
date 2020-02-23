//
//  AccountVoteCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountVoteCell.h"

@interface AccountVoteCell ()

@property (nonatomic,strong)UIImageView *schoolImageView;
@property (nonatomic,strong)PostionLabel *timeLabel;
@property (nonatomic,strong)NameLabel *titleLabel;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UIButton *voteButton;

@end

@implementation AccountVoteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createSubViews];
    }
    return self;
}

- (void)voteButtonClick {
    if (!_voteButton.selected) {
        if (_voteButtonBlock) {
            _voteButtonBlock(_model);
        }
    }
}

- (void)setModel:(Comment *)model {
    _model = model;
    
    [_schoolImageView sd_setImageWithURL:[NSURL URLWithString:model.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    [_titleLabel setNameString:model.userName showIcon:model.isBasic];
    
    CGFloat nameW = BoundWithSize(model.userName, SCREEN_WIDTH, 14).size.width;

    _titleLabel.width = model.isOccupation.intValue == 1?nameW:nameW - 12;
    
    _messageLabel.text = model.comment;
    [_voteButton setTitle:[NSString stringWithFormat:@"%d",[model.num intValue]] forState:UIControlStateNormal];
    CGSize size = [model.comment sizeWithFont:kSystem(13) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(87), MAXFLOAT)];
    _messageLabel.height = size.height;
    NSString *positon = [NSString stringWithFormat:@"%@%@",model.company?:@"",model.position?:@""];
    CGFloat postionW = BoundWithSize(positon, kDeviceWidth, 13).size.width+ 50;
    if (!IsStrEmpty(model.company) && !IsNilOrNull(model.position)) {
        if (![model.isOccupation isEqualToString:@"0"]) {
            _timeLabel.labelWidth = _timeLabel.width = postionW;

        }else{
            _timeLabel.labelWidth = kDeviceWidth-_titleLabel.right-kCurrentWidth(45);
        }
        _timeLabel.left = _titleLabel.right+kCurrentWidth(25);
        [_timeLabel setCompany:nil postion:[NSString stringWithFormat:@" | %@%@", model.company,model.position] showIcon:model.isOccupation];
        _timeLabel.width = postionW+5;
        _timeLabel.hidden = NO;
    }
    else {
        _timeLabel.hidden = YES;
    }
    
    if ([model.commentIsRecord intValue] == 0) {
        _voteButton.selected = NO;
    }
    else {
        _voteButton.selected = YES;
    }
    self.height = _messageLabel.bottom+kCurrentWidth(10);

}

- (CGFloat)cellHeight {
    return self.height;
}

- (void)enterAccountEvent {
    if (_accountButtonBlock) {
        _accountButtonBlock(self.model);
    }
}

- (void)createSubViews {
    
    _schoolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(15), kCurrentWidth(40), kCurrentWidth(40))];
    _schoolImageView.image = [UIImage imageNamed:@"no_headIcon"];
    _schoolImageView.layer.cornerRadius = kCurrentWidth(20);
    _schoolImageView.layer.masksToBounds = YES;
    _schoolImageView.userInteractionEnabled = YES;
    [_schoolImageView setContentScaleFactor:[[UIScreen mainScreen]scale]];
    _schoolImageView.contentMode = UIViewContentModeScaleAspectFill;
    _schoolImageView.autoresizingMask = UIViewAutoresizingNone;
    [self.contentView addSubview:_schoolImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterAccountEvent)];
    [_schoolImageView addGestureRecognizer:tap];
    
    _titleLabel = [[NameLabel alloc] initWithFrame:CGRectMake(kCurrentWidth(10)+_schoolImageView.right, _schoolImageView.top-kCurrentWidth(1), kCurrentWidth(50), kCurrentWidth(16))];
    [self.contentView addSubview:_titleLabel];
    
    _timeLabel = [[PostionLabel alloc] initWithFrame:CGRectMake(_titleLabel.right, _titleLabel.top, kCurrentWidth(150), kCurrentWidth(16))];
    _timeLabel.font = kSystem(13);
    _timeLabel.color = kLBNineColor;
    [self.contentView addSubview:_timeLabel];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(10)+_schoolImageView.right, _timeLabel.bottom+kCurrentWidth(8), kDeviceWidth-kCurrentWidth(87), 0)];
    _messageLabel.font = kSystem(13);
    _messageLabel.textColor = kLBBlackColor;
    _messageLabel.numberOfLines = 0;
    [self.contentView addSubview:_messageLabel];
    
    _voteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _voteButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(62), _titleLabel.top, kCurrentWidth(50), kCurrentWidth(16));
    [_voteButton setTitle:@"0" forState:UIControlStateNormal];
    [_voteButton setImage:[UIImage imageNamed:@"btn_dianzan"] forState:UIControlStateNormal];
    [_voteButton setImage:[UIImage imageNamed:@"icon_dianzan_sel"] forState:UIControlStateSelected];
    _voteButton.titleLabel.font = kSystem(12);
    [_voteButton setTitleColor:kLBNineColor forState:UIControlStateNormal];
    _voteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _voteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kCurrentWidth(5));
    [_voteButton addTarget:self action:@selector(voteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_voteButton];
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
