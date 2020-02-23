
#import "QuestionRalationPersonInfoCell.h"
#import "StarView.h"

@interface QuestionRalationPersonInfoCell ()

@property (nonatomic,strong)NameLabel *nameLabel;
@property (nonatomic,strong)PostionLabel *personLabel;
@property (nonatomic,strong)UIButton *numberLabel;
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)StarView *starView;
@property (nonatomic,strong)UIButton *sureButton;

@end
@implementation QuestionRalationPersonInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createSubViews];
        
    }
    return self;
}

- (void)setModel:(QuestionDetailModel *)model {
    _model = model;
    
    _nameLabel.userUid = model.userUid;
    _personLabel.userUid = model.userUid;
    [_nameLabel setNameString:model.userName showIcon:model.isBasic];
    _personLabel.left = _nameLabel.right+kCurrentWidth(10);
    [_numberLabel setTitle:[NSString stringWithFormat:@"帮助过%d人",[model.helpNum intValue]] forState:UIControlStateNormal];
    _starView.score = [model.startLevel floatValue];
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    
    if (_detailType == QuestionDetailTypeExpert) {
        if ([model.orderStates intValue] == 1 && [[_sureButton currentTitle] isEqualToString:@"回答"]) {
            NSString *string = [InsureValidate timestamp:model.Endtime];
            if ([string containsString:@"-"])
            {
                _personLabel.labelWidth = kDeviceWidth-(_nameLabel.right+kCurrentWidth(10))-kCurrentWidth(12);
                _sureButton.hidden = YES;
            }
            else
            {
                _personLabel.labelWidth = kDeviceWidth-(_nameLabel.right+kCurrentWidth(10))-kCurrentWidth(62);
                _sureButton.hidden = NO;
            }
        }
        else {
            _personLabel.labelWidth = kDeviceWidth-(_nameLabel.right+kCurrentWidth(10))-kCurrentWidth(12);
            _sureButton.hidden = YES;
        }
    }
    else {
                           
        _personLabel.labelWidth = kDeviceWidth-(_nameLabel.right+kCurrentWidth(10))-kCurrentWidth(62);
        _sureButton.hidden = NO;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSString *helpS = [NSString stringWithFormat:@"帮助过%d人",[self.model.helpNum intValue]];
    CGFloat numW = BoundWithSize(helpS, kDeviceWidth, 11).size.width + 80;
       
    _numberLabel.frame = CGRectMake(_iconImageView.right+kCurrentWidth(15), _nameLabel.bottom, numW, kCurrentWidth(20));

    CGFloat nameW = BoundWithSize(self.model.userName, SCREEN_WIDTH, 14).size.width;

    self.nameLabel.nameWidth = self.nameLabel.width = self.model.isBasic.intValue == 1?nameW:nameW - 12;
    
    self.nameLabel.left = _iconImageView.right + kCurrentWidth(15);
    //问答详情 ”回答“涉及到
    NSString *namePositon = [NSString stringWithFormat:@" %@%@",self.model.company,self.model.position];
    if (self.model.company.length == 0 && self.model.position.length == 0) {
        _personLabel.hidden = NO;
        [_personLabel setCompany:@"未填写公司和职位信息" postion:namePositon showIcon:self.model.isOccupationOne];
    }else{
        _personLabel.hidden = NO;

        namePositon = [NSString stringWithFormat:@"| %@%@",self.model.company,self.model.position];
        [_personLabel setCompany:@"" postion:namePositon showIcon:self.model.isOccupationOne];
        _personLabel.width = _personLabel.labelWidth;
        CGFloat nameW = BoundWithSize(namePositon, kDeviceWidth, 14).size.width;
        if (nameW > kDeviceWidth - _nameLabel.width - _iconImageView.width - kCurrentWidth(12)) {
            _personLabel.width = self.model.isOccupationOne.intValue == 1?kDeviceWidth-_nameLabel.width - _iconImageView.width - kCurrentWidth(115):kDeviceWidth-_nameLabel.width - _iconImageView.width - kCurrentWidth(82);
        }else{
            _personLabel.width = nameW + kCurrentWidth(12);
        }
    }
        _personLabel.left = _nameLabel.right+kCurrentWidth(15);
    
}

- (void)setDetailType:(QuestionDetailType)detailType {
    _detailType = detailType;
    
    switch (detailType) {
        case QuestionDetailTypeExpert:
        {
//
            [_sureButton setTitle:@"回答" forState:UIControlStateNormal];
        }
            break;
        case QuestionDetailTypeStudent:
        {
            _sureButton.hidden = NO;
            [_sureButton setTitle:@"提问" forState:UIControlStateNormal];
        }
            break;
        case QuestionDetailTypeVisitor:
        {
            _sureButton.hidden = NO;
            [_sureButton setTitle:@"提问" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)sureButtonClick {
    if (_questionButtonBlock) {
        _questionButtonBlock();
    }
}

#pragma mark 界面布局
- (void)createSubViews {

    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(10), kCurrentWidth(45), kCurrentWidth(45))];
    _iconImageView.image = [UIImage imageNamed:@"no_headIcon"];
    _iconImageView.layer.cornerRadius = kCurrentWidth(45)/2;
    _iconImageView.layer.masksToBounds = YES;
    [_iconImageView setContentScaleFactor:[[UIScreen mainScreen]scale]];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:_iconImageView];
    
    WeakSelf;
    _nameLabel = [[NameLabel alloc] initWithFrame:CGRectMake(_iconImageView.right+kCurrentWidth(25), kCurrentWidth(15), kCurrentWidth(45), kCurrentWidth(20))];
    [_nameLabel setNameString:@"猎帮" showIcon:@"1"];
    _nameLabel.GetBasicCertiImageViewBlock = ^(NSString *imageUrl) {
        if (weakSelf.GetBasicSourceBlock) {
            weakSelf.GetBasicSourceBlock(imageUrl);
        }
    };
    [self addSubview:_nameLabel];
    
    
    _personLabel = [[PostionLabel alloc] initWithFrame:CGRectMake(_nameLabel.right+kCurrentWidth(12), _nameLabel.top, kCurrentWidth(100), kCurrentWidth(20))];
    _personLabel.font = kSystem(12);
    _personLabel.color = kLBSixColor;
    _personLabel.GetWorkCertiImageViewBlock = ^(NSString *imageUrl) {
        if (weakSelf.GetWorkSourceBlock) {
            weakSelf.GetWorkSourceBlock(imageUrl);
        }
    };
    [self addSubview:_personLabel];
    
    _numberLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _numberLabel.frame = CGRectMake(_iconImageView.right+kCurrentWidth(15), _nameLabel.bottom, 75, kCurrentWidth(20));
    _numberLabel.adjustsImageWhenHighlighted = NO;
    [_numberLabel setTitleColor:kLBNineColor forState:UIControlStateNormal];
    [_numberLabel setTitle:@"帮助过0人" forState:UIControlStateNormal];
    [_numberLabel setImage:[UIImage imageNamed:@"list_icon_user"] forState:UIControlStateNormal];
    _numberLabel.titleLabel.font = kSystem(11);
    _numberLabel.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    _numberLabel.titleEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(6), 0, 0);
    [self addSubview:_numberLabel];
    
    _starView = [[StarView alloc] initWithFrame:CGRectMake(_numberLabel.right+kCurrentWidth(0), _numberLabel.top+kCurrentWidth(5), kCurrentWidth(78), kCurrentWidth(10))];
    _starView.score = 5.f;
    [self addSubview:_starView];
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(62), kCurrentWidth(20), kCurrentWidth(50), kCurrentWidth(25));
    [_sureButton setTitle:@"回答" forState:UIControlStateNormal];
    [_sureButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
    [_sureButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"ffffff"]] forState:UIControlStateNormal];
    _sureButton.layer.cornerRadius = kCurrentWidth(25)/2;
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.borderColor = kLBRedColor.CGColor;
    _sureButton.layer.borderWidth = 1.f;
    _sureButton.titleLabel.font = kSystemBold(14);
    [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sureButton];
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
