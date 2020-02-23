//
//  RequestUrl.h
//  Lottery
//
//  Created by  YIQI on 2018/4/16.
//  Copyright © 2018年 zhong. All rights reserved.
//

#ifndef RequestUrl_h
#define RequestUrl_h


////////////////////////////////////////////////////////////
/////////////////////////登录注册/////////////////////////////
////////////////////////////////////////////////////////////

/*
 注册
 */
#define kREGISTER_URL @"login/register_by_phone.shtml"

/*
 登录
 */
#define kLOGIN_URL @"login/user_login.shtml"

/*
 退出登录
 */
#define kLOGIN_OUT_URL @"login/sign/out.shtml"

/*
 用户注销
 */
#define kESC_LOGIN_URL @""

/*
 第三方登录
 */
#define kTHIRD_LOGIN_URL @"login/register_by_third.shtml"

/*
 修改手机号
 */
#define kMODIFY_PHONE_URL @"login/edit_user_phone.shtml"

/*
 修改密码
 */
#define kMODIFY_LOGINPWD_URL @"login/resetting_password.shtml"

/*
 发送验证码
 */
#define kSEND_CODE_URL @"login/getCode.shtml"

/*
 用户协议
 */
#define kUSER_PROTOCOL_URL @"Userprotocol/agreement.shtml"

/*
 绑定手机号
 */
#define kBIND_PHONE_URL @"login/binding_user_phone.shtml"

/*
 验证验证码
 */
#define kCHECK_CODE_URL @"login/Verification_user_code.shtml"

/*
 绑定微信号
 */
#define kBIND_WECHAT_URL @"login/binding_user_wechat.shtml"

/*
 广告页
 */
#define kGET_ADVERTISEMENT_URL @"index/getAdvertisement.shtml"

////////////////////////////////////////////////////////////
///////////////////////////首页//////////////////////////////
////////////////////////////////////////////////////////////

/*
 获取首页轮播图及分类
 */
#define kHome_URL @"index/getPicture_Classify.shtml"

/*
 获取全部分类
 */
#define kALL_CLASS_URL @"index/get_all_classify.shtml"

/*
 消息红点
 */
#define kMESSAGE_RED_BUTTON_URL @"message/red_button.shtml"

////////////////////////////////////////////////////////////
/////////////////////////个人信息/////////////////////////////
////////////////////////////////////////////////////////////

/*
 个人中心
 */
#define kUSER_CENTER_URL @"userAccountData/get_user.shtml"

/*
 个人信息页面
 */
#define kACCOUNT_URL @"userAccountData/get_user_data.shtml"

/*
 获取个人名片
 */
#define kACCOUNT_MESSAGE_URL @"userAccountData/get_user_visiting_card.shtml"

/*
 修改个人名片
 */
#define kEDIT_ACCOUNT_MESSAGE_URL @"userAccountData/edit_user_visiting_card.shtml"

/*
 获取教育经历
 */
#define kEDUCATION_URL @"userAccountData/get_education_authentication.shtml"

/*
 新增教育经历
 */
#define kADD_EDUCATION_URL @"userAccountData/add_education_authentication.shtml"

/*
 修改教育经历
 */
#define kEDIT_EDUCATION_URL @"userAccountData/edit_education_authentication.shtml"

/*
 删除教育经历
 */
#define kDELETE_EDUCATION_URL @"userAccountData/del_education_authentication.shtml"

/*
 获取工作经历
 */
#define kWORK_URL @"userAccountData/get_occupation_authentication.shtml"

/*
 新增工作经历
 */
#define kADD_WORK_URL @"userAccountData/add_occupation_authentication.shtml"

/*
 修改工作经历
 */
#define kEDIT_WORK_URL @"userAccountData/edit_occupation_authentication.shtml"

/*
 删除工作经历
 */
#define kDELETE_WORK_URL @"userAccountData/del_occupation_authentication.shtml"

/*
 修改用户自我介绍
 */
#define kEDIT_USER_INTRODUCE_URL @"userAccountData/edit_user_Introduce.shtml"

/*
 用户评价
 */
#define kPOST_COMMENT_URL @"userAccountData/add_user_comment.shtml"

/*
 喜欢用户
 */
#define kADD_LIKE_URL @"userAccountData/add_user_like.shtml"

/*
 修改生日与家乡
 */
#define kEDIT_HOMETOWN_URL @"userAccountData/edit_user_HomeBirth.shtml"

/*
 获取个人权限及黑名单
 */
#define kPRIVACY_URL @"message/get_user_privacy.shtml"

/*
 修改个人权限及黑名单
 */
#define kEDIT_PRIVACY_URL @"message/edit_user_privacy.shtml"

