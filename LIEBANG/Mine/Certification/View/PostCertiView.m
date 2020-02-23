//
//  PostCertiView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/3.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PostCertiView.h"

@interface PostCertiView ()

@property (nonatomic,strong)UIView *backView;

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UIImageView *icon;

@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,strong)UIButton *albumButton;
@property (nonatomic,strong)UIButton *cameraButton;

@property (nonatomic,strong)UIView *contentView;

@end

@implementation PostCertiView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight);
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight)];
        _backView.backgroundColor = [UIColor colorWithHexString:@"1B1B1B"];
        _backView.alpha = 0.9;
        [self addSubview:_backView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(20))];
        _titleLabel.font = kSystem(18);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kWhiteColor;
        [self addSubview:_titleLabel];
        
        _icon = [[UIImageView alloc] init];
        [self addSubview:_icon];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = kSystem(15);
        _detailLabel.textColor = kWhiteColor;
        _detailLabel.numberOfLines = 0;
        [self addSubview:_detailLabel];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight-kNavBarHeight-kCurrentWidth(136), kDeviceWidth, kCurrentWidth(136))];
        _contentView.backgroundColor = kSepparteLineColor;
        [self addSubview:_contentView];
        
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraButton.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(45));
        _cameraButton.backgroundColor = kWhiteColor;
        [_cameraButton setTitle:@"拍照" forState:UIControlStateNormal];
        [_cameraButton setTitleColor:kLBBlackColor forState:UIControlStateNormal];
        _cameraButton.titleLabel.font = kSystem(16);
        [_cameraButton addTarget:self action:@selector(cameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_cameraButton];
        
        _albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _albumButton.frame = CGRectMake(0, _cameraButton.bottom+kCurrentWidth(0.5), kDeviceWidth, kCurrentWidth(45));
        _albumButton.backgroundColor = kWhiteColor;
        [_albumButton setTitle:@"从手机相册选择" forState:UIControlStateNormal];
        [_albumButton setTitleColor:kLBBlackColor forState:UIControlStateNormal];
        _albumButton.titleLabel.font = kSystem(16);
        [_albumButton addTarget:self action:@selector(albumButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_albumButton];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, _albumButton.bottom+kCurrentWidth(0.5), kDeviceWidth, kCurrentWidth(45));
        _cancelButton.backgroundColor = kWhiteColor;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:kLBBlackColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = kSystem(16);
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_cancelButton];
        
        
    }
    return self;
}

