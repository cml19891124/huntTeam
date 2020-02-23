//
//  AccountHeadView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountHeadView.h"
#import "AccountSelectView.h"

#import "UIColor+Hex.h"

#import "UILabel+YFAdd.h"

@interface AccountHeadView ()

@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong)UILabel *messageLabel;

@property (nonatomic,strong)UIImageView *headIcon;
@property (nonatomic,strong)UIImageView *jobImageView;
@property (nonatomic,strong)NameLabel *nameLabel;

@property (nonatomic,strong)UIImageView *nameIdentifyIcon;

@property (nonatomic,strong)PostionLabel *careerLabel;

/**
 职位认证
 */
@property (nonatomic,strong) UIImageView *IdentifyIcon;

@property (nonatomic,strong)UILabel *tradeLabel;
@property (nonatomic,strong)UIButton *phoneLabel;

@property (nonatomic,strong) UIImageView *emailImage;

@property (nonatomic,strong)UIButton *emailLabel;

@property (nonatomic,strong) UIImageView *addressiImage;

@property (nonatomic,strong)AccountSelectView *selectView;

@property (nonatomic,strong)UIButton *editButton;
@property (nonatomic,strong)UIButton *confimButton;

@property (strong, nonatomic) UIView *bgview;
@end

@implementation AccountHeadView

- (void)initView
{
    self.backgroundColor = kWhiteColor;
    [self createSubViews];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self createSubViewsMasonry];
}
- (void)setAccountInfo:(AccountInfo *)accountInfo {
    _accountInfo = accountInfo;
    
    if (_accountState == AccountStateDisabled) {
        _backView.hidden = YES;
        self.backView.hidden = YES;
        self.contentView.hidden = YES;
        
        return;
    }
    _careerLabel.userUid = accountInfo.userUid?accountInfo.userUid:@"未编辑";
    _nameLabel.userUid = accountInfo.userUid?accountInfo.userUid:@"未编辑";
    
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:accountInfo.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];


    [self.nameLabel setNameString:accountInfo.userName showIcon:accountInfo.isBasic];
    if (accountInfo.company.length == 0 && accountInfo.position.length == 0) {
        [_careerLabel setCompany:@"" postion:@"未完善公司和职位信息" showIcon:accountInfo.isOccupationOne];
    }else{
        [_careerLabel setCompany:@"" postion:[NSString stringWithFormat:@"%@%@",accountInfo.company, accountInfo.position] showIcon:accountInfo.isOccupationOne];
    }

    _careerLabel.left = self.headIcon.right+kCurrentWidth(10);
    [_jobImageView sd_setImageWithURL:[NSURL URLWithString:accountInfo.comLogo] placeholderImage:[UIImage imageNamed:@"icon_liebang"]];
    
    NSMutableArray *titleArray = [NSMutableArray array];
    NSMutableArray *otherArray = [NSMutableArray array];
    for (UserClassify *model in accountInfo.UserClassify) {
        if (!IsStrEmpty(model.classify) && !IsNilOrNull(model.classify)) {
            [titleArray addObject:model.classify];
        }
    }
    NSString *classifyString = [titleArray componentsJoinedByString:@" "];
    
    if (!IsStrEmpty(accountInfo.userIndustry) && !IsNilOrNull(accountInfo.userIndustry)) {
        [otherArray addObject:accountInfo.userIndustry];
    }
    if (!IsStrEmpty(classifyString) && !IsNilOrNull(classifyString)) {
        [otherArray addObject:classifyString];
    }
    [otherArray addObject:[NSString stringWithFormat:@"影响力 %d",[accountInfo.effectScore intValue]]];
    _tradeLabel.text = [otherArray componentsJoinedByString:@" | "];
    CGSize size = [_tradeLabel.text sizeWithFont:kSystem(12) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(120), MAXFLOAT)];
