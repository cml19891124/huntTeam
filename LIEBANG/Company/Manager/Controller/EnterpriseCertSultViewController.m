#import "CompanyDetailViewController.h"

#import "EnterpriseCertSultViewController.h"

@interface EnterpriseCertSultViewController ()

@property (strong, nonatomic) UIImageView *accessImage;

@property (strong, nonatomic) UILabel *labTitle;

@property (strong, nonatomic) UIButton *expressBtn;

@end

@implementation EnterpriseCertSultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"审核通过";
    self.view.backgroundColor = kWhiteColor;
    
    [self setupSubviews];
}

- (void)setupSubviews
{
    _accessImage = UIImageView.new;
    _accessImage.image = IMAGE_NAMED(@"icon_tongguo");
    [self.view addSubview:_accessImage];
    [_accessImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(70);
        make.top.mas_equalTo(130);
        make.centerX.mas_equalTo(self.view);
    }];
    
    _labTitle = UILabel.new;
    _labTitle.text = @"恭喜 您已通过企业名片认证";
    _labTitle.textColor = kLBRedColor;
    _labTitle.font = kSystemBold(16);
    _labTitle.textAlignment  = NSTextAlignmentCenter;
    [self.view addSubview:_labTitle];
    [_labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.accessImage.mas_bottom).offset(20);
        make.height.mas_equalTo(30);
    }];
    
    _expressBtn = UIButton.new;
    _expressBtn.backgroundColor = kLBRedColor;
    _expressBtn.layer.cornerRadius = 2;
    _expressBtn.layer.masksToBounds = YES;
    [_expressBtn setTitle:@"去推广我的企业AI智能名片" forState:UIControlStateNormal];
    [_expressBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_expressBtn addTarget:self action:@selector(toExpressIdentifycation:) forControlEvents:UIControlEventTouchUpInside];
    _expressBtn.titleLabel.font = kSystem(16);
    [self.view addSubview:_expressBtn];
    [_expressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-(kTabBarViewHeight - 49) - 55);
        make.height.mas_equalTo(50);
    }];
}

- (void)toExpressIdentifycation:(UIButton *)button
{
    CompanyDetailViewController *nextCtr = [[CompanyDetailViewController alloc] init];
    nextCtr.companyUid = self.ID;
    nextCtr.companyType = @"0";
    nextCtr.isSelf = self;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

@end
