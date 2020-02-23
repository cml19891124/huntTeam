//
//  SearchFriendHeadView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/25.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "SearchFriendHeadView.h"
#import "SSSearchBar.h"
#import "MTSearchBar.h"

@interface SearchFriendHeadView ()<UISearchBarDelegate,UITextFieldDelegate>

@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UILabel *titleLabel;
//@property (nonatomic,strong)UIButton *searchButton;
@property (nonatomic,strong)MTSearchBar *searchBar;

@end

@implementation SearchFriendHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kBackgroundColor;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(72))];
    _backImageView.image = [UIImage imageNamed:@"img_background"];
    [self addSubview:_backImageView];
    
//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(72), kDeviceWidth-kCurrentWidth(24), kCurrentWidth(32))];
//    _titleLabel.textColor = kLBBlackColor;
//    _titleLabel.font = kSystem(13);
//    _titleLabel.text = @"你可能感兴趣的好友";
//    [self addSubview:_titleLabel];
    
    WeakSelf;
    _searchBar = [[MTSearchBar alloc] init];
    _searchBar.backgroundColor = kWhiteColor;
    _searchBar.returnKeyType = UIReturnKeySearch;
    _searchBar.layer.cornerRadius = 4;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索人脉";
#pragma mark -  UISearchBar 黑线处理导致崩溃 之前为了处理搜索框的黑线问题，通常会遍历 searchBar 的 subViews，找到并删除 UISearchBarBackground。在 iOS13 中这么做会导致 UI 渲染失败，然后直接崩溃，崩溃信息如下：*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Missing or detached view for search bar layout'
    for(UIView *view in[[[_searchBar subviews] lastObject] subviews]) {
        if([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            view.layer.contents = nil;
            break;
        }
    }
    _searchBar.searchTfButtonBlock = ^(NSString *keyWord) {
        if (weakSelf.searchButtonBlock) {
            weakSelf.searchButtonBlock(keyWord);
        }
        [weakSelf resignFirstResponder];

        [weakSelf.searchBar resignFirstResponder];
    };
    [self addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.mas_equalTo(self).offset(-15);
           make.centerY.mas_equalTo(self);
           make.left.mas_equalTo(15);
           make.height.mas_equalTo(36.f);
       }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.searchButtonBlock) {
        self.searchButtonBlock(textField.text);
    }

    [self resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_searchBar resignFirstResponder];
}

- (void)resignSearchFirstResponder {
    [_searchBar resignFirstResponder];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _searchBar.placeholder = placeholder;
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"搜索人脉==%@",searchBar.text);
    if (_searchButtonBlock) {
        _searchButtonBlock(searchBar.text);
    }
    [searchBar resignFirstResponder];
}

@end
