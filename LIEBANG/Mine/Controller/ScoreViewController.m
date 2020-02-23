//
//  ScoreViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/10/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ScoreViewController.h"

static NSArray *titleArray;
static NSArray *sectionArray;
@interface ScoreViewController ()

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"影响力奖励";
    self.view.backgroundColor = kWhiteColor;
    
    self.tableView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
    
    sectionArray = @[@"影响力奖励加分规则",@"影响力奖励减分规则"];
    titleArray = @[@[@"新手机注册用户+50",@"授权腾讯微信或新浪微博新注册用户+30",@"用户登陆APP+10/每天",@"个人基本信息认证通过+50",@"职业经历名片认证通过+30/每次",@"职业经历在职证明认证通过+30/每次",@"职业经历营业执照认证通过+30/每次",@"职业经历工牌认证通过+30/每次",@"教育经历学位证认证通过+50",@"教育经历毕业证认证通过+50",@"机构申请通过+50",@"主动加他人为好友人脉通过+10/每人",@"通过他人好友人脉申请+10/每人",@"发布话题商品+50/每次",@"学员确认服务完成+50/每次",@"行家确认服务完成+50/每次",@"回答他人在线提问+30/每次",@"被他人喜欢+10/每次",@"被他人点评/好评+20/每次",@"被他人认可职业标签+10/每次",@"付费预约行家+50/每次",@"付费在线提问+30/每次",@"付费查看他人在线问答+30/每次",@"喜欢他人+10/每次",@"点评/好评他人+20/每次",@"认可他人职业标签+10/每次",@"绑定微信/支付宝账户成功+50",@"个人话题被他人分享到微信好友/朋友圈/QQ/微博好友+50/每次",@"个人名片被他人分享到微信好友/朋友圈/QQ/微博好友+50/每次",@"分享他人的话题到微信好友/朋友圈/QQ/微博好友+100/每次",@"分享他人的名片到微信好友/朋友圈/QQ/微博好友+100/每次"],@[@"被解除好友关系-30",@"被屏蔽拉黑-20",@"因违规被限时冻结账号-100",@"因违规被冻结账户-影响力清0",@"未按约定时间而擅自爽约-50",@"未按约定时间而擅自爽约并退款-50",@"恶意给他人点评/差评-100"]];
}

#pragma mark UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[titleArray safeObjectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellStr = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.textLabel.textColor = kLBBlackColor;
    cell.textLabel.font = kSystem(15);
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [[titleArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40.f) title:[sectionArray safeObjectAtIndex:section]];
    headView.backgroundColor = kBackgroundColor;
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
