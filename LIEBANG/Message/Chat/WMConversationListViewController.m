

//
//  WMConversationListViewController.m
//  RCIM
//
//  Created by 郑文明 on 15/12/30.
//  Copyright © 2015年 郑文明. All rights reserved.
//

#import "WMConversationListViewController.h"
#import "AccountViewController.h"
#import "MosaicViewController.h"
#import "AppDelegate.h"
#import "RCDataManager.h"
#import "RCCustomCell.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "RCUserInfo+Addition.h"
#import "ConversationViewController.h"
#import "TipMessageCell.h"
#import "PendViewController.h"
#import "PendModel.h"
#import "FriendService.h"

@interface WMConversationListViewController ()<RCIMReceiveMessageDelegate,RCIMConnectionStatusDelegate
,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)TipMessageCell *tipView;

@end

@implementation WMConversationListViewController

+ (WMConversationListViewController *)shareMyChatViewController {
    static WMConversationListViewController *myChatVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myChatVC = [[WMConversationListViewController alloc] init];
    });
    return myChatVC;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置需要显示哪些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
        
        //设置需要将哪些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[@(ConversationType_SYSTEM)]];
        
        [RCIM sharedRCIM].receiveMessageDelegate = self;
        [RCIM sharedRCIM].connectionStatusDelegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMessageNotification:)name:RCKitDispatchMessageNotification object:nil];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        
        //设置需要显示哪些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
        
        //设置需要将哪些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[@(ConversationType_SYSTEM)]];
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[RCDataManager shareManager] refreshBadgeValue];
    self.conversationListTableView.tableHeaderView = self.tipView;
    [self.conversationListTableView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadPendDataSource];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[RCDataManager shareManager] refreshBadgeValue];
}

/*!
 接收消息的回调方法
 *
 */
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    [[RCDataManager shareManager] refreshBadgeValue];
    [self.conversationListTableView reloadData];
}
#pragma mark - RCIMConnectionStatusDelegate

