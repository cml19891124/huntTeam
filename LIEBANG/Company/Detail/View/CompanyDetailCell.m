#import "ObjectFunction.h"
#import "UIImage+ImageEffects.h"

#import "CompanyDetailCell.h"
#import "CompanyDiscussCell.h"
#import "InterestFriendCell.h"

static NSArray *buttonArray;
@interface CompanyDetailCell ()

@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIButton *saveButton;
@property (nonatomic,strong)UIButton *moreButton;

//公用
@property (nonatomic,strong)UILabel *typeLabel;
@property (nonatomic,strong)UILabel *messageLabel;


//企业员工信息
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UILabel *stallLabel;
@property (nonatomic,strong)UIButton *claimButton;
@property (nonatomic,strong)UIImageView *claimView;
@property (nonatomic,strong)UIImageView *faceView;
@property (nonatomic,strong)UILabel *faceLabel;
@property (nonatomic,strong)UIView *friendContentView;

//企业点评
@property (nonatomic,strong)UIView *discussView;
@property (nonatomic,strong)CompanyDiscussCell *discussContentView;

@end

@implementation CompanyDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        buttonArray = @[@"公司信息",@"产品服务",@"企业点评",@"招聘"];
        [self.contentView addSubview:self.topView];
//        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.moreButton];
        
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.stallLabel];
        [self.contentView addSubview:self.claimButton];
        [self.contentView addSubview:self.friendContentView];
        [self.contentView addSubview:self.claimView];
        
        // 对背景图片进行毛玻璃效果处理
        
        [self.claimView addSubview:self.faceView];
        [self.claimView addSubview:self.faceLabel];
        
        [self.contentView addSubview:self.discussView];
        [self.discussView addSubview:self.discussContentView];
        //非企业主的点评领红包按钮
        [self.contentView addSubview:self.saveButton];
        
        [self createTopButton];
        
        self.height = self.saveButton.bottom+kCurrentWidth(50);
    }
    return self;
}

#pragma mark
#pragma mark Event
- (void)detailButtonClick:(UIButton *)sender {
    for (int i = 0; i < buttonArray.count; i++) {
        [self topButtonSelect:i select:NO];
    }
    self.detailState = (int)(sender.tag-100);
    
    if (_refreshDetailCellBlock) {
        _refreshDetailCellBlock(self.detailState);
    }
}

- (void)moreButtonClick {
    if (_scanCompanyDetailBlock) {
        _scanCompanyDetailBlock(self.companyModel);
    }
}

- (void)saveButtonClick {
    if (_saveCompanyDetailBlock) {
        _saveCompanyDetailBlock(self.companyModel.id);
    }
}

- (void)claimButtonClick {
    if (_claimCompanyDetailBlock) {
        _claimCompanyDetailBlock(self.companyModel);
    }
}

- (void)setDetailState:(CompanyDetailCellState)detailState {
    _detailState = detailState;
    
    [self topButtonSelect:detailState select:YES];
    switch (detailState) {
        case CompanyDetailCellCompanyInfo:
        {
            if ([self.type intValue] == 0)
            {
                self.typeLabel.text = @"公司介绍";
                self.messageLabel.text = self.companyModel.companyInfo;
                CGSize size = [self.companyModel.companyInfo sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), MAXFLOAT)];
                self.messageLabel.height = (size.height>115)?115:size.height;
                self.moreButton.top = self.messageLabel.bottom+kCurrentWidth(5);
                //            [self showStallMessage:YES array:nil isClaim:[self.companyModel.commentJurisdiction boolValue]];
                [self showStallMessage:YES array:self.companyModel.staff isClaim:YES];
                self.saveButton.top = self.friendContentView.bottom+kCurrentWidth(44);
                //            self.saveButton.top = self.claimView.bottom+kCurrentWidth(44);
                [self.saveButton setTitle:@"我要创建企业AI智能名片" forState:UIControlStateNormal];
                [self showCompanyDiscuss:NO];
                self.saveButton.hidden = YES;
//                self.claimButton.hidden = YES;
//                self.friendContentView.hidden = NO;
//                self.claimView.hidden = NO;
                self.height = self.friendContentView.bottom;
            }
            else
            {
                self.typeLabel.text = @"公司介绍";
                self.messageLabel.text = self.companyModel.companyInfo;
                CGSize size = [self.companyModel.companyInfo sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), MAXFLOAT)];
                self.messageLabel.height = (size.height>115)?115:size.height;
                self.moreButton.top = self.messageLabel.bottom+kCurrentWidth(5);
                [self showStallMessage:YES array:self.companyModel.staff isClaim:YES];
                self.saveButton.top = ([self.companyModel.commentJurisdiction boolValue]?self.friendContentView.bottom:self.claimView.bottom)+kCurrentWidth(44);
                //            self.saveButton.top = self.claimView.bottom+kCurrentWidth(44);
                [self.saveButton setTitle:@"我要创建企业AI智能名片" forState:UIControlStateNormal];
                [self showCompanyDiscuss:NO];
                self.saveButton.hidden = YES;
                self.friendContentView.hidden = NO;
