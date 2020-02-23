
#import "CompanyCell.h"

#import "InsureValidate.h"

@interface CompanyCell ()

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UIView *topInfoView;

@property (strong, nonatomic) UIView *bottomView;

@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UIImageView *companyLogo;
@property (nonatomic,strong)UILabel *companyLabel;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *addressLabel;

/// 人员规模
@property (nonatomic,strong)UILabel *labPersonNum;

/// 行业
@property (nonatomic,strong)UILabel *labIndustry;

@property (nonatomic,strong)UILabel *numberLabel;
@property (nonatomic,strong)UILabel *biaoqianLabel;
@property (nonatomic,strong)UILabel *phoneLabel;
@property (nonatomic,strong)UILabel *webLabel;
@property (nonatomic,strong)UIImageView *markImage;
@property (nonatomic,strong)UIButton *allButton;

@property (nonatomic,strong)UIView *iconContentView;
@property (nonatomic,strong)UILabel *personnelNumLabel;

//已过期，请续费
@property (nonatomic,strong)UIButton *bigDaleyButton;
@property (nonatomic,strong)UIImageView *backContentView;

@property (nonatomic,strong)UIImageView *selectImageView;

//审核
@property (nonatomic,strong)UIButton *certButton;

//海报
@property (nonatomic,strong)UIImageView *headIcon;
@property (nonatomic,strong)NameLabel *nickLabel;
@property (nonatomic,strong)PostionLabel *postionLabel;
@property (nonatomic,strong)UILabel *tipLabel;

@end

@implementation CompanyCell

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupSubviews];
    [self setupSubviewsMasonry];

}

- (void)setupSubviews
{
    _bgView = UIView.new;
    _bgView.layer.borderColor = [UIColor colorWithHexString:@"EDEDED"].CGColor;
    _bgView.layer.borderWidth = 1;
    _bgView.layer.cornerRadius = 15;
    _bgView.layer.masksToBounds = YES;
    _bgView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:_bgView];
    
    _topInfoView = UIView.new;
    _topInfoView.backgroundColor = [UIColor colorWithHexString:@"EDEDED"];
    [_bgView addSubview:_topInfoView];
    
    _bottomView = UIView.new;
    _bottomView.backgroundColor = kWhiteColor;
    [_bgView addSubview:_bottomView];
    
    _companyLogo =[[UIImageView alloc] init];
    _companyLogo.layer.cornerRadius = kCurrentWidth(25);
    _companyLogo.layer.masksToBounds = YES;
    _companyLogo.layer.borderColor = [UIColor colorWithHexString:@"FFFFFF"].CGColor;
    _companyLogo.layer.borderWidth = 5.0f;
    _companyLogo.image = [UIImage imageNamed:@"icon_liebang"];
