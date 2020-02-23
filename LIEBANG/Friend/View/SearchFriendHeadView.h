//
//  SearchFriendHeadView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/25.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFriendHeadView : UIView

@property(nonatomic,copy)void(^searchButtonBlock)(NSString *keyWord);

- (void)resignSearchFirstResponder;

@property (nonatomic,strong)NSString *placeholder;

@end
