//
//  AppDelegate.m
//  LIEBANG
//
//  Created by  YIQI on 2018/6/26.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "RCDataManager.h"
#import "AppDelegate+PushService.h"
#import "HomeService.h"
#import "CompanyService.h"
#import "RMStore.h"
#import "WalletService.h"
#import "HXPhotoTools.h"

@interface AppDelegate ()<WXApiDelegate,RCIMUserInfoDataSource>

@property (nonatomic,strong)UIImageView *clickImageView;
@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,strong)NSString *turnUrl;

@property (strong, nonatomic) AppDelegate *appDelegate;
@end

@implementation AppDelegate

+ (AppDelegate *)currentAppDelegate {
   
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (CommonTabBarViewController *)tabBarCtr {
    if (!_tabBarCtr) {
        _tabBarCtr = [[CommonTabBarViewController alloc] init];
    }
    return _tabBarCtr;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self getAPPADRequestItem];
//    });
    
    self.friendsArray = [[NSMutableArray alloc]init];
    
    // 键盘处理工具
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getUserMessageRequestItem];
        [WXApi registerApp:WXappKey];
    });
    
    // 初始化JPush服务
    self.launchOptions = [launchOptions copy];
    [self initJPush];
    
    //友盟分享
    [UMConfigure setLogEnabled:YES];//设置打开日志
    [UMConfigure initWithAppkey:@"59892ebcaed179694b000104" channel:@"App Store"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXappKey appSecret:WXappSecret redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    //融云
    [[RCIM sharedRCIM] initWithAppKey:RongIMAppKey];
    [self loginRongIMService];
    
    //IAP内购丢单处理
    dispatch_async(dispatch_get_main_queue(), ^{
        [self checkOrderStatus];
//        [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions) {
//
//        } failure:^(NSError *error) {
//
//        }];
    });

    
//    [self enterRootViewController];
    [self createSqlite];
    return YES;
}

- (void)getUserMessageRequestItem {
    
    [CompanyService getIsPayCompanyWithSuccess:^(BOOL data) {
        
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        
    }];
}

- (void)loginRongIMService {
    
    //初始化全局的单例RCDataManager（融云数据管理者），这个RCDataManager把所以融云有关数据的逻辑和代码分离了，方便该，也方便维护。这里把userInfoDatasource设置为RCDataManager。
    [RCIM sharedRCIM].userInfoDataSource = [RCDataManager shareManager];
    
    /**enableMessageAttachUserInfo
     *  默认NO，如果YES，发送消息会包含自己用户信息。
     */
    LoginModel *account = [SDUserTool account];

    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    [[RCIM sharedRCIM] registerMessageType:WMCardMessage.class];
    [[RCIM sharedRCIM] registerMessageType:WMContent.class];
    [[RCIM sharedRCIM] registerMessageType:WMCompanyMessage.class];
    RCUserInfo *info = [RCUserInfo new];
    info.name = [Config currentConfig].username;
    info.userId = [Config currentConfig].userUid;
    info.portraitUri = [Config currentConfig].headIcon;
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCDataManager shareManager] loginRongCloudWithUserInfo:info withToken:account.rongCloudToken];
}

- (void)enterRootViewController {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:self.tabBarCtr];
    
//    __unused UITextView *tv = [[UITextView alloc] init];
    
    
    
//    if (IsStrEmpty([Config currentConfig].isFirst) || IsNilOrNull([Config currentConfig].isFirst)) {
//        [Config currentConfig].isFirst = @"YES";
//        NSLog(@"APP第一次启动");
//    } else {
//        NSLog(@"APP第N次启动");
//    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[RCDataManager shareManager] refreshBadgeValue];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)createSqlite{
    
