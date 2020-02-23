//
//  AccountCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountCell.h"

@interface AccountCell ()

@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *jobImageView;
@property (nonatomic,strong)UIButton *voteButton;

@end

@implementation AccountCell

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self createSubViews];
}

- (void)setAccountInfo:(AccountInfo *)accountInfo {
    _accountInfo = accountInfo;
    
    if (_accountCellState == AccountCellStateJob)//职业标签
    {
        UserClassify *model = [accountInfo.UserClassify safeObjectAtIndex:_indexPath.row];
        _titleLabel.text = model.classify;
        _timeLabel.text = [NSString stringWithFormat:@"%d人认可",[model.acceptNum intValue]];

        [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.jobImageView.mas_left).offset(-10);
        }];
        [_jobImageView sd_setImageWithURL:[NSURL URLWithString:model.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
        CGSize size = [model.classify sizeWithFont:kSystem(13) maxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(size.width + 10);
        }];
        
        if ([accountInfo.userUid isEqualToString:[Config currentConfig].userUid])
        {
            _voteButton.hidden = YES;
            [_jobImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
            }];
        }
        else
        {
            _voteButton.hidden = NO;
            if ([model.classifyIsRecord intValue] == 0) {
                _voteButton.selected = NO;
            }
            else {
                _voteButton.selected = YES;
            }
        }
    }
    else if (_accountCellState == AccountCellStateSource)//更多资料
    {
        if (_indexPath.row == 0)
        {
            _titleLabel.text = @"家乡";
            _timeLabel.text = IsStrEmpty(accountInfo.userHometown)?@"待完善":accountInfo.userHometown;
        }
        else if (_indexPath.row == 1)
        {
            _titleLabel.text = @"生日";
            _timeLabel.text = IsStrEmpty(accountInfo.userBirth)?@"待完善":[self showBirth:accountInfo.userBirth];
        }
        [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-10);
        }];
    }
}

- (NSString *)showBirth:(NSString *)userBirth {
    
    if (userBirth.length == 10) {
        return [userBirth substringFromIndex:5];
    }
    return userBirth;
}

- (void)setAccountCellState:(AccountCellState)accountCellState {
    _accountCellState = accountCellState;
    
    if (accountCellState == AccountCellStateJob)
    {
        self.timeLabel.textColor = kLBNineColor;
        self.timeLabel.font = kSystem(12);
        self.timeLabel.text = @"0人认可";
        _jobImageView.hidden = NO;
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.jobImageView.hidden) {
                make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
                make.top.right.mas_equalTo(0);
                make.height.mas_equalTo(kCurrentWidth(50));
            }else{
                make.right.mas_equalTo(-35);
                make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
                make.height.mas_equalTo(kCurrentWidth(50));
            }
        }];
        
    }else if (accountCellState == AccountCellStateHome)
        {
            self.timeLabel.textColor = kLBNineColor;
            self.timeLabel.font = kSystem(12);
            self.timeLabel.text = @"0人认可";
            _jobImageView.hidden = NO;
            [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
                make.top.right.mas_equalTo(0);
                make.height.mas_equalTo(kCurrentWidth(50));
            }];
        }
    else if (accountCellState == AccountCellStateSource)
    {
        self.timeLabel.textColor = kLBBlackColor;
        self.timeLabel.font = kSystem(14);
        _jobImageView.hidden = YES;
    }
}

- (void)createSubViews {

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = kSystem(13);
    _titleLabel.textColor = kLBBlackColor;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(kCurrentWidth(50));
        make.height.mas_equalTo(kCurrentWidth(44));
    }];
    
    _voteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voteButton setImage:[UIImage imageNamed:@"btn_dianzan"] forState:UIControlStateNormal];
    [_voteButton setImage:[UIImage imageNamed:@"icon_dianzan_sel"] forState:UIControlStateSelected];
    [_voteButton addTarget:self action:@selector(voteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _voteButton.hidden = YES;
    [self.contentView addSubview:_voteButton];
    [_voteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kCurrentWidth(30));
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(kCurrentWidth(50));
    }];
    
    _jobImageView = [[UIImageView alloc] init];
    _jobImageView.image = [UIImage imageNamed:@"no_headIcon"];
    _jobImageView.layer.cornerRadius = kCurrentWidth(10);
    _jobImageView.layer.masksToBounds = YES;
    _jobImageView.hidden = YES;
    [_jobImageView setContentScaleFactor:[[UIScreen mainScreen]scale]];
    _jobImageView.contentMode = UIViewContentModeScaleAspectFill;
    _jobImageView.autoresizingMask = UIViewAutoresizingNone;
    [self.contentView addSubview:_jobImageView];
    [_jobImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kCurrentWidth(20));
        make.top.mas_equalTo(kCurrentWidth(15));
        make.right.mas_equalTo(-35);
    }];
        
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = kSystem(14);
    _timeLabel.textColor = kLBNineColor;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.jobImageView.mas_left).offset(-10);
    }];
}

- (void)voteButtonClick {
    UserClassify *model = [self.accountInfo.UserClassify safeObjectAtIndex:_indexPath.row];
    _voteButton.selected = !_voteButton.selected;
    if (_voteButton.selected) {
        if (_voteButtonBlock) {
            _voteButtonBlock(model);
        }
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
