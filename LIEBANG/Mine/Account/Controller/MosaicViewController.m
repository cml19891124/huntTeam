//
//  MosaicViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/14.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "MosaicViewController.h"

@interface MosaicViewController ()

@property (nonatomic,strong)UIButton *closeButton;

@end

@implementation MosaicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBlackColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.imageArr = [NSMutableArray arrayWithObject:self.imageUrl];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * self.imageArr.count, scrollView.frame.size.height);
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < self.imageArr.count; i++) {
        UIScrollView *smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollView.frame.size.width * i, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        smallScrollView.contentSize = smallScrollView.frame.size;
        smallScrollView.maximumZoomScale = 3;
        smallScrollView.minimumZoomScale = 1;
        smallScrollView.delegate = self;
        [scrollView addSubview:smallScrollView];
        
        //添加图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:smallScrollView.bounds];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.imageArr safeObjectAtIndex:i]]] placeholderImage:[UIImage imageNamed:@"home_scrollView_logo"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(renzhenTap:)];
//        tap.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:tap];
//
//        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(renzhenTap:)];
//        tap1.numberOfTapsRequired = 1;
//        [imageView addGestureRecognizer:tap1];
        [smallScrollView addSubview:imageView];
    }
    
    self.closeButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(kCurrentWidth(20), kDeviceHeight-kCurrentWidth(80), kCurrentWidth(50), kCurrentWidth(44));
    [self.closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = kSystem(15);
    [self.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //获取要放大的视图
    UIImageView *imageView = (UIImageView *)[scrollView subviews][0];
    return imageView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)renzhenTap:(UITapGestureRecognizer*)tap {
    [self closeButtonClick];
}

- (void)closeButtonClick {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
