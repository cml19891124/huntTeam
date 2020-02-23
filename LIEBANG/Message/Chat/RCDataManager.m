



//
//  RCDataManager.m
//  RCIM
//
//  Created by 郑文明 on 15/12/30.
//  Copyright © 2015年 郑文明. All rights reserved.
//

#import "RCDataManager.h"
#import "RCUserInfo+Addition.h"
#import "AppDelegate.h"
#import "FriendListModel.h"
#import "FriendModel.h"
#import "FriendService.h"
#import "MessageService.h"
#import "WMConversationListViewController.h"

@implementation RCDataManager{
        NSMutableArray *dataSoure;
}

- (instancetype)init{
    if (self = [super init]) {
        [RCIM sharedRCIM].userInfoDataSource = self;
    }
    return self;
}

+ (RCDataManager *)shareManager{
    static RCDataManager* manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

/**
 *  从服务器同步好友列表
 */
-(void)syncFriendList:(void (^)(NSMutableArray* friends,BOOL isSuccess))completion
{
    dataSoure = [[NSMutableArray alloc]init];

    [FriendService getFriendListWithSuccess:^(FriendListModel *model) {
        [Config currentConfig].friendCount = [NSString stringWithFormat:@"%zd",model.data.count];
        for (FriendModel *dto in model.data) {
            
        
            
            RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:dto.userUid name:dto.userName portrait:dto.userHead isBasic:dto.isBasic isOccupation:dto.isOccupation job:dto.position];
            [self->dataSoure addObject:userInfo];
        }
        NSLog(@"dataSoure.count = %zd",self->dataSoure.count);
    } failure:^(NSUInteger code, NSString *errorStr) {
        
    }];

    [AppDelegate currentAppDelegate].friendsArray = dataSoure;
    [self syncRCUserInfo];
    completion(dataSoure,YES);
    
}

- (void)syncRCUserInfo {
    
    NSMutableArray *data = [NSMutableArray array];
    NSMutableArray *list = (NSMutableArray *)[NSObject readObjforKey:kRCUSERINFO];
    
    
    for (int j = 0; j < list.count; j++) {
        RCUserInfo *user = [list safeObjectAtIndex:j];
        BOOL isNewUser = YES;
        for (int i = 0; i < [AppDelegate currentAppDelegate].friendsArray.count; i++) {
            RCUserInfo *userInfo = [[AppDelegate currentAppDelegate].friendsArray safeObjectAtIndex:i];
            
            if ([userInfo.userId isEqualToString:user.userId]) {
                [data addObject:userInfo];
                isNewUser = NO;
                break;
            }
        }
        if (isNewUser) {
            [data addObject:user];
        }
    }
    
//    for (RCUserInfo *userInfo in [AppDelegate currentAppDelegate].friendsArray) {
//        BOOL isNewUser = YES;
//        for (RCUserInfo *user in list) {
//            if ([userInfo.userId isEqualToString:user.userId]) {
//                [data addObject:userInfo];
//                isNewUser = NO;
//                break;
//            }
//        }
//        if (isNewUser) {
//            [data addObject:userInfo];
//        }
//    }
    [NSObject saveObj:data withKey:kRCUSERINFO];
}

- (void)addRCUserInfo:(RCUserInfo *)model {
    
    if (IsNilOrNull(model)) {
        return;
    }
    NSMutableArray *list = (NSMutableArray *)[NSObject readObjforKey:kRCUSERINFO];
    NSMutableArray *data = [NSMutableArray arrayWithArray:list];
    BOOL isNewUser = YES;
    for (RCUserInfo *userInfo in list) {
        if ([userInfo.userId isEqualToString:model.userId]) {
            isNewUser = NO;
            break;
        }
    }
    if (isNewUser) {
        [data addObject:model];
    }
    [NSObject saveObj:data withKey:kRCUSERINFO];
}

#pragma mark
#pragma mark 根据userId获取RCUserInfo
-(RCUserInfo *)currentUserInfoWithUserId:(NSString *)userId{
    
    NSMutableArray *list = (NSMutableArray *)[NSObject readObjforKey:kRCUSERINFO];
    for (RCUserInfo *user in list) {
        if ([user.userId isEqualToString:userId]) {
            return user;
        }
    }
    
//    for (NSInteger i = 0; i<[AppDelegate currentAppDelegate].friendsArray.count; i++) {
//        RCUserInfo *aUser = [AppDelegate currentAppDelegate].friendsArray[i];
//        if ([userId isEqualToString:aUser.userId]) {
//            NSLog(@"current ＝ %@",aUser.name);
//            return aUser;
//        }
//    }
    return nil;
}
#pragma mark

