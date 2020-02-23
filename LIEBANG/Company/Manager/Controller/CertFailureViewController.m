#import "CompanyCertViewController.h"

#import "CertFailureViewController.h"

@interface CertFailureViewController ()

@property (strong, nonatomic) UILabel *labFailure;

@property (strong, nonatomic) UIImageView *filureImage;

@property (strong, nonatomic) UIButton *reuploadBtn;

@end

@implementation CertFailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;

    self.navigationItem.title = @"未通过审核";

    [self setupSubviews];
    [self setupSubviewsMasonry];

}

- (void)setupSubviews
{
    _labFailure = UILabel.new;
    _labFailure.text = @"抱歉，您的企业认证申请没有通过审核\n请根据审核建议进行操作";
    _labFailure.textAlignment = NSTextAlignmentCenter;
    _labFailure.numberOfLines = 0;
    _labFailure.textColor = kRedColor;
    [self.view addSubview:_labFailure];
    
    _filureImage = UIImageView.new;
    _filureImage.image = IMAGE_NAMED(@"icon_weitongtuo");
    [self.view addSubview:_filureImage];
    
    _reuploadBtn = UIButton.new;
    _reuploadBtn.backgroundColor = kLBRedColor;
    _reuploadBtn.layer.cornerRadius = 2;
    _reuploadBtn.layer.masksToBounds = YES;
    [_reuploadBtn setTitle:@"重新提交审核" forState:UIControlStateNormal];
    [_reuploadBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_reuploadBtn addTarget:self action:@selector(reloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _reuploadBtn.titleLabel.font = kSystem(16);
    [self.view addSubview:_reuploadBtn];
}

- (void)setupSubviewsMasonry
{
    [_labFailure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(75);
    }];
    
    [_filureImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(178/2);
        make.height.mas_equalTo(190/2);
        make.top.mas_equalTo(self.labFailure.mas_bottom).offset(40);
    }];
    
    [_reuploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-(kTabBarViewHeight - 49) - 55);
        make.height.mas_equalTo(50);
    }];
}

- (void)reloadBtnClick:(UIButton *)button
{
    CompanyCertViewController *nextCtr = [[CompanyCertViewController alloc] init];
    nextCtr.companyUid = self.companyUid;
    nextCtr.level = self.level;
    nextCtr.isModify = YES;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

@end
