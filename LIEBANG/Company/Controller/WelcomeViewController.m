//
//  WelcomeViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "WelcomeViewController.h"
#import "CompanyFeeViewController.h"
#import "PayViewController.h"
#import "CompanyService.h"
#import "CompanyFeeModel.h"
#import "CompanyService.h"
#import "CompanyModel.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)UILabel *welcomeLabel;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UIButton *buyButton;
@property (nonatomic,strong)UIImageView *adImageView;
@property (nonatomic,strong)UIView *contentView;
//@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)UIImageView *headIcon;
@property (nonatomic,strong)StaffModel *companyModel;
@property (nonatomic,strong)NameLabel *nameLabel;
@property (nonatomic,strong)PostionLabel *postionLabel;
@property (nonatomic,strong)UILabel *tipLabel;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getWelcomeMessage];
    [self createSubViewUI];
}

- (void)getWelcomeMessage {
    
    [self displayOverFlowActivityView];
    [CompanyService getCompanyWelcomeWithSuccess:^(StaffModel * _Nonnull data) {
        [self removeOverFlowActivityView];
        
        if (IsNilOrNull(data)) {
            [self messageViewHidden:YES];
            
        }
        else {
            if (IsNilOrNull(data.userName) || IsStrEmpty(data.userName)) {
                [self messageViewHidden:YES];
            }
            else {
                [self messageViewHidden:NO];
            }
        }
        self.companyModel = data;
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
        [self messageViewHidden:YES];
    }];
}

- (void)messageViewHidden:(BOOL)hidden {
    _headIcon.hidden = hidden;
    _tipLabel.hidden = hidden;
    _nameLabel.hidden = hidden;
    _postionLabel.hidden = hidden;
}

- (void)setCompanyModel:(StaffModel *)companyModel {
    _companyModel = companyModel;
    
    _nameLabel.userUid = companyModel.userUid;
    _postionLabel.userUid = companyModel.userUid;
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:companyModel.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
    [_nameLabel setNameString:companyModel.userName showIcon:companyModel.isBasic];
    _postionLabel.labelWidth = _tipLabel.left-_headIcon.right-kCurrentWidth(20);
    [_postionLabel setCompany:companyModel.company postion:companyModel.position showIcon:companyModel.isOccupation];
    
    WeakSelf;
    _postionLabel.GetWorkCertiImageViewBlock = ^(NSString *imageUrl) {
        [weakSelf pushToMosaicVC:imageUrl];
    };
    _nameLabel.GetBasicCertiImageViewBlock = ^(NSString *imageUrl) {
        [weakSelf pushToMosaicVC:imageUrl];
    };
}