-(NSString *)currentNameWithUserId:(NSString *)userId{
//    for (NSInteger i = 0; i<[AppDelegate currentAppDelegate].friendsArray.count; i++) {
//        RCUserInfo *aUser = [AppDelegate currentAppDelegate].friendsArray[i];
//        if ([userId isEqualToString:aUser.userId]) {
//            NSLog(@"current ＝ %@",aUser.name);
//            return aUser.name;
//        }
//    }
    
    NSMutableArray *list = (NSMutableArray *)[NSObject readObjforKey:kRCUSERINFO];
    for (RCUserInfo *user in list) {
        if ([user.userId isEqualToString:userId]) {
            return user.name;
        }
    }
    
    return nil;
}
#pragma mark
#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))completion
{
    NSLog(@"getUserInfoWithUserId ----- %@", userId);
    
    if (userId == nil || [userId length] == 0 )
    {
        [self syncFriendList:^(NSMutableArray *friends, BOOL isSuccess) {
            
        }];
        
        completion(nil);
        return ;
    }
    
    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
//        RCUserInfo *myselfInfo = [[RCUserInfo alloc]initWithUserId:[RCIM sharedRCIM].currentUserInfo.userId name:[RCIM sharedRCIM].currentUserInfo.name portrait:[RCIM sharedRCIM].currentUserInfo.portraitUri QQ:[RCIM sharedRCIM].currentUserInfo.QQ sex:[RCIM sharedRCIM].currentUserInfo.sex];
        RCUserInfo *myselfInfo = [[RCUserInfo alloc] initWithUserId:[RCIM sharedRCIM].currentUserInfo.userId name:[RCIM sharedRCIM].currentUserInfo.name portrait:[RCIM sharedRCIM].currentUserInfo.portraitUri isBasic:[RCIM sharedRCIM].currentUserInfo.isBasic isOccupation:[RCIM sharedRCIM].currentUserInfo.isOccupation job:[RCIM sharedRCIM].currentUserInfo.job];
        completion(myselfInfo);
        
    }
    
    for (NSInteger i = 0; i<[AppDelegate currentAppDelegate].friendsArray.count; i++) {
        RCUserInfo *aUser = [AppDelegate currentAppDelegate].friendsArray[i];
        if ([userId isEqualToString:aUser.userId]) {
            completion(aUser);
            break;
        }
    }
}
#pragma mark
#pragma mark - RCIMGroupInfoDataSource

-(void)loginRongCloudWithUserInfo:(RCUserInfo *)userInfo withToken:(NSString *)token{
                [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                    [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor redColor];
                    NSLog(@"login success with userId %@",userId);
                    //同步好友列表
                    [self syncFriendList:^(NSMutableArray *friends, BOOL isSuccess) {
                        NSLog(@"%@",friends);

                    }];
                    
                    [WMConversationListViewController shareMyChatViewController];
                    
                    [[RCIM sharedRCIM] setCurrentUserInfo:userInfo];
                    [RCIMClient sharedRCIMClient].currentUserInfo = userInfo;
                    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
                    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
//                    [RCIMClient sharedRCIMClient] setMessageSentStatus:<#(long)#> sentStatus:<#(RCSentStatus)#>
                    [[RCDataManager shareManager] refreshBadgeValue];
                } error:^(RCConnectErrorCode status) {
                    [[RCIM sharedRCIM] setCurrentUserInfo:userInfo];
                    [RCIMClient sharedRCIMClient].currentUserInfo = userInfo;
                    NSLog(@"status = %ld",(long)status);
                } tokenIncorrect:^{
                    [[RCIM sharedRCIM] setCurrentUserInfo:userInfo];
                    [RCIMClient sharedRCIMClient].currentUserInfo = userInfo;
                    NSLog(@"token 错误");
                }];
   
}

-(void)refreshBadgeValue{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger unreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
        
        UIView *readView = [[AppDelegate currentAppDelegate].tabBarCtr.tabBarView viewWithTag:999999];
        if (unreadMsgCount == 0) {
            readView.hidden = YES;
        }
        else {
            readView.hidden = NO;
        }
        
        [MessageService getMessageRedButtonWithSuccess:^(NSDictionary *info) {
            if ([[info objectForKey:@"privateLetter"] boolValue] || [[info objectForKey:@"visit"] boolValue] || [[info objectForKey:@"system"] boolValue])
            {
                readView.hidden = NO;
            }
            if (![[info objectForKey:@"system"] boolValue])
            {
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:unreadMsgCount];
                [JPUSHService setBadge:unreadMsgCount];
            }
            
            if ([info isKindOfClass:[NSDictionary class]]) {
                UIView *redView3 = [[AppDelegate currentAppDelegate].window viewWithTag:100000];
                UIView *redView1 = [[AppDelegate currentAppDelegate].window viewWithTag:100001];
                UIView *redView2 = [[AppDelegate currentAppDelegate].window viewWithTag:100002];
                
                if (unreadMsgCount == 0) {
                    redView3.hidden = ![[info objectForKey:@"privateLetter"] boolValue];
                }
                else {
                    redView3.hidden = NO;
                }
                redView1.hidden = ![[info objectForKey:@"visit"] boolValue];
                redView2.hidden = ![[info objectForKey:@"system"] boolValue];
            }
        }];
        
//        UINavigationController  *chatNav = [AppDelegate shareAppDelegate].tabbarVC.viewControllers[1];
//        if (unreadMsgCount == 0) {
//            chatNav.tabBarItem.badgeValue = nil;
//        }else{
//            chatNav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%li",(long)unreadMsgCount];
//        }
    });
}

-(BOOL)hasTheFriendWithUserId:(NSString *)userId{
    if ([AppDelegate currentAppDelegate].friendsArray.count) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        
        for (RCUserInfo *aUserInfo in [AppDelegate currentAppDelegate].friendsArray) {
            [tempArray addObject:aUserInfo.userId];
        }
        
        if ([tempArray containsObject:userId]) {
            return YES;
        }
    }
    
    
    return NO;
}
@end

