//
//  LBButton.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/30.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "LBButton.h"

@interface LBButton ()



@end

@implementation LBButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"chongzhi_liebangbi"] forState:UIControlStateSelected];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.font = kSystem(14);
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = kSepparteLineColor.CGColor;
        self.layer.borderWidth = 0.5;

    }
    return self;
}

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;

    NSString *allString = [NSString stringWithFormat:@"%.2f猎帮币\n%@元",[titleString floatValue],titleString];
    NSString *topString = [NSString stringWithFormat:@"%.2f猎帮币",[titleString floatValue]];
    NSString *bottomString = [NSString stringWithFormat:@"%@元",titleString];
    NSString *string = [NSString stringWithFormat:@"%.2f",[titleString floatValue]];
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:allString attributes:nil]];
    text.yy_color = kLBNineColor;
    [text yy_setColor:kLBThreeColor range:[allString rangeOfString:topString]];
    [text yy_setFont:kSystemBold(14) range:[allString rangeOfString:string]];
    [text yy_setFont:kSystem(10) range:[allString rangeOfString:@"猎帮币"]];
    [text yy_setFont:kSystem(10) range:[allString rangeOfString:bottomString]];
    [self setAttributedTitle:text forState:UIControlStateNormal];
    
    NSMutableAttributedString *selecText = [NSMutableAttributedString new];
    [selecText appendAttributedString:[[NSAttributedString alloc] initWithString:allString attributes:nil]];
    selecText.yy_color = kLBNineColor;
    [selecText yy_setColor:kLBRedColor range:[allString rangeOfString:topString]];
    [selecText yy_setFont:kSystemBold(14) range:[allString rangeOfString:string]];
    [selecText yy_setFont:kSystem(10) range:[allString rangeOfString:@"猎帮币"]];
    [selecText yy_setFont:kSystem(10) range:[allString rangeOfString:bottomString]];
    [self setAttributedTitle:selecText forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.layer.borderColor = kClearColor.CGColor;
    }
    else {
        self.layer.borderColor = kSepparteLineColor.CGColor;
    }
}

@end
