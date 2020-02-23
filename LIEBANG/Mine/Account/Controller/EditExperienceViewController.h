//
//  EditExperienceViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/7/17.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"


@interface EditExperienceViewController : CommonViewController

@property(nonatomic,copy)void(^refreshBlock)(void);
@property (nonatomic,assign)EditExperienceState experienceState;

@property (nonatomic,assign)BOOL isFirst;//是否是最新的经历
@property (nonatomic,assign)BOOL isEdit;//是编辑还是新增

@property (nonatomic,strong)EducationModel *basicEduModel;
@property (nonatomic,strong)WorkModel *basicWorkModel;
@property (nonatomic,strong)NSString *basicID;

@end
