//
//  PostCertSourceViewController.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/3.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CommonViewController.h"
#import "WorkModel.h"
#import "EducationModel.h"

/**
 PostCertSourceState
 */
typedef enum{
    PostCertSourceStateWork                             = 0,//工作经历
    PostCertSourceStateEducation                        = 1,//教育经历
}PostCertSourceState;

@interface PostCertSourceViewController : CommonViewController

@property(nonatomic,copy)void(^showSourceBlock)(NSDictionary *sourceDic);

@property (nonatomic,assign)PostCertSourceState certState;

@property (nonatomic,strong)WorkModel *workModel;

@property (nonatomic,strong)EducationModel *educationModel;

@property (nonatomic,assign)BOOL isAccount;

@end
