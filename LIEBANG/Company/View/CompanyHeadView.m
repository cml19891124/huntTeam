//
//  CompanyHeadView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CompanyHeadView.h"
#import "CompanyCell.h"
#import "HMScannerController.h"

@interface CompanyHeadView ()

@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)CompanyCell *companyView;
@property (nonatomic,strong)UIView *contentView;

@property (nonatomic,strong)UIImageView *codeIcon;

@end

@implementation CompanyHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        self.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(456+35));
        self.backgroundColor = kWhiteColor;
        WeakSelf;
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(209))];
        _headImageView.image = [UIImage imageNamed:@"home_scrollView_logo"];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        [self addSubview:_headImageView];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(219), kDeviceWidth, kCurrentWidth(227 + 35))];
        _contentView.backgroundColor = kWhiteColor;
        [self addSubview:_contentView];
        
        _companyView = [[CompanyCell alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(227 + 35))];
        _companyView.companyState = CompanyCellStateDisable;
        
        _companyView.allPersonnelMessageBlock = ^(NSString * _Nonnull uid) {
            [weakSelf allPersonnel:uid];
        };
        _companyView.width = kDeviceWidth;
        _companyView.height = kCurrentWidth(227 + 35);

        [_contentView addSubview:_companyView];
        
    }
    return self;
}

- (void)setDetailModel:(CompanyModel *)detailModel {
    _detailModel = detailModel;
    
    _companyView.companyModel = detailModel;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.background] placeholderImage:[UIImage imageNamed:@"home_scrollView_logo"]];
    NSString *address = [NSString stringWithFormat:@"地址：%@%@",detailModel.city?:@"",detailModel.region?:@""];
    CGFloat heigjt = BoundWithSize(address, kDeviceWidth, 12).size.height;
    _companyView.height = kCurrentWidth(227 + 35 + heigjt);

    NSString *scanUrl = [NSString stringWithFormat:@"http://liebangapp.com/share/#/company?id=%@&userUid=%@",detailModel.id,[Config currentConfig].userUid];
    
    if (self.isCompanyPoster) {
        [_companyView showCompanyPosterMessage];
        self.height = kCurrentWidth(590 + 50);
        _codeIcon = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(105))/2, _companyView.bottom+kCurrentWidth(30), kCurrentWidth(105), kCurrentWidth(105))];
        [self.contentView addSubview:_codeIcon];
        
        UIImage *mark = [UIImage imageNamed:@"icon-60"];
        [HMScannerController cardImageWithCardName:scanUrl avatar:mark scale:0.2 completion:^(UIImage *image) {
            self.codeIcon.image = image;
        }];
    }
}

- (void)setIsCompanyPoster:(BOOL)isCompanyPoster {
    _isCompanyPoster = isCompanyPoster;
    
    if (isCompanyPoster) {
//        [_companyView showCompanyPosterMessage];
//        self.height = kCurrentWidth(590);
//        _codeIcon = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(105))/2, _companyView.bottom+kCurrentWidth(35), kCurrentWidth(105), kCurrentWidth(105))];
//        _codeIcon.image = [UIImage imageNamed:@"erweima"];
//        [self.contentView addSubview:_codeIcon];
    }
}

- (void)allPersonnel:(NSString *)uid {
    if (_allPersonnelBlock) {
        _allPersonnelBlock(uid);
    }
}

@end
