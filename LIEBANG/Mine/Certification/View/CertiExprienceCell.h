//
//  CertiExprienceCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/8/7.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 CertiExprienceState
 */
typedef enum{
    CertiExprienceStateWorkNormal                             = 0,//无工作经历
    CertiExprienceStateWorkUnverified                         = 1,//未验证工作经历
    CertiExprienceStateWorkVerifing                           = 2,//验证工作经历中
    CertiExprienceStateWorkVerified                           = 3,//已验证工作经历
    CertiExprienceStateWorkVerifiedFail                       = 4,//验证工作经历失败
    CertiExprienceStateWorkVerifiedCancel                     = 10,//工作认证已取消
    CertiExprienceStateEduNormal                              = 5,//无教育经历
    CertiExprienceStateEduUnverified                          = 6,//未验证教育经历
    CertiExprienceStateEduVerifing                            = 7,//验证教育经历中
    CertiExprienceStateEduVerified                            = 8,//已验证教育经历
    CertiExprienceStateEduVerifiedFail                        = 9,//验证教育经历失败
    CertiExprienceStateEduVerifiedCancel                       = 11,//教育认证已取消

}CertiExprienceState;

@interface CertiExprienceCell : UITableViewCell

@property(nonatomic,copy)void(^addCertiExprienceBlock)(CertiExprienceState certiState,NSIndexPath *indexPath);
@property(nonatomic,copy)void(^editCertiSourceBlock)(NSIndexPath *indexPath);
@property(nonatomic,copy)void(^GetCertiImageViewBlock)(NSString *imageUrl);
@property (nonatomic,assign)CertiExprienceState certiState;

@property (nonatomic,strong)EducationModel *educationModel;
@property (nonatomic,strong)WorkModel *workModel;

@property (nonatomic,strong)UILabel *stateLabel;

- (void)setEducationModel:(EducationModel *)educationModel sourceDic:(NSDictionary *)sourceDic;
- (void)setWorkModel:(WorkModel *)workModel sourceDic:(NSDictionary *)sourceDic;

- (void)setStatusAccess;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,assign)CGFloat cellHeight;

@end
