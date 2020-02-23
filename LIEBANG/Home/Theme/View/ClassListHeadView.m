//
//  ClassHeadView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/10.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ClassListHeadView.h"

@interface ClassListHeadView ()

@end

@implementation ClassListHeadView

- (instancetype)initWithTitleArray:(NSArray *)titleArray 
{
    self = [super init];
    if (self) {
        self.backgroundColor = kBackgroundColor;
        self.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(54));

        [self createButtonWithArray:titleArray];
    }
    return self;
}

- (void)createButtonWithArray:(NSArray *)titleArray {
    
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((kDeviceWidth/titleArray.count)*i, 0, kDeviceWidth/titleArray.count, kCurrentWidth(44));
        [button setTitle:[titleArray safeObjectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:kLBFiveColor forState:UIControlStateNormal];
        [button setTitleColor:kLBRedColor forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"btn_shouqi"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_zhankai"] forState:UIControlStateSelected];
        [button setImgViewStyle:ButtonImgViewStyleRight imageSize:CGSizeMake(10, 10) space:5];
        button.titleLabel.font = kSystem(14);
        button.backgroundColor = kWhiteColor;
        [self addSubview:button];
    }
}

@end