/*
 点赞标签
 */
#define kUP_CLASSIFY_URL @"userAccountData/give_user_classify.shtml"

/*
 点赞评价
 */
#define kUP_COMMENT_URL @"userAccountData/give_user_comment.shtml"

/*
 系统消息
 */
#define kUP_SYSTEMMESS_CENTER_URL @"message/message_center"

/*
 私信权限
 */
#define kPRIVATE_LETTER_URL @"userAccountData/private_letter.shtml"

/*
 个人信息获取问答列表
 */
#define kACCOUNT_QUESTION_LIST_URL @"userAccountData/get_userCenter_question.shtml"

////////////////////////////////////////////////////////////
/////////////////////////资产相关/////////////////////////////
////////////////////////////////////////////////////////////

/*
 获取优惠券
 */
#define kCOUPON_URL @"coupon/get_coupon.shtml"

/*
 优惠券说明
 */
#define kCOUPON_DETAIL_URL @"other/get_coupon_explain.shtml"

/*
 充值
 */
#define kRECHARGE_URL @"coupon/user_Recharge.shtml"

/*
 猎帮币充值
 */
#define kAPPLE_RECHARGE_URL @"apple/verification/recharge.shtml"

/*
 是否绑定微信(提现用)
 */
#define kIS_WECHAT_URL @"login/is_user_wechat.shtml"

/*
 提现
 */
#define kFORWARD_URL @"coupon/user_forward.shtml"

/*
 钱包列表
 */
#define kASSET_DETAIL_URL @"coupon/get_user_assetsDetail.shtml"

////////////////////////////////////////////////////////////
/////////////////////////订单相关/////////////////////////////
////////////////////////////////////////////////////////////

/*
 获取话题订单
 */
#define kTHEME_ORDER_URL @"order/get_user_topic.shtml"

/*
 获取问答订单
 */
#define kQUESTION_ORDER_URL @"order/get_user_question.shtml"

/*
 评价订单
 */
#define kPOST_ORDER_COMMENT_URL @"order/evaluate_order.shtml"

/*
 评价话题订单
 */
#define kPOST_THEME_ORDER_COMMENT_URL @"order/topic_evaluate_order.shtml"

/*
 评价问答详情
 */
#define kPOST_QUESTION_COMMENT_URL @"question/question_detail_evaluate.shtml"

/*
 问答订单详情
 */
#define kQUESTION_ORDER_DETAIL_URL @"order/question_order_detail.shtml"

/*
 话题订单详情
 */
#define kTHEME_ORDER_DETAIL_URL @"order/topic_order_detail.shtml"

/*
 取消订单
 */
#define kCANCEL_ORDER_URL @"order/cancel_order.shtml"

/*
 获取未读数量
 */
#define kORDER_READNUM_URL @"order/get_user_questionNum.shtml"

/*
 忽略话题
 */
#define kCANCEL_THEME_ORDER_URL @"order/ignore_topic.shtml"

/*
 用户话题确认服务完成
 */
#define kCONFIM_THEME_ORDER_URL @"order/sure_userTopic_order.shtml"

/*
 行家话题确认服务完成
 */
#define kEXP_CONFIM_THEME_ORDER_URL @"order/hangjiaSure_userTopic_order.shtml"

/*
 用户确认预约话题
 */
#define kTHEME_APPOINT_URL @"order/appointment_userTopic_order.shtml"

/*
 行家确认预约话题
 */
#define kTHEME_APPOINT_EXP_URL @"order/appointment_topic_order.shtml"

/*
 提醒行家
 */
#define kREMIND_EXPERT_URL @"topic/remind_hangjia.shtml"

////////////////////////////////////////////////////////////
/////////////////////////好友相关/////////////////////////////
////////////////////////////////////////////////////////////

/*
 推荐好友
 */
#define kRECOMMEND_Friend_URL @"userFriend/get_user_recommendation.shtml"

/*
 获取好友列表
 */
#define kFriend_List_URL @"userFriend/get_user_friend.shtml"

/*
 获取他人好友
 */
#define kFriend_OTHER_URL @"userFriend/get_otherUser_friend.shtml"

/*
 拒绝添加好友
 */
#define kREFUSE_FRIEND_URL @"userFriend/refuse_user_friend.shtml"

/*
 通过好友
 */
#define kPASS_FRIEND_URL @"userFriend/pass_user_friend.shtml"

/*
 申请好友/（他人主页）申请好友
 */
#define kADD_FRIEND_URL @"userFriend/add_user_friend.shtml"

/*
 删除好友
 */
#define kDELETE_FRIEND_URL @"userFriend/delete_user_friend.shtml"

/*
 搜索好友
 */
