//
//  NoDataView.m
//  Lottery
//
//  Created by  YIQI on 2018/5/24.
//  Copyright © 2018年 zhong. All rights reserved.
//

#import "NoDataView.h"

@interface NoDataView ()

@property (nonatomic,strong)UIImageView *noDataImage;
@property (nonatomic,strong)UILabel *label;

@end

@implementation NoDataView


- (instancetype)initWithHeight:(CGFloat)height
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kDeviceWidth, height);
        
        
        
        _noDataImage = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(100))/2, (height-kCurrentWidth(120))/2, kCurrentWidth(100), kCurrentWidth(69))];
        _noDataImage.image = [UIImage imageNamed:@"icon_no_data"];
        [self addSubview:_noDataImage];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(_noDataImage.left, _noDataImage.bottom+kCurrentWidth(14), kCurrentWidth(100), kCurrentWidth(17))];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor colorWithHexString:@"B6B6B6"];
        _label.text = @"暂无数据哦";
        _label.adjustsFontSizeToFitWidth = YES;
        _label.font = kSystem(15);
        [self addSubview:_label];
    }
    return self;
}

- (void)setTitleString:(NSString *)titleString {
    _label.text = titleString;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        _noDataImage = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(163))/2, kCurrentWidth(150), kCurrentWidth(163), kCurrentWidth(117))];
//        _noDataImage.image = [UIImage imageNamed:@"icon_no_data"];
//        [self addSubview:_noDataImage];
//        
//        _label = [[UILabel alloc] initWithFrame:CGRectMake(_noDataImage.left, _noDataImage.bottom+kCurrentWidth(40), kCurrentWidth(163), kCurrentWidth(17))];
//        _label.textAlignment = NSTextAlignmentCenter;
//        _label.textColor = [UIColor colorWithHexString:@"4D4D4D"];
//        _label.text = @"暂无数据哦";
//        [self addSubview:_label];
//    }
//    return self;
//}

@end
