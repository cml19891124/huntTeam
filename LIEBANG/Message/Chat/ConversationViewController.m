//
//  ConversationViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ConversationViewController.h"
#import "QuestionDetailViewController.h"
#import "CompanyDetailViewController.h"
#import "WMLocationViewController.h"
#import "ThemeDetailViewController.h"
#import "AccountViewController.h"
#import "MyFriendViewController.h"
#import "IQKeyboardManager.h"
#import "ApplySuccessViewController.h"
#import "RCDataManager.h"
#import "FriendService.h"
#import "WMVideoMessageCell.h"
#import "WMContentCell.h"
#import "AccountService.h"
#import "MessageService.h"
#import "WMCompanyCell.h"

@interface ConversationViewController ()<RCIMUserInfoDataSource,RCMessageCellDelegate>

@property (nonatomic,strong)UIButton *rightNaviBtn;

@end

@implementation ConversationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable=false;
    [self createNavButton];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable=true;

}

- (void)createNavButton {
    
    self.rightNaviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightNaviBtn.frame=CGRectMake(0, 0, 44, 44);
    [self.rightNaviBtn setImage:[UIImage imageNamed:@"nav_btn_more"] forState:UIControlStateNormal];
    self.rightNaviBtn.backgroundColor=[UIColor clearColor];
    self.rightNaviBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightNaviBtn];
    self.navigationItem.rightBarButtonItem=rightButton;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0, 30.0, 44.0)];//
    [back setImage:[UIImage imageNamed:@"nav_btn_backblue"] forState:UIControlStateNormal];
    [back setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [back addTarget:self action:@selector(backNavItemTapped) forControlEvents:UIControlEventTouchUpInside];
    back.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)rightNaviBtnClick:(UIButton *)sender {
    
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"拉黑/屏蔽" image:nil handler:^(YCMenuAction *action) {
        [self addBlackFriendRequest];
    }];
    YCMenuAction *action2 = [YCMenuAction actionWithTitle:@"加为好友" image:nil handler:^(YCMenuAction *action) {
        [self addFriendRequest];
    }];
    YCMenuAction *action3 = [YCMenuAction actionWithTitle:@"解除好友关系" image:nil handler:^(YCMenuAction *action) {
        [self deleteFriendEvent];
    }];
    
    [CHAlertView displayOverFlowActivityView:self.view];
    [MessageService isFriendWithParameters:self.targetId success:^(NSString *info) {
        [CHAlertView removeOverFlowActivityView:self.view];
        if (info.boolValue) {
            YCMenuView *view = [YCMenuView menuWithActions:@[action1,action3] width:140 relyonView:sender];
            view.maxDisplayCount = 10;
            [view show];
        }
        else {
            YCMenuView *view = [YCMenuView menuWithActions:@[action1,action2] width:140 relyonView:sender];
            view.maxDisplayCount = 10;
            [view show];
        }
    } failure:^(NSUInteger code, NSString *errorStr) {
        [CHAlertView removeOverFlowActivityView:self.view];
        [CHAlertView presentHUBMessage:errorStr showView:self.view];
    }];
}

//添加黑名单
- (void)addBlackFriendRequest {
    
    UIAlertController *alert = [CHAlertView showMessageWith:@"确定" title:@"确定将该用户移至黑名单?" confim:^{
        [FriendService getAddBlackFriendWithParameters:self.targetId success:^(NSString *success) {
            [self alertErrorAndLeft:success];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self alertErrorAndLeft:errorStr];
        }];
    }];
    [self presentViewController:alert animated:YES completion:nil];
    
}

//删除好友
- (void)deleteFriendEvent {
    
    [FriendService getDeleteFriendWithParameters:self.targetId success:^(NSString *success) {
        [self alertErrorAndLeft:success];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [FriendService getFriendListWithSuccess:^(FriendListModel *model) {
            } failure:^(NSUInteger code, NSString *errorStr) {
            }];
        });
        
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self alertErrorAndLeft:errorStr];
    }];
}

//申请好友
- (void)addFriendRequest {
    
    [FriendService getAddFriendWithParameters:self.targetId success:^(NSString *success) {
        ApplySuccessViewController *nextCtr = [[ApplySuccessViewController alloc] init];
        [self.navigationController pushViewController:nextCtr animated:YES];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self alertErrorAndLeft:errorStr];
    }];
}