#define kSEARCH_FRIEND_URL @"userFriend/search_friend.shtml"

/*
 待处理的好友信息
 */
#define kTREATED_FRIEND_URL @"userFriend/get_treated_friend_message.shtml"

/*
 添加黑名单
 */
#define kADD_BLACK_FRIEND_URL @"userFriend/add_user_blackList.shtml"

/*
 访客记录
 */
#define kVISITOR_URL @"message/get_Visitor_record.shtml"


////////////////////////////////////////////////////////////
/////////////////////////认证相关/////////////////////////////
////////////////////////////////////////////////////////////

/*
 基础认证
 */
#define kBASIC_AUTH_URL @"authentication/add_basic_authentication.shtml"

/*
 教育经历认证
 */
#define kEDUCATION_AUTH_URL @"authentication/add_education_authentication.shtml"

/*
 工作经历认证
 */
#define kWORK_AUTH_URL @"authentication/add_occupation_authentication.shtml"

/*
 获取机构认证
 */
#define kGET_MECHANISM_AUTH_URL @"authentication/get_mechanism_authentication.shtml"

/*
 机构认证
 */
#define kMECHANISM_AUTH_URL @"authentication/add_mechanism_authentication.shtml"

/*
 获取所有工作经历
 */
#define kGET_WORK_AUTH_URL @"authentication/get_occupation_authentication.shtml"

/*
 获取所有教育经历
 */
#define kGET_EDU_AUTH_URL @"authentication/get_education_authentication.shtml"

/*
 获取认证打码图片
 */
#define kGET_MOSAIC_AUTH_URL @"authentication/get_User_Mosaic.shtml"

/*
 获取认证打码图片--经历
 */
#define kGET_USER_MOSAIC_AUTH_URL @"authentication/userCenterMosaic.shtml"

/*
 获取用户认证状态
 */
#define kGET_ALL_AUTH_STATE_URL @"authentication/get_user_authentication_states.shtml"

/*
 获取基础认证
 */
#define kGET_BASIC_AUTH_URL @"authentication/get_basic_authentication.shtml"

/*
 认证提交审核
 */
#define kPOST_ALL_AUTH_URL @"authentication/personal_authentication.shtml"

/*
 上传认证图片
 */
#define kPOST_AUTH_IMAGE_URL @"authentication/upload_authentication__image.shtml"
////////////////////////////////////////////////////////////
/////////////////////////问答相关/////////////////////////////
////////////////////////////////////////////////////////////

/*
 获取推荐行家
 */
#define kGET_HANGJIA_CLASSIFYID_URL @"question/get_hangJia.shtml"

/*
 根据回答用户id获取标签
 */
#define kUSER_CLASSIFYID_URL @"question/get_answer_classify.shtml"

/*
 根据标签获取用户
 */
#define kGETUSER_CLASSIFYID_URL @"question/get_hangJia_by_Type.shtml"

/*
 获取问答价格
 */
#define kGET_QUESTION_PRICE_URL @"question/get_question_price.shtml"

/*
 添加问答
 */
#define kADD_QUESTION_URL @"question/add_question.shtml"

/*
 下单
 */
//#define kPOST_QUESTION_ORDER_URL @"order/take_order.shtml"//原
#define kPOST_QUESTION_ORDER_URL @"order/place/order.shtml"//苹果

/*
 回答问答
 */
#define kANSWER_QUESTION_URL @"question/answer_question.shtml"

/*
 问答筛选
 */
#define kQUESTION_LIST_URL @"question/screen_question.shtml"

/*
 问答详情
 */
#define kQUESTION_DETAIL_URL @"question/get_question_detail.shtml"

/*
 搜索问答
 */
#define kSEARCH_QUESTION_URL @"question/search_question.shtml"

/*
 搜索用户
 */
#define kSEARCH_USER_URL @"userFriend/search_user.shtml"

/*
 忽略问答
 */
#define kCANCEL_QUESTION_URL @"question/ignore_question.shtml"

////////////////////////////////////////////////////////////
/////////////////////////话题相关/////////////////////////////
////////////////////////////////////////////////////////////

/*
 搜索话题
 */
#define kSEARCH_THEME_URL @"topic/search_topic.shtml"

/*
 添加话题
 */
#define kADD_THEME_URL @"topic/add_topic.shtml"

/*
 话题筛选
 */
#define kTHEME_LIST_URL @"topic/screen_topic.shtml"

/*
 话题详情
 */
#define kTHEME_DETAIL_URL @"topic/topic_detail.shtml"

/*
 编辑话题
 */
#define kEDIT_THEME_URL @"topic/modify_topic.shtml"

/*
 删除话题
 */
