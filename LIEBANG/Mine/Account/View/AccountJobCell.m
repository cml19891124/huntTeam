//
//  AccountJobCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountJobCell.h"
#import "CertiService.h"

@interface AccountJobCell ()

@property (nonatomic,strong)UIImageView *schoolImageView;

@property (nonatomic,strong)UIImageView *markImageView;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *messageLabel;

@property (nonatomic,strong)UIButton *editButton;
@property (nonatomic,strong)UIButton *confimButton;

@end

@implementation AccountJobCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self createSubViews];
    }
    return self;
}

- (void)setModel:(WorkModel *)model {
    _model = model;
    
    if (IsNilOrNull(model))
    {
        self.jobState = AccountJobCellStateStateDisable;
        self.height = _titleLabel.bottom+kCurrentWidth(15);
    }
    else
    {
        if (_jobState == AccountJobCellStateStateEdit)
        {
            if ([model.status intValue] == 2 || [model.status intValue] == 3 || [model.status intValue] == 0 || [model.status intValue] == 4)
            {
                _confimButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(56), _titleLabel.bottom - kCurrentWidth(25), kCurrentWidth(44), kCurrentWidth(20));
                _editButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(54)-kCurrentWidth(56),_titleLabel.bottom - kCurrentWidth(25), kCurrentWidth(44), kCurrentWidth(20));
//                _confimButton.hidden = YES;
                _markImageView.hidden = YES;
                
            }
            else
            {
                _confimButton.hidden = YES;
                _markImageView.hidden = NO;
                _markImageView.frame = CGRectMake(_titleLabel.right+kCurrentWidth(5), _titleLabel.top+(kCurrentWidth(16)-14)/2, 21, 14);

                _editButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(56), kCurrentWidth(10), kCurrentWidth(44), kCurrentWidth(20));
            }
        }
        else if (_jobState != AccountJobCellStateStateBackGround)
        {
            self.jobState = AccountJobCellStateStateNormal;
        }

        [_schoolImageView sd_setImageWithURL:[NSURL URLWithString:model.comLogo] placeholderImage:[UIImage imageNamed:@"icon_liebang"]];
        _titleLabel.text = model.company;
        _timeLabel.text = [NSString stringWithFormat:@"%@-%@,%@",[LBForProject conversionDate2:model.beginTime],[LBForProject conversionDate2:model.endTime],model.position];
        _messageLabel.text = model.describeInfo;
        
        if (_jobState == AccountJobCellStateStateBackGround)
        {
            CGSize size = [model.describeInfo sizeWithFont:kSystem(13) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(75), MAXFLOAT)];
            _messageLabel.width = kDeviceWidth-kCurrentWidth(75);
//            if (size.height >= 55) {
//                _messageLabel.height = 55;
//            }else{
                _messageLabel.height = size.height;