//    [_companyLogo setContentScaleFactor:[[UIScreen mainScreen]scale]];
    _companyLogo.contentMode = UIViewContentModeScaleAspectFill;
    _companyLogo.clipsToBounds = YES;
    [_topInfoView addSubview:_companyLogo];

    _companyLabel = [[UILabel alloc] init];
    _companyLabel.textColor = kLBBlackColor;
    _companyLabel.font = kSystem(18);
    [_topInfoView addSubview:self.companyLabel];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = kLBBlackColor;
    _nameLabel.font = kSystem(16);
    [_topInfoView addSubview:self.nameLabel];
    
    _markImage = [[UIImageView alloc] init];
    _markImage.image = [UIImage imageNamed:@"icon_company_renzheng"];
    _markImage.hidden = YES;
    [_topInfoView addSubview:self.markImage];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.numberOfLines = 2;
    _addressLabel.textColor = kLBSixColor;
    _addressLabel.font = kSystem(12);
    [_topInfoView addSubview:self.addressLabel];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.textColor = kLBSixColor;
    _numberLabel.font = kSystem(12);
    [_topInfoView addSubview:self.numberLabel];

    _labPersonNum = [[UILabel alloc] init];
    _labPersonNum.numberOfLines = 2;
    _labPersonNum.textColor = kLBSixColor;
    _labPersonNum.font = kSystem(12);
    [_topInfoView addSubview:self.labPersonNum];
    
    _labIndustry = [[UILabel alloc] init];
    _labIndustry.textColor = kLBSixColor;
    _labIndustry.font = kSystem(12);
    [_topInfoView addSubview:_labIndustry];
    
    _phoneLabel = [[UILabel alloc] init];
    _phoneLabel.textColor = kLBSixColor;
    _phoneLabel.font = kSystem(12);
    [_topInfoView addSubview:self.phoneLabel];
    
    _webLabel = [[UILabel alloc] init];
    _webLabel.textColor = kLBSixColor;
    _webLabel.font = kSystem(12);
    [_topInfoView addSubview:self.webLabel];
    
    _daleyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_daleyButton setBackgroundImage:[UIImage imageNamed:@"company_daley"] forState:UIControlStateNormal];
    _daleyButton.hidden = YES;
    [_daleyButton setTitle:@"续费" forState:UIControlStateNormal];
    _daleyButton.titleLabel.font = kSystemBold(12);
    [_daleyButton addTarget:self action:@selector(daleyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:self.daleyButton];
    
    _dayLabel = [[UILabel alloc] init];
    _dayLabel.textColor = [UIColor colorWithHexString:@"A45C00"];
    _dayLabel.font = kSystem(12);
    _dayLabel.adjustsFontSizeToFitWidth = YES;
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:self.dayLabel];
    
    _iconContentView = [[UIView alloc] init];
    _iconContentView.backgroundColor = kWhiteColor;
    [_bottomView addSubview:self.iconContentView];
    
    _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
    _allButton.titleLabel.font = kSystem(14);
    _allButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _allButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_allButton addTarget:self action:@selector(allButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:self.allButton];

    _personnelNumLabel = [[UILabel alloc] init];
    _personnelNumLabel.textColor = kLBNineColor;
    _personnelNumLabel.font = kSystem(12);
    [_bottomView addSubview:self.personnelNumLabel];
    
    _certButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _certButton.frame = CGRectMake(self.backImageView.width-kCurrentWidth(82), kCurrentWidth(128), kCurrentWidth(70), kCurrentWidth(22));
    _certButton.backgroundColor = kWhiteColor;
    _certButton.layer.cornerRadius = kCurrentWidth(11);
    _certButton.layer.masksToBounds = YES;
    [_certButton setTitle:@"未认证" forState:UIControlStateNormal];
    [_certButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
    _certButton.titleLabel.font = kSystem(kCurrentWidth(14));
    [_certButton addTarget:self action:@selector(certButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_topInfoView addSubview:self.certButton];
    
    _backContentView = [[UIImageView alloc] init];
    _backContentView.image = [UIImage imageNamed:@"company_backGround"];
    _backContentView.hidden = YES;
    [self.contentView addSubview:self.backContentView];
    
    _bigDaleyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bigDaleyButton setTitle:@"请续费" forState:UIControlStateNormal];
    [_bigDaleyButton setTitleColor:[UIColor colorWithHexString:@"0082B4"] forState:UIControlStateNormal];
    _bigDaleyButton.titleLabel.font = kSystemBold(18);
    [_bigDaleyButton setImage:[UIImage imageNamed:@"company_big_xufei"] forState:UIControlStateNormal];
    [_bigDaleyButton setImgViewStyle:ButtonImgViewStyleRight imageSize:CGSizeMake(18, 25) space:6];
    [_bigDaleyButton addTarget:self action:@selector(daleyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _bigDaleyButton.hidden = YES;
    [self.contentView addSubview:self.bigDaleyButton];
    
    _headIcon = [[UIImageView alloc] init];
    _headIcon.layer.cornerRadius = kCurrentWidth(20);
    _headIcon.layer.masksToBounds = YES;
    [self.bottomView addSubview:_headIcon];

    _nickLabel = [[NameLabel alloc] init];
    _nickLabel.labelFont = kSystem(14);
    [self.bottomView addSubview:_nickLabel];

    _postionLabel = [[PostionLabel alloc] init];
    _postionLabel.font = kSystem(10);
    _postionLabel.color = kLBSixColor;
    [self.bottomView addSubview:_postionLabel];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.font = kSystem(12);
    _tipLabel.textColor = kLBBlackColor;
    _tipLabel.text = @"推荐您使用猎帮企业AI智能名片";
    _tipLabel.hidden = YES;
    [self.bottomView addSubview:_tipLabel];
}

- (void)setupSubviewsMasonry
{
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kCurrentWidth(10));
        make.bottom.mas_equalTo(kCurrentWidth(-10));
        make.left.mas_equalTo(kCurrentWidth(12));
        make.right.mas_equalTo(kCurrentWidth(-12));
    }];
    
    [_topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topInfoView.mas_bottom);
        make.bottom.mas_equalTo(self.bgView);
    }];
    
    [_companyLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kCurrentWidth(10));
        make.top.mas_equalTo(kCurrentWidth(10));
        make.width.height.mas_equalTo(kCurrentWidth(50));
    }];
    
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kCurrentWidth(65));
        make.top.mas_equalTo(kCurrentWidth(12));
        make.height.mas_equalTo(kCurrentWidth(25));
        make.left.mas_equalTo(kCurrentWidth(15));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-kCurrentWidth(65));
        make.top.mas_equalTo(self.companyLabel.mas_bottom).offset(kCurrentWidth(5));
        make.height.mas_equalTo(kCurrentWidth(22));
        make.left.mas_equalTo(kCurrentWidth(15));
    }];
    
    [_markImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.companyLabel.mas_bottom).offset(kCurrentWidth(11));
        make.height.width.mas_equalTo(kCurrentWidth(12));
        make.left.mas_equalTo(self.nameLabel.mas_right);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kCurrentWidth(1));
        make.left.mas_equalTo(kCurrentWidth(15));
        make.right.mas_equalTo(kCurrentWidth(-15));
    }];

    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.addressLabel.mas_bottom).offset(kCurrentWidth(1));
            make.height.mas_equalTo(kCurrentWidth(17));
            make.left.mas_equalTo(kCurrentWidth(15));
            make.right.mas_equalTo(kCurrentWidth(-15));
        }];
    
    [_labPersonNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.numberLabel.mas_bottom).offset(kCurrentWidth(1));
        make.height.mas_equalTo(kCurrentWidth(17));
        make.left.mas_equalTo(kCurrentWidth(15));
        make.right.mas_equalTo(kCurrentWidth(-15));
    }];
    
    [_labIndustry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labPersonNum.mas_bottom).offset(kCurrentWidth(1));
        make.height.mas_equalTo(kCurrentWidth(17));
        make.left.mas_equalTo(kCurrentWidth(15));
        make.right.mas_equalTo(kCurrentWidth(-15));
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labIndustry.mas_bottom).offset(kCurrentWidth(1));
        make.height.mas_equalTo(kCurrentWidth(17));
        make.left.mas_equalTo(kCurrentWidth(15));
        make.right.mas_equalTo(kCurrentWidth(-15));
    }];
    
    [_webLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneLabel.mas_bottom).offset(kCurrentWidth(1));
        make.height.mas_equalTo(kCurrentWidth(17));
        make.left.mas_equalTo(kCurrentWidth(15));
        make.right.mas_equalTo(kCurrentWidth(-15));
        make.bottom.mas_equalTo(-10);
    }];
    
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kCurrentWidth(10));
        make.height.mas_equalTo(kCurrentWidth(17));
        make.width.mas_equalTo(kCurrentWidth(70));
        make.right.mas_equalTo(-kCurrentWidth(10));
    }];
    
    [_daleyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dayLabel.mas_bottom).offset(kCurrentWidth(10));
        make.height.mas_equalTo(kCurrentWidth(20));
        make.width.mas_equalTo(kCurrentWidth(70));
        make.right.mas_equalTo(kCurrentWidth(-10));
    }];
    
    [_allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kCurrentWidth(15));
        make.height.mas_equalTo(kCurrentWidth(17));
        make.top.mas_equalTo(kCurrentWidth(10));
        make.right.mas_equalTo(kCurrentWidth(100));
    }];
    
    [_iconContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.allButton.mas_bottom).offset(kCurrentWidth(2.5));
        make.height.width.mas_equalTo(kCurrentWidth(25));
        make.left.mas_equalTo(kCurrentWidth(15));
        make.bottom.mas_equalTo(kCurrentWidth(-10));
    }];
    
    [_personnelNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconContentView.mas_right).offset(kCurrentWidth(8));
        make.height.mas_equalTo(kCurrentWidth(25));
        make.centerY.mas_equalTo(self.iconContentView);
        make.right.mas_equalTo(-15);
    }];
    
    [_certButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kCurrentWidth(70));
        make.height.mas_equalTo(kCurrentWidth(25));
        make.bottom.mas_equalTo(kCurrentWidth(-10));
        make.right.mas_equalTo(kCurrentWidth(-10));
    }];
    
    [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.bottom.mas_equalTo(self.bgView);
    }];

    [_bigDaleyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kCurrentWidth(100));
        make.right.mas_equalTo(kCurrentWidth(-10));
        make.height.mas_equalTo(kCurrentWidth(17));
        make.top.mas_equalTo(kCurrentWidth(105));
    }];
    
    //企业认证信息视图
    [_headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kCurrentWidth(15));
        make.height.width.mas_equalTo(kCurrentWidth(40));
        make.centerY.mas_equalTo(self.bottomView);
    }];
    
    [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headIcon.mas_right).offset(kCurrentWidth(5));
        make.height.mas_equalTo(kCurrentWidth(20));
        make.top.mas_equalTo(kCurrentWidth(15));
        make.width.mas_equalTo(kDeviceWidth-_headIcon.right-115-kCurrentWidth(20));
    }];
    
    [_postionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickLabel.mas_right).offset(kCurrentWidth(3));
        make.height.mas_equalTo(kCurrentWidth(20));
        make.top.mas_equalTo(self.nickLabel.mas_top);
        make.width.mas_equalTo(kDeviceWidth-_headIcon.right-115-kCurrentWidth(20));
    }];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headIcon.mas_right).offset(kCurrentWidth(5));
        make.height.mas_equalTo(kCurrentWidth(15));
        make.top.mas_equalTo(self.nickLabel.mas_bottom);
        make.width.mas_equalTo(kDeviceWidth-_headIcon.right-kCurrentWidth(20));
    }];
}