#define kDELETE_THEME_URL @"topic/remove_topic.shtml"

////////////////////////////////////////////////////////////
/////////////////////////其他信息/////////////////////////////
////////////////////////////////////////////////////////////

/*
 使用说明
 */
#define kUSER_HELP_URL @"help/getHelp_Classify.shtml"

/*
 获取未处理事项数量
 */
#define kUNREAD_UNM_URL @"message/user_treated_num.shtml"

/*
 系统消息
 */
#define kSYSTEM_MESSAGE_URL @"message/message_center.shtml"

/*
 删除消息
 */
#define kDELETE_SYSTEM_MESSAGE_URL @"message/remove_user_message.shtml"

/*
 删除学员（买家）订单
 */
#define kDELETE_ORDER_URL @"order/remove_user_order.shtml"

/*
 删除行家（卖家）订单
 */
#define kDELETE_SELLER_ORDER_URL @"order/remove_expert_order.shtml"

/*
 是否好友
 */
#define kIS_FRIEND_URL @"userFriend/is_friend.shtml"

////////////////////////////////////////////////////////////
/////////////////////////企业相关/////////////////////////////
////////////////////////////////////////////////////////////
/*
 我的企业名片列表
 */
#define kMY_COMPANY_LIST_URL @"enterprise/personal/list.shtml"

/*
 我认领的企业名片列表
 */
#define kMY_CLAIM_COMPANY_LIST_URL @"enterprise/claimed/list.shtml"

/*
 收藏企业
 */
#define kCOLLECT_COMPANY_URL @"enterprise/add/collection.shtml"

/*
 通过企业认领
 */
#define kPASS_STALL_CLAIM_URL @"enterprise/pass/staff/claim.shtml"

/*
 拒绝企业认领
 */
#define kREFUSE_STALL_CLAIM_URL @"enterprise/refund/application.shtml"

/*
 认领企业申请
 */
#define kSTALL_CLAIM_URL @"enterprise/staff/claim.shtml"

/*
 企业员工列表
 */
#define kSTALL_LIST_URL @"enterprise/staff/list.shtml"

/*
 企业点评列表
 */
#define kCOMMENT_LIST_URL @"enterprise/comment/list.shtml"

/*
 企业点评
 */
#define kADD_COMMENT_URL @"enterprise/add/comment.shtml"

/*
 10.23 新增 企业名片详情
 */
#define kCOMPANY_DETAIL_URL @"enterprise/personal/enterprise/detail.shtml"

/*
 企业名片详情
 */
#define kPERSONNEL_DETAIL_URL @"enterprise/personal/detail.shtml"

/*
 企业名片付款
 */
#define kCOMPANY_PAY_URL @"enterprise/get/pay/amount.shtml"

/*
 企业认证提交审核
 */
#define kSUB_AUTHENTICATION_URL @"enterprise/submission/authentication.shtml"

/*
 企业认证保存信息
 */
#define kSAVE_AUTHENTICATION_URL @"enterprise/upload/authentication.shtml"

/*
 获取企业付费列表
 */
#define kCOMPANY_PAY_LIST_URL @"enterprise/get/pay/amount.shtml"

/*
 收藏企业列表
 */
#define kCOMPANY_COLLECTION_LIST_URL @"enterprise/collection/list.shtml"

/*
 删除收藏企业
 */
#define kREMOVE_COLLECTION_URL @"enterprise/remove/collection.shtml"

/*
 删除员工
 */
#define kREMOVE_STALL_URL @"enterprise/remove/staff.shtml"

/*
 添加员工
 */
#define kADD_STALL_URL @"enterprise/add/staff.shtml"

/*
 待处理消息
 */
#define kTREATED_MESSAGE_URL @"userFriend/treated/message.shtml"

/*
 待处理消息详情
 */
#define kTREATED_MESSAGE_DETAIL_URL @"message/treated/message/detail.shtml"

/*
 搜索企业列表
 */
#define kSEARCH_COMPANY_URL @"enterprise/search.shtml"

/*
 我的企业名片数量
 */
#define kCOMPANY_NUM_URL @"enterprise/num.shtml"

/*
 是否购买过企业名片
 */
#define kIS_PAY_COMPANY_URL @"enterprise/is/pay.shtml"

/*
 企业购买名片
 */
#define kPAY_COMPANY_URL @"enterprise/order/pay/money.shtml"

/*
 删除已认领的企业
 */
#define kDELETE_CLAIM_COMPANY_URL @"enterprise/remove/claim/enterprise.shtml"

/*
 欢迎页用户信息
 */
#define kWELCOME_COMPANY_URL @"enterprise/welcome/invitation/user.shtml"

#endif /* RequestUrl_h */
