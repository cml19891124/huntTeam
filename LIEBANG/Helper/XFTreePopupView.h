//
//  XFTreePopupView.h
//  IntoSaler
//
//  Created by weihongfang on 2017/9/9.
//  Copyright © 2017年 Leven Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XFTreePopupView_TINT_COLOR [UIColor darkGrayColor]

typedef void (^CommitTreeNodeBlock)(NSArray *);

@interface XFTreePopupView : UIView

@property (nonatomic, retain) NSString *nodeNameKey;
@property (nonatomic, retain) NSString *nodeIDKey;
@property (nonatomic, retain) NSString *nodeListKey;


@property (nonatomic, strong)UILabel *lblTitle;

@property(nonatomic, assign) BOOL isHidden;
@property (nonatomic, copy) CommitTreeNodeBlock commitBlock;

@property (nonatomic, retain) NSString *selectedItem;



- (instancetype)initWithDataSource:(id)dataSource Commit:(void(^)(NSArray *))selectItems;

@end
