//
//  WMLocationViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/13.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "WMLocationViewController.h"

@interface WMLocationViewController ()

@property (nonatomic,strong)UIButton *rightNaviBtn;

@end

@implementation WMLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rightNaviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightNaviBtn.frame=CGRectMake(0, 0, 44, 44);
    [self.rightNaviBtn setTitle:@"导航" forState:UIControlStateNormal];
    self.rightNaviBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    self.rightNaviBtn.backgroundColor=[UIColor clearColor];
    [self.rightNaviBtn setTitleColor:[UIColor colorWithHexString:@"00ADEF"] forState:UIControlStateNormal];
    self.rightNaviBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightNaviBtn];
    self.navigationItem.rightBarButtonItem=rightButton;
}

#pragma mark
#pragma mark Event
- (void)rightNaviBtnClick {
    NSArray *appListArr = [self checkHasOwnApp];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *title in appListArr) {
        UIAlertAction *mapAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([action.title isEqualToString:@"苹果原生地图"]) {
                __unused CLLocationCoordinate2D from = CLLocationCoordinate2DMake(self.location.latitude, self.location.longitude);
                MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
                currentLocation.name = @"我的位置";
                
                CLLocationCoordinate2D to = CLLocationCoordinate2DMake(self.location.latitude, self.location.longitude);
                MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
                toLocation.name = self.locationName;
                [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
            } else if ([action.title isEqualToString:@"高德地图"]) {
                NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=2",@"刷哪儿",self.location.latitude,self.location.longitude,self.locationName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *r = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:r];
            } else if ([action.title isEqualToString:@"百度地图"]) {
                NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=walking&coord_type=gcj02",self.location.latitude,self.location.longitude,self.locationName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }
        }];
        [alertController addAction:mapAction];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 其他地图
- (NSArray *)checkHasOwnApp{
    NSArray *mapSchemeArr = @[@"iosamap://navi",@"baidumap://map/"];
    NSMutableArray *appListArr = [[NSMutableArray alloc] initWithObjects:@"苹果原生地图", nil];
    for (int i = 0; i < [mapSchemeArr count]; i++) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[mapSchemeArr objectAtIndex:i]]]]) {
            if (i == 0){
                [appListArr addObject:@"高德地图"];
            }else if (i == 1){
                [appListArr addObject:@"百度地图"];
            }
        }
    }
    return appListArr;
}

//back
- (void)leftBarButtonItemPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
