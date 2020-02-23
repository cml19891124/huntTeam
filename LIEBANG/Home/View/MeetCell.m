//
//  MeetCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/25.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "MeetCell.h"
#import "StarView.h"

@interface MeetCell ()

@property (nonatomic,strong)UIButton *numberLabel;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)PriceLabel *priceLabel;
@property (nonatomic,strong)UIButton *typeLabel;
@property (nonatomic,strong)StarView *starView;
@property (nonatomic,strong)UIButton *timeLabel;


@property (nonatomic,strong)UIButton *editButton;
@property (nonatomic,strong)UIButton *confimButton;

@end

@implementation MeetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createSubViews];
        
    }
    return self;
}

- (void)setDetailModel:(ThemeOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
//    [_numberLabel setTitle:[NSString stringWithFormat:@"帮助过%d人",[detailModel.helpNum intValue]] forState:UIControlStateNormal];
    if (self.themeClassModel.helpNum.length != 0) {
        NSString *help = [NSString stringWithFormat:@"帮助过%@人",self.themeClassModel.helpNum];
        CGFloat helpW = BoundWithSize(help, kDeviceWidth, 11).size.width + 20;

        _numberLabel.frame = CGRectMake(kCurrentWidth(10), _messageLabel.bottom,helpW, kCurrentWidth(20));
        _timeLabel.frame = CGRectMake(_numberLabel.right+kCurrentWidth(5), _numberLabel.top, 75, kCurrentWidth(20));
        [_numberLabel setTitle:help forState:UIControlStateNormal];
    }else{
        NSString *help = [NSString stringWithFormat:@"帮助过%@人",self.detailModel.helpNum];
        CGFloat helpW = BoundWithSize(help, kDeviceWidth, 11).size.width + 20;

        _numberLabel.frame = CGRectMake(kCurrentWidth(10), _messageLabel.bottom,helpW, kCurrentWidth(20));
        _timeLabel.frame = CGRectMake(_numberLabel.right+kCurrentWidth(5), _numberLabel.top, 75, kCurrentWidth(20));
        [_numberLabel setTitle:help forState:UIControlStateNormal];

    }

    _starView.score = [detailModel.startLevel floatValue];
    [_priceLabel setUsePrice:detailModel.topicPrice oldPrice:detailModel.originalPrice];
    
    _messageLabel.text = detailModel.topicName;
    [_timeLabel setTitle:[NSString stringWithFormat:@"%@小时/次",detailModel.serviceTime] forState:UIControlStateNormal];
    
    if ([detailModel.serviceType isEqualToString:@"0"])
    {
        [_typeLabel setTitle:@"线下约见" forState:UIControlStateNormal];
        [_typeLabel setBackgroundImage:[UIImage imageNamed:@"list_button_xianxia"] forState:UIControlStateNormal];
    }
    else if ([detailModel.serviceType isEqualToString:@"1"])
    {
        [_typeLabel setTitle:@"全国通话" forState:UIControlStateNormal];
        [_typeLabel setBackgroundImage:[UIImage imageNamed:@"list_button_quanguo"] forState:UIControlStateNormal];
    }

        CGSize size = [detailModel.topicName sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(20), MAXFLOAT)];
        _messageLabel.height = size.height;

    _numberLabel.top = _messageLabel.bottom+kCurrentWidth(4);
    _timeLabel.top = _messageLabel.bottom+kCurrentWidth(4);
    _priceLabel.top = _numberLabel.bottom;
    _starView.top = _numberLabel.bottom;
    self.height = _starView.bottom + kCurrentWidth(15);
}


