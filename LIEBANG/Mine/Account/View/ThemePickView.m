//
//  ThemePickView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/23.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ThemePickView.h"
#import "AccountThemeCell.h"

@interface ThemePickView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIButton *windowButton;
@property (nonatomic,strong)UIView *borderView;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *closeButton;

@end

@implementation ThemePickView

+ (void)showThemePickViewWithAnimation:(BOOL)bAnimation
                          accountState:(AccountState)accountState
                            dataSource:(NSArray *)dataSource
                             pickBlock:(void(^)(ThemeClassModel *model))pickBlock
{
    ThemePickView *pickView = [[ThemePickView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    pickView.accountState = accountState;
    pickView.dataSource = dataSource.mutableCopy;
    pickView.pickBlock = ^(ThemeClassModel *model) {
        if (pickBlock) {
            pickBlock(model);
        }
    };
    [pickView showWithAnimation:YES];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createContentView];
        
    }
    return self;
}

- (void)createContentView {
    
    _windowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _windowButton.backgroundColor = kBlackColor;
    _windowButton.alpha = 0.5;
    _windowButton.frame = self.bounds;
    [_windowButton addTarget:self action:@selector(closePickerView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.windowButton];
    
    _borderView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(198)+kViewHeight, kDeviceWidth, kDeviceHeight)];
    _borderView.clipsToBounds = YES;
    [self addSubview:_borderView];
    
    _contentView = [[UIView alloc] initWithFrame:self.borderView.bounds];
    _contentView.backgroundColor = kWhiteColor;
    [_borderView addSubview:_contentView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(44))];
    _titleLabel.textColor = kLBRedColor;
    _titleLabel.text = @"请选择预约话题";
    _titleLabel.font = kSystem(16);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_titleLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(44)-0.5, kDeviceWidth, 0.5)];
    _lineView.backgroundColor = kSepparteLineColor;
    [_contentView addSubview:_lineView];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(32), 0, kCurrentWidth(20), kCurrentWidth(20));
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"btn_guanbi"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closePickerView) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.hidden = YES;
//    [self addSubview:_closeButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(44), kDeviceWidth, _contentView.height-kCurrentWidth(44)) style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    _tableView.scrollEnabled = YES;
    _tableView.userInteractionEnabled = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundView = nil;
    _tableView.scrollEnabled = NO;
    [_contentView addSubview:_tableView];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ThemeClassModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    NSString *cellStr = @"AccountThemeCell";
    AccountThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[AccountThemeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.themeModel = model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCurrentWidth(44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ThemeClassModel *model = [self.dataSource safeObjectAtIndex:indexPath.row];
    if (_pickBlock) {
        _pickBlock(model);
    }
    [self closePickerView];
}

#pragma mark 响应事件
- (void)closePickerView {
    WeakSelf;
    self.closeButton.hidden = YES;
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         weakSelf.contentView.top = weakSelf.borderView.bottom;
                         weakSelf.closeButton.centerY = weakSelf.contentView.bottom;
                     }
                     completion:^(BOOL finished) {
                         [weakSelf removeFromSuperview];
                     }];
}

- (void)showWithAnimation:(BOOL)bAnimation {
    UIView *window = [UIApplication sharedApplication].keyWindow;
    
    if (bAnimation)
    {
        WeakSelf;
        self.contentView.top = self.borderView.bottom;
        self.closeButton.centerY = self.contentView.bottom;
        [window addSubview:self];
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.contentView.top = 0;
            weakSelf.closeButton.centerY = weakSelf.borderView.top;
        }];
    }
    else
    {
        [window addSubview:self];
    }
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    if (dataSource.count > 12) {
        _dataSource = [dataSource subarrayWithRange:NSMakeRange(0, 12)].mutableCopy;
    }
    else {
        _dataSource = dataSource;
    }
    
    if (_accountState == AccountStateOther) {
        self.borderView.frame = CGRectMake(0, kDeviceHeight-(kCurrentWidth(44)*(_dataSource.count+1))-kCurrentWidth(46)-kViewHeight, kDeviceWidth, (kCurrentWidth(44)*(_dataSource.count+1)));
    } else {
        self.borderView.frame = CGRectMake(0, kDeviceHeight-(kCurrentWidth(44)*(_dataSource.count+1))-kViewHeight, kDeviceWidth, (kCurrentWidth(44)*(_dataSource.count+1)));
    }
    _closeButton.centerY = self.borderView.bottom;
    _closeButton.hidden = NO;
    [_tableView reloadData];
}

@end
