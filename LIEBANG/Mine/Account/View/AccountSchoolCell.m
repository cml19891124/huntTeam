//
//  AccountSchoolCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountSchoolCell.h"
#import "CertiService.h"

@interface AccountSchoolCell ()

@property (nonatomic,strong)UIImageView *schoolImageView;

@property (nonatomic,strong)UIImageView *markImageView;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *messageLabel;

@property (nonatomic,strong)UIButton *editButton;
@property (nonatomic,strong)UIButton *confimButton;

@end

@implementation AccountSchoolCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self createSubViews];
    }
    return self;
}

- (void)setModel:(EducationModel *)model {
    _model = model;
    
    if (IsNilOrNull(model))
    {
        self.schoolState = AccountSchoolCellStateDisable;
    }
    else
    {
        if (_schoolState == AccountSchoolCellStateEdit)
        {
            if ([model.status intValue] == 2 || [model.status intValue] == 3 || [model.status intValue] == 0 || [model.status intValue] == 4)
            {
                _confimButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(56), kCurrentWidth(10), kCurrentWidth(44), kCurrentWidth(20));
                _editButton.frame = CGRectMake(_confimButton.left-kCurrentWidth(54), kCurrentWidth(10), kCurrentWidth(44), kCurrentWidth(20));
                _confimButton.hidden = NO;
                
                CGSize size = [model.schoolName sizeWithFont:kSystem(14) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(160), kCurrentWidth(20))];
                if (size.width > kDeviceWidth-kCurrentWidth(160)) {
                    _titleLabel.width = kDeviceWidth-kCurrentWidth(160);
                }
                else {
                    _titleLabel.width = size.width;
                }
                _markImageView.hidden = YES;
            }
            else
            {
                _confimButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(56), kCurrentWidth(10), kCurrentWidth(44), kCurrentWidth(20));

                _confimButton.hidden = YES;
                if (_confimButton.hidden) {
                    _editButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(56), kCurrentWidth(10), kCurrentWidth(44), kCurrentWidth(20));
                }else{
                    
                }
                
                CGSize size = [model.schoolName sizeWithFont:kSystem(14) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(110), kCurrentWidth(20))];
                if (size.width > kDeviceWidth-kCurrentWidth(110)) {
                    _titleLabel.width = kDeviceWidth-kCurrentWidth(110);
                }
                else {
                    _titleLabel.width = size.width;
                }
                _markImageView.hidden = NO;
            }
        }
        else if (_schoolState != AccountSchoolCellStateBackGround)
        {
            self.schoolState = AccountSchoolCellStateNormal;
            
            CGSize size = [model.schoolName sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(80), kCurrentWidth(20))];
            if (size.width > kDeviceWidth-kCurrentWidth(80)) {
                _titleLabel.width = kDeviceWidth-kCurrentWidth(80);
            }
            else {
                _titleLabel.width = size.width - kCurrentWidth(10);
            }
        }
        else if (_schoolState == AccountSchoolCellStateBackGround)
        {
            self.messageLabel.text = model.eduDescribe;
            
            CGSize size1 = [model.eduDescribe sizeWithFont:kSystem(13) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(75), MAXFLOAT)];
            _messageLabel.height = size1.height;
            self.height = _messageLabel.bottom+kCurrentWidth(15);
            
            CGSize size = [model.schoolName sizeWithFont:kSystem(14) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(80), kCurrentWidth(20))];
            if (size.width > kDeviceWidth-kCurrentWidth(80)) {
                _titleLabel.width = kDeviceWidth-kCurrentWidth(80);
            }
            else {
                _titleLabel.width = size.width;
            }
        }
        
        [_schoolImageView sd_setImageWithURL:[NSURL URLWithString:model.eduLogo] placeholderImage:[UIImage imageNamed:@"icon_liebang"]];
        _titleLabel.text = model.schoolName;
        
        _timeLabel.text = [NSString stringWithFormat:@"%@-%@,%@,%@",[LBForProject conversionDate2:model.beginTime],[LBForProject conversionDate2:model.endTime],model.subjectName,model.diploma];

        if ([model.status intValue] == 1) {
            _markImageView.hidden = NO;
        }
        else {
            _markImageView.hidden = YES;
        }
        CGSize size = [_model.schoolName sizeWithFont:kSystem(14) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(80), kCurrentWidth(20))];
        _titleLabel.width = size.width;
        _markImageView.left = _titleLabel.right+kCurrentWidth(5);
        
    }
}

