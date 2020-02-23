
#import <UIKit/UIKit.h>
#import "QuestionOrderDetailModel.h"
#import "QuestionDetailModel.h"

@interface QuestionRalationPersonInfoCell : UITableViewCell

@property(nonatomic,copy)void(^GetWorkSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^GetBasicSourceBlock)(NSString *imageUrl);
@property(nonatomic,copy)void(^questionButtonBlock)(void);

@property (nonatomic,strong)QuestionOrderDetailModel *detailModel;

@property (nonatomic,strong)QuestionDetailModel *model;

@property (nonatomic,assign)QuestionDetailType detailType;

@end