/**
 *  网络状态变化。
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    LoginModel *account = [SDUserTool account];

    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        
        account.rongCloudToken = nil;
        [Config currentConfig].registrationID = nil;
        [Config currentConfig].balanceAmount = nil;
        [Config currentConfig].liebangCurrency = nil;
        [Config currentConfig].friendCount = nil;
        [Config currentConfig].userUid = nil;
        [Config currentConfig].company = nil;
        [[RCIM sharedRCIM] logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IS_PAY_COMPANY_NOTIFICATION" object:nil];
        UIAlertController *alert = [CHAlertView showAlertWith:@"知道了" title:@"您的帐号已在别的设备上登录，\n您被迫下线！" confim:^{
            LoginViewController *loginCtr = [[LoginViewController alloc] init];
            CommonNavgationViewController *loginNav = [[CommonNavgationViewController alloc] initWithRootViewController:loginCtr];
            [self.navigationController presentViewController:loginNav animated:YES completion:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[AppDelegate currentAppDelegate].tabBarCtr tabBarSetSelectedIndex:0];
            }];
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark
#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.conversationListTableView.separatorColor = [UIColor colorWithHexString:@"dfdfdf"];
    self.conversationListTableView.tableFooterView = [UIView new];
}

- (void)loadPendDataSource {
    
    [FriendService getUnreadNumWithSuccess:^(NSString *number) {
        self.tipView.readCount = [number integerValue];
    } failure:^(NSUInteger code, NSString *errorStr) {
        self.tipView.readCount = 0;
    }];
}

#pragma mark
#pragma mark 禁止右滑删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//左滑删除
-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //可以从数据库删除数据
    [self refreshConversationTableViewIfNeeded];
    RCConversationModel *model = [self.conversationListDataSource safeObjectAtIndex:indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:model.conversationType targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
    [[RCDataManager shareManager] refreshBadgeValue];
}
//高度
-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}

//插入自定义会话model
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource{
    for (int i=0; i<dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        if(model.conversationType == ConversationType_PRIVATE){
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
    }
    return dataSource;
}

#pragma mark
#pragma mark onSelectedTableRow
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    
    if (model.conversationType==ConversationType_PRIVATE) {//单聊
        RCCustomCell *cell = (RCCustomCell *)[self rcConversationListTableView:self.conversationListTableView cellForRowAtIndexPath:indexPath];
        
        
        NSInteger iconNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:iconNumber-model.unreadMessageCount];
        [JPUSHService setBadge:iconNumber-model.unreadMessageCount];

        ConversationViewController *_conversationVC = [[ConversationViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        
//        RCUserInfo *aUserInfo = [[RCDataManager shareManager] currentUserInfoWithUserId:model.targetId];
//        _conversationVC.title = IsStrEmpty(aUserInfo.name)?@"未知好友":aUserInfo.name;
        _conversationVC.title = cell.name;
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
}

-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf;
    if (!IsArrEmpty(self.conversationListDataSource))
    {
        static NSString *cellStr = @"RCCustomCell";
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
        RCCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[RCCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        [cell setConversationModel:model];
        cell.accountButtonBlock = ^{
            [weakSelf gotoAccountViewController:nil userUid:model.targetId];
        };
        cell.GetBasicSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        cell.GetWorkSourceBlock = ^(NSString *imageUrl) {
            [weakSelf pushToMosaicVC:imageUrl];
        };
        return cell;
    }
    else
    {
        return [[RCConversationBaseCell alloc]init];
    }
//    if (self.conversationListDataSource.count&&indexPath.row < self.conversationListDataSource.count) {
//
//    }
//    else{
//
//    }
}

- (void)pushToMosaicVC:(NSString *)turnStr {
    MosaicViewController *nextCtr = [[MosaicViewController alloc] init];
    nextCtr.imageUrl = turnStr;
    [self presentViewController:nextCtr animated:NO completion:nil];
}

//查看资料权限
- (void)gotoAccountViewController:(NSString *)dataPrivacyType userUid:(NSString *)userUid {
    
    AccountViewController *nextCtr = [[AccountViewController alloc] init];
    if ([[Config currentConfig].userUid isEqualToString:userUid]) {
        nextCtr.accountState = AccountStateNormal;
    }
    else {
        nextCtr.accountState = AccountStateOther;
    }
    nextCtr.userUid = userUid;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

#pragma mark - 收到消息监听
-(void)didReceiveMessageNotification:(NSNotification *)notification{
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    
    if ([message.content isMemberOfClass:[RCMessageContent class]]) {
        if (message.conversationType == ConversationType_PRIVATE) {
            NSLog(@"好友消息要发系统消息！！！");
            @throw  [[NSException alloc] initWithName:@"error" reason:@"好友消息要发系统消息！！！" userInfo:nil];
        }
        RCConversationModel *customModel = [RCConversationModel new];
        //自定义cell的type
        customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        customModel.senderUserId = message.senderUserId;
        customModel.lastestMessage = message.content;
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
//            [super didReceiveMessageNotification:notification];
//            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [blockSelf_ emptyConversationView];
//            [self notifyUpdateUnreadMessageCount];
            
            //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
            //原因请查看super didReceiveMessageNotification的注释。
            
            [[RCDataManager shareManager] addRCUserInfo:customModel.lastestMessage.senderUserInfo];
//             [[RCIM sharedRCIM] refreshUserInfoCache:customModel.lastestMessage.senderUserInfo withUserId:customModel.senderUserId];
            
        });
        
    }else if (message.conversationType == ConversationType_PRIVATE){
        //获取接受到会话
        RCConversation *receivedConversation = [[RCIMClient sharedRCIMClient] getConversation:message.conversationType targetId:message.targetId];
        
        //转换新会话为新会话模型
        RCConversationModel *customModel = [[RCConversationModel alloc] init:RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION conversation:receivedConversation extend:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
            //[super didReceiveMessageNotification:notification];
//            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [blockSelf_ emptyConversationView];
            [self notifyUpdateUnreadMessageCount];
            
            //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
            //原因请查看super didReceiveMessageNotification的注释。
            NSNumber *left = [notification.userInfo objectForKey:@"left"];
            if (0 == left.integerValue) {
                [super refreshConversationTableViewIfNeeded];
            }
            
            NSLog(@"保存%@信息",customModel.senderUserId);
            [[RCDataManager shareManager] addRCUserInfo:customModel.lastestMessage.senderUserInfo];
            
//            RCUserInfo *user1 = [[RCIM sharedRCIM] getUserInfoCache:customModel.senderUserId];
//            if (IsNilOrNull(user1)) {
//                NSLog(@"保存%@信息",customModel.senderUserId);
//                [[RCDataManager shareManager] addRCUserInfo:customModel.lastestMessage.senderUserInfo];
////                [[RCIM sharedRCIM] refreshUserInfoCache:customModel.lastestMessage.senderUserInfo withUserId:customModel.senderUserId];
//            }
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            调用父类刷新未读消息数
//            [super didReceiveMessageNotification:notification];
//            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [blockSelf_ emptyConversationView];
            [self notifyUpdateUnreadMessageCount];
            //        super会调用notifyUpdateUnreadMessageCount
        });
    }
    NSLog(@"保存刷新列表之前");
//    [self refreshConversationTableViewIfNeeded];
    [self.conversationListTableView reloadData];
    NSLog(@"保存刷新列表之后");
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.conversationListDataSource.count;
}

- (void)showEmptyConversationView{
    
}

- (void)enterPendVC {
    PendViewController *nextCtr = [[PendViewController alloc] init];
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (TipMessageCell *)tipView {
    if (!_tipView) {
        _tipView = [[TipMessageCell alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterPendVC)];
        [_tipView addGestureRecognizer:tap];
    }
    return _tipView;
}

#pragma mark - 禁止下拉
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    
    scrollView.contentOffset = offset;

}
@end
