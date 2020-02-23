//
//  CommonViewController.m
//  Lottery
//
//  Created by YIQI on 2018/3/23.
//  Copyright © 2018年 zhong. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@property (nonatomic,assign)BOOL isPresentSheet;


@end

@implementation CommonViewController

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    
    _groupTableView.delegate = nil;
    _groupTableView.dataSource = nil;
    _groupTableView = nil;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIFont *font = kSystemBold(16);
    NSDictionary *dic = @{NSFontAttributeName:font,NSForegroundColorAttributeName:kLBBlackColor};
    self.navigationController.navigationBar.titleTextAttributes =dic;
    
    if (!self.isHiddenBackBtn) {
        [self initBackBtn];
    }
}

- (void)initBackBtn {
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0, 30.0, 44.0)];//
    [back setImage:[UIImage imageNamed:@"nav_btn_backblue"] forState:UIControlStateNormal];
    [back setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [back addTarget:self action:@selector(backNavItemTapped) forControlEvents:UIControlEventTouchUpInside];
    back.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)backNavItemTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
        _tableView.scrollEnabled = YES;
        _tableView.userInteractionEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView = nil;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (UITableView *)groupTableView {
    if (!_groupTableView) {
        _groupTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_groupTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_groupTableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
        _groupTableView.scrollEnabled = YES;
        _groupTableView.userInteractionEnabled = YES;
        _groupTableView.delegate = self;
        _groupTableView.dataSource = self;
        _groupTableView.backgroundColor = [UIColor whiteColor];
        _groupTableView.backgroundView = nil;
        if (@available(iOS 11.0, *)) {
            _groupTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _groupTableView;
}

- (void)showNoDataWithImage:(NSString *)image {
    [self hideNoDataImage];
    self.groupTableView.backgroundColor = kWhiteColor;
    self.noDataImage = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(190))/2, kCurrentWidth(100), kCurrentWidth(190), kCurrentWidth(100))];
    self.noDataImage.image = [UIImage imageNamed:image];
    self.noDataImage.backgroundColor = kWhiteColor;
    [self.groupTableView addSubview:self.noDataImage];
}

- (void)hideNoDataImage {
    if (self.noDataImage) {
        [self.noDataImage removeFromSuperview];
        self.noDataImage = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001f;
}

- (void)presentSheet:(NSString *)title {
    self.isPresentSheet = YES;
    MBProgressHUD *progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressHud];
    
    progressHud.mode = MBProgressHUDModeText;
    progressHud.label.text = title;
    [progressHud showAnimated:YES];
    
    [self performBlock:^{
        [progressHud hideAnimated:YES];
        [progressHud removeFromSuperview];
    } afterDelay:1.5];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isPresentSheet) {
        [self removeOverFlowActivityView];
    }
}

- (void)displayOverFlowActivityView {
    self.isPresentSheet = NO;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    MBProgressHUD *progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressHud];
    [self.view bringSubviewToFront:progressHud];
    progressHud.mode = MBProgressHUDModeIndeterminate;
    //_progressHud.delegate = self;
    //_HUD.labelText = cString;
    [progressHud showAnimated:YES];
    [progressHud setTag:9955];
    
}

- (void)removeOverFlowActivityView {
    dispatch_async(dispatch_queue_create(0, 0), ^{

        // 子线程执行任务（比如获取较大数据）

        dispatch_async(dispatch_get_main_queue(), ^{

         // 通知主线程刷新 神马的
            [[self.view viewWithTag:9955] removeFromSuperview];

        });

    });
    
}

-(void)showAlertWithString:(NSString*)message {
#ifdef IOS9_OR_LATER
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
#else
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles: nil];
    [alert show];
#endif
}

-(void)showHDAlertWithString:(NSString *)message {//黑色提示框 自动消失
    MBProgressHUD *progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressHud];
    
    progressHud.mode = MBProgressHUDModeText;
    //_progressHud.delegate = self;
    progressHud.label.text = message;
    [progressHud showAnimated:YES];
    
    [self performBlock:^{
        [progressHud hideAnimated:YES];
        [progressHud removeFromSuperview];
    } afterDelay:1.5];
}

//延迟调用的方法
- (void)performBlock:(void(^)(void))block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

-(void)showLoadingViewWithTime:(NSInteger)time{//显示加载等待界面  几秒后消失
    MBProgressHUD *progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressHud];
    
    progressHud.mode = MBProgressHUDModeIndeterminate;
    //_progressHud.delegate = self;
    //_HUD.labelText = cString;
    [progressHud showAnimated:YES];
    
    [self performBlock:^{
        [progressHud hideAnimated:YES];
        [progressHud removeFromSuperview];
        
    } afterDelay:time];
}

