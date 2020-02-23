//
//  CommonTabBar.m
//  Storm
//
//  Created by 朱攀峰 on 15/11/27.
//  Copyright (c) 2015年 MCDS. All rights reserved.
//

#import "CommonTabBar.h"

@interface CommonTabBar ()

@property (nonatomic,strong)NSMutableArray *buttons;

@property (nonatomic,assign)NSInteger tabbarHeight;

@end

@implementation CommonTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _buttons = [NSMutableArray array];
        CommonTabBarDTO *dataSource = [[CommonTabBarDTO alloc] init];
        self.dataSource = dataSource;
        
        self.tabbarHeight = kCurrentWidth(self.height);
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    NSUInteger tagCounter = _dataSource.dataArray.count;
    float width = self.frame.size.width/tagCounter;
    for (int i = 0; i < tagCounter; i++) {
        CommonDTO1 *dto = [_dataSource.dataArray objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.titleLabel.font = kSystem(10);
        [button setTitle:dto.title forState:UIControlStateNormal];
        [button setTitleColor:kLBSixColor forState:UIControlStateNormal];
        [button setTitleColor:kLBRedColor forState:UIControlStateSelected];
        [button setImage:dto.normalImage forState:UIControlStateNormal];
        [button setImage:dto.selectedImage forState:UIControlStateSelected];
        [button setFrame:CGRectMake(width*i, 0, width, self.height)];
        [button setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(25, 25) space:3];
        [button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 1) {
            UIView *readView = [[UIView alloc] initWithFrame:CGRectMake(width/2+10, 6, 6, 6)];
            readView.layer.cornerRadius = 3;
            readView.layer.masksToBounds = YES;
            readView.backgroundColor = kRedColor;
            readView.tag = 999999;
            readView.hidden = YES;
            [button addSubview:readView];
        }
        
        [self addSubview:button];
        [_buttons addObject:button];
    }
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    image.image = [UIImage imageNamed:@"tab_button_al"];
    image.center = CGPointMake(kDeviceWidth/2, 6);
    [self addSubview:image];
    
    _selectedButton = [_buttons firstObject];
    _selectedButton.selected = YES;
}

- (void)setSelectedButton:(UIButton *)selectedButton {
    _selectedButton.selected = NO;
    selectedButton.selected = YES;
    _selectedButton = selectedButton;
}

- (void)setSelectedButtonIndex:(NSInteger)index {
    UIButton *selectedButton = [_buttons objectAtIndex:index];
    if (_selectedButton == selectedButton) {
        return;
    }
    _selectedButton.selected = NO;
    selectedButton.selected = YES;
    _selectedButton = selectedButton;
}

- (void)didMoveToSuperview {
    [self setSelectedButton:[_buttons firstObject]];
}

- (void)tabButtonPressed:(UIButton *)sender {
    if (_selectedButton == sender) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RCDataManager shareManager] refreshBadgeValue];
    });
    
    NSUInteger btnIndex = [_buttons indexOfObject:sender];
    [_delegate tabBar:self didPressButton:sender atIndex:btnIndex];
    [self setSelectedButton:sender];
}

@end
