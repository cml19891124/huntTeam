//
//  HomeQuestionHeadView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "HomeQuestionHeadView.h"
#import "HomeButton.h"

@interface HomeQuestionHeadView ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIButton *moreButton;

@property (nonatomic,strong)HomeButton *questionButton;
@property (nonatomic,strong)HomeButton *meetButton;

@property (nonatomic,strong)UILabel *companyLabel;//推荐企业智能Ai名片title
@property (nonatomic,strong)UIButton *companyButton;//企业名片AI更多
@property (nonatomic,strong)UIView *companyLine;//企业名片AI线
@property (nonatomic,strong)NSArray *companyArray;//企业名片数组

@end

@implementation HomeQuestionHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self createSubViews];
        
    }
    return self;
}

- (void)setModel:(HomeModel *)model {
    _model = model;
    
    self.companyArray = model.enterprise;
    if (model.enterprise.count > 4) {
        [self hiddenCompanyView:NO];
        //企业推荐名片按钮下的横线垂直坐标调整
        _lineView.top = kCurrentWidth(301)+kCurrentWidth(10);
    }
    else if (IsArrEmpty(model.enterprise)) {
        [self hiddenCompanyView:YES];
        _lineView.top = kCurrentWidth(107)+kCurrentWidth(10);
    }
    else {
        [self hiddenCompanyView:NO];
        _lineView.top = kCurrentWidth(231)+kCurrentWidth(10);
    }
    _titleLabel.top = _lineView.bottom;
    _moreButton.top = _lineView.bottom;
}

- (void)hiddenCompanyView:(BOOL)hidden {
    _companyLine.hidden = hidden;
    _companyLabel.hidden = hidden;
    _companyButton.hidden = hidden;
}

- (void)setCompanyArray:(NSArray *)companyArray {
    _companyArray = companyArray;
    
    CGFloat width = (kDeviceWidth-(kCurrentWidth(53)*4))/5;
    NSInteger count = MIN(8, companyArray.count);
    for (int i = 0; i < count; i++) {
        UIImageView *company = [[UIImageView alloc] init];
        company.layer.borderColor = [UIColor colorWithHexString:@"C3C3C3"].CGColor;
        company.layer.borderWidth = 0.5;
        company.layer.cornerRadius = kCurrentWidth(26.5);
        company.layer.masksToBounds = YES;
        company.frame = CGRectMake(width+(width+kCurrentWidth(53))*(i%4), _companyLabel.bottom+kCurrentWidth(70)*(i/4), kCurrentWidth(53), kCurrentWidth(53));
        company.backgroundColor = kWhiteColor;
        company.tag = 100+i;
        [company setContentScaleFactor:[[UIScreen mainScreen]scale]];
        company.contentMode = UIViewContentModeScaleAspectFill;
        company.autoresizingMask = UIViewAutoresizingNone;
        
        Enterprise *model = [companyArray safeObjectAtIndex:i];
        [company sd_setImageWithURL:[NSURL URLWithString:model.companyLogo] placeholderImage:[UIImage imageNamed:@"home_button_logo"]];
        company.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterAccountEvent:)];
        [company addGestureRecognizer:tap];
        [self addSubview:company];
    }
}

- (void)questionButtonClick {
    if (_questionButtonBlock) {
        _questionButtonBlock();
    }
}

- (void)meetButtonClick {
    if (_meetButtonBlock) {
        _meetButtonBlock();
    }
}

- (void)moreButtonClick {
    if (_moreQuestionButtonBlock) {
        _moreQuestionButtonBlock();
    }
}

- (void)enterAccountEvent:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag-100;
    Enterprise *dto = [self.model.enterprise safeObjectAtIndex:index];
    if (_companyBlock) {
        _companyBlock(dto.id,dto.isSelf.boolValue);
    }
}

- (void)moreCompanyButtonClick {
    if (_companyMoreBlock) {
        _companyMoreBlock();
    }
}

#pragma mark 界面布局
- (void)createSubViews {
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(107), kDeviceWidth, 0.5)];
    _lineView.backgroundColor = kSepparteLineColor;
    [self addSubview:_lineView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _lineView.bottom, kDeviceWidth, kCurrentWidth(49))];
    _titleLabel.textColor = kBlackColor;
    _titleLabel.text = @"精彩问答";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = kSystemBold(15);
    [self addSubview:_titleLabel];
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(52), _lineView.bottom, kCurrentWidth(38), kCurrentWidth(49));
    [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [_moreButton setTitleColor:kLBNineColor forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:@"list_button_enter"] forState:UIControlStateNormal];
    [_moreButton setImgViewStyle:ButtonImgViewStyleRight imageSize:CGSizeMake(6, 10) space:10];
    _moreButton.titleLabel.font = kSystem(11);
    [_moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreButton];
    
    _questionButton = [[HomeButton alloc] initWithFrame:CGRectMake(kCurrentWidth(15), kCurrentWidth(15), (kDeviceWidth-kCurrentWidth(43))/2, kCurrentWidth(85))];
    [_questionButton setTitle:@"我要提问" message:@"向行家提问题\n在线问答" imageString:@"icon_home_bofang"];
    _questionButton.isLoad = NO;
    [_questionButton addTarget:self action:@selector(questionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_questionButton];
    
    _meetButton = [[HomeButton alloc] initWithFrame:CGRectMake(kDeviceWidth-_questionButton.width-kCurrentWidth(15), _questionButton.top, _questionButton.width, _questionButton.height)];
    [_meetButton setTitle:@"约见行家" message:@"与行家面对面约谈\n全国通话" imageString:@"icon_home_bofang"];
    _meetButton.isLoad = NO;
    [_meetButton addTarget:self action:@selector(meetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_meetButton];
    
    _companyLine = [[UIView alloc] initWithFrame:CGRectMake(0, _questionButton.bottom+kCurrentWidth(15), kDeviceWidth, 0.5)];
    _companyLine.backgroundColor = kSepparteLineColor;
    [self addSubview:_companyLine];
    
    _companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _companyLine.bottom, kDeviceWidth, kCurrentWidth(54))];
    _companyLabel.textColor = kLBThreeColor;
    _companyLabel.text = @"企业AI智能名片推荐";
    _companyLabel.textAlignment = NSTextAlignmentCenter;
    _companyLabel.font = kSystemBold(15);
    [self addSubview:_companyLabel];
    
    _companyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _companyButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(52), _companyLine.bottom, kCurrentWidth(38), kCurrentWidth(54));
    [_companyButton setTitle:@"更多" forState:UIControlStateNormal];
    [_companyButton setTitleColor:kLBNineColor forState:UIControlStateNormal];
    [_companyButton setImage:[UIImage imageNamed:@"list_button_enter"] forState:UIControlStateNormal];
    [_companyButton setImgViewStyle:ButtonImgViewStyleRight imageSize:CGSizeMake(6, 10) space:10];
    _companyButton.titleLabel.font = kSystem(11);
    [_companyButton addTarget:self action:@selector(moreCompanyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_companyButton];
}

@end