//    //1、创建模型对象
//    //获取模型路径
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
//    //根据模型文件创建模型对象
//    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//
//
//    //2、创建持久化存储助理：数据库
//    //利用模型对象创建助理对象
//    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
//
//    //数据库的名称和路径
//    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *sqlPath = [docStr stringByAppendingPathComponent:@"coreData.sqlite"];
//    NSLog(@"数据库 path = %@", sqlPath);
//    NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
//
//    NSError *error = nil;
//    //设置数据库相关信息 添加一个持久化存储库并设置存储类型和路径，NSSQLiteStoreType：SQLite作为存储库
//    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:&error];
//
//    if (error) {
//        NSLog(@"添加数据库失败:%@",error);
//    } else {
//        NSLog(@"添加数据库成功");
//    }
//
//    //3、创建上下文 保存信息 操作数据库
//
//    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//
//    //关联持久化助理
//    context.persistentStoreCoordinator = store;
//
//    _context = context;
    
}

#pragma mark
#pragma mark 加载广告页
- (void)getAPPADRequestItem {
    [self enterRootViewController];
    [self.window addSubview:self.clickImageView];
//    [self.window bringSubviewToFront:self.clickImageView];
    [HomeService getAPPADClassWithParameters:nil success:^(APPADModel *model) {
        self.turnUrl = model.turnUrl;
        [self.window addSubview:self.cancelButton];
        NSString *imageUrl = [model.bannerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self hiddenImageView:NO];
        int leftTime = 0;
        if (!imageUrl) {
            leftTime = 0;
        }else{
            leftTime = 3;
        }
        [self countDownWithTime:leftTime countDownBlock:^(int timeLeft) {
            [self.cancelButton setTitle:[NSString stringWithFormat:@"%dS",timeLeft+1] forState:UIControlStateNormal];
        } endBlock:^{
            [self hiddenImageView:YES];
        }];
        [self.clickImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[self placeholderImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            if (error)
//            {
//                [self hiddenImageView:YES];
//            }
//            else
//            {
//                [self hiddenImageView:NO];
//                [self countDownWithTime:3 countDownBlock:^(int timeLeft) {
//                    [self.cancelButton setTitle:[NSString stringWithFormat:@"%dS",timeLeft+1] forState:UIControlStateNormal];
//                } endBlock:^{
//                    [self hiddenImageView:YES];
//                }];
//            }
        }];

    } failure:^(NSUInteger code, NSString *errorStr) {
        [self hiddenImageView:YES];
    }];
}

- (void)hiddenImageView:(BOOL)isShow {
    self.clickImageView.hidden = isShow;
    self.cancelButton.hidden = isShow;
}

- (UIImageView *)clickImageView {
    if (!_clickImageView) {
        _clickImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
//        _clickImageView.hidden = YES;
        _clickImageView.userInteractionEnabled = YES;
        _clickImageView.image = [self placeholderImage];
        UITapGestureRecognizer *r5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headIconClick:)];
        [_clickImageView addGestureRecognizer:r5];
    }
    return _clickImageView;
}

- (UIImage *)placeholderImage {
    if (isIphone4) {
        return [UIImage imageNamed:@"640x960"];
    }
    else if (isIphone5) {
        return [UIImage imageNamed:@"640x1136"];
    }
    else if (isIphone6) {
        return [UIImage imageNamed:@"750x1334"];
    }
    else if (isIphone6p) {
        return [UIImage imageNamed:@"1242x2208"];
    }
    else {
        return [UIImage imageNamed:@"1125x2436"];
    }
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(kDeviceWidth-65, 40, 40, 40);
        [_cancelButton setTitle:@"3S" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:kLBBlackColor forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:kWhiteColor];
        _cancelButton.alpha = 0.5;
        _cancelButton.layer.cornerRadius = 20;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.titleLabel.font = kSystem(14);
        _cancelButton.hidden = YES;
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (void)cancelButtonClick {
    [self hiddenImageView:YES];
}

- (void)headIconClick:(UITapGestureRecognizer *)tap {
    
    if (IsNilOrNull(self.turnUrl) || IsStrEmpty(self.turnUrl)) {
        return;
    }
    
    [self hiddenImageView:YES];
    WebViewController *nextCtr = [[WebViewController alloc] init];
    CommonNavgationViewController *nextNav = [[CommonNavgationViewController alloc] initWithRootViewController:nextCtr];
    nextCtr.contentString = self.turnUrl;
    nextCtr.navTitle = @"推广";
    nextCtr.isPresent = YES;
    nextCtr.webViewType = WebViewTypeHTTP;
    [self.window.rootViewController presentViewController:nextNav animated:NO completion:nil];
}

- (void)countDownWithTime:(int)time
           countDownBlock:(void (^)(int timeLeft))countDownBlock
                 endBlock:(void (^)(void))endBlock
{
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (endBlock) {
                    endBlock();
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                timeout--;
                if (countDownBlock) {
                    countDownBlock(timeout);
                }
            });
        }
    });
    dispatch_resume(_timer);
}

