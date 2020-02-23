//
//  SearchExpertViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"

@interface SearchExpertViewController : CommonViewController

@property(nonatomic,copy)void(^selectedExpertBlock)(NSMutableArray *list);

@end