//    _tradeLabel.height = size.height;
//    [self.tradeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        [make.height.mas_equalTo(size.height) priorityHigh];
//    }];
    
    if (IsStrEmpty(accountInfo.phone)) {
        _phoneLabel.hidden = YES;
    }
    else {
        _phoneLabel.hidden = NO;
        [_phoneLabel setTitle:[NSString stringWithFormat:@"%@",IsStrEmpty(accountInfo.phone)?@"未编辑":accountInfo.phone] forState:UIControlStateNormal];
    }
    
    [_emailLabel setTitle:[NSString stringWithFormat:@"%@",IsStrEmpty(accountInfo.userEmail)?@"未编辑":accountInfo.userEmail] forState:UIControlStateNormal];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",IsStrEmpty(accountInfo.userWorkAddress)?@"":accountInfo.userWorkAddress,IsStrEmpty(accountInfo.userDetailAddress)?@"":accountInfo.userDetailAddress];

    [_addressLabel setText:[NSString stringWithFormat:@"%@",IsStrEmpty(string)?@"未编辑":string]];
    CGSize addressSize = [_addressLabel.text sizeWithFont:kSystem(12) maxSize:CGSizeMake(kDeviceWidth - kCurrentWidth(130), CGFLOAT_MAX)];
    [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(addressSize.height);
    }];
    
    if (_accountState == AccountStateDisabled) {
        _messageLabel.text = @"该用户已被封禁";
    }
    else {
        
        NSString *selectText = [NSString stringWithFormat:@"%@人喜欢，帮助过%@人",accountInfo.likeNum,accountInfo.helpNum];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:selectText];
        [attr addAttribute:NSForegroundColorAttributeName
                     value:kLBRedColor
                     range:[selectText rangeOfString:accountInfo.likeNum]];
        [attr addAttribute:NSForegroundColorAttributeName
                     value:kLBRedColor
                     range:[selectText rangeOfString:accountInfo.helpNum]];
        
        _messageLabel.attributedText = attr;
    }
    
    if (_accountState == AccountStateEdit)
    {
        if ([accountInfo.isBasic intValue] == 0)
        {
//            _confimButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(66), kCurrentWidth(24), kCurrentWidth(44), kCurrentWidth(20));
//            _editButton.frame = CGRectMake(_confimButton.left-kCurrentWidth(54), kCurrentWidth(24), kCurrentWidth(44), kCurrentWidth(20));
            _confimButton.hidden = NO;
        }
        else
        {
            _confimButton.hidden = YES;
//            _editButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(66), kCurrentWidth(24), kCurrentWidth(44), kCurrentWidth(20));
            [_confimButton mas_updateConstraints:^(MASConstraintMaker *make) {
                [make.width uninstall];
                [make.right uninstall];
                make.width.mas_equalTo(0);
                make.right.mas_equalTo(0);

            }];
            [_editButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(kCurrentWidth(-10));
                make.width.mas_equalTo(kCurrentWidth(44));
                make.height.mas_equalTo(20);
                make.top.mas_equalTo(kCurrentWidth(16));
            }];
        }
    }

    if (_accountState == AccountStateOther)
    {
        
        if ([accountInfo.phonePrivacy integerValue] == 1) {
            _phoneLabel.hidden = NO;
        }
        else {
            _phoneLabel.hidden = YES;
        }
    }
    else if (_accountState == AccountStateDisabled)
    {
        _phoneLabel.hidden = YES;
    }
    else
    {
        _phoneLabel.hidden = NO;
    }
}

- (void)setAccountState:(AccountState)accountState {
    _accountState = accountState;
    _selectView.accountState = _accountState;
    
    if (accountState == AccountStateDisabled)
    {
        _selectView.hidden = YES;
        _messageLabel.text = @"该用户已被封禁";
        _messageLabel.textColor = kLBNineColor;
    }
    else if (accountState == AccountStateNormal)
    {
        
    }
    else if (accountState == AccountStateOther)
    {

    }
    else if (accountState == AccountStateEdit)
    {
        _editButton.hidden = NO;
        _confimButton.hidden = NO;
    }
}

- (void)createSubViews {
    
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = kLBRedColor;
    [self addSubview:_backView];
    //名片背景图
    _contentView = [[UIView alloc] init];
    _contentView.layer.cornerRadius =  5;
    _contentView.backgroundColor = kWhiteColor;
    _contentView.layer.shadowColor = kLBSixColor.CGColor;
    _contentView.layer.shadowOpacity = 0.3f;
    _contentView.layer.shadowOffset = CGSizeMake(0, 0);
    _contentView.layer.shadowRadius = 18.0f;
    [self addSubview:_contentView];
    //互动提示label
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.font = kSystem(13);
    _messageLabel.textColor = kLBSixColor;
    _messageLabel.text = @"0人喜欢，帮助过0人";
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_messageLabel];
    //名片中头像
    _headIcon = [[UIImageView alloc] init];
    _headIcon.image = [UIImage imageNamed:@"no_headIcon"];
    _headIcon.layer.cornerRadius = 28;
    _headIcon.layer.masksToBounds = YES;
    [_headIcon setContentScaleFactor:[[UIScreen mainScreen]scale]];
    _headIcon.contentMode = UIViewContentModeScaleAspectFill;
    _headIcon.autoresizingMask = UIViewAutoresizingNone;
    _headIcon.userInteractionEnabled = YES;
    [_contentView addSubview:_headIcon];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterAccountEvent)];
    [_headIcon addGestureRecognizer:tap];
    //名片卡中右下角icon
    _jobImageView = [[UIImageView alloc] init];
    _jobImageView.image = [UIImage imageNamed:@"icon_liebang"];
    _jobImageView.layer.cornerRadius = 8;
    _jobImageView.layer.masksToBounds = YES;
    [_jobImageView setContentScaleFactor:[[UIScreen mainScreen]scale]];
    _jobImageView.contentMode = UIViewContentModeScaleAspectFill;
    _jobImageView.autoresizingMask = UIViewAutoresizingNone;
    _jobImageView.userInteractionEnabled = YES;
    [_contentView addSubview:_jobImageView];
    
    UITapGestureRecognizer *jobTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterCompanyEvent)];
    [_jobImageView addGestureRecognizer:jobTap];
    
    _emailLabel = [UIButton buttonWithType:UIButtonTypeCustom];