//            }
            _messageLabel.numberOfLines = 0;
            self.height = _messageLabel.bottom+kCurrentWidth(15);

        }
        else
        {
            CGSize size = [model.describeInfo sizeWithFont:kSystem(13) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(115), MAXFLOAT)];
            _messageLabel.width = kDeviceWidth-kCurrentWidth(108);
            if (size.height >= 55) {
                _messageLabel.height = 55;
                self.height = _messageLabel.bottom+kCurrentWidth(15);

            }else{
                _messageLabel.height = size.height;
                self.height = _messageLabel.bottom+kCurrentWidth(15);

            }
        }
        
        if (_messageLabel.text.length == 0) {
            _messageLabel.hidden = YES;
            self.height = _timeLabel.bottom+kCurrentWidth(15);
        }else{
            _messageLabel.hidden = NO;
            self.height = _messageLabel.bottom+kCurrentWidth(15);
        }
        if (_jobState == AccountJobCellStateStateBackGround || _jobState == AccountJobCellStateStateNormal)
        {
            CGSize size1 = [model.company sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(60), kCurrentWidth(16))];
            _titleLabel.width = size1.width;
            _titleLabel.height = size1.height;
            _messageLabel.numberOfLines = 0;
            self.height = _messageLabel.bottom+kCurrentWidth(15);
            if (_messageLabel.text.length == 0) {
                _messageLabel.hidden = YES;
                self.height = _timeLabel.bottom+kCurrentWidth(15);
            }else{
                _messageLabel.hidden = NO;
                self.height = _messageLabel.bottom+kCurrentWidth(15);
            }
        }
        else
        {//已认证情况，有编辑 无认证按钮 有认证图标  -  默认进来和编辑信息后
            CGSize size1 = [model.company sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(108), kCurrentWidth(16))];
            if (size1.width > kDeviceWidth - kCurrentWidth(108) - _schoolImageView.width) {
                _titleLabel.width = size1.width - kCurrentWidth(25);
            }else{
                _titleLabel.width = size1.width;
            }
        }
        
        if ([model.status intValue] == 1) {
            CGSize size1 = [model.company sizeWithFont:kSystem(14) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(108), kCurrentWidth(16))];

            _markImageView.hidden = NO;
            _markImageView.frame = CGRectMake(_titleLabel.right+kCurrentWidth(5), _titleLabel.top +2, 21, 14);
            _titleLabel.width = size1.width;
        }
        else {
            _markImageView.hidden = YES;
        }
        _markImageView.left = _titleLabel.right+kCurrentWidth(5);
    }
}

- (void)setJobState:(AccountJobCellState)jobState {
    _jobState = jobState;
    
    switch (jobState) {
        case AccountJobCellStateStateNormal:
        {
            _confimButton.hidden = YES;
            _editButton.hidden = YES;
            _schoolImageView.hidden = NO;
            _timeLabel.hidden = NO;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            CGSize size1 = [_model.company sizeWithFont:kSystem(14) maxSize:CGSizeMake(kDeviceWidth-_schoolImageView.width, kCurrentWidth(16))];

            _titleLabel.frame = CGRectMake(kCurrentWidth(10)+_schoolImageView.right, _schoolImageView.top,size1.width - kCurrentWidth(20), kCurrentWidth(16));
            _titleLabel.textAlignment = NSTextAlignmentLeft;
            _messageLabel.numberOfLines = 3;
        }
            break;
        case AccountJobCellStateStateEdit:
        {
            _confimButton.hidden = NO;
            _editButton.hidden = NO;
            _schoolImageView.hidden = NO;
            _timeLabel.hidden = NO;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            _titleLabel.frame = CGRectMake(kCurrentWidth(10)+_schoolImageView.right, _schoolImageView.top, kDeviceWidth-kCurrentWidth(108) - kCurrentWidth(60), kCurrentWidth(16));
            _titleLabel.textAlignment = NSTextAlignmentLeft;
            _messageLabel.numberOfLines = 3;
            CGSize size1 = [_model.company sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(108) - kCurrentWidth(60), kCurrentWidth(16))];
            _titleLabel.width = size1.width;
        }
            break;
        case AccountJobCellStateStateDisable:
        {
            _confimButton.hidden = YES;
            _editButton.hidden = YES;
            _schoolImageView.hidden = YES;
            _timeLabel.hidden = YES;
            self.accessoryType = UITableViewCellAccessoryNone;
            _titleLabel.frame = CGRectMake(kCurrentWidth(30), kCurrentWidth(15), kDeviceWidth - kCurrentWidth(60), kCurrentWidth(16));
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _messageLabel.text = @"";
            _titleLabel.text = @"暂无添加工作经历";
            _markImageView.hidden = YES;
        }
            break;
        case AccountJobCellStateStateBackGround:
        {//查看资料状态
            _confimButton.hidden = YES;
            _editButton.hidden = YES;
            _schoolImageView.hidden = NO;
            _timeLabel.hidden = NO;
            self.accessoryType = UITableViewCellAccessoryNone;
            _titleLabel.frame = CGRectMake(kCurrentWidth(10)+_schoolImageView.right, _schoolImageView.top, kDeviceWidth - kCurrentWidth(60), kCurrentWidth(16));
            _titleLabel.textAlignment = NSTextAlignmentLeft;
            _messageLabel.numberOfLines = 0;
            self.height = _messageLabel.bottom+kCurrentWidth(15);

        }
            break;
        default:
            break;
    }
}