#pragma mark
#pragma mark Events
- (void)buyButtonClick {
    if (self.isContiues) {
        
        if ([self.level intValue] == 0)
        {
            CompanyFeeViewController *nextCtr = [[CompanyFeeViewController alloc] init];
            nextCtr.isContiues = !self.isContiuesTwo;
            nextCtr.isContiuesII = YES;
            nextCtr.enterpriseId = self.companyUid;
            nextCtr.companyUid = self.companyUid;
            nextCtr.serviceType = @"企业名片";
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else
        {
            CompanyFeeViewController *nextCtr = [[CompanyFeeViewController alloc] init];
            nextCtr.isContiues = !self.isContiuesTwo;
            nextCtr.isContiuesII = YES;
            nextCtr.enterpriseId = self.companyUid;
            nextCtr.companyUid = self.companyUid;
            nextCtr.serviceType = @"企业名片";
            [self.navigationController pushViewController:nextCtr animated:YES];
//            [self displayOverFlowActivityView];
//            [CompanyService getCompanyPayListWithSuccess:^(NSArray * _Nonnull data) {
//                [self removeOverFlowActivityView];
//                NSString *payPrice;
//                for (CompanyFeeModel *model in data) {
//                    if ([model.level isEqualToString:self.level]) {
//                        payPrice = model.cost;
//                        break;
//                    }
//                }
//
//                PayViewController *nextCtr = [[PayViewController alloc] init];
//                nextCtr.isContiues = !self.isContiuesTwo;
//                nextCtr.isContiuesII = YES;
//                nextCtr.enterpriseId = self.companyUid;
//                nextCtr.level = self.level;
//                nextCtr.serviceType = @"企业名片";
//                nextCtr.questionPri = payPrice;
//                [self.navigationController pushViewController:nextCtr animated:YES];
//
//            } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
//                [self removeOverFlowActivityView];
//                [self presentSheet:errorStr];
//            }];
        }
    }
    else {
        CompanyFeeViewController *nextCtr = [[CompanyFeeViewController alloc] init];
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}

- (void)backButtonClick {
    [self backNavItemTapped];
}

#pragma mark
#pragma mark UI
- (void)createSubViewUI {
    self.view.backgroundColor = kWhiteColor;
    
    _adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kCurrentWidth(358)-kViewHeight)];
    _adImageView.image = [UIImage imageNamed:@"company_backimage"];
    [self.view addSubview:_adImageView];
    
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kDeviceWidth, kDeviceHeight-kNavBarHeight)];
//    _scrollView.backgroundColor = kClearColor;
//    _scrollView.bounces = NO;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.showsVerticalScrollIndicator = NO;
//
//    if (isIphone4 || isIphone5 || isIphone6 || isIphone6p) {
//        _scrollView.contentSize = CGSizeMake(0, kDeviceHeight-kNavBarHeight+kCurrentWidth(358)-kNavBarHeight-kNavBarHeight);
//    }
//    else {
//        _scrollView.contentSize = CGSizeMake(0, kDeviceHeight-kNavBarHeight+kCurrentWidth(358)-kNavBarHeight);
//    }
//
//    [self.view addSubview:_scrollView];

    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight-kCurrentWidth(368)-kViewHeight, kDeviceWidth, kDeviceHeight-kNavBarHeight)];
    _contentView.backgroundColor = kWhiteColor;
    _contentView.layer.masksToBounds = YES;
    _contentView.layer.cornerRadius = kCurrentWidth(10);
    [self.view addSubview:_contentView];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(kCurrentWidth(12), kStatusBarViewHeight+kCurrentWidth(11), kCurrentWidth(25), kCurrentWidth(25));
    [_backButton setImage:[UIImage imageNamed:@"company_back"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _backButton.hidden = !self.isRefee;
    [self.view addSubview:_backButton];
    
    _welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(16), kCurrentWidth(20), kDeviceWidth-kCurrentWidth(32), kCurrentWidth(64))];
    _welcomeLabel.text = @"欢迎您\n加入猎帮企业AI智能名片";
    _welcomeLabel.textColor = kLBBlackColor;
    _welcomeLabel.font = kSystemBold(29);
    _welcomeLabel.numberOfLines = 2;
    _welcomeLabel.adjustsFontSizeToFitWidth = YES;
    [_contentView addSubview:_welcomeLabel];
    
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(16), _welcomeLabel.bottom, kDeviceWidth-kCurrentWidth(32), kCurrentWidth(66))];
    _messageLabel.textColor = kLBBlackColor;
    _messageLabel.font = kSystem(21);
    _messageLabel.numberOfLines = 3;
    _messageLabel.text = @"帮助企业构建基于移动互联网场景下的“企业AI智能名片”，开启全新商务社交，助力企业提升销售效率。";
    _messageLabel.adjustsFontSizeToFitWidth = YES;
    [_contentView addSubview:_messageLabel];
    
    _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyButton.frame = CGRectMake((kDeviceWidth-kCurrentWidth(130))/2, kCurrentWidth(238), kCurrentWidth(130), kCurrentWidth(40));
    _buyButton.backgroundColor = kLBRedColor;
    _buyButton.layer.cornerRadius = kCurrentWidth(20);
    _buyButton.layer.masksToBounds = YES;
    [_buyButton setTitle:self.isContiues?@"立即续费":@"立即购买" forState:UIControlStateNormal];
    [_buyButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _buyButton.titleLabel.font = kSystem(15);
    [_buyButton setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
    [_buyButton setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateHighlighted];
    [_buyButton setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateSelected];

    [_buyButton addTarget:self action:@selector(buyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_buyButton];
    
    _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(16), kCurrentWidth(168), kCurrentWidth(40), kCurrentWidth(40))];
    _headIcon.layer.cornerRadius = kCurrentWidth(20);
    _headIcon.layer.masksToBounds = YES;
    _headIcon.image = [UIImage imageNamed:@"no_headIcon"];
    [_contentView addSubview:_headIcon];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(16)-120, _headIcon.top, 120, kCurrentWidth(40))];
    _tipLabel.font = kSystem(13);
    _tipLabel.numberOfLines = 2;
    _tipLabel.textAlignment = NSTextAlignmentRight;
    _tipLabel.text = @"推荐您使用\n猎帮企业AI智能名片";
    [_contentView addSubview:_tipLabel];
    
    _nameLabel = [[NameLabel alloc] initWithFrame:CGRectMake(_headIcon.right+kCurrentWidth(5), _headIcon.top+kCurrentWidth(5), kDeviceWidth-_headIcon.right-115-kCurrentWidth(20), kCurrentWidth(17))];
    _nameLabel.labelFont = kSystem(15);
    [_nameLabel setNameString:@"高雅娜" showIcon:@"0"];
    [_contentView addSubview:_nameLabel];
    
    _postionLabel = [[PostionLabel alloc] initWithFrame:CGRectMake(_headIcon.right+kCurrentWidth(5), _nameLabel.bottom, kDeviceWidth-_headIcon.right-115-kCurrentWidth(20), kCurrentWidth(14))];
    _postionLabel.font = kSystem(12);
    _postionLabel.color = kLBSixColor;
    [_postionLabel setCompany:nil postion:@"数字100平台运营总监" showIcon:@"1"];
    [_contentView addSubview:_postionLabel];
    [self messageViewHidden:YES];
    
}

@end