- (void)setCompanyModel:(CompanyModel *)companyModel {
    _companyModel = companyModel;
    
    self.selected = companyModel.isDelete;
    [self.allButton setTitle:@"查看全部员工" forState:UIControlStateNormal];
    [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:companyModel.companyLogo] placeholderImage:[UIImage imageNamed:@"icon_liebang"]];
    self.companyLabel.text = companyModel.companyAbbreviation;
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(BoundWithSize(companyModel.fullName, kDeviceWidth, 16).size.width);
    }];
    self.nameLabel.text = companyModel.fullName;

    self.dayLabel.text = [NSString stringWithFormat:@"有效期%d天",[companyModel.validityDay intValue]];
    NSString *address = [NSString stringWithFormat:@"地址：%@%@",companyModel.city?:@"",companyModel.region?:@""];
    
    
    NSString *days = [InsureValidate getCountDownStringWithEndTime:self.companyModel.createTime];

    NSInteger leftDays = self.companyModel.validityDay.intValue - days.intValue;
    if (leftDays <= 30) {
        if (self.companyState == CompanyCellStateEdit || self.companyState == CompanyCellStateDisable) {
            _daleyButton.hidden = YES;

        }else{
            _daleyButton.hidden = NO;
        }
    }else{
        _daleyButton.hidden = YES;

    }
    
    self.addressLabel.text = address;
    self.labPersonNum.text = [NSString stringWithFormat:@"人员规模：%@",companyModel.personnelScale];
    self.labIndustry.text = [NSString stringWithFormat:@"所处行业：%@",companyModel.industry];

    self.numberLabel.text = [NSString stringWithFormat:@"融资状态：%@",companyModel.financingStatus];

    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",companyModel.companyPelephone];
    self.webLabel.text = [NSString stringWithFormat:@"官网：%@",companyModel.officialWebsite];
    self.webLabel.hidden = companyModel.officialWebsite.length == 0?YES:NO;
    self.phoneLabel.hidden = companyModel.companyPelephone.length == 0?YES:NO;
    self.addressLabel.hidden = companyModel.region.length == 0?YES:NO;
    self.companyLabel.hidden = companyModel.companyAbbreviation.length == 0?YES:NO;
    self.biaoqianLabel.hidden = companyModel.industry.length == 0?YES:NO;

    self.labPersonNum.hidden = companyModel.personnelScale.length == 0?YES:NO;
       self.labIndustry.hidden = companyModel.industry.length == 0?YES:NO;
    self.numberLabel.hidden = companyModel.industry.length == 0?YES:NO;

    self.markImage.left = self.nameLabel.right+kCurrentWidth(5);
    self.markImage.hidden = !([companyModel.status intValue] == 1);
    
    [self showPersonnelWith:companyModel.staff num:[companyModel.friendNum integerValue]];
    [self showCertButtonState:companyModel.status];
    [self showBigDaleyButton:[companyModel.validityDay intValue]];
    

}

