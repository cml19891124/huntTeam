//
//  PersonnelHeadView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/27.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MESearchTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonnelHeadView : UIView

@property(nonatomic,copy)void(^editMessageBlock)(NSString *phone);
@property(nonatomic,copy)void(^addMessageBlock)(NSString *phone);
@property (nonatomic,strong) MESearchTextField *phoneTf;

@end

NS_ASSUME_NONNULL_END
