//
//  ClassSelectView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassSelectView : UIView

@property (nonatomic,strong)NSArray *titleArray;

@property(nonatomic,copy)void(^removeObjectBlock)(NSInteger objectIndex);

@end