- (void)setThemeClassModel:(ThemeClassModel *)themeClassModel {
    _themeClassModel = themeClassModel;

    if (self.ishelp) {
        NSString *help = [NSString stringWithFormat:@"帮助过%d人",[themeClassModel.helpNum intValue]];
        [_numberLabel setTitle:help forState:UIControlStateNormal];
    }
    else {
        NSString *help = [NSString stringWithFormat:@"帮助过%d人",[themeClassModel.helpNum intValue]];
        [_numberLabel setTitle:help forState:UIControlStateNormal];
    }
    
    NSLog(@" ======    ===   %@",themeClassModel.helpNum);

    _starView.score = [themeClassModel.startLevel floatValue];
    [_priceLabel setUsePrice:themeClassModel.topicPrice oldPrice:themeClassModel.originalPrice];

    _messageLabel.text = themeClassModel.topicName;
    [_timeLabel setTitle:[NSString stringWithFormat:@"%@小时/次",themeClassModel.serviceTime] forState:UIControlStateNormal];

    if ([themeClassModel.serviceType isEqualToString:@"0"])
    {
        [_typeLabel setTitle:@"线下约见" forState:UIControlStateNormal];
        [_typeLabel setBackgroundImage:[UIImage imageNamed:@"list_button_xianxia"] forState:UIControlStateNormal];
    }
    else if ([themeClassModel.serviceType isEqualToString:@"1"])
    {
        [_typeLabel setTitle:@"全国通话" forState:UIControlStateNormal];
        [_typeLabel setBackgroundImage:[UIImage imageNamed:@"list_button_quanguo"] forState:UIControlStateNormal];
    }

    CGSize size = [themeClassModel.topicName sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(20), MAXFLOAT)];
    _messageLabel.height = size.height;

    _numberLabel.top = _messageLabel.bottom+kCurrentWidth(4);

    _timeLabel.top = _messageLabel.bottom+kCurrentWidth(4);
    _priceLabel.top = _numberLabel.bottom;
    _starView.top = _numberLabel.bottom;
    self.height = _starView.bottom + kCurrentWidth(15);
}


- (CGFloat)cellHeight {
    return self.height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.themeClassModel) {
        if (self.themeClassModel.helpNum.length != 0) {
            NSString *help = [NSString stringWithFormat:@"帮助过%@人",self.themeClassModel.helpNum];
            CGFloat helpW = BoundWithSize(help, kDeviceWidth, 11).size.width + 20;

            _numberLabel.frame = CGRectMake(kCurrentWidth(10), _messageLabel.bottom,helpW, kCurrentWidth(20));
            _timeLabel.frame = CGRectMake(_numberLabel.right+kCurrentWidth(5), _numberLabel.top, 75, kCurrentWidth(20));
            [_numberLabel setTitle:help forState:UIControlStateNormal];
        }else{
            NSString *help = [NSString stringWithFormat:@"帮助过%@人",self.themeClassModel.map_helpNum];
            CGFloat helpW = BoundWithSize(help, kDeviceWidth, 11).size.width + 20;

            _numberLabel.frame = CGRectMake(kCurrentWidth(10), _messageLabel.bottom,helpW, kCurrentWidth(20));
            _timeLabel.frame = CGRectMake(_numberLabel.right+kCurrentWidth(5), _numberLabel.top, 75, kCurrentWidth(20));
            [_numberLabel setTitle:help forState:UIControlStateNormal];

        }
        

    }else{
        NSString *help = [NSString stringWithFormat:@"帮助过%d人",[self.detailModel.helpNum intValue]];
        CGFloat helpW = BoundWithSize(help, kDeviceWidth, 11).size.width + 20;
        _numberLabel.frame = CGRectMake(kCurrentWidth(10), _messageLabel.bottom,helpW, kCurrentWidth(20));
        _timeLabel.frame = CGRectMake(_numberLabel.right+kCurrentWidth(5), _numberLabel.top, 75, kCurrentWidth(20));

    }

}

