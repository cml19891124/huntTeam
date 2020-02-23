//
//  MTSearchBar.m
//  TreasureApp
//
//  Created by caominglei on 2019/9/15.
//  Copyright © 2019 caominglei. All rights reserved.
//

#import "MTSearchBar.h"


@implementation MTSearchBar
// icon宽度
static CGFloat const searchIconW = 20.0;
// icon与placeholder间距
static CGFloat const iconSpacing = 10.0;
// 占位文字的字体大小
static CGFloat const placeHolderFont = 15.0;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.frame = CGRectMake(0,0,300, 30);
        self.font = kSystem(13);
        self.placeholder = @"  搜索人脉";
        self.textAlignment = NSTextAlignmentLeft;
        // 提前在Xcode上设置图片中间拉伸
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        
        // 通过init初始化的控件大多都没有尺寸
        UIButton *searchIcon = [[UIButton alloc] init];
        [searchIcon setImage:IMAGE_NAMED(@"nav_button_search") forState:UIControlStateNormal];;
        [searchIcon addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];

        [searchIcon setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        // contentMode：default is UIViewContentModeScaleToFill，要设置为UIViewContentModeCenter：使图片居中，防止图片填充整个imageView
        searchIcon.contentMode = UIViewContentModeCenter;
        searchIcon.frame = CGRectMake(0,0,40, 40);
        
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName : kLBSixColor,NSFontAttributeName : kSystem(13)}];
        self.attributedPlaceholder = placeholderString;
        
        UIView *leftView = [[UIView alloc] init];
        leftView.frame = CGRectMake(0,0,10,35);
        leftView.contentMode = UIViewContentModeCenter;
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;

                        
        self.rightView = searchIcon;
        self.rightViewMode = UITextFieldViewModeAlways;

    }
    return self;
}

+(instancetype)searchBar
{
    return [[self alloc] init];
}

- (void)searchButtonClick {
    if (self.searchTfButtonBlock) {
        self.searchTfButtonBlock(self.text);
    }
}
/*
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
}*/
@end