//                self.claimView.hidden = NO;
                self.height = self.friendContentView.bottom;
            }
        }
            break;
        case CompanyDetailCellProductService:
        {
            self.typeLabel.text = @"产品服务";
            self.messageLabel.text = self.companyModel.productService;
            CGSize size = [self.companyModel.productService sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), MAXFLOAT)];
            self.messageLabel.height = (size.height>115)?115:size.height;
            self.moreButton.top = self.messageLabel.bottom+kCurrentWidth(5);
            [self showStallMessage:YES array:@[] isClaim:NO];
            self.saveButton.top = self.moreButton.bottom+kCurrentWidth(44);
            [self.saveButton setTitle:@"我要创建企业AI智能名片" forState:UIControlStateNormal];
            [self showCompanyDiscuss:NO];
            self.saveButton.hidden = YES;
            self.friendContentView.hidden = YES;
            self.claimView.hidden = YES;
            self.height = self.moreButton.bottom + kCurrentWidth(20);
        }
            break;
        case CompanyDetailCellCompanyDiscuss:
        {
            self.typeLabel.text = @"公司点评";
            [self showCompanyDiscuss:(!IsNilOrNull(self.companyModel.comment) && !IsStrEmpty(self.companyModel.comment))];
            if (!IsNilOrNull(self.companyModel.comment) && !IsStrEmpty(self.companyModel.comment)) {
                CompanyCommentModel *model = [CompanyCommentModel new];
                model.userHead = self.companyModel.commentUserHead;
                model.isOccupation = self.companyModel.isOccupation;
                model.userName = self.companyModel.commentUserName;
                model.userUid = self.companyModel.commentUserUid;
                model.comLogo = self.companyModel.comLogo;
                model.position = self.companyModel.position;
                model.comment = self.companyModel.comment;
                model.company = self.companyModel.company;
                model.isBasic = self.companyModel.isBasic;
                self.discussContentView.model = model;
                self.discussView.height = self.discussContentView.cellHeight;
                self.moreButton.top = self.discussView.bottom+kCurrentWidth(5);
                self.height = self.moreButton.bottom + kCurrentWidth(20);
                [self.moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
            }
            else {
                self.messageLabel.text = @"暂无评论";
                self.messageLabel.textAlignment = NSTextAlignmentCenter;
                CGSize size = [self.messageLabel.text sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), MAXFLOAT)];
                self.messageLabel.top = kCurrentWidth(15) + self.topView.bottom;

                self.messageLabel.height = (size.height>115)?115:size.height;
                self.moreButton.top = self.messageLabel.bottom+kCurrentWidth(5);
            }
            [self showStallMessage:YES array:@[] isClaim:NO];

            self.saveButton.top = self.moreButton.bottom+kCurrentWidth(44);
            [self.saveButton setTitle:@"写公司点评，赢优惠券红包" forState:UIControlStateNormal];
            self.saveButton.hidden = ![self.companyModel.commentJurisdiction boolValue];
            self.friendContentView.hidden = YES;
            self.claimView.hidden = YES;
            self.height = self.saveButton.bottom + kCurrentWidth(20);
        }
            break;
        case CompanyDetailCellrecruit:
        {
            self.typeLabel.text = @"人员招聘";
            self.messageLabel.text = self.companyModel.recruit;
            CGSize size = [self.companyModel.recruit sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), MAXFLOAT)];
            self.messageLabel.height = (size.height>115)?115:size.height;
            self.moreButton.top = self.messageLabel.bottom+kCurrentWidth(5);
            [self showStallMessage:YES array:@[] isClaim:NO];
            self.saveButton.top = self.moreButton.bottom+kCurrentWidth(44);
            [self.saveButton setTitle:@"我要创建企业AI智能名片" forState:UIControlStateNormal];
            self.saveButton.hidden = YES;
            [self showCompanyDiscuss:NO];
            self.friendContentView.hidden = YES;
            self.claimView.hidden = YES;
            self.height = self.moreButton.bottom + kCurrentWidth(20);
        }
            break;
        default:
            break;
    }
    