- (void)setIsRen:(BOOL)isRen
{
    _isRen = isRen;
    if (isRen) {
        _daleyButton.hidden = YES;
    }else{
        _daleyButton.hidden = NO;
    }
}

- (void)showBigDaleyButton:(int)validityDay {
//    if (self.companyState == CompanyCellStateNormal) {
//        self.backContentView.hidden = (validityDay > 0)?YES:NO;
//        self.bigDaleyButton.hidden = (validityDay > 0)?YES:NO;
//    }
//    else {
//        self.backContentView.hidden = YES;
//        self.bigDaleyButton.hidden = YES;
//    }
}

- (void)showCertButtonState:(NSString *)status {
    //0 认证中 1已认证 2认证失败 3.未审核
    [self.certButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
    switch ([status intValue]) {
        case 0:
            [self.certButton setTitle:@"审核中" forState:UIControlStateNormal];
            break;
        case 1:
            [self.certButton setTitle:@"已通过" forState:UIControlStateNormal];
            break;
        case 2:
            [self.certButton setTitleColor:kRedColor forState:UIControlStateNormal];
            [self.certButton setTitle:@"认证失败" forState:UIControlStateNormal];
            break;
        case 3:
            [self.certButton setTitle:@"未认证" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)showPersonnelWith:(NSArray *)array num:(NSInteger)num{
    
    [self.iconContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < array.count; i ++) {
        StaffModel *model = [array safeObjectAtIndex:i];
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(33)*i, 0, kCurrentWidth(25), kCurrentWidth(25))];
        logo.layer.cornerRadius = kCurrentWidth(12.5);
        logo.layer.masksToBounds = YES;
        [logo sd_setImageWithURL:[NSURL URLWithString:model.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
        [logo setContentScaleFactor:[[UIScreen mainScreen]scale]];
        logo.contentMode = UIViewContentModeScaleAspectFill;
        logo.userInteractionEnabled = YES;
        [self.iconContentView addSubview:logo];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageClick:)];
        [logo addGestureRecognizer:tap];
    }
    [self.iconContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kCurrentWidth(33)*array.count);
    }];
    
    [self.personnelNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconContentView.mas_right);
        make.bottom.mas_equalTo(kCurrentWidth(-10));
    }];
