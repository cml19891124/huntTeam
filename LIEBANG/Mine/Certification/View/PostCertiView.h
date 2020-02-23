//
//  PostCertiView.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/3.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 PostCertiViewType的样式
 */
typedef enum{
    PostCertiViewCard                                 = 0,//名片
    PostCertiViewProof                                = 1,//在职证明
    PostCertiViewLicense                              = 2,//营业执照
    PostCertiViewWorkCard                             = 3,//工牌
    PostCertiViewDegree                               = 4,//学位证
    PostCertiViewDiploma                              = 5,//毕业证
}PostCertiViewType;

@interface PostCertiView : UIView

@property (nonatomic,assign)PostCertiViewType type;
@property(nonatomic,copy)void(^postCertiViewBlock)(NSInteger index);

@end