- (CGFloat)getHeight {
    return self.height;
}

- (void)createSubViews {
    
    _schoolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(13), kCurrentWidth(20), kCurrentWidth(40), kCurrentWidth(40))];
    _schoolImageView.image = [UIImage imageNamed:@"icon_liebang"];
    _schoolImageView.layer.cornerRadius = kCurrentWidth(20);
    [_schoolImageView setContentScaleFactor:[[UIScreen mainScreen]scale]];
    _schoolImageView.contentMode = UIViewContentModeScaleAspectFill;
    _schoolImageView.autoresizingMask = UIViewAutoresizingNone;
    _schoolImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_schoolImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(10)+_schoolImageView.right,kCurrentWidth(23), kDeviceWidth-kCurrentWidth(108), kCurrentWidth(16))];
    _titleLabel.font = kSystem(14);
    _titleLabel.textColor = kLBBlackColor;
    _titleLabel.text = @"猎帮";
    [self.contentView addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(10)+_schoolImageView.right, _titleLabel.bottom-2, kDeviceWidth-kCurrentWidth(108), kCurrentWidth(22))];
    _timeLabel.font = kSystem(13);
    _timeLabel.textColor = kLBNineColor;
//    _timeLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_timeLabel];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(10)+_schoolImageView.right, _timeLabel.bottom, kDeviceWidth-kCurrentWidth(60), kCurrentWidth(55))];
    _messageLabel.font = kSystem(13);
    _messageLabel.textColor = kLBBlackColor;
    _messageLabel.numberOfLines = 3;
    [self.contentView addSubview:_messageLabel];
    
    _confimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confimButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(56), _titleLabel.bottom, kCurrentWidth(44), kCurrentWidth(20));
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
    
    _markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.right+kCurrentWidth(5), _titleLabel.top+(kCurrentWidth(16)-14)/2, 21, 14)];
    _markImageView.image = [UIImage imageNamed:@"icon_bianqian"];
    _markImageView.hidden = YES;
    _markImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(renzhenTap:)];
    [_markImageView addGestureRecognizer:tap];
    [self.contentView addSubview:_markImageView];
}

- (void)renzhenTap:(UITapGestureRecognizer*)tap {
    
    [CertiService getUserMosaicImageWithType:@"1" Uid:self.model.id success:^(id info) {
        NSString *visitingImagemosaic = [info objectForKey:@"visitingImagemosaic"];
        NSString *certificateImagemosaic = [info objectForKey:@"certificateImagemosaic"];
        NSString *licenseImagemosaic = [info objectForKey:@"licenseImagemosaic"];
        NSString *workCardImagemosaic = [info objectForKey:@"workCardImagemosaic"];
        if (!IsStrEmpty(visitingImagemosaic)) {
            if (self.GetWorkCertiImageViewBlock) {
                self.GetWorkCertiImageViewBlock(visitingImagemosaic);
            }
        }
        if (!IsStrEmpty(certificateImagemosaic)) {
            if (self.GetWorkCertiImageViewBlock) {
                self.GetWorkCertiImageViewBlock(certificateImagemosaic);
            }
        }
        if (!IsStrEmpty(licenseImagemosaic)) {
            if (self.GetWorkCertiImageViewBlock) {
                self.GetWorkCertiImageViewBlock(licenseImagemosaic);
            }
        }
        if (!IsStrEmpty(workCardImagemosaic)) {
            if (self.GetWorkCertiImageViewBlock) {
                self.GetWorkCertiImageViewBlock(workCardImagemosaic);
            }
        }
    } failure:^(NSUInteger code, NSString *errorStr) {
        
    }];
}

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