//    self.iconContentView.width = kCurrentWidth(33)*array.count;
//    self.personnelNumLabel.left = self.iconContentView.right;
    self.personnelNumLabel.text = [NSString stringWithFormat:@"我有%zd个好友在此公司",num];
}

#pragma mark - 头像点击事件
- (void)headerImageClick:(UITapGestureRecognizer *)tap
{
    if (_HeaderPersonnelBlock) {
        _HeaderPersonnelBlock(self.companyModel.id);
    }
}

- (void)showCompanyPosterMessage {
    self.dayLabel.hidden = YES;
    self.daleyButton.hidden = YES;
    self.certButton.hidden = YES;
    self.allButton.hidden = YES;
    [self.iconContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.iconContentView.hidden = YES;
    self.personnelNumLabel.hidden = YES;
    self.tipLabel.hidden = NO;

        [_headIcon sd_setImageWithURL:[NSURL URLWithString:[Config currentConfig].headIcon] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
        
        [_nickLabel setNameString:[Config currentConfig].username showIcon:self.companyModel.status];
    LoginModel *account = [SDUserTool account];
    CGFloat width = BoundWithSize(account.userName, kDeviceWidth, 14).size.width - 15;
    [_nickLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.companyModel.status) {
            make.width.mas_equalTo(width);
        }else{
            make.width.mas_equalTo(width - 15);
        }
    }];
    
    StaffModel *staffModel = self.companyModel.staff[0];
    if ([staffModel.userUid isEqualToString:account.userUid]) {
        NSString *name = [NSString stringWithFormat:@"%@%@",staffModel.company?:@"",staffModel.position?:@""];
        [_postionLabel setCompany:self.companyModel.companyAbbreviation postion:name showIcon:self.companyModel.status];
        CGFloat nameW = BoundWithSize(name, kDeviceWidth, 11).size.width;
        if (nameW >= kDeviceWidth/2) {
            [_postionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(nameW - 60);
            }];
            
        }
    }
    
}