//    self.height = self.saveButton.bottom+kCurrentWidth(50);
}

//cell顶部button状态变化
- (void)topButtonSelect:(int)index select:(BOOL)select{
    UIButton *sender = [self.contentView viewWithTag:index+100];
    sender.selected = select;
//    UIView *selView = [self.contentView viewWithTag:index+200];
    
    self.lineV.centerX = sender.centerX;
}

//公司信息
- (void)showStallMessage:(BOOL)isShow array:(NSArray *)array isClaim:(BOOL)isClaim {
    
    WeakSelf;
    if (isShow && isClaim)
    {
        self.lineView.top = self.moreButton.bottom+kCurrentWidth(20);
        self.stallLabel.top = self.lineView.bottom;
        self.claimButton.top = self.lineView.bottom;
        self.claimView.top = self.lineView.bottom+kCurrentWidth(40);
        self.friendContentView.top = self.stallLabel.bottom;
        self.friendContentView.hidden = NO;
        [self.friendContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.lineView.hidden = NO;
        self.claimView.hidden = [self.type boolValue];

        self.faceView.hidden = [self.type boolValue];
        self.faceLabel.hidden = [self.type boolValue];
        self.claimButton.hidden = NO;
//        self.stallLabel.hidden = ![self.type boolValue];
        //有蒙版的时候高度不需自适应
        if (!self.claimView.hidden) {
            self.friendContentView.height = kCurrentWidth(70)*3;
        }else{
            self.friendContentView.height = kCurrentWidth(70)*array.count;
        }
        if (IsArrEmpty(array))
        {
            self.friendContentView.hidden = NO;
            UILabel *emptyLab = UILabel.new;
            emptyLab.text = @"暂无员工";
            emptyLab.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(70));
            emptyLab.textAlignment = NSTextAlignmentCenter;
            emptyLab.font = kSystem(13);
            emptyLab.textColor = kBlackColor;
            [self.friendContentView addSubview:emptyLab];
            self.lineView.hidden = NO;
            self.stallLabel.hidden = NO;
            self.faceView.hidden = NO;
            self.faceLabel.hidden = NO;
        }
        else
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, kDeviceWidth, 0.5)];
            line.backgroundColor = kSepparteLineColor;
            line.hidden = IsArrEmpty(array);
            self.lineView.hidden = IsArrEmpty(array);
