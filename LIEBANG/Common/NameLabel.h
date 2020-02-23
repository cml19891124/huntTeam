//
//  NameLabel.h
//  LIEBANG
//
//  Created by AUX on 2018/8/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameLabel : UIView

@property (nonatomic,assign)CGFloat nameWidth;

@property(nonatomic,copy)void(^GetBasicCertiImageViewBlock)(NSString *imageUrl);
- (void)setNameString:(NSString *)nameString showIcon:(NSString *)showIcon;

@property (nonatomic,strong)NSString *userUid;
@property (nonatomic,strong)UIFont *labelFont;

@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIImageView *imageView;


@end