- (void)backNavItemTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView
                             cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    
    RCMessageContent *messageContent = model.content;
    
    if ([messageContent isMemberOfClass:[WMCardMessage class]])
    {
        WMVideoMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMVideoMessageCell" forIndexPath:indexPath];
        [cell setDataModel:model];
        [cell setDelegate:self];
        return cell;
    }
    else if ([messageContent isMemberOfClass:[WMContent class]])
    {
        WMContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMContentCell" forIndexPath:indexPath];
        [cell setDataModel:model];
        [cell setDelegate:self];
        return cell;
    }
    else if ([messageContent isMemberOfClass:[WMCompanyMessage class]])
    {
        WMCompanyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMCompanyCell" forIndexPath:indexPath];
        [cell setDataModel:model];
        [cell setDelegate:self];
        return cell;
    }
    else {
        return [super rcConversationCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [self shareMessageContent];
    
    [self registerClass:[WMVideoMessageCell class] forMessageClass:[WMCardMessage class]];
    [self registerClass:[WMContentCell class] forMessageClass:[WMContent class]];
    [self registerClass:[WMCompanyCell class] forMessageClass:[WMCompanyMessage class]];
    
    //设置输入工具栏的样式
    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER_EXTENTION];
    UIImage *imageFile = [RCKitUtility imageNamed:@"card" ofBundle:@"RongCloud.bundle"];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:imageFile
                                                                   title:@"个人名片"
                                                                 atIndex:2
                                                                     tag:203];
    
//    UIImage *imageFile1 = [RCKitUtility imageNamed:@"Comment" ofBundle:@"RongCloud.bundle"];
//    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:imageFile1
//                                                                   title:@"去TA的主页"
//                                                                 atIndex:2
//                                                                     tag:204];
    
    //刷新自己头像昵称
    self.displayUserNameInCell = NO;
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    [[RCIM sharedRCIM] refreshUserInfoCache:[RCIMClient sharedRCIMClient].currentUserInfo withUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId];
}