//            self.stallLabel.hidden = IsArrEmpty(array);
            [self.friendContentView addSubview:line];
        
            for (int i = 0; i < array.count; i++) {
                UIView *friendView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(70)*i, kDeviceWidth, kCurrentWidth(70))];
                friendView.backgroundColor = kWhiteColor;
                StaffModel *model = [array safeObjectAtIndex:i];
                InterestFriendCell *friendCell = [[InterestFriendCell alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(70))];
                friendCell.sureButtonState = SureButtonStateNormal;
                friendCell.stallTwoModel = model;
                friendCell.sureButtonBlock = ^(InterestFriendModel *friendModel) {
                    if (weakSelf.sureButtonBlock) {
                        weakSelf.sureButtonBlock(friendModel);
                    }
                };
                friendCell.GetBasicSourceBlock = ^(NSString *imageUrl) {
                    if (weakSelf.GetBasicSourceBlock) {
                        weakSelf.GetBasicSourceBlock(imageUrl);
                    }
                };
                friendCell.GetWorkSourceBlock = ^(NSString *imageUrl) {
                    if (weakSelf.GetWorkSourceBlock) {
                        weakSelf.GetWorkSourceBlock(imageUrl);
                    }
                };
                friendCell.height = kCurrentWidth(70);
                [friendView addSubview:friendCell];
                [self.friendContentView addSubview:friendView];
                
                UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, friendView.bottom-0.25, kDeviceWidth, 0.25)];
                line2.backgroundColor = kSepparteLineColor;
                [self.friendContentView addSubview:line2];
            }
        }
        
    }
    else
    {
//        self.lineView.hidden = !isClaim;
//        self.claimView.hidden = !isClaim;
//        self.faceView.hidden = !isClaim;
//        self.faceLabel.hidden = !isClaim;
//        self.claimButton.hidden = !isClaim;
//        self.stallLabel.hidden = !isClaim;
//        self.friendContentView.hidden = !isClaim;
        
//        self.lineView.top = self.moreButton.bottom+kCurrentWidth(20);
//        self.stallLabel.top = self.lineView.bottom;
//        self.claimButton.top = self.lineView.bottom;
//        self.claimView.top = self.lineView.bottom+kCurrentWidth(40);
//        self.height = self.moreButton.bottom+kCurrentWidth(50);

        self.lineView.hidden = YES;
        self.claimView.hidden = YES;
        self.faceLabel.hidden = YES;
        self.claimButton.hidden = YES;
        self.stallLabel.hidden = YES;
        self.friendContentView.hidden = YES;
    }
    
}

//公司点评
- (void)showCompanyDiscuss:(BOOL)isShow {
    self.discussView.hidden = !isShow;
    self.discussContentView.hidden = !isShow;
    self.messageLabel.hidden = isShow;
}

- (CGFloat)cellHeight {
    return self.height;
}

#pragma mark UI
- (void)createTopButton {
    [self.topView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat buttonWidth = (kDeviceWidth-kCurrentWidth(30))/buttonArray.count;
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kCurrentWidth(15)+buttonWidth*i, 0, buttonWidth, kCurrentWidth(46));
        [button setTitle:[buttonArray safeObjectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:kLBSixColor forState:UIControlStateNormal];
        [button setTitleColor:kLBBlackColor forState:UIControlStateSelected];
        button.titleLabel.font = kSystem(16);
        button.tag = 100+i;
        button.selected = (i == 0);
        
        [button addTarget:self action:@selector(detailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:button];
        if (i == 0) {
        
#pragma mark - 按钮底部蓝色线条
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, button.bottom-kCurrentWidth(1), kCurrentWidth(64), kCurrentWidth(2))];
        redView.tag = 200+i;
        redView.center = CGPointMake(button.centerX, button.bottom-kCurrentWidth(1));
        redView.backgroundColor = kLBRedColor;
        [self.topView addSubview:redView];

        self.lineV = redView;
        }
//        redView.hidden = !(i == 0);
//        redView.tag = 200+i;
        
    }
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(46))];
        _topView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _topView;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.layer.cornerRadius = 4;
        _saveButton.layer.masksToBounds = YES;
        _saveButton.frame = CGRectMake(kCurrentWidth(19), self.topView.bottom+kCurrentWidth(150), kDeviceWidth-kCurrentWidth(38), kCurrentWidth(40));
        _saveButton.backgroundColor = kLBRedColor;
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kSystem(16);
        [_saveButton setTitle:@"我要创建企业AI智能名片" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), self.topView.bottom+kCurrentWidth(10), kDeviceWidth-kCurrentWidth(24), kCurrentWidth(20))];
        _typeLabel.text = @"公司介绍";
        _typeLabel.font = kSystem(14);
        _typeLabel.textColor = kLBBlackColor;
    }
    return _typeLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(5) + self.topView.bottom, kDeviceWidth-kCurrentWidth(24), 0)];
        _messageLabel.textColor = kLBSixColor;
        _messageLabel.font = kSystem(15);
        _messageLabel.numberOfLines = 5;
    }
    return _messageLabel;
}

