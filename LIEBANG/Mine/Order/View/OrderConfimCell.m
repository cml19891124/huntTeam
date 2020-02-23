//
//  OrderConfimCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/4.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "OrderConfimCell.h"

static NSArray *titleArray;
@interface OrderConfimCell ()

@property (nonatomic,strong)UIView *content;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *otherLabel;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIView *lineView1;
@property (nonatomic,strong)UIButton *selectButton;
@property (nonatomic,strong)UIButton *selectButton1;


@property (nonatomic,strong)UIButton *addButton;

@end

@implementation OrderConfimCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setDetailModel:(ThemeOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
    if (!IsStrEmpty(detailModel.mettingEdnTime) && !IsNilOrNull(detailModel.mettingEdnTime))
    {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.lineView1];
        [self.contentView addSubview:self.otherLabel];
        [self.contentView addSubview:self.selectButton];
        [self.contentView addSubview:self.selectButton1];
        [self.contentView addSubview:self.addButton];
        
        if ([detailModel.serviceType intValue] == 0)
        {
            [self.addButton setTitle:@"预约时间地点" forState:UIControlStateNormal];
            self.titleLabel.text = @"行家提出的见面时间和地点";
        }
        else
        {
            [self.addButton setTitle:@"预约时间" forState:UIControlStateNormal];
            self.titleLabel.text = @"行家提出的见面时间";
        }
        
        [self createMessageLabel:detailModel];
    }
    else
    {
        if ([detailModel.serviceType intValue] == 0)
        {
            [self.addButton setTitle:@"预约时间地点" forState:UIControlStateNormal];
        }
        else
        {
            [self.addButton setTitle:@"预约时间" forState:UIControlStateNormal];
        }
        
        self.addButton.hidden = NO;
        [self.contentView addSubview:self.addButton];
        self.height = kCurrentWidth(60);
    }
}

//用户未确认预约前，可以修改
- (void)createMessageLabel:(ThemeOrderDetailModel *)detailModel {//0:线下约见 1：全国通话
    
    if ([detailModel.serviceType intValue] == 0)
    {
        titleArray = @[@"开始时间",@"结束时间",@"地       点",@"详细地址"];
    }
    else if ([detailModel.serviceType intValue] == 1)
    {
        titleArray = @[@"开始时间",@"结束时间"];
    }
    
    CGFloat totalHeight = kCurrentWidth(16);
    [self.content.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < titleArray.count; i ++) {
        
        NSString *string;
        if (i == 0) {
            string = [NSString stringWithFormat:@"%@:%@",[titleArray safeObjectAtIndex:i],detailModel.mettingBeginTime];
        }
        else if (i == 1) {
            string = [NSString stringWithFormat:@"%@:%@",[titleArray safeObjectAtIndex:i],detailModel.mettingEdnTime];
        }
        else if (i == 2) {
            string = [NSString stringWithFormat:@"%@:%@",[titleArray safeObjectAtIndex:i],detailModel.mettingAddress];
        }
        else if (i == 3) {
            string = [NSString stringWithFormat:@"%@:%@",[titleArray safeObjectAtIndex:i],detailModel.detailedAddress];
        }
        
        CGSize size = [string sizeWithFont:kSystem(13) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(62), MAXFLOAT)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(42), totalHeight, kDeviceWidth-kCurrentWidth(62), size.height)];
        label.numberOfLines = 0;
        label.text = string;
        label.textColor = kLBNineColor;
        label.font = kSystem(13);
        [self.content addSubview:label];
        
        totalHeight += (size.height + kCurrentWidth(8));
    }
    self.content.height = totalHeight+kCurrentWidth(8);
    self.lineView1.top = self.content.bottom;
    self.selectButton.center = CGPointMake(kCurrentWidth(25), self.content.centerY);
    
    if ([detailModel.orderStates intValue] == 10 || [detailModel.orderStates intValue] == 4 || [detailModel.orderStates intValue] == 11 || [detailModel.orderStates intValue] == 3)
    {
        self.addButton.hidden = YES;
        self.selectButton1.hidden = YES;
        self.otherLabel.hidden = YES;
        self.selectButton.hidden = YES;
        self.height = self.lineView1.bottom;
    }
    else
    {
        if (self.detailType == QuestionDetailTypeStudent)
        {
            self.addButton.hidden = YES;
            self.selectButton1.hidden = NO;
            self.otherLabel.hidden = NO;
            self.otherLabel.top = self.lineView1.bottom;
            self.selectButton1.center = CGPointMake(kCurrentWidth(25), self.otherLabel.centerY);
            self.height = self.otherLabel.bottom;
        }
        else if (self.detailType == QuestionDetailTypeExpert)
        {
            self.addButton.hidden = NO;
            self.selectButton1.hidden = YES;
            self.selectButton.hidden = YES;
            self.otherLabel.hidden = YES;
            self.addButton.top = self.lineView1.bottom + kCurrentWidth(15);
            self.height = self.addButton.bottom+kCurrentWidth(15);
            
            if ([detailModel.serviceType intValue] == 0)
            {
                [self.addButton setTitle:@"修改预约时间地点" forState:UIControlStateNormal];
            }
            else
            {
                [self.addButton setTitle:@"修改时间" forState:UIControlStateNormal];
            }
        }
    }
    
}