- (CGFloat)cellHeight {
    return self.height;
}

- (void)setSchoolState:(AccountSchoolCellState)schoolState {
    _schoolState = schoolState;
    
    switch (schoolState) {
        case AccountSchoolCellStateNormal:
        {//默认为个人主页，无任何认证交互按钮 9-22add
            _confimButton.hidden = YES;
            _editButton.hidden = YES;
            _schoolImageView.hidden = NO;
            _timeLabel.hidden = NO;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            _titleLabel.frame = CGRectMake(kCurrentWidth(10)+_schoolImageView.right, _schoolImageView.top, kDeviceWidth-kCurrentWidth(208), kCurrentWidth(20));
            _titleLabel.textAlignment = NSTextAlignmentLeft;
            _titleLabel.font = kSystem(14);
            _messageLabel.hidden = YES;
            CGSize size = [_model.schoolName sizeWithFont:kSystem(14) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(80), kCurrentWidth(20))];
            if (size.width > kDeviceWidth-kCurrentWidth(80)) {
                _titleLabel.width = kDeviceWidth-kCurrentWidth(100);
            }
            else {
                _titleLabel.width = size.width;
            }
        }
            break;
        case AccountSchoolCellStateEdit:
        {
//            _confimButton.hidden = YES;
            _editButton.hidden = NO;
            _schoolImageView.hidden = NO;
            _timeLabel.hidden = NO;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            _titleLabel.frame = CGRectMake(kCurrentWidth(10)+_schoolImageView.right, _schoolImageView.top, kDeviceWidth-kCurrentWidth(208), kCurrentWidth(20));
            _titleLabel.textAlignment = NSTextAlignmentLeft;
            _titleLabel.font = kSystem(14);
            _messageLabel.hidden = YES;
        }
            break;
        case AccountSchoolCellStateDisable:
        {
            _confimButton.hidden = YES;
            _editButton.hidden = YES;
            _schoolImageView.hidden = YES;
            _timeLabel.hidden = YES;
            self.accessoryType = UITableViewCellAccessoryNone;
            _titleLabel.frame = CGRectMake(0, _schoolImageView.top-20, kDeviceWidth, kCurrentWidth(75));
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.text = @"暂无添加教育经历";
            _titleLabel.font = kSystem(14);
            _messageLabel.hidden = YES;
            _markImageView.hidden = YES;

        }
            break;
        case AccountSchoolCellStateBackGround:
        {
            _confimButton.hidden = YES;
            _editButton.hidden = YES;
            _schoolImageView.hidden = NO;
            _timeLabel.hidden = NO;
            self.accessoryType = UITableViewCellAccessoryNone;
            _titleLabel.frame = CGRectMake(kCurrentWidth(10)+_schoolImageView.right, _schoolImageView.top, kDeviceWidth-kCurrentWidth(208), kCurrentWidth(20));
            _titleLabel.textAlignment = NSTextAlignmentLeft;
            _titleLabel.font = kSystem(14);
            _messageLabel.hidden = NO;
            CGSize size = [_model.schoolName sizeWithFont:kSystem(14) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(80), kCurrentWidth(20))];
            if (size.width > kDeviceWidth-kCurrentWidth(80)) {
                _titleLabel.width = kDeviceWidth-kCurrentWidth(80);
            }
            else {
                _titleLabel.width = size.width;
            }
        }
            break;
        default:
            break;
    }
}

- (void)renzhenTap:(UITapGestureRecognizer*)tap {
    
    [CertiService getUserMosaicImageWithType:@"2" Uid:self.model.id success:^(id info) {
        NSString *degreeImagemosaic = [info objectForKey:@"degreeImagemosaic"];
        NSString *diplomaImagemosaic = [info objectForKey:@"diplomaImagemosaic"];
        if (!IsStrEmpty(degreeImagemosaic)) {
            if (self.GetEduCertiImageViewBlock) {
                self.GetEduCertiImageViewBlock(degreeImagemosaic);
            }
        }
        if (!IsStrEmpty(diplomaImagemosaic)) {
            if (self.GetEduCertiImageViewBlock) {
                self.GetEduCertiImageViewBlock(diplomaImagemosaic);
            }
        }
    } failure:^(NSUInteger code, NSString *errorStr) {
        
    }];
}

