//
//  AccountSelfCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountSelfCell.h"

@interface AccountSelfCell ()

@property (nonatomic,strong)UIButton *detailButton;
@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation AccountSelfCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)setModel:(AccountInfo *)model {
    _model = model;
    
    if (IsStrEmpty(model.userIntroduce))
    {
        _titleLabel.text = @"暂无添加自我介绍";
        _detailButton.hidden = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        CGSize size = [_titleLabel.text sizeWithFont:kSystem(14) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(26), kCurrentWidth(53))];
        
        _titleLabel.frame = CGRectMake(kCurrentWidth(13), kCurrentWidth(15), kDeviceWidth-kCurrentWidth(26), size.height);
        self.height = _titleLabel.bottom+kCurrentWidth(15);
    }
    else
    {
        _titleLabel.text = model.userIntroduce;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        
        CGSize size1 = [model.userIntroduce sizeWithFont:kSystem(14) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(26), kCurrentWidth(53))];
        CGSize size2 = [model.userIntroduce sizeWithFont:kSystem(14) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(26), MAXFLOAT)];
        
                //设置行距
        NSMutableParagraphStyle *paraphStyle = [[NSMutableParagraphStyle alloc] init];
                paraphStyle.lineSpacing = 4;
        NSDictionary *attrDict = @{                                NSParagraphStyleAttributeName:paraphStyle,//样式
                                          };
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text attributes:attrDict];
        _titleLabel.attributedText = attr;
        
        if (size2.height > size1.height)
        {
            _detailButton.hidden = NO;
            _detailButton.selected = model.isOpen;
            
            if (_detailButton.selected)
            {
                _titleLabel.numberOfLines = 0;
                _titleLabel.frame = CGRectMake(kCurrentWidth(13), kCurrentWidth(15), kDeviceWidth-kCurrentWidth(26), size2.height + 10);
                _detailButton.top = _titleLabel.bottom+kCurrentWidth(15);

            }
            else
            {
                _titleLabel.numberOfLines = 3;
                _titleLabel.frame = CGRectMake(kCurrentWidth(13), kCurrentWidth(15), kDeviceWidth-kCurrentWidth(26), size1.height + 10);
                _detailButton.top = _titleLabel.bottom+kCurrentWidth(15);

            }
            self.height = _detailButton.bottom+kCurrentWidth(25);
        }
        else
        {
            _detailButton.hidden = YES;
            _titleLabel.numberOfLines = 3;
            _titleLabel.frame = CGRectMake(kCurrentWidth(13), kCurrentWidth(15), kDeviceWidth-kCurrentWidth(26), size1.height + 15);
            self.height = _titleLabel.bottom+kCurrentWidth(15);
        }
    }
}


- (CGFloat)getHeight {
    return self.height;
}

- (void)createSubViews {
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), kCurrentWidth(15), kDeviceWidth-kCurrentWidth(26), kCurrentWidth(53))];
    _titleLabel.font = kSystem(14);
    _titleLabel.textColor = [UIColor colorWithHexString:@"000011"];
    _titleLabel.numberOfLines = 3;
    [self.contentView addSubview:_titleLabel];
    
    _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _detailButton.frame = CGRectMake((kDeviceWidth-kCurrentWidth(125))/2, _titleLabel.bottom+kCurrentWidth(14), kCurrentWidth(125), kCurrentWidth(30));
    [_detailButton setTitle:@"展开查看更多" forState:UIControlStateNormal];
    [_detailButton setTitle:@"收起全部" forState:UIControlStateSelected];
    [_detailButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
    _detailButton.titleLabel.font = kSystem(15);
    _detailButton.layer.cornerRadius = kCurrentWidth(15);
    _detailButton.layer.masksToBounds = YES;
    _detailButton.layer.borderColor = kLBRedColor.CGColor;
    _detailButton.layer.borderWidth = 0.5f;
    _detailButton.hidden = YES;
    [_detailButton addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_detailButton];
}

- (void)detailButtonClick {
    
    _detailButton.selected = !_detailButton.selected;
    self.model.isOpen = _detailButton.selected;
    if (_confimButtonBlock) {
        _confimButtonBlock();
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
