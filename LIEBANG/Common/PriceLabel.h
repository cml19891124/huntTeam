//
//  PriceLabel.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/20.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceLabel : UIView

@property (nonatomic,strong)NSString *usePrice;//购买价格

@property (nonatomic,strong)NSString *oldPrice;//原价

@property (nonatomic,assign)BOOL isOrder;

@property (nonatomic,assign)NSTextAlignment priceTextAlignment;

- (void)setUsePrice:(NSString *)usePrice oldPrice:(NSString *)oldPrice;

@end
