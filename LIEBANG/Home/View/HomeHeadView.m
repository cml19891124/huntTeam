//
//  HomeHeadView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "HomeHeadView.h"

#import "AppClassifyButton.h"

static NSArray *titleArray;
static NSArray *imageArray;

@interface HomeHeadView ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong)UIView *lineView1;
@property (nonatomic,strong)UIView *lineView2;

@property (nonatomic,strong)UILabel *homeTitleLabel;
@property (nonatomic,strong)UILabel *homeMessageLabel;

@property (nonatomic,strong)UIView *contentView;

@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;

@end

@implementation HomeHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        titleArray = @[@"职场发展",@"互联网+",@"创业者",@"投资人",@"教育学习",@"养老护理",@"生活时尚",@"全部分类"];
        imageArray = @[@"list_button_zhichang",@"list_button_hulianwang",@"list_button_chuanghyezhe",@"list_button_touziren",@"list_button_jiaoyu",@"list_button_yanglao",@"list_button_shenghuo",@"list_button_quanbu"];
        [self addSubview:self.cycleScrollView];
        [self createSubViews];
    }
    return self;
}

- (void)setModel:(HomeModel *)model {
    _model = model;
    
    NSMutableArray *array = [NSMutableArray array];
    for (IndexBanner *dto in model.indexBanner) {
        [array addObject:dto.bannerUrl];
    }
    
    _cycleScrollView.imageURLStringsGroup = array;
    
    [self createHomeButtonWithModel:model];
}

- (void)homeButtonClick:(UIButton *)sender {
    if (_homeButtonBlock) {
        _homeButtonBlock(sender.tag-10);
    }
}

#pragma mark 界面布局
- (void)createSubViews {
    
    _lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(266), kDeviceWidth, kCurrentWidth(9))];
    _lineView1.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    [self addSubview:_lineView1];
    
    
    _homeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(17), kCurrentWidth(223), kDeviceWidth-kCurrentWidth(34), kCurrentWidth(19))];
    _homeTitleLabel.textColor = kBlackColor;
    _homeTitleLabel.text = @"猎帮";
    _homeTitleLabel.font = kSystem(15);
    [self addSubview:_homeTitleLabel];
    
    _homeMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(17), _homeTitleLabel.bottom, kDeviceWidth-kCurrentWidth(34), kCurrentWidth(15))];
    _homeMessageLabel.textColor = kLBNineColor;
    _homeMessageLabel.text = @"猎帮";
    _homeMessageLabel.font = kSystem(13);
    [self addSubview:_homeMessageLabel];
    [self createHomeButtonWithArray];
}

- (void)createHomeButtonWithArray {
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _lineView1.bottom, kDeviceWidth, kCurrentWidth(160))];
    _contentView.backgroundColor = kWhiteColor;
    [self addSubview:_contentView];
    
    for (int i = 0; i < titleArray.count; i ++) {
        AppClassifyButton *homeButton = [[AppClassifyButton alloc] initWithFrame:CGRectMake((kDeviceWidth/4)*(i%4), kCurrentWidth(80)*(i/4), kDeviceWidth/4, kCurrentWidth(80))];
        homeButton.tag = 10+i;
        [homeButton addTarget:self action:@selector(homeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:homeButton];
    }
}

- (void)createHomeButtonWithModel:(HomeModel *)model {
    
    [_contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _contentView.height = (model.appClassify.count-1)/4*kCurrentWidth(80)+kCurrentWidth(80);
    for (int i = 0; i < model.appClassify.count; i ++) {
        
        AppClassify *dto = [model.appClassify safeObjectAtIndex:i];
        AppClassifyButton *homeButton = [[AppClassifyButton alloc] initWithFrame:CGRectMake((kDeviceWidth/4)*(i%4), kCurrentWidth(80)*(i/4), kDeviceWidth/4, kCurrentWidth(80))];
        homeButton.tag = 10+i;
        homeButton.imageString = dto.icon;
        homeButton.contentString = dto.classify;
        [homeButton addTarget:self action:@selector(homeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:homeButton];
    }
    
    _lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, _contentView.bottom+4, kDeviceWidth, kCurrentWidth(9))];
    _lineView2.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    [self addSubview:_lineView2];
    
    self.height = _lineView2.bottom;
}

- (UIImage*)originImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (_bannerBlock) {
        _bannerBlock(index);
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    IndexBanner *dto = [self.model.indexBanner safeObjectAtIndex:index];
    self.homeTitleLabel.text = dto.title;
    self.homeMessageLabel.text = dto.content;
}

#pragma mark - Setter && Getter
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(217)) delegate:self placeholderImage:[UIImage imageNamed:@"home_scrollView_logo"]];
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
