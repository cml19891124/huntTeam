//
//  MemberPhoneCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/24.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "MemberPhoneCell.h"
#import "StarView.h"

@interface MemberPhoneCell ()

@property (nonatomic,strong)NameLabel *nameLabel;
@property (nonatomic,strong)PostionLabel *personLabel;
@property (nonatomic,strong)UIButton *numberLabel;
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UIImageView *enterImageView;
@property (nonatomic,strong)UIButton *phoneButton;
@property (nonatomic,strong)StarView *starView;

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIView *bottomView;

@end

@implementation MemberPhoneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(10))];
        _lineView.backgroundColor = kBackgroundColor;
        [self addSubview:_lineView];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(84), kDeviceWidth, kCurrentWidth(10))];
        _bottomView.backgroundColor = kBackgroundColor;
        [self addSubview:_bottomView];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), _lineView.bottom+kCurrentWidth(15), kCurrentWidth(44), kCurrentWidth(44))];
        _iconImageView.image = [UIImage imageNamed:@"no_headIcon"];
        _iconImageView.layer.cornerRadius = kCurrentWidth(22);
        _iconImageView.layer.masksToBounds = YES;
        [_iconImageView setContentScaleFactor:[[UIScreen mainScreen]scale]];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:_iconImageView];
        
        WeakSelf;
        _nameLabel = [[NameLabel alloc] initWithFrame:CGRectMake(_iconImageView.right+kCurrentWidth(8), _lineView.bottom+kCurrentWidth(18), kCurrentWidth(45), kCurrentWidth(20))];
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
        _numberLabel.frame = CGRectMake(_iconImageView.right+kCurrentWidth(8), _nameLabel.bottom, 75, kCurrentWidth(20));
        _numberLabel.adjustsImageWhenHighlighted = NO;
        [_numberLabel setTitleColor:kLBNineColor forState:UIControlStateNormal];
        [_numberLabel setTitle:@"帮助过0人" forState:UIControlStateNormal];
        [_numberLabel setImage:[UIImage imageNamed:@"list_icon_user"] forState:UIControlStateNormal];
        _numberLabel.titleLabel.font = kSystem(12);
        _numberLabel.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        _numberLabel.titleEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(6), 0, 0);
        [self addSubview:_numberLabel];
        
        _starView = [[StarView alloc] initWithFrame:CGRectMake(_numberLabel.right+kCurrentWidth(0), _numberLabel.top+kCurrentWidth(5), kCurrentWidth(78), kCurrentWidth(10))];
        [self addSubview:_starView];
        
        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(39), _lineView.bottom+kCurrentWidth(24), kCurrentWidth(27), kCurrentWidth(27));
        [_phoneButton setImage:[UIImage imageNamed:@"list_button_dianhua.png"] forState:UIControlStateNormal];
        [_phoneButton addTarget:self action:@selector(phoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_phoneButton];
        
        _enterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(56), _lineView.bottom+kCurrentWidth(32), kCurrentWidth(6), kCurrentWidth(10))];
        _enterImageView.image = [UIImage imageNamed:@"list_btn_enter.png"];
        [self addSubview:_enterImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.orderStatus.intValue == 4) {//已收到列表---行家
        CGFloat nameW = BoundWithSize(self.detailModel.StudentuserName, SCREEN_WIDTH, 14).size.width;
        [_nameLabel setNameString:self.detailModel.StudentuserName showIcon:self.detailModel.StudentisBasic];

        self.nameLabel.nameWidth = self.nameLabel.width = self.detailModel.StudentisBasic.intValue == 1?nameW:nameW - 12;
        NSString *namePositon = [NSString stringWithFormat:@" %@%@",self.detailModel.Studentcompany,self.detailModel.Studentposition];
            if (self.detailModel.Studentcompany.length == 0 && self.detailModel.Studentposition.length == 0) {
                _personLabel.hidden = NO;
                [_personLabel setCompany:@"未填写公司和职位信息" postion:namePositon showIcon:self.detailModel.StudentisOccupationOne];
            }else{
                _personLabel.hidden = NO;

                namePositon = [NSString stringWithFormat:@" | %@%@",self.detailModel.Studentcompany,self.detailModel.Studentposition];
                [_personLabel setCompany:@"" postion:namePositon showIcon:self.detailModel.StudentisOccupationOne];
            }
        
        CGFloat pW = BoundWithSize(namePositon, kDeviceWidth, 14).size.width;
            if (pW > kDeviceWidth-_nameLabel.width - _iconImageView.width -kCurrentWidth(12)) {
                _personLabel.width = self.detailModel.StudentisOccupationOne.intValue == 1?kDeviceWidth-_nameLabel.width - _iconImageView.width - kCurrentWidth(92):kDeviceWidth-_nameLabel.width - _iconImageView.width - kCurrentWidth(72);

            }else{
                _personLabel.width = pW + kCurrentWidth(12);
            }
        _personLabel.left = _nameLabel.right+kCurrentWidth(10);

        NSString *helpnum = [NSString stringWithFormat:@"帮助过%d人",[self.detailModel.StudenthelpNum intValue]];
        CGFloat helpW = BoundWithSize(helpnum, kDeviceWidth, 11).size.width+25;
        [_numberLabel setTitle:helpnum forState:UIControlStateNormal];
        _numberLabel.width = helpW;
    }else{
    CGFloat nameW = BoundWithSize(self.detailModel.userName, SCREEN_WIDTH, 14).size.width;
        [_nameLabel setNameString:self.detailModel.userName showIcon:self.detailModel.isBasic];

    self.nameLabel.nameWidth = self.nameLabel.width = self.detailModel.isBasic.intValue == 1?nameW:nameW - 12;
    NSString *namePositon = [NSString stringWithFormat:@" %@%@",self.detailModel.company,self.detailModel.position];
        if (self.detailModel.company.length == 0 && self.detailModel.position.length == 0) {
            _personLabel.hidden = NO;
            [_personLabel setCompany:@"未填写公司和职位信息" postion:namePositon showIcon:self.detailModel.isOccupationOne];
        }else{
            _personLabel.hidden = NO;

            namePositon = [NSString stringWithFormat:@" | %@%@",self.detailModel.company,self.detailModel.position];
            [_personLabel setCompany:@"" postion:namePositon showIcon:self.detailModel.isOccupationOne];
        }
    
    CGFloat pW = BoundWithSize(namePositon, kDeviceWidth, 14).size.width;
        if (pW > kDeviceWidth-_nameLabel.width - _iconImageView.width -kCurrentWidth(12)) {
            _personLabel.width = self.detailModel.isOccupationOne.intValue == 1?kDeviceWidth-_nameLabel.width - _iconImageView.width - kCurrentWidth(92):kDeviceWidth-_nameLabel.width - _iconImageView.width - kCurrentWidth(72);

        }else{
            _personLabel.width = pW + kCurrentWidth(12);
        }
    _personLabel.left = _nameLabel.right+kCurrentWidth(10);

    NSString *helpnum = [NSString stringWithFormat:@"帮助过%d人",[self.detailModel.helpNum intValue]];
    CGFloat helpW = BoundWithSize(helpnum, kDeviceWidth, 11).size.width+25;
    [_numberLabel setTitle:helpnum forState:UIControlStateNormal];
    _numberLabel.width = helpW;
    }
}

