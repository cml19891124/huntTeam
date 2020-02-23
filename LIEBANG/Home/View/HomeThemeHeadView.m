//
//  HomeThemeHeadView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "HomeThemeHeadView.h"

@interface HomeThemeHeadView ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;

@end

@implementation HomeThemeHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.titleLabel];
        [self addSubview:self.cycleScrollView];
    }
    return self;
}

- (void)setModel:(HomeModel *)model {
    _model = model;
    NSMutableArray *array = [NSMutableArray array];
    for (TopicBanner *dto in model.topicBanner) {
        [array addObject:dto.bannerUrl];
    }
    
    _cycleScrollView.imageURLStringsGroup = array;
}

#pragma mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (_bannerBlock) {
        _bannerBlock(index);
    }
}

#pragma mark 界面布局
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(49))];
        _titleLabel.textColor = kBlackColor;
        _titleLabel.text = @"推荐话题";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kSystemBold(15);
    }
    return _titleLabel;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(49), kDeviceWidth-kCurrentWidth(24), kCurrentWidth(174)) delegate:self placeholderImage:[UIImage imageNamed:@"home_scrollView_logo"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
//        _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
//        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
//        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.layer.masksToBounds = YES;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _cycleScrollView;
}

@end
