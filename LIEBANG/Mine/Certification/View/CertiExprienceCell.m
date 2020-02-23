//
//  CertiExprienceCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/7.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "CertiExprienceCell.h"

@interface CertiExprienceCell ()

@property (nonatomic,strong)UIImageView *titleImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UIButton *addButton;
@property (nonatomic,strong)UILabel *typeLabel;
@property (nonatomic,strong)UILabel *tiplabel;
@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,strong)UIView *contentIconView;
@property (nonatomic,strong)UIButton *editSourceButton;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIImageView *uploadImageView;
@property (nonatomic,strong)UIImageView *markImageView;

@property (nonatomic,strong)UIView *bottomView;

@end

@implementation CertiExprienceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)setEducationModel:(EducationModel *)educationModel sourceDic:(NSDictionary *)sourceDic; {
    _educationModel = educationModel;
    
    _titleLabel.text = educationModel.schoolName;
    _detailLabel.text = [NSString stringWithFormat:@"%@-%@,%@",educationModel.beginTime,educationModel.endTime,educationModel.subjectName];
    _timeLabel.text = [[InsureValidate timeInStr:educationModel.updateTime] substringToIndex:16];
    [_titleImageView sd_setImageWithURL:[NSURL URLWithString:educationModel.eduLogo] placeholderImage:[UIImage imageNamed:@"icon_logo1"]];

    if ([educationModel.status intValue] == 0)
    {
        self.certiState = CertiExprienceStateEduVerifing;
    }
    else if ([educationModel.status intValue] == 1)
    {
        self.certiState = CertiExprienceStateEduVerified;
    }
    else if ([educationModel.status intValue] == 2)
    {
        self.certiState = CertiExprienceStateEduVerifiedFail;
    }
    else if ([educationModel.status intValue] == 3)
    {
        self.certiState = CertiExprienceStateEduUnverified;
    }else if ([educationModel.status intValue] == 4)
    {
        self.certiState = CertiExprienceStateEduVerifiedCancel;
    }
    
    [self.uploadImageView sd_setImageWithURL:[NSURL URLWithString:educationModel.image] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
//    _stateLabel.textColor = kRedColor;

    if (IsStrEmpty(educationModel.image)) {
        [self hiddenSourceView:YES];
    }
    else {
        [self hiddenSourceView:NO];
    }
}

- (void)setWorkModel:(WorkModel *)workModel sourceDic:(NSDictionary *)sourceDic; {
    _workModel = workModel;
    
    _titleLabel.text = workModel.company;
    _detailLabel.text = [NSString stringWithFormat:@"%@-%@,%@",workModel.beginTime,workModel.endTime,workModel.position];
    NSString *timer = [[InsureValidate timeInStr:workModel.updateTime] substringToIndex:16];
    CGFloat timeW = BoundWithSize(timer, SCREEN_WIDTH, 12).size.width+ 10;
    
    _timeLabel.text = timer;
    _timeLabel.frame = CGRectMake(kDeviceWidth-kCurrentWidth(95)- kCurrentWidth(20), _contentIconView.bottom-kCurrentWidth(20),timeW, kCurrentWidth(20));
    
    [_titleImageView sd_setImageWithURL:[NSURL URLWithString:workModel.comLogo] placeholderImage:[UIImage imageNamed:@"icon_logo1"]];
    
    if ([workModel.status intValue] == 0)
    {
        self.certiState = CertiExprienceStateWorkVerifing;
    }
    else if ([workModel.status intValue] == 1)
    {
        self.certiState = CertiExprienceStateWorkVerified;
    }
    else if ([workModel.status intValue] == 2)
    {
        self.certiState = CertiExprienceStateWorkVerifiedFail;
    }
    else if ([workModel.status intValue] == 3)
    {
        self.certiState = CertiExprienceStateWorkUnverified;
    }else if ([workModel.status intValue] == 4){
        self.certiState = CertiExprienceStateWorkVerifiedCancel;
    }
    
    [self.uploadImageView sd_setImageWithURL:[NSURL URLWithString:workModel.image] placeholderImage:[UIImage imageNamed:@"img_mingpian"]];

    if (IsStrEmpty(workModel.image)) {
        [self hiddenSourceView:YES];
    }
    else {
        [self hiddenSourceView:NO];
    }
}


- (CGFloat)cellHeight {
    return self.height;
}

- (void)setCertiState:(CertiExprienceState)certiState {
    _certiState = certiState;
    
    switch (certiState) {
        case CertiExprienceStateWorkNormal://无工作经历的情况，只显示“+”按钮 和 “添加工作经历”字样
        {
            [self hiddenView:YES];
            [self hiddenSourceView:YES];
            _typeLabel.text = @"添加工作经历";
            _tiplabel.text = @"";
            self.height = kCurrentWidth(160);
            _markImageView.image = nil;
            _stateLabel.textColor = kLBRedColor;
        }
            break;
        case CertiExprienceStateWorkUnverified:
        {
            [self hiddenView:NO];
            [self hiddenSourceView:YES];
//            _bottomView.backgroundColor = UIColor.clearColor;
            _stateLabel.text = @"未审核";
            _typeLabel.text = @"上传此工作经历证明";
            _tiplabel.text = @"名片、在职证明、营业执照、工牌等任一材料";
            _markImageView.image = [UIImage imageNamed:@"icon_weiyanzhneg.png"];
            _stateLabel.textColor = kLBRedColor;
        }
            break;
        case CertiExprienceStateWorkVerifing:
        {
            [self hiddenView:NO];
            [self hiddenSourceView:NO];
            _stateLabel.text = @"审核中";
            _typeLabel.text = @"上传此工作经历证明";
            _tiplabel.text = @"名片、在职证明、营业执照、工牌等任一材料";
            _markImageView.image = [UIImage imageNamed:@"icon_weiyanzhneg.png"];
            _stateLabel.textColor = kLBRedColor;
        }
            break;
        case CertiExprienceStateWorkVerified:
        {
            [self hiddenView:NO];
            [self hiddenSourceView:NO];
            _stateLabel.text = @"已审核";
            _typeLabel.text = @"上传此工作经历证明";
            _tiplabel.text = @"名片、在职证明、营业执照、工牌等任一材料";
            _markImageView.image = [UIImage imageNamed:@"icon_yanzheng"];
            _stateLabel.textColor = kLBRedColor;
        }
            break;
        case CertiExprienceStateWorkVerifiedFail:
        {
            [self hiddenView:NO];
            [self hiddenSourceView:NO];

            _stateLabel.text = @"认证失败";
            _stateLabel.textColor = UIColor.redColor;
            _typeLabel.text = @"上传此工作经历证明";
            _tiplabel.text = @"名片、在职证明、营业执照、工牌等任一材料";
            _markImageView.image = [UIImage imageNamed:@"icon_weiyanzhneg.png"];
        }
            break;
        case CertiExprienceStateWorkVerifiedCancel:
        {
            [self hiddenView:NO];
            [self hiddenSourceView:NO];
            _stateLabel.text = @"已取消";
            _typeLabel.text = @"上传此工作经历证明";
            _tiplabel.text = @"名片、在职证明、营业执照、工牌等任一材料";
            _markImageView.image = [UIImage imageNamed:@"icon_weiyanzhneg.png"];
            _stateLabel.textColor = kLBRedColor;//蓝色
        }
            break;
        case CertiExprienceStateEduNormal:
        {
            [self hiddenView:YES];
            [self hiddenSourceView:YES];
            [self setTitleViewFrame];
            _typeLabel.text = @"添加教育经历";
            _tiplabel.text = @"";
            self.height = kCurrentWidth(160);
            _markImageView.image = nil;
            _stateLabel.textColor = kLBRedColor;
        }
            break;
        case CertiExprienceStateEduUnverified:
        {
            [self hiddenView:NO];
            [self hiddenSourceView:NO];
            [self setTitleViewFrame];
            _stateLabel.text = @"未审核";
            _typeLabel.text = @"上传此教育经历凭证";
            _tiplabel.text = @"学位证、毕业证等任一材料";
            _markImageView.image = [UIImage imageNamed:@"icon_weiyanzhneg.png"];
            _stateLabel.textColor = kLBRedColor;
        }
            break;
        case CertiExprienceStateEduVerifing:
        {
            [self hiddenView:NO];
            [self hiddenSourceView:NO];
            [self setTitleViewFrame];
            _stateLabel.text = @"审核中";
            _typeLabel.text = @"上传此教育经历凭证";
            _tiplabel.text = @"学位证、毕业证等任一材料";
            _markImageView.image = [UIImage imageNamed:@"icon_weiyanzhneg.png"];
            _stateLabel.textColor = kLBRedColor;
        }
            break;
        case CertiExprienceStateEduVerified:
        {
            [self hiddenView:NO];
            [self hiddenSourceView:NO];
            [self setTitleViewFrame];
            _stateLabel.text = @"已审核";
            _typeLabel.text = @"上传此教育经历凭证";
            _tiplabel.text = @"学位证、毕业证等任一材料";
            _markImageView.image = [UIImage imageNamed:@"icon_yanzheng"];
            _stateLabel.textColor = kBlueColor;
        }
            break;
        case CertiExprienceStateEduVerifiedFail:
        {
            [self hiddenView:NO];
            [self hiddenSourceView:NO];
            [self setTitleViewFrame];
            _stateLabel.text = @"认证失败";
            _stateLabel.textColor = UIColor.redColor;
            _typeLabel.text = @"上传此教育经历凭证";
            _tiplabel.text = @"学位证、毕业证等任一材料";
            _markImageView.image = [UIImage imageNamed:@"icon_weiyanzhneg.png"];
        }
            break;
        case CertiExprienceStateEduVerifiedCancel:
        {
            [self hiddenView:NO];
            [self hiddenSourceView:NO];
            [self setTitleViewFrame];
            _stateLabel.text = @"已取消";
            _typeLabel.text = @"上传此教育经历凭证";
            _tiplabel.text = @"学位证、毕业证等任一材料";
            _markImageView.image = [UIImage imageNamed:@"icon_weiyanzhneg.png"];
            _stateLabel.textColor = kLBRedColor;
        }
            break;
        default:
            break;
    }
    CGSize szie = [_stateLabel.text sizeWithFont:kSystem(14) maxSize:CGSizeMake(MAXFLOAT, kCurrentWidth(42))];
    _stateLabel.frame = CGRectMake(kDeviceWidth-kCurrentWidth(15)-szie.width, _titleImageView.top, szie.width, kCurrentWidth(42));
    _markImageView.center = CGPointMake(_stateLabel.left-kCurrentWidth(13), _stateLabel.centerY);

}

- (void)setStatusAccess
{
    if (self.certiState == CertiExprienceStateWorkVerified) {
        self.stateLabel.textColor = kLBRedColor;
        self.stateLabel.text = @"已通过";
    }
    if (self.certiState == CertiExprienceStateEduVerified) {
        self.stateLabel.textColor = kLBRedColor;
        self.stateLabel.text = @"已通过";
    }
}

- (void)hiddenView:(BOOL)hidden {
    _titleLabel.hidden = hidden;
    _titleImageView.hidden = hidden;
    _detailLabel.hidden = hidden;
    _stateLabel.hidden = hidden;
    _lineView.hidden = hidden;
    _bottomView.hidden = hidden;

    if (hidden)
    {
        _addButton.frame = CGRectMake((kDeviceWidth-kCurrentWidth(30))/2, kCurrentWidth(20), kCurrentWidth(30), kCurrentWidth(30));
        _typeLabel.frame = CGRectMake(0, _addButton.bottom+kCurrentWidth(19), kDeviceWidth, kCurrentWidth(20));
        _tiplabel.frame = CGRectMake(0, _typeLabel.bottom, kDeviceWidth, kCurrentWidth(29));
    }
    else
    {
        _addButton.frame = CGRectMake((kDeviceWidth-kCurrentWidth(30))/2, _lineView.bottom+kCurrentWidth(20), kCurrentWidth(30), kCurrentWidth(30));
        _typeLabel.frame = CGRectMake(0, _addButton.bottom+kCurrentWidth(19), kDeviceWidth, kCurrentWidth(20));
        _tiplabel.frame = CGRectMake(0, _typeLabel.bottom, kDeviceWidth, kCurrentWidth(29));
    }
}

- (void)hiddenSourceView:(BOOL)hidden {
    //底部左边默认图片底图
    _contentIconView.hidden = hidden;
//    _bottomView.hidden = hidden;

    //编辑资料按钮
    _editSourceButton.hidden = hidden;
    _timeLabel.hidden = hidden;
    _addButton.hidden = !hidden;
    _typeLabel.hidden = !hidden;
    _tiplabel.hidden = !hidden;
    
    if (hidden) {
        _bottomView.frame = CGRectMake(0, _tiplabel.bottom + 10, kDeviceWidth, 1);
        self.height = _bottomView.bottom+kCurrentWidth(0);
    }
    else {
        _bottomView.frame = CGRectMake(0, _contentIconView.bottom + 20, kDeviceWidth, 1);
        self.height = _bottomView.bottom+kCurrentWidth(0);
    }
}

- (void)setTitleViewFrame {
    
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_titleImageView.frame) + kCurrentWidth(12), kCurrentWidth(10), kCurrentWidth(150), kCurrentWidth(24));
    _detailLabel.frame = CGRectMake(CGRectGetMaxX(_titleImageView.frame) + kCurrentWidth(12), _titleLabel.bottom, kCurrentWidth(240), kCurrentWidth(14));//kCurrentWidth(210)
    
    CGFloat timeW = BoundWithSize(_timeLabel.text, SCREEN_WIDTH, 12).size.width+ 10;
    
    _timeLabel.frame = CGRectMake(kDeviceWidth-kCurrentWidth(95)- kCurrentWidth(20), _contentIconView.bottom-kCurrentWidth(20),timeW, kCurrentWidth(20));
}

