//
//  CommonViewController+Mosaic.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/14.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController+Mosaic.h"
#import "MosaicViewController.h"

@implementation CommonViewController (Mosaic)

- (void)pushToMosaicVC:(NSString *)turnStr {
    NSLog(@"加载的图片 = %@",turnStr);
    MosaicViewController *nextCtr = [[MosaicViewController alloc] init];
    nextCtr.imageUrl = turnStr;
    [self presentViewController:nextCtr animated:NO completion:nil];
}

@end