#pragma mark 界面布局
- (void)createSubViews {
    
    _typeLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _typeLabel.frame = CGRectMake(kDeviceWidth-kCurrentWidth(72), 0, kCurrentWidth(60), kCurrentWidth(19));
    [_typeLabel setBackgroundImage:[UIImage imageNamed:@"list_button_xianxia"] forState:UIControlStateNormal];
    [_typeLabel setTitle:@"线下约见" forState:UIControlStateNormal];
    [_typeLabel setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _typeLabel.titleLabel.font = kSystem(12);
    _typeLabel.adjustsImageWhenHighlighted = NO;
    [self addSubview:_typeLabel];

    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(10), kCurrentWidth(24), kDeviceWidth-kCurrentWidth(20), kCurrentWidth(20))];
    _messageLabel.text = @"讲一讲生产型企业IT信息安全优化";
    _messageLabel.font = kSystem(15);
    _messageLabel.textColor = kLBBlackColor;
    _messageLabel.numberOfLines = 0;
    [self addSubview:_messageLabel];

    _numberLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _numberLabel.frame = CGRectMake(kCurrentWidth(10), _messageLabel.bottom,75, kCurrentWidth(20));
    _numberLabel.adjustsImageWhenHighlighted = NO;
    [_numberLabel setTitleColor:kLBNineColor forState:UIControlStateNormal];
    [_numberLabel setTitle:@"帮助过0人" forState:UIControlStateNormal];
    [_numberLabel setImage:[UIImage imageNamed:@"list_icon_user"] forState:UIControlStateNormal];
    _numberLabel.titleLabel.font = kSystem(11);
    _numberLabel.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    _numberLabel.titleEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(6), 0, 0);
    [self addSubview:_numberLabel];
    
    _timeLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeLabel.frame = CGRectMake(_numberLabel.right+kCurrentWidth(0), _numberLabel.top, 75, kCurrentWidth(20));
    _timeLabel.adjustsImageWhenHighlighted = NO;
    [_timeLabel setTitleColor:kLBNineColor forState:UIControlStateNormal];
    [_timeLabel setTitle:@"1小时/次" forState:UIControlStateNormal];
    [_timeLabel setImage:[UIImage imageNamed:@"list_icon_zhong"] forState:UIControlStateNormal];
    _timeLabel.titleLabel.font = kSystem(11);
    _timeLabel.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    _timeLabel.titleEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(5), 0, 0);
    [self addSubview:_timeLabel];
    
    _priceLabel = [[PriceLabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(112), _numberLabel.bottom, kCurrentWidth(100), kCurrentWidth(14))];
    _priceLabel.priceTextAlignment = NSTextAlignmentRight;
    [self addSubview:_priceLabel];
    
    _starView = [[StarView alloc] initWithFrame:CGRectMake(kCurrentWidth(10), _numberLabel.bottom, kCurrentWidth(78), kCurrentWidth(10))];
    _starView.score = 4.5f;
    [self addSubview:_starView];
    
//    _confimButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _confimButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(56), kCurrentWidth(10), kCurrentWidth(44), kCurrentWidth(20));
//    [_confimButton setTitle:@"编辑" forState:UIControlStateNormal];
//    [_confimButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
//    _confimButton.layer.cornerRadius = kCurrentWidth(10);
//    _confimButton.layer.borderColor = kLBRedColor.CGColor;
//    _confimButton.layer.borderWidth = 0.5;
//    _confimButton.layer.masksToBounds = YES;
//    _confimButton.titleLabel.font = kSystem(13);
//    _confimButton.hidden = YES;
//    [_confimButton addTarget:self action:@selector(confimButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_confimButton];
//    
//    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _editButton.frame = CGRectMake(_confimButton.left-kCurrentWidth(54), kCurrentWidth(10), kCurrentWidth(44), kCurrentWidth(20));
//    [_editButton setTitle:@"删除" forState:UIControlStateNormal];
//    [_editButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
//    _editButton.layer.cornerRadius = kCurrentWidth(10);
//    _editButton.layer.borderColor = kLBRedColor.CGColor;
//    _editButton.layer.borderWidth = 0.5;
//    _editButton.layer.masksToBounds = YES;
//    _editButton.titleLabel.font = kSystem(13);
//    _editButton.hidden = YES;
//    [_editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_editButton];
    
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
