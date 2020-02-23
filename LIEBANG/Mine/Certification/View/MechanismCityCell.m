//
//  MechanismCityCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/10/29.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "MechanismCityCell.h"

static NSArray *cityArray;
@interface MechanismCityCell ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UITextField *contentTf;
@property (nonatomic,strong)UIView *buttonContentView;

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UILabel *messageLabel;

@end

@implementation MechanismCityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        cityArray = @[@"北京",@"上海",@"广州",@"深圳",@"其他"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(80), kCurrentWidth(44))];
        _titleLabel.font = kSystem(14);
        _titleLabel.textColor = kLBBlackColor;
        [self.contentView addSubview:_titleLabel];
        
        _buttonContentView = [[UIView alloc] initWithFrame:CGRectMake(_titleLabel.right, 0, kDeviceWidth-_titleLabel.right-kCurrentWidth(13), kCurrentWidth(44))];
        _buttonContentView.backgroundColor = kWhiteColor;
        [self.contentView addSubview:_buttonContentView];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _buttonContentView.bottom, kDeviceWidth, 0.5)];
        _lineView.backgroundColor = kSepparteLineColor;
        [self.contentView addSubview:_lineView];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(15), _lineView.bottom, SCREEN_WIDTH - kCurrentWidth(32), 0)];
        _messageLabel.font = kSystem(13);
        _messageLabel.textColor = kLBBlackColor;
        _messageLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_messageLabel];
        
        [self createCityButtonWith:cityArray];
    }
    return self;
}

- (CGFloat)cellHeight {
    return self.height;
}

- (void)createCityButtonWith:(NSArray *)buttonArray {
    
    CGFloat spaceWidth = (_buttonContentView.width-kCurrentWidth(250))/4;
    
    [_buttonContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < buttonArray.count; i ++) {
        UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
        sender.frame = CGRectMake((kCurrentWidth(50)+spaceWidth)*i, kCurrentWidth(12), kCurrentWidth(50), kCurrentWidth(20));
        [sender setTitle:[buttonArray safeObjectAtIndex:i] forState:UIControlStateNormal];
        [sender setTitleColor:kLBBlackColor forState:UIControlStateNormal];
        [sender setTitleColor:kLBRedColor forState:UIControlStateSelected];
        [sender setBackgroundColor:kWhiteColor];
        sender.titleLabel.font = kSystem(14);
        sender.layer.cornerRadius = kCurrentWidth(10);
        sender.layer.masksToBounds = YES;
        sender.layer.borderColor = kLBBlackColor.CGColor;
        sender.layer.borderWidth = 0.5;
        sender.tag = 100 + i;
        if ([[buttonArray safeObjectAtIndex:i] isEqualToString:self.companyModel.city]) {
            sender.selected = YES;
            sender.layer.borderColor = kLBRedColor.CGColor;
        }
        [sender addTarget:self action:@selector(selectCityClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonContentView addSubview:sender];
    }
}

- (void)setModel:(MechanismModel *)model {
    _model = model;
    
    if (![cityArray containsObject:model.city]) {
        _messageLabel.text = model.city;
    }
    else {
        _messageLabel.text = @"";
    }
    
    if (IsStrEmpty(_messageLabel.text) || IsNilOrNull(_messageLabel.text))
    {
        _messageLabel.height = 0;
    }
    else
    {
        _messageLabel.height = kCurrentWidth(44);
    }
    
    self.height = _messageLabel.bottom;
    
    NSString *selectGameText = @"*";
    NSString *allSelectGameText = [[LBForProject currentProject].ORCertiCellTitleArray safeObjectAtIndex:self.indexPath.row];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectGameText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithHexString:@"FB3F3F"]
                 range:[allSelectGameText rangeOfString:selectGameText]];
    _titleLabel.attributedText = attr;
}

- (void)setCompanyModel:(CompanyModel *)companyModel {
    _companyModel = companyModel;
    
    if (![cityArray containsObject:companyModel.city]) {
        _messageLabel.text = companyModel.city;
    }
    else {
        _messageLabel.text = @"";
    }
    
    if (IsStrEmpty(_messageLabel.text) || IsNilOrNull(_messageLabel.text))
    {
        _messageLabel.height = 0;
    }
    else
    {
        _messageLabel.height = kCurrentWidth(44);
    }
    [self createCityButtonWith:cityArray];
    self.height = _messageLabel.bottom;
    
    NSString *selectGameText = @"*";
    NSString *allSelectGameText = [[LBForProject currentProject].comCertiCellTitleArray safeObjectAtIndex:self.indexPath.row];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectGameText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithHexString:@"FB3F3F"]
                 range:[allSelectGameText rangeOfString:selectGameText]];
    _titleLabel.attributedText = attr;
}

#pragma mark
#pragma mark Event
- (void)selectCityClick:(UIButton *)sender {
    
    for (int i = 0; i < cityArray.count; i++) {
        UIButton *button = [self viewWithTag:100+i];
        button.selected = NO;
        button.layer.borderColor = kLBBlackColor.CGColor;
    }
    sender.selected = YES;
    sender.layer.borderColor = kLBRedColor.CGColor;
    
    if (_editCitySourceBlock) {
        _editCitySourceBlock(sender.tag-100,[sender currentTitle]);
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
