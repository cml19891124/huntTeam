
#import "ThemeListQuestionCell.h"
#import "StarView.h"
#import "OrderStatusView.h"

@interface ThemeListQuestionCell ()

@property (nonatomic,strong)NameLabel *nameLabel;
@property (nonatomic,strong)PostionLabel *personLabel;
@property (nonatomic,strong)UIButton *numberLabel;
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UIButton *typeLabel;
@property (nonatomic,strong)StarView *starView;
@property (nonatomic,strong)OrderStatusView *statusView;

@end

@implementation ThemeListQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setQuestionClassModel:(QuestionClassModel *)questionClassModel {//精彩问答
    _questionClassModel = questionClassModel;
    
    _personLabel.userUid = questionClassModel.userUid;
    _nameLabel.userUid = questionClassModel.userUid;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:questionClassModel.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    [_nameLabel setNameString:questionClassModel.userName showIcon:questionClassModel.isBasic];
    _nameLabel.width = _nameLabel.nameWidth;
    [_numberLabel setTitle:[NSString stringWithFormat:@"帮助过%d人",[questionClassModel.helpNum intValue]] forState:UIControlStateNormal];
    
    if (IsStrEmpty(questionClassModel.position))
    {
        _personLabel.hidden = YES;
    }
    else
    {
        _personLabel.hidden = NO;
        
        NSString *userName = questionClassModel.userName;
        CGFloat nameW = BoundWithSize(userName, kDeviceWidth, 13).size.width;
//        _nameLabel.width = nameW - 8;
        if ([questionClassModel.isBasic isEqualToString:@"0"]) {
            _nameLabel.width = nameW - 20;
        }else{
            _nameLabel.width = nameW - 8;
        }
        
        NSString *name = [NSString stringWithFormat:@"%@%@",questionClassModel.company,questionClassModel.position];
        CGSize size = BoundWithSize(name, kDeviceWidth, 13).size;
        
        _personLabel.labelWidth = size.width + 15;
        [_personLabel setCompany:@"" postion:[NSString stringWithFormat:@"  |  %@%@",questionClassModel.company,questionClassModel.position] showIcon:questionClassModel.isOccupation];
        _personLabel.left = _nameLabel.right+kCurrentWidth(10)+15;
    }
    
    NSString *name = [NSString stringWithFormat:@"%@%@",questionClassModel.company,questionClassModel.position];
    CGSize persize = BoundWithSize(name, kDeviceWidth, 13).size;

    if (persize.width > kDeviceWidth-_nameLabel.width - _iconImageView.width -kCurrentWidth(12)) {
        _personLabel.width = kDeviceWidth-_nameLabel.width - _iconImageView.width - kCurrentWidth(30);
    }else{
        if ([questionClassModel.isOccupationOne isEqualToString:@"0"]) {
            _personLabel.labelWidth = persize.width + 20;

        }else{
            _personLabel.width = persize.width + 44;
        }
    }
    
    if ([questionClassModel.chargeState intValue] == 0) {
        _priceLabel.text = @"限时免费";
        _priceLabel.font = kSystem(12);
        _priceLabel.textColor = [UIColor colorWithHexString:@"FE701B"];
    }
    else {
        _priceLabel.font = kSystemBold(15);
        _priceLabel.textColor = kLBRedColor;
        NSString *selectText = @"猎帮币";
        NSString *allSelectText = @"1猎帮币";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
        [attr addAttribute:NSFontAttributeName
                     value:kSystem(11)
                     range:[allSelectText rangeOfString:selectText]];
        _priceLabel.attributedText = attr;
    }
    
    _starView.score = [questionClassModel.startLevel floatValue];
    _messageLabel.text = questionClassModel.quizcontent;
    
    CGSize size = [_messageLabel.text sizeWithFont:kSystem(13) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(32), kCurrentWidth(50))];
    
    if (size.height > kCurrentWidth(50)) {
        _messageLabel.frame = CGRectMake(kCurrentWidth(16), kCurrentWidth(80), kDeviceWidth-kCurrentWidth(32), kCurrentWidth(50));
    }
    else {
        _messageLabel.frame = CGRectMake(kCurrentWidth(16), kCurrentWidth(80), kDeviceWidth-kCurrentWidth(32), size.height);
    }

    self.height = _messageLabel.bottom+kCurrentWidth(10);
}