- (UIView *)discussView {
    if (!_discussView) {
        _discussView = [[UIView alloc] initWithFrame:CGRectMake(0, self.typeLabel.bottom+kCurrentWidth(-25), kDeviceWidth, 0)];
        _discussView.backgroundColor = kWhiteColor;
    }
    return _discussView;
}

- (CompanyDiscussCell *)discussContentView {
    if (!_discussContentView) {
        _discussContentView = [[CompanyDiscussCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                        reuseIdentifier:nil];
    }
    return _discussContentView;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(162), self.messageLabel.bottom+kCurrentWidth(5), kCurrentWidth(150), kCurrentWidth(20));
        [_moreButton setTitle:@"展开详情" forState:UIControlStateNormal];
        [_moreButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
        _moreButton.titleLabel.font = kSystem(15);
        _moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.moreButton.bottom+kCurrentWidth(20), kDeviceWidth, kCurrentWidth(10))];
        _lineView.backgroundColor = kBackgroundColor;
    }
    return _lineView;
}

#pragma mark 认领
- (UIView *)friendContentView {
    if (!_friendContentView) {
        _friendContentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.lineView.bottom+kCurrentWidth(40), kDeviceWidth, 0)];
        _friendContentView.backgroundColor = kWhiteColor;

    }
    return _friendContentView;
}

- (UIImageView *)claimView {
    if (!_claimView) {
        _claimView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.lineView.bottom+kCurrentWidth(40), kDeviceWidth, kCurrentWidth(225))];
        _claimView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        /**  毛玻璃特效类型
        *  UIBlurEffectStyleExtraLight,
        *  UIBlurEffectStyleLight,
        *  UIBlurEffectStyleDark
        */
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//
//        //  毛玻璃视图
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//
//        //添加到要有毛玻璃特效的控件中
//        effectView.frame = _claimView.bounds;
//        [_claimView addSubview:effectView];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:_claimView.bounds];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        [_claimView addSubview:toolbar];
        toolbar.alpha = 0.5;
        //设置模糊透明度
//        effectView.alpha = 0.5f;
    }
    return _claimView;
}

- (UIImageView *)faceView {
    if (!_faceView) {
        _faceView = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(40))/2, kCurrentWidth(65), kCurrentWidth(40), kCurrentWidth(40))];
        _faceView.image = [UIImage imageNamed:@"biaoqing copy"];
    }
    return _faceView;
}

- (UILabel *)faceLabel {
    if (!_faceLabel) {
        _faceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.faceView.bottom+kCurrentWidth(10), kDeviceWidth, kCurrentWidth(20))];
        _faceLabel.text = @"先去认领我的公司才能查看企业员工哦";
        _faceLabel.textColor = kLBRedColor;
        _faceLabel.font = kSystem(14);
        _faceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _faceLabel;
}

- (UILabel *)stallLabel {
    if (!_stallLabel) {
        _stallLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), self.lineView.bottom, kDeviceWidth, kCurrentWidth(40))];
        _stallLabel.text = @"企业员工";
        _stallLabel.textColor = kLBBlackColor;
        _stallLabel.font = kSystem(14);
    }
    return _stallLabel;
}

- (UIButton *)claimButton {
    if (!_claimButton) {
        _claimButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _claimButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(130), self.lineView.bottom, kCurrentWidth(130), kCurrentWidth(40));
        [_claimButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
        [_claimButton setTitle:@"去认领我的公司" forState:UIControlStateNormal];
        _claimButton.titleLabel.font = kSystem(14);
        [_claimButton setImage:[UIImage imageNamed:@"company_detail_cliam"] forState:UIControlStateNormal];
        [_claimButton setImgViewStyle:ButtonImgViewStyleRight imageSize:CGSizeMake(6, 8) space:7];
        [_claimButton addTarget:self action:@selector(claimButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _claimButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
