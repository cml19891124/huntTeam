//
//  UserProtocolCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/29.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserProtocolCell : UIView

@property(nonatomic,copy)void(^userProtocolBlock)(void);
@property (nonatomic,assign,readonly)BOOL isUserProtocol;

@property (nonatomic,assign)NSInteger number;

@property (nonatomic,assign)BOOL isLabelShow;

@end