- (CGFloat)getCellHeight {
    return self.height;
}

#pragma mark Event
- (void)addButtonClick {
    if (_messageButtonBlock) {
        _messageButtonBlock();
    }
}

- (void)selectButtonClick {
    self.selectButton.selected = YES;
    self.selectButton1.selected = NO;
    [Config currentConfig].isMessage = @"NO";
}

- (void)otherButtonClick {
    self.selectButton.selected = NO;
    self.selectButton1.selected = YES;
    [Config currentConfig].isMessage = @"YES";
}

#pragma mark UI
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(50), kDeviceWidth, 0.5)];
        _lineView.backgroundColor = kSepparteLineColor;
    }
    return _lineView;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.content.bottom, kDeviceWidth, 0.5)];
        _lineView1.backgroundColor = kSepparteLineColor;
    }
    return _lineView1;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kDeviceWidth-kCurrentWidth(48), kCurrentWidth(50))];
        _titleLabel.text = @"行家提出的见面时间和地点";
        _titleLabel.font = kSystem(15);
        _titleLabel.textColor = kLBBlackColor;
    }
    return _titleLabel;
}

- (UILabel *)otherLabel {
    if (!_otherLabel) {
        _otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(50), self.lineView1.bottom, kDeviceWidth-kCurrentWidth(48), kCurrentWidth(50))];
        _otherLabel.text = @"以上都不合适，私信沟通协商确定";
        _otherLabel.font = kSystem(13);
        _otherLabel.textColor = kLBFiveColor;
    }
    return _otherLabel;
}

- (UIView *)content {
    if (!_content) {
        _content = [[UIView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), self.lineView.bottom, kDeviceWidth-kCurrentWidth(50), kCurrentWidth(100))];
        _content.backgroundColor = kWhiteColor;
    }
    return _content;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(0, 0, kCurrentWidth(50), kCurrentWidth(50));
        [_selectButton setImage:[UIImage imageNamed:@"icon_weixuanzhong_normal"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"icon_sel_login"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _selectButton.selected = YES;
    }
    return _selectButton;
}

- (UIButton *)selectButton1 {
    if (!_selectButton1) {
        _selectButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton1.frame = CGRectMake(0, 0, kCurrentWidth(50), kCurrentWidth(50));
        [_selectButton1 setImage:[UIImage imageNamed:@"icon_weixuanzhong_normal"] forState:UIControlStateNormal];
        [_selectButton1 setImage:[UIImage imageNamed:@"icon_sel_login"] forState:UIControlStateSelected];
        [_selectButton1 addTarget:self action:@selector(otherButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton1;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake((kDeviceWidth-kCurrentWidth(160))/2, kCurrentWidth(15), kCurrentWidth(160), kCurrentWidth(30));
        _addButton.layer.cornerRadius = kCurrentWidth(15);
        _addButton.layer.masksToBounds = YES;
        _addButton.layer.borderColor = kLBRedColor.CGColor;
        _addButton.layer.borderWidth = 0.5;
        [_addButton setTitle:@"预约时间地点" forState:UIControlStateNormal];
        [_addButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
        _addButton.titleLabel.font = kSystemBold(15);
        [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
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