//分享的消息
- (void)shareMessageContent {
    
    [AccountService getPrivateLetterWithParameters:self.targetId success:^(id model) {
        if ([model intValue] == 0)
        {//0 不可以发送  1：可以发送
            self.chatSessionInputBarControl.hidden = YES;
            UIAlertController *alert = [CHAlertView showAlertWith:@"知道了" title:@"对方已设置私信权限:\n仅好友可私信！" confim:^{
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            if (!IsStrEmpty(self.message) && !IsNilOrNull(self.message)) {
                RCTextMessage *msg = [RCTextMessage messageWithContent:self.message];
                [self sendMessage:msg pushContent:nil];
            }
            if (!IsNilOrNull(self.cardMessage)) {
                [self sendMessage:self.cardMessage pushContent:nil];
            }
            if (!IsNilOrNull(self.shareMessage)) {
                [self sendMessage:self.shareMessage pushContent:nil];
            }
            if (!IsNilOrNull(self.companyMessage)) {
                [self sendMessage:self.companyMessage pushContent:nil];
            }
        }
    } failure:^(NSUInteger code, NSString *errorStr) {
        [CHAlertView presentHUBMessage:@"发送失败，请重新发送" showView:self.view];
    }];
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {
    
    if (tag == 204)
    {
        AccountViewController *nextCtr = [[AccountViewController alloc] init];
        nextCtr.accountState = AccountStateOther;
        nextCtr.userUid = self.targetId;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if (tag == 203)
    {
        MyFriendViewController *nextCtr = [[MyFriendViewController alloc] init];
        nextCtr.messageButtonBlock = ^(FriendModel *model) {
            WMCardMessage *videoMessage = [WMCardMessage messageWithContent:model];
            [self sendMessage:videoMessage pushContent:nil];
        };
        [self.navigationController pushViewController:nextCtr animated:YES];
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];//记得调用super父类的方法
    }
    else
    {
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }
}

/*!
 点击Cell中头像的回调
 
 @param userId  点击头像对应的用户ID
 */
- (void)didTapCellPortrait:(NSString *)userId {
    
    if (![[Config currentConfig].userUid isEqualToString:userId]) {
        AccountViewController *nextCtr = [[AccountViewController alloc] init];
        nextCtr.accountState = AccountStateOther;
        nextCtr.userUid = userId;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else {
        AccountViewController *nextCtr = [[AccountViewController alloc] init];
        nextCtr.accountState = AccountStateNormal;
        nextCtr.userUid = userId;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
}

- (void)didTapMessageCell:(RCMessageModel *)model {
    RCMessageContent *messageContent = model.content;
    if ([messageContent isMemberOfClass:[WMCardMessage class]])
    {
        WMCardMessage *_videoMessage = (WMCardMessage *)model.content;
        if (_videoMessage) {
            AccountViewController *nextCtr = [[AccountViewController alloc] init];
            if ([[Config currentConfig].userUid isEqualToString:_videoMessage.userUid])
            {
                nextCtr.accountState = AccountStateNormal;
            }
            else
            {
                nextCtr.accountState = AccountStateOther;
            }
            nextCtr.userUid = _videoMessage.userUid;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
    }
    else if ([messageContent isMemberOfClass:[WMContent class]])
    {
        WMContent *dto = (WMContent *)model.content;
        if ([dto.detailType isEqualToString:@"2"])
        {
            ThemeDetailViewController *nextCtr = [[ThemeDetailViewController alloc] init];
            nextCtr.themeUid = dto.detailUid;
            if ([dto.shareUid isEqualToString:[Config currentConfig].userUid]) {
                nextCtr.detailState = ThemeDetailStateEdit;
            }
            else {
                nextCtr.detailState = ThemeDetailStateNormal;
            }
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
        else if ([dto.detailType isEqualToString:@"1"])
        {
            QuestionDetailViewController *nextCtr = [[QuestionDetailViewController alloc] init];
            nextCtr.detailType = QuestionDetailTypeVisitor;
            nextCtr.questionUid = dto.detailUid;
            [self.navigationController pushViewController:nextCtr animated:YES];
        }
    }
    else if ([messageContent isMemberOfClass:[RCLocationMessage class]])
    {
        RCLocationMessage *dto = (RCLocationMessage *)model.content;
        WMLocationViewController *nextCtr = [[WMLocationViewController alloc] init];
        nextCtr.locationName = dto.locationName;
        nextCtr.location = dto.location;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else if ([messageContent isMemberOfClass:[WMCompanyMessage class]])
    {
        WMCompanyMessage *dto = (WMCompanyMessage *)model.content;
        CompanyDetailViewController *nextCtr = [[CompanyDetailViewController alloc] init];
        nextCtr.companyUid = dto.id;
        nextCtr.companyName = dto.companyAbbreviation;
        nextCtr.companyType = @"1";
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else
    {
        [super didTapMessageCell:model];
    }
}

// cell样式
- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if([cell isMemberOfClass:[RCTextMessageCell class]]) {
        // 内容
        RCTextMessageCell *textC=(RCTextMessageCell *)cell;
        UILabel *textL=(UILabel *)textC.textLabel;
        [textL setTextColor:[UIColor colorWithHexString:@"414141"]];
        [textL setFont:kSystem(15)];
        [self reloadImageView:(UIImageView *)textC.portraitImageView];
    } else if([cell isMemberOfClass:[RCRichContentMessageCell class]]) {
        RCRichContentMessageCell *rCell=(RCRichContentMessageCell *)cell;
        [self reloadImageView:(UIImageView *)rCell.portraitImageView];
    } else if([cell isMemberOfClass:[RCVoiceMessageCell class]]) {
        RCVoiceMessageCell *rCell=(RCVoiceMessageCell *)cell;
        [self reloadImageView:(UIImageView *)rCell.portraitImageView];
    } else if([cell isMemberOfClass:[RCImageMessageCell class]]) {
        RCImageMessageCell *rCell=(RCImageMessageCell *)cell;
        [self reloadImageView:(UIImageView *)rCell.portraitImageView];
    } else if([cell isMemberOfClass:[RCLocationMessageCell class]]) {
        RCLocationMessageCell *rCell=(RCLocationMessageCell *)cell;
        [self reloadImageView:(UIImageView *)rCell.portraitImageView];
    } else if([cell isMemberOfClass:[WMVideoMessageCell class]]) {
        WMVideoMessageCell *rCell=(WMVideoMessageCell *)cell;
        [self reloadImageView:(UIImageView *)rCell.portraitImageView];
    } else if([cell isMemberOfClass:[WMContentCell class]]) {
        WMContentCell *rCell=(WMContentCell *)cell;
        [self reloadImageView:(UIImageView *)rCell.portraitImageView];
    } else if([cell isMemberOfClass:[WMCompanyCell class]]) {
        WMCompanyCell *rCell=(WMCompanyCell *)cell;
        [self reloadImageView:(UIImageView *)rCell.portraitImageView];
    }
}

- (void)reloadImageView:(UIImageView *)portraitImageView {
    portraitImageView.layer.cornerRadius = CGRectGetHeight(portraitImageView.frame)/2;
    [portraitImageView setContentScaleFactor:[[UIScreen mainScreen]scale]];
    portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    portraitImageView.autoresizingMask = UIViewAutoresizingNone;
}

#pragma mark 获取个人信息
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    
    NSMutableArray *list = (NSMutableArray *)[NSObject readObjforKey:kRCUSERINFO];
    for (RCUserInfo *info in list) {
        if ([userId isEqualToString:info.userId]) {
            completion(info);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