-(void)setRightNaviBtnImage:(UIImage *)img {
    self.rightNaviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightNaviBtn.frame=CGRectMake(0, 0, 25, 44);
    //[self.rightNaviBtn setBackgroundImage:img forState:UIControlStateNormal];
    [self.rightNaviBtn setImage:img forState:UIControlStateNormal];
    //    [self.rightNaviBtn setTitle:@"返回" forState:UIControlStateNormal];
    self.rightNaviBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.rightNaviBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.rightNaviBtn.backgroundColor=[UIColor clearColor];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightNaviBtn];
    self.navigationItem.rightBarButtonItem=rightButton;
}

-(void)setRightNaviBtnImage:(UIImage *)img image:(UIImage *)image {
    self.rightNaviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightNaviBtn.frame=CGRectMake(0, 0, 18, 17);
    //[self.rightNaviBtn setBackgroundImage:img forState:UIControlStateNormal];
    [self.rightNaviBtn setImage:img forState:UIControlStateNormal];
    //    [self.rightNaviBtn setTitle:@"返回" forState:UIControlStateNormal];
    self.rightNaviBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.rightNaviBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.rightNaviBtn.backgroundColor=[UIColor clearColor];
    
    self.rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightNavBtn.frame=CGRectMake(0, 0, 18, 17);
    //[self.rightNaviBtn setBackgroundImage:img forState:UIControlStateNormal];
    [self.rightNavBtn setImage:image forState:UIControlStateNormal];
    //    [self.rightNaviBtn setTitle:@"返回" forState:UIControlStateNormal];
    self.rightNavBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [self.rightNavBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.rightNavBtn.backgroundColor=[UIColor clearColor];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightNaviBtn];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:self.rightNavBtn];
    self.navigationItem.rightBarButtonItems = @[rightBtn,rightButton];
}

-(void)setRightNaviBtnTitle:(NSString *)str image:(NSString *)image {
    self.rightNaviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightNaviBtn.frame=CGRectMake(0, 0, 70, 44);
    [self.rightNaviBtn setTitle:str forState:UIControlStateNormal];
    self.rightNaviBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [self.rightNaviBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.rightNaviBtn.backgroundColor=[UIColor clearColor];
    [self.rightNaviBtn setTitleColor:[UIColor colorWithHexString:@"484848"] forState:UIControlStateNormal];
    [self.rightNaviBtn setImgViewStyle:ButtonImgViewStyleLeft imageSize:CGSizeMake(15, 15) space:5];
    [self.rightNaviBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightNaviBtn];
    self.navigationItem.rightBarButtonItem=rightButton;
}

-(void)setRightNaviBtnTitle:(NSString *)str {
    
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 44)];
    
    if (size.width < 40) {
        size.width += 20;
    }
    
    self.rightNaviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightNaviBtn.frame=CGRectMake(0, 0, size.width, 44);
    [self.rightNaviBtn setTitle:str forState:UIControlStateNormal];
    self.rightNaviBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.rightNaviBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.rightNaviBtn.backgroundColor=[UIColor clearColor];
    [self.rightNaviBtn setTitleColor:[UIColor colorWithHexString:@"00ADEF"] forState:UIControlStateNormal];
    self.rightNaviBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightNaviBtn];
    self.navigationItem.rightBarButtonItem=rightButton;
}

//-(void)setLeftNaviBtnImage:(UIImage*)img {
//    self.leftNaviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.leftNaviBtn.frame=CGRectMake(0, 0, 44, 44);
//    //[self.rightNaviBtn setBackgroundImage:img forState:UIControlStateNormal];
//    [self.leftNaviBtn setImage:img forState:UIControlStateNormal];
//    //    [self.rightNaviBtn setTitle:@"返回" forState:UIControlStateNormal];
//    self.leftNaviBtn.titleLabel.font=[UIFont systemFontOfSize:16];
//    [self.leftNaviBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    self.leftNaviBtn.backgroundColor=[UIColor clearColor];
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:self.leftNaviBtn];
//    self.navigationItem.leftBarButtonItem=rightButton;
//}

-(void)setLeftNaviBtnTitle:(NSString*)str image:(NSString *)image {
    self.leftNaviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftNaviBtn.frame=CGRectMake(0, 0, 44, 44);
    [self.leftNaviBtn setTitle:str forState:UIControlStateNormal];
    self.leftNaviBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [self.leftNaviBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.leftNaviBtn.backgroundColor=[UIColor clearColor];
    [self.leftNaviBtn setTitleColor:[UIColor colorWithHexString:@"484848"] forState:UIControlStateNormal];
    [self.leftNaviBtn setImgViewStyle:ButtonImgViewStyleLeft imageSize:CGSizeMake(15, 15) space:5];
    [self.leftNaviBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:self.leftNaviBtn];
    self.navigationItem.leftBarButtonItem=rightButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
