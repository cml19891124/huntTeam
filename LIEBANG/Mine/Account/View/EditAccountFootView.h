//
//  EditAccountFootView.h
//  LIEBANG
//
//  Created by AUX on 2018/8/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAccountFootView : UIView

@property(nonatomic,copy)void(^saveBasicMessageBlock)(void);
@property(nonatomic,copy)void(^editSourceBlock)(void);

@property (nonatomic,assign)BOOL isSaveButton;

@property (nonatomic,strong)UIImage *image;

@property (nonatomic,strong)UIImage *upImage;

@property (nonatomic,strong)NSString *imageString;

@end