//    _emailLabel.frame = CGRectMake(kCurrentWidth(27), _jobImageView.top+kCurrentWidth(5), kDeviceWidth-kCurrentWidth(110), kCurrentWidth(18));
    _emailLabel.titleLabel.font = kSystem(12);
    [_emailLabel setTitle:@"未编辑" forState:UIControlStateNormal];
    [_emailLabel setTitleColor:kLBSixColor forState:UIControlStateNormal];
    [_emailLabel setImage:[UIImage imageNamed:@"icon_email"] forState:UIControlStateNormal];
    _emailLabel.adjustsImageWhenHighlighted = NO;
    _emailLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _emailLabel.titleEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(10), 0, 0);
    [_contentView addSubview:_emailLabel];
    
    _phoneLabel = [UIButton buttonWithType:UIButtonTypeCustom];
//    _phoneLabel.frame = CGRectMake(kCurrentWidth(27), _emailLabel.top-kCurrentWidth(18), kDeviceWidth-kCurrentWidth(110), kCurrentWidth(18));
    _phoneLabel.titleLabel.font = kSystem(12);
    [_phoneLabel setTitle:@"未编辑" forState:UIControlStateNormal];
    [_phoneLabel setTitleColor:kLBSixColor forState:UIControlStateNormal];
    [_phoneLabel setImage:[UIImage imageNamed:@"icon_call_normal"] forState:UIControlStateNormal];
    _phoneLabel.adjustsImageWhenHighlighted = NO;
    _phoneLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _phoneLabel.titleEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(10), 0, 0);
    [_contentView addSubview:_phoneLabel];
    
    _addressiImage = UIImageView.new;
    _addressiImage.image = IMAGE_NAMED(@"icon_dizhi");
    [_contentView addSubview:_addressiImage];

    _addressLabel = [UILabel new];
    _addressLabel.font = kSystem(12);
    _addressLabel.text = @"未编辑";
    _addressLabel.textColor = kLBSixColor;
    _addressLabel.numberOfLines = 3;
