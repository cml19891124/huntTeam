//
//  TypedefConstant.h
//  Lottery
//
//  Created by  YIQI on 2018/4/10.
//  Copyright © 2018年 zhong. All rights reserved.
//

#ifndef TypedefConstant_h
#define TypedefConstant_h

/**
 AccountViewController的样式
 */
typedef enum{
    AccountStateNormal                             = 0,//个人账户
    AccountStateDisabled                           = 1,//封禁账户
    AccountStateOther                              = 2,//他人账户
    AccountStateEdit                               = 3,//编辑账户
}AccountState;

/**
 话题详情的样式
 */
typedef enum{
    ThemeDetailStateNormal                             = 0,//默认
    ThemeDetailStateEdit                               = 1,//编辑
    ThemeDetailStateDisabled                           = 2,//已删除
}ThemeDetailState;

/**
 QuestionDetailState的样式
 */
typedef enum{
    QuestionDetailStateExpertNormal                             = 0,//行家回答---对方已支付，请尽快回答
    QuestionDetailStateExpertComplete                           = 1,//行家回答---回答已完成
    QuestionDetailStateExpertTimeOut                            = 2,//行家回答---没有在48h内回答，问题已失效
    QuestionDetailStateExpertOmit                               = 3,//行家回答---行家无法回答，已忽略
    QuestionDetailStateStudentWait                              = 4,//学员提问---已支付等待回答
    QuestionDetailStateStudentTimeOut                           = 5,//学员提问---没有在48h内回答，问题已失效
    QuestionDetailStateStudentOmit                              = 6,//学员提问---行家无法回答，已忽略
    QuestionDetailStateStudentComment                           = 7,//学员提问---行家已回答，待评价
    QuestionDetailStateStudentComplete                          = 8,//学员提问---回答已完成,已评价
    QuestionDetailStateVisitorPay                               = 9,//游客查看---待付款
    QuestionDetailStateVisitorComment                           = 10,//游客查看---待评价
    QuestionDetailStateVisitorComplete                          = 11,//游客查看---已评价
}QuestionDetailState;

/**
 QuestionDetailType的样式
 */
typedef enum{
    QuestionDetailTypeExpert                             = 0,//行家回答
    QuestionDetailTypeStudent                            = 1,//学员提问
    QuestionDetailTypeVisitor                            = 2,//游客查看
}QuestionDetailType;

/**
 EditExperienceState
 */
typedef enum{
    EditExperienceStateWork                             = 0,//工作经历
    EditExperienceStateEducation                        = 1,//教育经历
}EditExperienceState;

#endif /* TypedefConstant_h */