- (void)setType:(PostCertiViewType)type {
    _type = type;
    
    switch (type) {
        case PostCertiViewCard:
        {
            _titleLabel.text = @"名片拍摄技巧";
            _titleLabel.center = CGPointMake(kDeviceWidth/2, kCurrentWidth(77));
            _icon.image = [UIImage imageNamed:@"img_mingpianpaishe"];
            _icon.frame = CGRectMake(kCurrentWidth(39), kCurrentWidth(121), kCurrentWidth(294), kCurrentWidth(221));
            
            NSString *selectText1 = @"【手持纸质名片拍摄】";
            NSString *selectText2 = @"【材料将对所有人可见】";
            NSString *allSelectText = @"1.须【手持纸质名片拍摄】，确保姓名、公司、职位、手机号拍摄清晰，请勿遮挡。\n2.【材料将对所有人可见】，如材料中含手机号等隐私信息，系统将自动打码处理。";
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
            [attr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"FF9650"]
                         range:[allSelectText rangeOfString:selectText1]];
            [attr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"FF9650"]
                         range:[allSelectText rangeOfString:selectText2]];
            
            CGSize size = [allSelectText sizeWithFont:kSystem(15) maxSize:CGSizeMake(kCurrentWidth(320), MAXFLOAT)];
            _detailLabel.frame = CGRectMake(kCurrentWidth(39), _icon.bottom+kCurrentWidth(kCurrentWidth(10)), kCurrentWidth(320), size.height);
            _detailLabel.attributedText = attr;
        }
            break;
        case PostCertiViewProof:
        {
            _titleLabel.text = @"在职证明拍摄技巧";
            _titleLabel.center = CGPointMake(kDeviceWidth/2, kCurrentWidth(110));
            _icon.image = [UIImage imageNamed:@"img_zaizhipaishe"];
            _icon.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(188), kCurrentWidth(198), kCurrentWidth(227));
            
            NSString *selectText1 = @"【材料将对所有人可见】";
            NSString *selectText2 = @"【手指挡住局部以拍摄】";
            NSString *allSelectText = @"1.确保公司/职位、姓名信息区域拍摄清晰。\n2.【材料将对所有人可见】，如含联系方式隐私信息，建议【手指挡住局部以拍摄】。";
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
            [attr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"FF9650"]
                         range:[allSelectText rangeOfString:selectText1]];
            [attr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"FF9650"]
                         range:[allSelectText rangeOfString:selectText2]];
            
            CGSize size = [allSelectText sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(230), MAXFLOAT)];
            _detailLabel.frame = CGRectMake(_icon.right+kCurrentWidth(3), _icon.top+kCurrentWidth(6), kDeviceWidth-kCurrentWidth(230), size.height);
            _detailLabel.attributedText = attr;
        }
            break;
        case PostCertiViewLicense:
        {
            _titleLabel.text = @"营业执照拍摄技巧";
            _titleLabel.center = CGPointMake(kDeviceWidth/2, kCurrentWidth(130));
            _icon.image = [UIImage imageNamed:@"img_yingyezhizhaopaishe"];
            _icon.frame = CGRectMake(kCurrentWidth(12), kCurrentWidth(201), kCurrentWidth(198), kCurrentWidth(220));
            
            NSString *selectText1 = @"【材料将对所有人可见】";
            NSString *selectText2 = @"【手指挡住局部以拍摄】";
            NSString *allSelectText = @"1.确保公司/法人信息区域拍摄清晰。\n2.【材料将对所有人可见】，如含联系方式隐私信息，建议【手指挡住局部以拍摄】。";
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
            [attr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"FF9650"]
                         range:[allSelectText rangeOfString:selectText1]];
            [attr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"FF9650"]
                         range:[allSelectText rangeOfString:selectText2]];
            
            CGSize size = [allSelectText sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(230), MAXFLOAT)];
            _detailLabel.frame = CGRectMake(_icon.right+kCurrentWidth(4), _icon.top+kCurrentWidth(6), kDeviceWidth-kCurrentWidth(230), size.height);
            _detailLabel.attributedText = attr;
        }
            break;
        case PostCertiViewWorkCard:
        {
            _titleLabel.text = @"工牌拍摄技巧";
            _titleLabel.center = CGPointMake(kDeviceWidth/2, kCurrentWidth(122));
            _icon.image = [UIImage imageNamed:@"img_gongpaipaishe"];
            _icon.frame = CGRectMake(kCurrentWidth(17), kCurrentWidth(177), kCurrentWidth(192), kCurrentWidth(232));
            
            NSString *selectText1 = @"【材料将对所有人可见】";
            NSString *selectText2 = @"【手指挡住局部以拍摄】";
            NSString *allSelectText = @"1.确保公司/职位、姓名信息区域拍摄清晰。\n2.【材料将对所有人可见】，如含联系方式隐私信息，建议【手指挡住局部以拍摄】。";
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
            [attr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"FF9650"]
                         range:[allSelectText rangeOfString:selectText1]];
            [attr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"FF9650"]
                         range:[allSelectText rangeOfString:selectText2]];
            
            CGSize size = [allSelectText sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(230), MAXFLOAT)];
            _detailLabel.frame = CGRectMake(_icon.right+kCurrentWidth(5), _icon.top+kCurrentWidth(48), kDeviceWidth-kCurrentWidth(230), size.height);
            _detailLabel.attributedText = attr;
        }
            break;
        case PostCertiViewDegree:
        {
            _titleLabel.text = @"学位证拍摄技巧";
            _titleLabel.center = CGPointMake(kDeviceWidth/2, kCurrentWidth(90));
            _icon.image = [UIImage imageNamed:@"jpg_xueweizheng"];
            _icon.frame = CGRectMake(kCurrentWidth(28), kCurrentWidth(123), kCurrentWidth(320), kCurrentWidth(237));
            
            NSString *selectText1 = @"【材料将对所有人可见】";
            NSString *allSelectText = @"1.确保学校/姓名区域拍摄清晰。\n2.【材料将对所有人可见】，如材料中含隐私信息，建议手指挡住局部拍摄。";
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
            [attr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"FF9650"]
                         range:[allSelectText rangeOfString:selectText1]];
            
            CGSize size = [allSelectText sizeWithFont:kSystem(15) maxSize:CGSizeMake(kCurrentWidth(300), MAXFLOAT)];
            _detailLabel.frame = CGRectMake(kCurrentWidth(28), _icon.bottom+kCurrentWidth(10), kCurrentWidth(300), size.height);
            _detailLabel.attributedText = attr;
        }
            break;
        case PostCertiViewDiploma:
        {
            _titleLabel.text = @"毕业证拍摄技巧";
            _titleLabel.center = CGPointMake(kDeviceWidth/2, kCurrentWidth(90));
            _icon.image = [UIImage imageNamed:@"pic_biyezhengpaishe"];
            _icon.frame = CGRectMake(kCurrentWidth(37), kCurrentWidth(134), kCurrentWidth(300), kCurrentWidth(222));
            
            NSString *selectText1 = @"【材料将对所有人可见】";
            NSString *allSelectText = @"1.确保学校/姓名区域拍摄清晰。\n2.【材料将对所有人可见】，如材料中含隐私信息，建议手指挡住局部拍摄。";
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
            [attr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"FF9650"]
                         range:[allSelectText rangeOfString:selectText1]];
            
            CGSize size = [allSelectText sizeWithFont:kSystem(15) maxSize:CGSizeMake(kCurrentWidth(300), MAXFLOAT)];
            _detailLabel.frame = CGRectMake(kCurrentWidth(37), _icon.bottom+kCurrentWidth(10), kCurrentWidth(300), size.height);
            _detailLabel.attributedText = attr;
        }
            break;
        default:
            break;
    }
}

#pragma mark Event
- (void)cameraButtonClick {
    if (_postCertiViewBlock) {
        _postCertiViewBlock(1);
    }
}

- (void)albumButtonClick {
    if (_postCertiViewBlock) {
        _postCertiViewBlock(2);
    }
}

- (void)cancelButtonClick {
    if (_postCertiViewBlock) {
        _postCertiViewBlock(0);
    }
}

@end