- (void)createSubViews {
    
    _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(10), kCurrentWidth(42), kCurrentWidth(42))];
    _titleImageView.image = [UIImage imageNamed:@"icon_logo1"];
    [_titleImageView setContentScaleFactor:[[UIScreen mainScreen]scale]];
    _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    _titleImageView.autoresizingMask = UIViewAutoresizingNone;
    _titleImageView.layer.cornerRadius = kCurrentWidth(42)/2;
    _titleImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_titleImageView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(60), kDeviceWidth, 1)];
    _lineView.backgroundColor = kSepparteLineColor;
    [self.contentView addSubview:_lineView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleImageView.right+kCurrentWidth(10), _titleImageView.top,SCREEN_WIDTH - kCurrentWidth(60) - _titleImageView.right - kCurrentWidth(10), kCurrentWidth(24))];
    _titleLabel.text = @"猎帮技术有限公司";
    _titleLabel.textColor = kLBBlackColor;
    _titleLabel.font = kSystem(14);
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleImageView.right+kCurrentWidth(10), _titleLabel.bottom, kCurrentWidth(240), kCurrentWidth(14))];
    _detailLabel.text = @"2017-至今，创始人/董事";
    _detailLabel.textColor = kLBBlackColor;
    _detailLabel.font = kSystem(12);
    [self.contentView addSubview:_detailLabel];
    
    _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(75), _titleImageView.top, kCurrentWidth(60), kCurrentWidth(42))];
    _stateLabel.text = @"未验证";
    _stateLabel.textColor = kLBRedColor;
    _stateLabel.font = kSystem(14);
    _stateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_stateLabel];
    
    _markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(16), kCurrentWidth(16))];
    [self.contentView addSubview:_markImageView];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake((kDeviceWidth-kCurrentWidth(30))/2, _lineView.bottom+kCurrentWidth(20), kCurrentWidth(30), kCurrentWidth(30));
    [_addButton setImage:[UIImage imageNamed:@"btn_tianjia"] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addButton];
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _addButton.bottom+kCurrentWidth(19), kDeviceWidth, kCurrentWidth(20))];
    _typeLabel.text = @"上传此工作经历证明";
    _typeLabel.textColor = kLBNineColor;
    _typeLabel.font = kSystem(14);
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_typeLabel];
    
    _tiplabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _typeLabel.bottom, kDeviceWidth, kCurrentWidth(29))];
    _tiplabel.text = @"名片、在职证明、营业执照、工牌等任一材料";
    _tiplabel.textColor = kLBNineColor;
    _tiplabel.font = kSystem(13);
    _tiplabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_tiplabel];
    
    _contentIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _lineView.bottom+kCurrentWidth(8), kDeviceWidth-kCurrentWidth(100), kCurrentWidth(80))];
    //img_mingpian   kCurrentWidth(55),   kCurrentWidth(80)
    [self.contentView addSubview:_contentIconView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(145), _contentIconView.bottom-kCurrentWidth(20), kCurrentWidth(80), kCurrentWidth(20))];
    _timeLabel.text = @"2018-12-30";
    _timeLabel.textColor = kLBNineColor;
    _timeLabel.font = kSystem(12);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    
    _editSourceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _editSourceButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(90), _contentIconView.top+kCurrentWidth(2), kCurrentWidth(75), kCurrentWidth(25));
    _editSourceButton.titleLabel.font = kSystemBold(15);
    [_editSourceButton setTitle:@"更新材料" forState:UIControlStateNormal];
    [_editSourceButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
    _editSourceButton.layer.cornerRadius = 2.f;
    _editSourceButton.layer.borderColor = kLBRedColor.CGColor;
    _editSourceButton.layer.borderWidth = 0.5;
    _editSourceButton.layer.masksToBounds = YES;
    [_editSourceButton addTarget:self action:@selector(editSourceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editSourceButton];
    
    _uploadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCurrentWidth(15), 0, kCurrentWidth(55), kCurrentWidth(80))];
    _uploadImageView.image = [UIImage imageNamed:@"img_mingpian"];
    _uploadImageView.contentMode = UIViewContentModeScaleAspectFit;
    _uploadImageView.userInteractionEnabled = YES;
    
    _contentIconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(renzhenTap:)];
    [_contentIconView addGestureRecognizer:tap];
    [_contentIconView addSubview:_uploadImageView];
    
    _bottomView = UIView.new;
    _bottomView.frame = CGRectMake(0, self.tiplabel.bottom+10, kDeviceWidth, 1);
    _bottomView.backgroundColor = kSepparteLineColor;
//    [self.contentView addSubview:_bottomView];

}

- (void)renzhenTap:(UITapGestureRecognizer*)tap {
    
    if (!IsStrEmpty(self.workModel.image) && IsStrEmpty(self.educationModel.image)) {
        if (_GetCertiImageViewBlock) {
            _GetCertiImageViewBlock(self.workModel.image);
        }
    }
    if (!IsStrEmpty(self.educationModel.image) && IsStrEmpty(self.workModel.image)) {
        if (_GetCertiImageViewBlock) {
            _GetCertiImageViewBlock(self.educationModel.image);
        }
    }
}

#pragma mark Event
- (void)addButtonClick {
    if (_addCertiExprienceBlock) {
        _addCertiExprienceBlock(_certiState,self.indexPath);
    }
}

- (void)editSourceButtonClick {
    if (_editCertiSourceBlock) {
        _editCertiSourceBlock(self.indexPath);
    }
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
