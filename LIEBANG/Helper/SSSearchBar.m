//
//  SSSearchBar.m
//  Demo
//
//  Created by xk jiang on 2017/10/10.
//  Copyright © 2017年 xk jiang. All rights reserved.
//

#import "SSSearchBar.h"
//#import "UIImage+Tool.h"

@interface SSSearchBar () <UITextFieldDelegate>
{
    UIButton *searchButton;
}
// placeholder 和icon 和 间隙的整体宽度
@property (nonatomic, assign) CGFloat placeholderWidth;

@end

// icon宽度
static CGFloat const searchIconW = 20.0;
// icon与placeholder间距
static CGFloat const iconSpacing = 10.0;
// 占位文字的字体大小
static CGFloat const placeHolderFont = 15.0;

@implementation SSSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        // 设置背景图片
            UIImage *backImage = [UIImage createImageWithColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1]];
            [self setBackgroundImage:backImage];
            for (UIView *view in [self.subviews lastObject].subviews) {
                
                if ([view isKindOfClass:[UITextField class]]) {
                    UITextField *field = (UITextField *)view;
                    // 重设field的frame
                    field.frame = CGRectMake(kCurrentWidth(32), kCurrentWidth(15), self.frame.size.width-kCurrentWidth(64), kCurrentWidth(35));
                    [field setBackgroundColor:[UIColor whiteColor]];
                    field.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                    
        //            field.borderStyle = UITextBorderStyleNone;
                    field.layer.cornerRadius = 3.0f;
                    field.layer.masksToBounds = YES;
                    
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, kCurrentWidth(35))];
                    view.backgroundColor = kWhiteColor;
                    field.leftView = view;
                    field.leftViewMode = UITextFieldViewModeAlways;
                    
                    // 设置占位文字字体颜色
                    [field setValue:[UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
                    [field setValue:[UIFont systemFontOfSize:placeHolderFont] forKeyPath:@"_placeholderLabel.font"];
                    
                    searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    searchButton.frame = CGRectMake(0, 0, 45, field.height);
        //            [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
                    [searchButton setImage:[UIImage imageNamed:@"nav_button_search"] forState:UIControlStateNormal];
                    [searchButton setTitleColor:kLBSixColor forState:UIControlStateNormal];
                    searchButton.titleLabel.font = [UIFont systemFontOfSize:placeHolderFont];
                    field.rightView = searchButton;
                    field.rightViewMode = UITextFieldViewModeAlways;
                    searchButton.hidden = YES;
                    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (@available(iOS 11.0, *)) {
                        // 先默认居中placeholder
                        [self setPositionAdjustment:UIOffsetMake((field.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
                    }
                }
            }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *view in self.subviews.lastObject.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            view.layer.contents = nil;
            break;
        }
    }
}

- (void)searchButtonClick {
    if (self.searchTfButtonBlock) {
        self.searchTfButtonBlock(self.text);
    }
}

// 开始编辑的时候重置为靠左
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // 继续传递代理方法
    searchButton.hidden = NO;
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        [self.delegate searchBarShouldBeginEditing:self];
    }
    if (@available(iOS 11.0, *)) {
        [self setPositionAdjustment:UIOffsetZero forSearchBarIcon:UISearchBarIconSearch];
    }
    return YES;
}
// 结束编辑的时候设置为居中
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    searchButton.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        [self.delegate searchBarShouldEndEditing:self];
    }
    if (@available(iOS 11.0, *)) {
        [self setPositionAdjustment:UIOffsetMake((textField.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
    }
    return YES;
}

// 计算placeholder、icon、icon和placeholder间距的总宽度
- (CGFloat)placeholderWidth {
    if (!_placeholderWidth) {
        CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:placeHolderFont]} context:nil].size;
        _placeholderWidth = size.width + iconSpacing + searchIconW;
    }
    return _placeholderWidth;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
