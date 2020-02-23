//
//  PriceLabel.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/20.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PriceLabel.h"

@interface PriceLabel ()

@property (nonatomic,strong)UILabel *usePriceLabel;
@property (nonatomic,strong)UILabel *oldPriceLabel;
@property (nonatomic,strong)UIImageView *icon;
@property (nonatomic,strong)UIView *lineView;

@end

@implementation PriceLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        
        [self createSubViews];
    }
    return self;
}

- (void)setUsePrice:(NSString *)usePrice oldPrice:(NSString *)oldPrice {
    _oldPrice = oldPrice;
    _usePrice = usePrice;
    
    if ([oldPrice doubleValue] == 0.00f && [usePrice doubleValue] == 0.00f)
    {
        _lineView.hidden = YES;
        _oldPriceLabel.hidden = YES;
        _icon.hidden = YES;
        _usePriceLabel.hidden = YES;
        
    }
    else
    {
        if ([usePrice doubleValue] == [oldPrice doubleValue] || [oldPrice doubleValue] == 0.f)
        {
            _lineView.hidden = YES;
            _oldPriceLabel.hidden = YES;
            _icon.hidden = YES;
            _usePriceLabel.hidden = NO;
            
            
            NSString *selectText = [NSString stringWithFormat:@"%.2f",[usePrice doubleValue]];
            NSString *allSelectText = [NSString stringWithFormat:@"%.2f猎帮币",[usePrice doubleValue]];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
            [attr addAttribute:NSFontAttributeName
                         value:kSystemBold(15)
                         range:[allSelectText rangeOfString:selectText]];
            _usePriceLabel.attributedText = attr;
            
            CGSize useSize = [allSelectText sizeWithFont:kSystemBold(14) maxSize:CGSizeMake(MAXFLOAT, self.height)];
            
            if (_priceTextAlignment == NSTextAlignmentLeft)
            {
                _usePriceLabel.frame = CGRectMake(0, 0, useSize.width, self.height);
            }
            else if (_priceTextAlignment == NSTextAlignmentRight)
            {
                _usePriceLabel.frame = CGRectMake(self.width-useSize.width, 0, useSize.width, self.height);
            }
        }
        else
        {
            _lineView.hidden = NO;
            _oldPriceLabel.hidden = NO;
            _icon.hidden = NO;
            _usePriceLabel.hidden = NO;
            
            _oldPriceLabel.text = [NSString stringWithFormat:@"%.2f猎帮币/次",[oldPrice doubleValue]];
            CGSize oldSize = [_oldPriceLabel.text sizeWithFont:kSystem(10) maxSize:CGSizeMake(MAXFLOAT, self.height)];
                    
            NSString *selectText = [NSString stringWithFormat:@"%.2f",[usePrice doubleValue]];
            NSString *allSelectText = [NSString stringWithFormat:@"%.2f猎帮币/次",[usePrice doubleValue]];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
            [attr addAttribute:NSFontAttributeName
                         value:kSystemBold(15)
                         range:[allSelectText rangeOfString:selectText]];
            _usePriceLabel.attributedText = attr;
            
            CGSize useSize = [allSelectText sizeWithFont:kSystemBold(14) maxSize:CGSizeMake(MAXFLOAT, self.height)];

            if (_priceTextAlignment == NSTextAlignmentLeft)
            {
                _icon.frame = CGRectMake(0, (self.height-kCurrentWidth(13))/2, kCurrentWidth(13), kCurrentWidth(13));
                _usePriceLabel.frame = CGRectMake(_icon.width+2, 0, useSize.width, self.height);
                _oldPriceLabel.frame = CGRectMake(_usePriceLabel.right+5, 2, oldSize.width, self.height);
                _lineView.frame = CGRectMake(0, (self.height-0.5)/2, oldSize.width, 0.5);
            }
            else if (_priceTextAlignment == NSTextAlignmentRight)
            {
                _oldPriceLabel.frame = CGRectMake(self.width-oldSize.width, 2, oldSize.width, self.height);
                _usePriceLabel.frame = CGRectMake(self.width-oldSize.width-useSize.width-5, 0, useSize.width, self.height);
                _lineView.frame = CGRectMake(0, (self.height-0.5)/2, oldSize.width, 0.5);
                _icon.frame = CGRectMake(self.width-oldSize.width-useSize.width-kCurrentWidth(18), (self.height-kCurrentWidth(13))/2, kCurrentWidth(13), kCurrentWidth(13));
            }
        }
    }
}

#pragma mark 界面布局
- (void)createSubViews {
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _icon.image = [UIImage imageNamed:@"list_icon_hui"];
    [self addSubview:_icon];
    
    _usePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _usePriceLabel.textColor = kLBRedColor;
    _usePriceLabel.font = kSystemBold(12);
    _usePriceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_usePriceLabel];
    
    _oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _oldPriceLabel.textColor = kLBNineColor;
    _oldPriceLabel.font = kSystem(10);
    _oldPriceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_oldPriceLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5)];
    _lineView.backgroundColor = kLBNineColor;
    [_oldPriceLabel addSubview:_lineView];
    
}

@end
