//
//  AccountQuestionCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountQuestionCell.h"
#import "StarView.h"

@interface AccountQuestionCell ()

@property (nonatomic,strong)UIButton *numberLabel;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UIButton *typeLabel;
@property (nonatomic,strong)StarView *starView;

@end
@implementation AccountQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createSubViews];
        
    }
    return self;
}

- (void)setQuestionClassModel:(QuestionClassModel *)questionClassModel {
    _questionClassModel = questionClassModel;
    NSString *help = [NSString stringWithFormat:@"帮助过%d人",[questionClassModel.helpNum intValue]];
    CGFloat helpw = BoundWithSize(help, kDeviceWidth, 11).size.width + 80;
    [_numberLabel setTitle:help forState:UIControlStateNormal];
//    _numberLabel.width = helpw;
    _numberLabel.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(22), helpw, kCurrentWidth(20));

    if ([questionClassModel.chargeState intValue] == 0) {
        _priceLabel.text = @"限时免费";
        _priceLabel.font = kSystem(12);
        _priceLabel.textColor = [UIColor colorWithHexString:@"FE701B"];
    }
    else {
//        _priceLabel.font = kSystemBold(15);
//        _priceLabel.textColor = kLBRedColor;
//        _priceLabel.text = @"1猎帮币";
        
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
    
    CGSize size = [_messageLabel.text sizeWithFont:kSystem(13) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), kCurrentWidth(50))];
    _messageLabel.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(47), kDeviceWidth-kCurrentWidth(24), size.height);
    self.height = _messageLabel.bottom+kCurrentWidth(10);
}

- (CGFloat)getHeight {
    return self.height;
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

    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(47), kDeviceWidth-kCurrentWidth(24), kCurrentWidth(50))];
    _messageLabel.text = @"教育近些年来，网络教育发展迅速，用户数量也在逐年递增，您觉得它今后的展前景如何？网络教育最终真的会和传统教育平起平坐吗？";
    _messageLabel.font = kSystem(13);
    _messageLabel.textColor = kLBBlackColor;
    _messageLabel.numberOfLines = 3;
    [self addSubview:_messageLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(162), kCurrentWidth(25), kCurrentWidth(150), kCurrentWidth(14))];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_priceLabel];
    
    _numberLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _numberLabel.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(22), 75, kCurrentWidth(20));
    _numberLabel.adjustsImageWhenHighlighted = NO;
    [_numberLabel setTitleColor:kLBNineColor forState:UIControlStateNormal];
    [_numberLabel setTitle:@"帮助过0人" forState:UIControlStateNormal];
    [_numberLabel setImage:[UIImage imageNamed:@"list_icon_user"] forState:UIControlStateNormal];
    _numberLabel.titleLabel.font = kSystem(11);
    _numberLabel.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    _numberLabel.titleEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(6), 0, 0);
    [self addSubview:_numberLabel];
    
    _starView = [[StarView alloc] initWithFrame:CGRectMake(_numberLabel.right+kCurrentWidth(5), _numberLabel.top+kCurrentWidth(5), kCurrentWidth(78), kCurrentWidth(10))];
    [self addSubview:_starView];
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
