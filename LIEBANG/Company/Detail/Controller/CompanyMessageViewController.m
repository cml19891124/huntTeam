//
//  CompanyMessageViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/8.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "CompanyMessageViewController.h"

@interface CompanyMessageViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;

@end

@implementation CompanyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.messageLabel];
    [self showMessageWith:self.detailState];
}

- (void)showMessageWith:(CompanyDetailCellState)detailState {
    
    switch (detailState) {
        case CompanyDetailCellCompanyInfo:
        {
            self.navigationItem.title = @"公司详细介绍";
            self.messageLabel.text = self.detailModel.companyInfo;
            [self loadImagesWithArray:self.detailModel.companyInfoImages];
        }
            break;
        case CompanyDetailCellProductService:
        {
            self.navigationItem.title = @"产品服务";
            self.messageLabel.text = self.detailModel.productService;
            [self loadImagesWithArray:self.detailModel.productServiceImages];
        }
            break;
        case CompanyDetailCellCompanyDiscuss:
        {
            
        }
            break;
        case CompanyDetailCellrecruit:
        {
            self.navigationItem.title = @"人员招聘";
            self.messageLabel.text = self.detailModel.recruit;
            [self loadImagesWithArray:self.detailModel.recruitImages];
        }
            break;
        default:
            break;
    }
}

- (void)loadImagesWithArray:(NSArray *)imageArray {
    if (imageArray.count == 0) {
        return;
    }
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(210)*i+kCurrentWidth(10), kDeviceWidth-kCurrentWidth(24), kCurrentWidth(200))];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray safeObjectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"home_scrollView_logo"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    CGSize size = [self.messageLabel.text sizeWithFont:kSystem(14) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), MAXFLOAT)];
    self.messageLabel.top = self.cycleScrollView.bottom + kCurrentWidth(10);// kCurrentWidth(210)*imageArray.count+kCurrentWidth(10);
    self.messageLabel.height = size.height;
    self.scrollView.contentSize = CGSizeMake(0, self.messageLabel.bottom+kCurrentWidth(15));
    [self.scrollView addSubview:_cycleScrollView];

    _cycleScrollView.imageURLStringsGroup = imageArray;

}

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
        _cycleScrollView.autoScroll = NO;
    }
    return _cycleScrollView;
}

#pragma mark
#pragma mark 懒加载
- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12),self.cycleScrollView.bottom + kCurrentWidth(10), kDeviceWidth-kCurrentWidth(24), 0)];
        _messageLabel.textColor = kLBBlackColor;
        _messageLabel.font = kSystem(14);
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight)];
        _scrollView.contentSize = CGSizeMake(0, kDeviceHeight-kNavBarHeight-kViewHeight);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

@end
