//
//  CustomSegment.m
//  Storm
//
//  Created by 朱攀峰 on 15/12/18.
//  Copyright (c) 2015年 MCDS. All rights reserved.
//

#import "CustomSegment.h"
#import "NSArray+SNFoundation.h"

@interface CustomSegment()
{
    BOOL setupFinished;
}

@property (nonatomic,strong)NSArray *buttons;
@property (nonatomic,strong)NSArray *lines;
@end

@implementation CustomSegment

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kBackgroundColor;
        _selectedFont = 13;
        _hasCenterLine = YES;
        [self commonSetup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedFont = 13;
        _hasCenterLine = YES;
        [self commonSetup];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonSetup];
}

- (void)commonSetup
{
    if (setupFinished) {
        return;
    }
    
    self.backgroundColor = kBackgroundColor;
    
    setupFinished = YES;
}

- (void)setItems:(NSArray *)items
{
    if (_items != items) {
        _items = items;
        
        [self setButtons];
        
        [self setBottomLine:self.bottomLine];
    }
}

- (void)setinitCurrentIndex
{
    for (int i = 0; i < self.items.count; i++) {
        UIButton *btn = (UIButton *)[self.buttons safeObjectAtIndex:i];
        if (!IsNilOrNull(btn)) {
            [btn setTitleColor:[self getBtnColorAtIndex:i] forState:UIControlStateNormal];
            btn.titleLabel.font = [self getBtnFontAtIndex:i];
        }
    }
    
    self.currentIndex = 0;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex >= self.buttons.count) {
        return;
    }
    
    if (currentIndex != _currentIndex) {
        _currentIndex = currentIndex;
        
        for (int i = 0; i<[self.buttons count]; i++) {
            UIButton *btn = (UIButton *)[self.buttons safeObjectAtIndex:i];
            [btn setTitleColor:[self getBtnColorAtIndex:i] forState:UIControlStateNormal];
            btn.titleLabel.font = [self getBtnFontAtIndex:i];
            btn.selected = NO;
        }
        
        UIButton *button = (UIButton *)[self.buttons safeObjectAtIndex:_currentIndex];
        button.selected = YES;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(segment:didSelectedAtIndex:)]) {
        [_delegate segment:self didSelectedAtIndex:_currentIndex];
    }
}

- (UIColor *)getBtnColorAtIndex:(NSInteger)index
{
    if (self.currentIndex == index) {
        if (_settingColor) {
            return _settingColor;
        }else{
            return kBlackColor;
        }
    }else{
        return kBlackColor;
    }
}
- (UIFont *)getBtnFontAtIndex:(NSInteger)index
{
    if (self.currentIndex == index) {
        return kSystem(_selectedFont);
    }else{
        return kSystem(13);
    }
}
- (void)setButtons
{
    NSInteger count = [_items count];
    CGFloat width = self.bounds.size.width / count;
    CGFloat height = self.bounds.size.height;
    NSMutableArray *btnArr = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *lineArr = [NSMutableArray arrayWithCapacity:count-1];
    for (int i = 0; i < _items.count; i++) {
        NSString *title = [_items safeObjectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*width, 0, width, height-15);
        [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [self getBtnFontAtIndex:i];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitleColor:[self getBtnColorAtIndex:i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[self.imageItems safeObjectAtIndex:i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[self.selectItems safeObjectAtIndex:i]] forState:UIControlStateSelected];
        [btn setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(70, 70) space:10];
        btn.backgroundColor = kBackgroundColor;
        if (i == 0) {
            btn.selected = YES;
        }
        
        [btnArr addObject:btn];
        [self addSubview:btn];
    }
    self.buttons = btnArr;
    self.lines = lineArr;
}

- (void)buttonTapped:(id)sender
{
    NSInteger index = [(UIButton *)sender tag];
    
    self.currentIndex = index;
}
- (void)setButtonsEnable:(NSInteger)count enable:(BOOL)enable
{
    if (IsArrEmpty(self.items)) {
        return;
    }
    if (count > self.items.count) {
        return;
    }
    for (int i = 0; i < self.items.count; i++) {
        UIButton *btn = (UIButton *)[self.buttons safeObjectAtIndex:i];
        if (!IsNilOrNull(btn)) {
            btn.enabled = enable;
        }
    }
    
    for (int i = 0; i < count; i++) {
        UIButton *btn = (UIButton *)[self.buttons safeObjectAtIndex:i];
        if (!IsNilOrNull(btn)) {
            btn.enabled = enable;
        }
    }
}

- (void)setButtonTitle:(NSInteger)index title:(NSString *)title
{
    if (IsArrEmpty(self.items)) {
        return;
    }
    if (index >= self.items.count) {
        return;
    }
    
    for (int i = 0; i < self.buttons.count; i++) {
        if (i == index) {
            UIButton *btn = (UIButton *)[self.buttons safeObjectAtIndex:i];
            if (!IsNilOrNull(btn)) {
                [btn setTitle:title forState:UIControlStateNormal];
            }
        }
    }
}
@end