- (void)phoneButtonClick {
    _phoneButton.enabled = NO;
    [self countDownWithTime:3 countDownBlock:nil endBlock:^{
        self.phoneButton.enabled = YES;
    }];
    if (_callPhoneButtonBlock) {
        _callPhoneButtonBlock();
    }
}

- (void)countDownWithTime:(int)time
           countDownBlock:(void (^)(int timeLeft))countDownBlock
                 endBlock:(void (^)(void))endBlock
{
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (endBlock) {
                    endBlock();
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                timeout--;
                if (countDownBlock) {
                    countDownBlock(timeout);
                }
            });
        }
    });
    dispatch_resume(_timer);
}

- (void)setDetailModel:(ThemeOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
    if ([self.orderStatus intValue] == 4) {
        _nameLabel.userUid = detailModel.userUid;
        _personLabel.userUid = detailModel.userUid;
        CGFloat nameW = BoundWithSize(self.detailModel.StudentuserName, SCREEN_WIDTH, 14).size.width;

        self.nameLabel.nameWidth = self.nameLabel.width = self.detailModel.StudentisBasic.intValue == 1?nameW:nameW - 12;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.StudentuserHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
//
        [_nameLabel setNameString:detailModel.StudentuserName showIcon:detailModel.StudentisBasic];
//
//        NSString *helpnum = [NSString stringWithFormat:@"帮助过%d人",[detailModel.helpNum intValue]];
//        CGFloat helpW = BoundWithSize(helpnum, kDeviceWidth, 11).size.width+15;
//        [_numberLabel setTitle:helpnum forState:UIControlStateNormal];
//        _numberLabel.width = helpW;


        _starView.hidden = YES;
        
        self.nameLabel.nameWidth = self.nameLabel.width = self.detailModel.StudentisBasic.intValue == 1?nameW:nameW - 12;
        NSString *namePositon = [NSString stringWithFormat:@" %@%@",self.detailModel.Studentcompany,self.detailModel.Studentposition];
            if (self.detailModel.Studentcompany.length == 0 && self.detailModel.Studentposition.length == 0) {
                _personLabel.hidden = NO;
                [_personLabel setCompany:@"未填写公司和职位信息" postion:namePositon showIcon:self.detailModel.StudentisOccupationOne];
            }else{
                _personLabel.hidden = NO;

                namePositon = [NSString stringWithFormat:@" | %@%@",self.detailModel.Studentcompany,self.detailModel.Studentposition];
                [_personLabel setCompany:@"" postion:namePositon showIcon:self.detailModel.StudentisOccupationOne];
            }
        
        CGFloat pW = BoundWithSize(namePositon, kDeviceWidth, 14).size.width;
            if (pW > kDeviceWidth-_nameLabel.width - _iconImageView.width -kCurrentWidth(12)) {
                _personLabel.width = self.detailModel.StudentisOccupationOne.intValue == 1?kDeviceWidth-_nameLabel.width - _iconImageView.width - kCurrentWidth(92):kDeviceWidth-_nameLabel.width - _iconImageView.width - kCurrentWidth(72);

            }else{
                _personLabel.width = pW + kCurrentWidth(12);
            }
        _personLabel.left = _nameLabel.right+kCurrentWidth(10);

        NSString *helpnum = [NSString stringWithFormat:@"帮助过%d人",[self.detailModel.StudenthelpNum intValue]];
        CGFloat helpW = BoundWithSize(helpnum, kDeviceWidth, 11).size.width+25;
        [_numberLabel setTitle:helpnum forState:UIControlStateNormal];
        _numberLabel.width = helpW;
    }
    else {
        _nameLabel.userUid = detailModel.userUid;
        _personLabel.userUid = detailModel.userUid;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
        [_nameLabel setNameString:detailModel.userName showIcon:detailModel.isBasic];
//        CGFloat nameW = BoundWithSize(detailModel.userName, SCREEN_WIDTH, 14).size.width;
//
//        self.nameLabel.nameWidth = self.nameLabel.width = detailModel.isBasic.intValue == 1?nameW:nameW - 12;
//        [_numberLabel setTitle:[NSString stringWithFormat:@"帮助过%d人",[detailModel.helpNum intValue]] forState:UIControlStateNormal];
//
//        NSString *namePositon = [NSString stringWithFormat:@" %@%@",detailModel.company,detailModel.position];
//            if (detailModel.company.length == 0 && detailModel.position.length == 0) {
//                _personLabel.hidden = NO;
//                [_personLabel setCompany:@"未填写公司和职位信息" postion:namePositon showIcon:detailModel.isOccupationOne];
//            }else{
//                _personLabel.hidden = NO;
//
//                namePositon = [NSString stringWithFormat:@" | %@%@",detailModel.company,detailModel.position];
//                [_personLabel setCompany:@"" postion:namePositon showIcon:detailModel.isOccupationOne];
//                //话题---”已收到“ 详情页的遮盖”提问“、”回答“涉及到
//
//            }
        
        CGFloat nameW = BoundWithSize(self.detailModel.userName, SCREEN_WIDTH, 14).size.width;

        self.nameLabel.nameWidth = self.nameLabel.width = self.detailModel.isBasic.intValue == 1?nameW:nameW - 12;
        NSString *namePositon = [NSString stringWithFormat:@" %@%@",self.detailModel.company,self.detailModel.position];
            if (self.detailModel.company.length == 0 && self.detailModel.position.length == 0) {
                _personLabel.hidden = NO;
                [_personLabel setCompany:@"未填写公司和职位信息" postion:namePositon showIcon:self.detailModel.isOccupationOne];
            }else{
                _personLabel.hidden = NO;

                namePositon = [NSString stringWithFormat:@" | %@%@",self.detailModel.company,self.detailModel.position];
                [_personLabel setCompany:@"" postion:namePositon showIcon:self.detailModel.isOccupationOne];
            }
        
        CGFloat pW = BoundWithSize(namePositon, kDeviceWidth, 14).size.width;
            if (pW > kDeviceWidth-_nameLabel.width - _iconImageView.width -kCurrentWidth(12)) {
                _personLabel.width = self.detailModel.isOccupationOne.intValue == 1?kDeviceWidth-_nameLabel.width - _iconImageView.width - kCurrentWidth(92):kDeviceWidth-_nameLabel.width - _iconImageView.width - kCurrentWidth(72);

            }else{
                _personLabel.width = pW + kCurrentWidth(12);
            }
        _personLabel.left = _nameLabel.right+kCurrentWidth(10);

        NSString *helpnum = [NSString stringWithFormat:@"帮助过%d人",[self.detailModel.helpNum intValue]];
        CGFloat helpW = BoundWithSize(helpnum, kDeviceWidth, 11).size.width+25;
        [_numberLabel setTitle:helpnum forState:UIControlStateNormal];
        _numberLabel.width = helpW;
        
        _starView.hidden = NO;
        _starView.left = _numberLabel.right + kCurrentWidth(5);
        _starView.score = [detailModel.startLevel floatValue];
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