- (void)createSubViews {
    
    _schoolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(20), kCurrentWidth(40), kCurrentWidth(40))];
    _schoolImageView.image = [UIImage imageNamed:@"icon_liebang"];
    [_schoolImageView setContentScaleFactor:[[UIScreen mainScreen]scale]];
    _schoolImageView.contentMode = UIViewContentModeScaleAspectFill;
    _schoolImageView.autoresizingMask = UIViewAutoresizingNone;
    _schoolImageView.layer.masksToBounds = YES;
    _schoolImageView.layer.cornerRadius = kCurrentWidth(20);
    [self.contentView addSubview:_schoolImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(10)+_schoolImageView.right, _schoolImageView.top, kDeviceWidth-kCurrentWidth(90), kCurrentWidth(20))];
    _titleLabel.font = kSystem(14);
    _titleLabel.textColor = kLBBlackColor;
    [self.contentView addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(10)+_schoolImageView.right, _titleLabel.bottom, kDeviceWidth-kCurrentWidth(90), kCurrentWidth(22))];
    _timeLabel.font = kSystem(13);
    _timeLabel.textColor = kLBNineColor;
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_timeLabel];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(10)+_schoolImageView.right, _timeLabel.bottom+kCurrentWidth(4), kDeviceWidth-kCurrentWidth(75), kCurrentWidth(55))];
    _messageLabel.font = kSystem(13);
    _messageLabel.textColor = kLBBlackColor;
    _messageLabel.numberOfLines = 0;
    [self.contentView addSubview:_messageLabel];
    
    _confimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confimButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(56), kCurrentWidth(10), kCurrentWidth(44), kCurrentWidth(20));
    [_confimButton setTitle:@"认证" forState:UIControlStateNormal];
    [_confimButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
    _confimButton.layer.cornerRadius = kCurrentWidth(10);
    _confimButton.layer.borderColor = kLBRedColor.CGColor;
    _confimButton.layer.borderWidth = 0.5;
    _confimButton.layer.masksToBounds = YES;
    _confimButton.titleLabel.font = kSystem(13);
    _confimButton.hidden = YES;
    [_confimButton addTarget:self action:@selector(confimButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confimButton];
    
    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _editButton.frame = CGRectMake(_confimButton.left-kCurrentWidth(54), kCurrentWidth(10), kCurrentWidth(44), kCurrentWidth(20));
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
    _editButton.layer.cornerRadius = kCurrentWidth(10);
    _editButton.layer.borderColor = kLBRedColor.CGColor;
    _editButton.layer.borderWidth = 0.5;
    _editButton.layer.masksToBounds = YES;
    _editButton.titleLabel.font = kSystem(13);
    _editButton.hidden = YES;
    [_editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_editButton];
    
    _markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.right, _titleLabel.top+kCurrentWidth(7)/2, kCurrentWidth(21), kCurrentWidth(13))];
    _markImageView.image = [UIImage imageNamed:@"icon-xueshimao"];
    _markImageView.hidden = YES;
    _markImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(renzhenTap:)];
    [_markImageView addGestureRecognizer:tap];
    [self.contentView addSubview:_markImageView];
    
//    [self setupSuviewsMasonry];
}
/*
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_schoolImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(40);
        make.left.mas_equalTo(13);
    }];
    
    [_confimButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.width.mas_equalTo(kCurrentWidth(44));
        make.height.mas_equalTo(kCurrentWidth(20));
        make.top.mas_equalTo(10);
    }];
    
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.confimButton.mas_left).offset(-10);
        make.width.mas_equalTo(kCurrentWidth(44));
        make.height.mas_equalTo(kCurrentWidth(20));
        make.top.mas_equalTo(10);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.schoolImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.editButton.mas_left).offset(-10);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom);      make.left.mas_equalTo(self.schoolImageView.mas_right).offset(10);
        make.height.mas_equalTo(22);
        make.right.mas_equalTo(self.editButton.mas_left).offset(-10);
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(5);      make.left.mas_equalTo(self.schoolImageView.mas_right).offset(10);
        make.bottom.mas_equalTo(-18);
        make.right.mas_equalTo(self.editButton.mas_left).offset(-10);
    }];
}*/

#pragma mark Event
- (void)confimButtonClick {
    if (_confimButtonBlock) {
        _confimButtonBlock(_model);
    }
}

- (void)editButtonClick {
    if (_editButtonBlock) {
        _editButtonBlock(_model);
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