//    _addressLabel.yf_contentInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    [_contentView addSubview:_addressLabel];
    
    WeakSelf;
    _nameLabel = [[NameLabel alloc] init];
    _nameLabel.height = 20;
    [_nameLabel setNameString:@"猎帮" showIcon:@"0"];
    _nameLabel.GetBasicCertiImageViewBlock = ^(NSString *imageUrl) {
        if (weakSelf.GetBasicSourceBlock) {
            weakSelf.GetBasicSourceBlock(imageUrl);
        }
    };
    [_contentView addSubview:_nameLabel];

    _careerLabel = [[PostionLabel alloc] init];
    _careerLabel.color = kLBSixColor;
    _careerLabel.font = kSystem(13);
    [_careerLabel setCompany:nil postion:@"未编辑" showIcon:@"0"];
    _careerLabel.GetWorkCertiImageViewBlock = ^(NSString *imageUrl) {
        if (weakSelf.GetWorkSourceBlock) {
            weakSelf.GetWorkSourceBlock(imageUrl);
        }
    };
    [_contentView addSubview:_careerLabel];
    
    _tradeLabel = [[UILabel alloc] init];
    _tradeLabel.text = @"影响力 0";
    _tradeLabel.textColor = kLBSixColor;
    _tradeLabel.font = kSystem(12);
    _tradeLabel.numberOfLines = 2;
    [_contentView addSubview:_tradeLabel];
    
    _selectView = [[AccountSelectView alloc] initWithFrame:CGRectMake(0, _messageLabel.bottom, kDeviceWidth, kCurrentWidth(64.5))];
    _selectView.selectViewButtonBlock = ^(NSInteger index) {
        if (weakSelf.headButtonBlock) {
            weakSelf.headButtonBlock(index);
        }
    };
    [self addSubview:_selectView];
    
    _confimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confimButton setTitle:@"认证" forState:UIControlStateNormal];
    [_confimButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
    _confimButton.layer.cornerRadius = kCurrentWidth(10);
    _confimButton.layer.borderColor = kLBRedColor.CGColor;
    _confimButton.layer.borderWidth = 0.5;
    _confimButton.layer.masksToBounds = YES;
    _confimButton.titleLabel.font = kSystem(13);
    _confimButton.hidden = YES;
    [_confimButton addTarget:self action:@selector(confimButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_confimButton];
    
    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
    _editButton.layer.cornerRadius = kCurrentWidth(10);
    _editButton.layer.borderColor = kLBRedColor.CGColor;
    _editButton.layer.borderWidth = 0.5;
    _editButton.layer.masksToBounds = YES;
    _editButton.titleLabel.font = kSystem(13);
    _editButton.hidden = YES;
    [_editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_editButton];
    
    UIView *bgview = [[UIView alloc] init];
    bgview.backgroundColor = [UIColor colorWithHexString:@"C4C4C4"];
    bgview.alpha = 0.5;
    self.bgview = bgview;
    [self addSubview:bgview];
    
}

- (void)createSubViewsMasonry
{
    //蓝色背景图
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(kCurrentWidth(126)+kNavBarHeight);
    }];
    //子控件父视图
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kCurrentWidth(16));
        make.right.mas_equalTo(kCurrentWidth(-16));
        make.top.mas_equalTo(kNavBarHeight);
    }];
    
    [_confimButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kCurrentWidth(-16));
        make.width.mas_equalTo(kCurrentWidth(44));
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(kCurrentWidth(16));
    }];
    
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.confimButton.mas_left).offset(kCurrentWidth(-10));
        make.width.mas_equalTo(kCurrentWidth(44));
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(kCurrentWidth(16));
    }];
    
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kCurrentWidth(16));
        make.top.mas_equalTo(kCurrentWidth(16));
        make.width.mas_equalTo(kCurrentWidth(56));
        make.height.mas_equalTo(kCurrentWidth(56));
    }];

     [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.headIcon.mas_right).offset(10);
         make.right.mas_equalTo(self.editButton.mas_left).offset(kCurrentWidth(-10));
         make.top.mas_equalTo(self.headIcon.mas_top);
         make.height.mas_equalTo(20);
     }];
    
     [self.careerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.nameLabel.mas_left);
         [make.height.mas_equalTo(20) priorityHigh];
         make.top.mas_equalTo(self.nameLabel.mas_bottom);
         make.right.mas_equalTo(-28);
     }];
     
     [self.tradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(self.nameLabel.mas_left);
         make.right.mas_equalTo(-20);
         make.top.mas_equalTo(self.careerLabel.mas_bottom);
     }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kCurrentWidth(16));
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.top.mas_equalTo(self.tradeLabel.mas_bottom).offset(20);
    }];
    
    [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kCurrentWidth(16));
        make.top.mas_equalTo(self.phoneLabel.mas_bottom).offset(-2);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(25);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.addressiImage.mas_right).offset(10);
        make.right.mas_equalTo(self.jobImageView.mas_left).offset(-16);
        make.top.mas_equalTo(self.emailLabel.mas_bottom).offset(0);
    }];
    
    [self.addressiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kCurrentWidth(16));
        make.centerY.mas_equalTo(self.addressLabel);
        make.width.mas_equalTo(kCurrentWidth(8));
        make.height.mas_equalTo(20/2);
    }];
    
    [self.jobImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kCurrentWidth(-16));
        make.bottom.mas_equalTo(self.addressLabel.mas_bottom);
        make.height.width.mas_equalTo(kCurrentWidth(44));
    }];

    //帮助过某人
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.contentView.mas_bottom).offset(20);
    }];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self); make.top.mas_equalTo(self.messageLabel.mas_bottom).offset(kCurrentWidth(0));
        make.height.mas_equalTo(kCurrentWidth(64.5));
    }];
    
    [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self);
        make.top.mas_equalTo(self.selectView.mas_bottom).offset(-2);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)confimButtonClick {
    if (_confimButtonBlock) {
        _confimButtonBlock();
    }
}

- (void)editButtonClick {
    if (_editButtonBlock) {
        _editButtonBlock();
    }
}

- (void)enterAccountEvent {
    
    if (IsNilOrNull(self.accountInfo.userHead) || IsStrEmpty(self.accountInfo.userHead)) {
        return;
    }
    if (![self.accountInfo.userHead containsString:@"http"]) {
        return;
    }
    
    if (_accountButtonBlock) {
        _accountButtonBlock(self.accountInfo.userHead);
    }
}

- (void)enterCompanyEvent {
    if (_companyButtonBlock) {
        _companyButtonBlock(self.accountInfo.userUid);
    }
}

@end