- (CGFloat)getHeight {
    return self.height;
}

- (void)enterAccountEvent {
    if (_accountButtonBlock) {
        _accountButtonBlock();
    }
}

#pragma mark 界面布局
- (void)createSubViews {
    
    _typeLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeLabel.frame = CGRectMake(kDeviceWidth-kCurrentWidth(72), 0, kCurrentWidth(60), kCurrentWidth(19));
    [_typeLabel setBackgroundImage:[UIImage imageNamed:@"list_button_zaixianwenda"] forState:UIControlStateNormal];
    [_typeLabel setTitle:@"在线问答" forState:UIControlStateNormal];
    [_typeLabel setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _typeLabel.titleLabel.font = kSystem(12);
    _typeLabel.adjustsImageWhenHighlighted = NO;
    [self addSubview:_typeLabel];
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(15), kCurrentWidth(21), kCurrentWidth(45), kCurrentWidth(45))];
    _iconImageView.image = [UIImage imageNamed:@"no_headIcon"];
    _iconImageView.layer.cornerRadius = kCurrentWidth(45)/2;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.userInteractionEnabled = YES;
    [_iconImageView setContentScaleFactor:[[UIScreen mainScreen]scale]];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:_iconImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterAccountEvent)];
    [_iconImageView addGestureRecognizer:tap];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(16), kCurrentWidth(80), kDeviceWidth-kCurrentWidth(32), kCurrentWidth(50))];
    _messageLabel.text = @"教育近些年来，网络教育发展迅速，用户数量也在逐年递增，您觉得它今后的展前景如何？网络教育最终真的会和传统教育平起平坐吗？";
    _messageLabel.font = kSystem(13);
    _messageLabel.textColor = kLBBlackColor;
    _messageLabel.numberOfLines = 3;
    [self addSubview:_messageLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(162), kCurrentWidth(48), kCurrentWidth(150), kCurrentWidth(14))];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_priceLabel];
    
    WeakSelf;
    _nameLabel = [[NameLabel alloc] initWithFrame:CGRectMake(_iconImageView.right+kCurrentWidth(15), kCurrentWidth(23), kCurrentWidth(60), kCurrentWidth(20))];
    [_nameLabel setNameString:@"猎帮" showIcon:@"0"];
    _nameLabel.GetBasicCertiImageViewBlock = ^(NSString *imageUrl) {
        if (weakSelf.GetBasicSourceBlock) {
            weakSelf.GetBasicSourceBlock(imageUrl);
        }
    };
    [self addSubview:_nameLabel];
    
    _personLabel = [[PostionLabel alloc] initWithFrame:CGRectMake(_nameLabel.right+kCurrentWidth(12)+15, _nameLabel.top, kCurrentWidth(100), kCurrentWidth(20))];
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
    [_numberLabel setTitle:@"帮助过10人" forState:UIControlStateNormal];
    [_numberLabel setImage:[UIImage imageNamed:@"list_icon_user"] forState:UIControlStateNormal];
    _numberLabel.titleLabel.font = kSystem(11);
    _numberLabel.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    _numberLabel.titleEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(6), 0, 0);
    [self addSubview:_numberLabel];
    
    _starView = [[StarView alloc] initWithFrame:CGRectMake(_numberLabel.right+kCurrentWidth(0), _numberLabel.top+kCurrentWidth(5), kCurrentWidth(78), kCurrentWidth(10))];
    [self addSubview:_starView];
}

- (OrderStatusView *)statusView {
    if (!_statusView) {
        _statusView = [[OrderStatusView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(145), kDeviceWidth, kCurrentWidth(42))];
    }
    return _statusView;
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