- (void)setCompanyState:(CompanyCellState)companyState {
    _companyState = companyState;

    switch (companyState) {
        case CompanyCellStateNormal:
        {
            self.dayLabel.hidden = NO;
            self.daleyButton.hidden = NO;
            self.certButton.hidden = YES;
        }
            break;
        case CompanyCellStateDisable:
        {
            self.dayLabel.hidden = YES;
            self.daleyButton.hidden = YES;
            self.certButton.hidden = YES;
        }
            break;
        case CompanyCellStateEdit:
        {
            self.dayLabel.hidden = YES;
            self.daleyButton.hidden = YES;
            self.certButton.hidden = NO;
        }
            break;
        default:
            break;
    }
}

#pragma mark Event
- (void)allButtonClick {
    if (_allPersonnelMessageBlock) {
        _allPersonnelMessageBlock(self.companyModel.id);
    }
}

- (void)daleyButtonClick {
    if (_daleyMessageBlock) {
        _daleyMessageBlock(self.companyModel);
    }
}

- (void)certButtonClick {
    if (_certiMessageBlock) {
        _certiMessageBlock(self.companyModel.id,self.companyModel.status,self.companyModel.createTime,self.companyModel.level);
    }
}

#pragma mark layoutSubviews
-(void)layoutSubviews
{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            control.backgroundColor = kWhiteColor;
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    //                    UIImageView *img=(UIImageView *)v;
                    //                    if (self.selected) {
                    //                        img.image=[UIImage imageNamed:@"icon_xuanze_dui"];
                    //                    }else
                    //                    {
                    //                        img.image=[UIImage imageNamed:@"icon_xuanze_weixuanzhong"];
                    //                    }
                    self.selectImageView = (UIImageView *)v;
                    if (self.selected) {
                        self.selectImageView.image = [UIImage imageNamed:@"icon_xuanze_dui"];
                    }else
                    {
                        self.selectImageView.image = [UIImage imageNamed:@"icon_xuanze_weixuanzhong"];
                    }
                }
            }
        }
    }
    [super layoutSubviews];
}

//适配第一次图片为空的情况
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            control.backgroundColor = kWhiteColor;
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    //                    UIImageView *img=(UIImageView *)v;
                    //                    if (!self.selected) {
                    //                        img.image=[UIImage imageNamed:@"icon_xuanze_weixuanzhong"];
                    //                    }
                    self.selectImageView = (UIImageView *)v;
                    if (!self.selected) {
                        self.selectImageView.image=[UIImage imageNamed:@"icon_xuanze_weixuanzhong"];
                    }
                    else {
                        self.selectImageView.image = [UIImage imageNamed:@"icon_xuanze_dui"];
                    }
                }
            }
        }
    }
    
    /*if (editing)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.backImageView.width = kDeviceWidth-kCurrentWidth(24)-kCurrentWidth(30);
            self.companyLogo.left = self.backImageView.width-kCurrentWidth(62);
            self.companyLabel.width = self.backImageView.width-kCurrentWidth(80);
            self.nameLabel.width = self.backImageView.width-kCurrentWidth(80);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.backImageView.width = kDeviceWidth-kCurrentWidth(24);
            self.companyLogo.left = self.backImageView.width-kCurrentWidth(62);
            self.companyLabel.width = self.backImageView.width-kCurrentWidth(80);
            self.nameLabel.width = self.backImageView.width-kCurrentWidth(80);
        }];
    }*/
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