#pragma mark -- 丢单处理
static NSString *const kSaveReceiptData = @"kSaveReceiptData";
//检查漏单情况
- (void)checkOrderStatus
{
    NSMutableArray *orderInfo = [self getReceiptData];
    if (orderInfo != nil) {
        [self verifyPurchaseForServiceWithReceipt:orderInfo];
    }
}

- (void)verifyPurchaseForServiceWithReceipt:(NSMutableArray *)receiptString {
    [WalletService appleRechargeWithParameters:receiptString success:^(NSString *data) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self removeLocReceiptData];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

- (void)saveReceiptData:(NSDictionary *)receiptData
{
    [[NSUserDefaults standardUserDefaults] setValue:receiptData forKey:kSaveReceiptData];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (NSMutableArray *)getReceiptData
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kSaveReceiptData];
}

- (void)removeLocReceiptData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSaveReceiptData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//#pragma mark -- 数据处理
//
////插入数据
//- (void)insertData:(LBUser *)model {
//    
//    // 1.根据Entity名称和NSManagedObjectContext获取一个新的继承于NSManagedObject的子类Student
//    
//    LBUser * user = [NSEntityDescription
//                         insertNewObjectForEntityForName:@"LBUser"
//                         inManagedObjectContext:_context];
//    
//    //  2.根据表Student中的键值，给NSManagedObject对象赋值
//    user.name = model.name;
//    user.userUid = model.userUid;
//    user.imgUrl = model.imgUrl;
//    user.job = model.job;
//    user.isJob = model.isJob;
//    user.isBasic = model.isBasic;
//    
//    //查询所有数据的请求
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LBUser"];
//    NSArray *resArray = [_context executeFetchRequest:request error:nil];
////    _dataSource = [NSMutableArray arrayWithArray:resArray];
////    [self.tableView reloadData];
//    
//    //   3.保存插入的数据
//    NSError *error = nil;
//    if ([_context save:&error]) {
//        NSLog(@"数据插入到数据库成功");
//    }else{
//         NSLog(@"数据插入到数据库失败");
//    }
//    
//}
////
//////删除
////- (void)deleteData:(NSString *)userUid{
////    
////    //创建删除请求
////    NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
////    
////    //删除条件
////    NSPredicate *pre = [NSPredicate predicateWithFormat:@"age < %d", 10];
////    deleRequest.predicate = pre;
////    
////    //返回需要删除的对象数组
////    NSArray *deleArray = [_context executeFetchRequest:deleRequest error:nil];
////    
////    //从数据库中删除
////    for (Student *stu in deleArray) {
////        [_context deleteObject:stu];
////    }
////    
////    //没有任何条件就是读取所有的数据
////    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
////    NSArray *resArray = [_context executeFetchRequest:request error:nil];
////    _dataSource = [NSMutableArray arrayWithArray:resArray];
////    [self.tableView reloadData];
////    
////    NSError *error = nil;
////    //保存--记住保存
////    if ([_context save:&error]) {
////        [self alertViewWithMessage:@"删除 age < 10 的数据"];
////    }else{
////        NSLog(@"删除数据失败, %@", error);
////    }
////    
////}
////
//////更新，修改
////- (void)updateData:(NSString *)userUid{
////    
////    //创建查询请求
////    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
////    
////    NSPredicate *pre = [NSPredicate predicateWithFormat:@"sex = %@", @"帅哥"];
////    request.predicate = pre;
////    
////    //发送请求
////    NSArray *resArray = [_context executeFetchRequest:request error:nil];
////    
////    //修改
////    for (Student *stu in resArray) {
////        stu.name = @"且行且珍惜_iOS";
////    }
////    
////    _dataSource = [NSMutableArray arrayWithArray:resArray];
////    [self.tableView reloadData];
////    
////    //保存
////    NSError *error = nil;
////    if ([_context save:&error]) {
////        [self alertViewWithMessage:@"更新所有帅哥的的名字为“且行且珍惜_iOS”"];
////    }else{
////        NSLog(@"更新数据失败, %@", error);
////    }
////    
////    
////}
////
//////读取查询
////- (void)readData:(NSString *)userUid{
////    
////    
////    /* 谓词的条件指令
////     1.比较运算符 > 、< 、== 、>= 、<= 、!=
////     例：@"number >= 99"
////     
////     2.范围运算符：IN 、BETWEEN
////     例：@"number BETWEEN {1,5}"
////     @"address IN {'shanghai','nanjing'}"
////     
////     3.字符串本身:SELF
////     例：@"SELF == 'APPLE'"
////     
////     4.字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
////     例：  @"name CONTAIN[cd] 'ang'"  //包含某个字符串
////     @"name BEGINSWITH[c] 'sh'"    //以某个字符串开头
////     @"name ENDSWITH[d] 'ang'"    //以某个字符串结束
////     
////     5.通配符：LIKE
////     例：@"name LIKE[cd] '*er*'"   //*代表通配符,Like也接受[cd].
////     @"name LIKE[cd] '???er*'"
////     
////     *注*: 星号 "*" : 代表0个或多个字符
////     问号 "?" : 代表一个字符
////     
////     6.正则表达式：MATCHES
////     例：NSString *regex = @"^A.+e$"; //以A开头，e结尾
////     @"name MATCHES %@",regex
////     
////     注:[c]*不区分大小写 , [d]不区分发音符号即没有重音符号, [cd]既不区分大小写，也不区分发音符号。
////     
////     7. 合计操作
////     ANY，SOME：指定下列表达式中的任意元素。比如，ANY children.age < 18。
////     ALL：指定下列表达式中的所有元素。比如，ALL children.age < 18。
////     NONE：指定下列表达式中没有的元素。比如，NONE children.age < 18。它在逻辑上等于NOT (ANY ...)。
////     IN：等于SQL的IN操作，左边的表达必须出现在右边指定的集合中。比如，name IN { 'Ben', 'Melissa', 'Nick' }。
////     
////     提示:
////     1. 谓词中的匹配指令关键字通常使用大写字母
////     2. 谓词中可以使用格式字符串
////     3. 如果通过对象的key
////     path指定匹配条件，需要使用%K
////     
////     */
////    
////    
////    //创建查询请求
////    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
////    
////    //查询条件
////    NSPredicate *pre = [NSPredicate predicateWithFormat:@"sex = %@", @"美女"];
////    request.predicate = pre;
////    
////    
////    // 从第几页开始显示
////    // 通过这个属性实现分页
////    //request.fetchOffset = 0;
////    
////    // 每页显示多少条数据
////    //request.fetchLimit = 6;
////    
////    
////    //发送查询请求,并返回结果
////    NSArray *resArray = [_context executeFetchRequest:request error:nil];
////    
////    _dataSource = [NSMutableArray arrayWithArray:resArray];
////    [self.tableView reloadData];
////    
////    [self alertViewWithMessage:@"查询所有的美女"];
////    
////    
////}

@end
