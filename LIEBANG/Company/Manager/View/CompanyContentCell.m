//
//  CompanyContentCell.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/2.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "CompanyContentCell.h"
#import "IQTextView.h"

static NSArray *titleArray;
static NSArray *subTitleArray;
@interface CompanyContentCell ()<UITextViewDelegate>

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UILabel *contentTv;
@property (nonatomic,strong)UIButton *iconButton;
@property (nonatomic,strong) QMUIButton *numBtn;
@property (nonatomic,strong)UIView *iconContentView;
@property (nonatomic,strong)UIButton *nextButton;
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (strong, nonatomic) QMUIButton *addBtn;

@property (nonatomic,strong)UILabel *labSubAddTitle;

@property (nonatomic,strong)UILabel *labTime;

@end

@implementation CompanyContentCell

- (void)initView
{
    [self initSubveiws];
    [self initSubveiwsMasonry];
//    self.height = self.icon.bottom+kCurrentWidth(10);
}

- (void)initSubveiws
{
    titleArray = @[@"公司信息",@"产品服务",@"招聘"];
    subTitleArray = @[@"可添加公司介绍、项目介绍等公司信息",@"可添加产品服务等信息，获取商机",@"可添加人员招聘信息"];
            //标题
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(24), 0, kDeviceWidth-kCurrentWidth(48), kCurrentWidth(43))];
    _contentLabel.textColor = kLBBlackColor;
    _contentLabel.font = kSystemBold(14);
    [self.contentView addSubview:_contentLabel];
            //顶部分割线
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), _contentLabel.bottom, kDeviceWidth-kCurrentWidth(24), 0.5)];
    _lineView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:_lineView];
    
    self.iconContentView = [[UIView alloc] init];
    [self.contentView addSubview:self.iconContentView];
    
    _addBtn = [QMUIButton buttonWithType:UIButtonTypeContactAdd];
    _addBtn.userInteractionEnabled = NO;
    [_addBtn setImagePosition:QMUIButtonImagePositionLeft];
    _addBtn.spacingBetweenImageAndTitle = 30;
//    [_addBtn setImage:IMAGE_NAMED(@"btn_tianjia") forState:UIControlStateNormal];
    [_addBtn setTitle:@"添加图集" forState:UIControlStateNormal];
    _addBtn.titleLabel.font = kSystem(14);
    [_addBtn setTitleColor:kLBRedColor forState:UIControlStateNormal];
    _addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    [_addBtn addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_iconContentView addSubview:_addBtn];
    
    _labSubAddTitle = UILabel.new;
    _labSubAddTitle.text = @"可添加公司介绍、项目介绍等公司信息";
    _labSubAddTitle.textColor = kLBNineColor;
    _labSubAddTitle.font = kSystemBold(14);
    _labSubAddTitle.textAlignment = NSTextAlignmentCenter;
    [self.iconContentView addSubview:_labSubAddTitle];
    
    
                //以上 以下
    self.contentTv = [[UILabel alloc] init];
//    self.contentTv.hidden = YES;
//    self.contentTv.placeholderTextColor = kLBNineColor;
    self.contentTv.textColor = kLBBlackColor;
    self.contentTv.numberOfLines = 3;
    self.contentTv.font = kSystem(13);
//    self.contentTv.delegate = self;
    self.contentTv.hidden = YES;
    [self.iconContentView addSubview:self.contentTv];
    
    _labTime = UILabel.new;
    _labTime.textColor = kLBNineColor;
    _labTime.font = kSystemBold(14);
    _labTime.textAlignment = NSTextAlignmentLeft;
    [self.iconContentView addSubview:_labTime];

}

- (void)initSubveiwsMasonry
{
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kCurrentWidth(24));
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(kCurrentWidth(43));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kCurrentWidth(12));
        make.top.mas_equalTo(self.contentLabel.mas_bottom);
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(-kCurrentWidth(12));
    }];
    
    [_iconContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kCurrentWidth(10));
        make.height.mas_equalTo(kCurrentWidth(100));
        make.right.mas_equalTo(-kCurrentWidth(10));
        make.bottom.mas_equalTo(0);
    }];
    
    
    [_labSubAddTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconContentView).offset(2);
        make.height.mas_equalTo(kCurrentWidth(22));
        make.width.mas_equalTo(kDeviceWidth-kCurrentWidth(80));
        make.left.mas_equalTo(kCurrentWidth(40));
    }];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.labSubAddTitle);
        make.height.mas_equalTo(kCurrentWidth(22));
        make.width.mas_equalTo(kDeviceWidth-kCurrentWidth(80));
        make.bottom.mas_equalTo(self.labSubAddTitle.mas_top).offset(-10);
    }];

}

- (CGFloat)cellHeight {
    return kCurrentWidth(144);
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    _contentLabel.text = [titleArray safeObjectAtIndex:indexPath.row-14];
    _labSubAddTitle.text = [subTitleArray safeObjectAtIndex:indexPath.row - 14];
    self.iconContentView.tag = 30+indexPath.row;

    if (indexPath.row == 14) {
        self.maxImageNum = 2;
    }
    else if (indexPath.row == 15) {
        self.maxImageNum = 4;
    }
    else if (indexPath.row == 16) {
        self.maxImageNum = 1;
    }
}

- (void)setCompanyModel:(CompanyModel *)companyModel {
    _companyModel = companyModel;
    
//    switch (self.indexPath.row) {
//        case 13:
//        {
////            self.contentTv.text = companyModel.companyInfo;
//            self.imageArray = [NSMutableArray arrayWithArray:companyModel.companyInfoImages];
//        }
//            break;
//        case 14:
//        {
////            self.contentTv.text = companyModel.productService;
//            self.imageArray = [NSMutableArray arrayWithArray:companyModel.productServiceImages];
//        }
//            break;
//        case 15:
//        {
////            self.contentTv.text = companyModel.recruit;
//            self.imageArray = [NSMutableArray arrayWithArray:companyModel.recruitImages];
//        }
//            break;
//        default:
//            break;
//    }
}

- (void)setImageArray:(NSMutableArray *)imageArray {
    _imageArray = imageArray;

    NSLog(@"imageArray == %zd",imageArray.count);
    [self.dataArray removeAllObjects];
    
//    [self.iconContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < imageArray.count; i ++) {
        UIImageView *icon = [[UIImageView alloc] init];
        id data = [imageArray safeObjectAtIndex:0];
        if ([data isKindOfClass:[NSString class]]) {
            [icon sd_setImageWithURL:[NSURL URLWithString:data] placeholderImage:[UIImage imageNamed:@"photo_quantity"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    [self.dataArray addObject:image];
                }
            }];
//            [icon sd_setImageWithURL:[NSURL URLWithString:data] placeholderImage:[UIImage imageNamed:@"photo_quantity"]];

        }

        else if ([data isKindOfClass:[UIImage class]]) {
            icon.image = data;
            [self.dataArray addObject:data];
        }
        self.addBtn.hidden = YES;
        self.labSubAddTitle.hidden = YES;
        
        
        if (self.indexPath.row == 14) {
            
            if ([LBForProject currentProject].companyInfo.length && [LBForProject currentProject].companyInfoArray.count) {
                self.contentTv.hidden = NO;
                self.addBtn.hidden = YES;
                self.labSubAddTitle.hidden = YES;
                self.contentTv.text = [LBForProject currentProject].companyInfo;
            }else{
                if (self.companyModel.companyInfo) {
                    self.contentTv.hidden = NO;
                    self.contentTv.text = self.companyModel.companyInfo;
                    self.addBtn.hidden = YES;
                    self.labSubAddTitle.hidden = YES;
                }else{
                    self.addBtn.hidden = YES;
                    self.labSubAddTitle.hidden = YES;
                    self.contentTv.hidden = NO;
                }
            }
            
            if (self.companyModel.beginTime) {
                self.labTime.hidden = NO;
                self.labTime.text = self.companyModel.beginTime;

            }else{
                self.labTime.hidden = YES;

            }
        }
        
        if (self.indexPath.row == 15) {
            
            if ([LBForProject currentProject].productInfo.length && [LBForProject currentProject].productServiceArray.count) {
                self.contentTv.hidden = NO;
                self.addBtn.hidden = YES;
                self.labSubAddTitle.hidden = YES;
                self.contentTv.text = [LBForProject currentProject].productInfo;
            }else{
                if (self.companyModel.productService) {
                    self.contentTv.hidden = NO;
                    self.contentTv.text = self.companyModel.productService;
                    self.addBtn.hidden = YES;
                    self.labSubAddTitle.hidden = YES;
                }else{
                    self.addBtn.hidden = YES;
                    self.labSubAddTitle.hidden = YES;
                    self.contentTv.hidden = NO;
                }
            }
            if (self.companyModel.beginTime) {
                self.labTime.hidden = NO;
                self.labTime.text = self.companyModel.beginTime;

            }else{
                self.labTime.hidden = YES;

            }
        }
        
        
        if (self.indexPath.row == 16) {
            
            if ([LBForProject currentProject].employeeInfo.length && [LBForProject currentProject].recruitArray.count) {
                self.contentTv.hidden = NO;
                self.addBtn.hidden = YES;
                self.labSubAddTitle.hidden = YES;
                self.contentTv.text = [LBForProject currentProject].employeeInfo;
            }else{
                if (self.companyModel.recruit) {
                    self.contentTv.hidden = NO;
                    self.contentTv.text = self.companyModel.recruit;
                    self.addBtn.hidden = YES;
                    self.labSubAddTitle.hidden = YES;
                }else{
                    self.addBtn.hidden = YES;
                    self.labSubAddTitle.hidden = YES;
                    self.contentTv.hidden = NO;
                }
            }
            if (self.companyModel.beginTime) {
                self.labTime.hidden = NO;
                self.labTime.text = self.companyModel.beginTime;
            }else{
                self.labTime.hidden = YES;

            }
        }

        
        [self.iconContentView addSubview:icon];
        
        UIImageView *effectV = UIImageView.new;
        effectV.image = IMAGE_NAMED(@"effect");
        [self.iconContentView addSubview:effectV];
        [effectV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon.mas_right);
            make.centerY.mas_equalTo(icon);
            make.height.mas_equalTo(icon);
            make.width.mas_equalTo(21);
        }];
        
        _numBtn = [QMUIButton new];
        _numBtn.backgroundColor = kLBBlackColor;
        _numBtn.layer.cornerRadius = 4;
        _numBtn.layer.masksToBounds = YES;
        [_numBtn setImagePosition:QMUIButtonImagePositionLeft];
        _numBtn.spacingBetweenImageAndTitle = 5;
        [_numBtn setImage:IMAGE_NAMED(@"photo_quantity") forState:UIControlStateNormal];
        [_numBtn setTitle:[NSString stringWithFormat:@"%ld",imageArray.count] forState:UIControlStateNormal];
        [_numBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _numBtn.titleLabel.font = kSystem(13);
        _numBtn.contentMode = UIViewContentModeScaleAspectFill;
        [icon addSubview:_numBtn];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(kCurrentWidth(-10));
            make.width.height.mas_equalTo(kCurrentWidth(90));
        }];
        
        [icon addSubview:self.numBtn];
            
        [_numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(kCurrentWidth(-5));
                make.width.mas_equalTo(kCurrentWidth(30));
                make.bottom.mas_equalTo(kCurrentWidth(-5));
            make.height.mas_equalTo(15);
        }];
        
        [_contentTv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(effectV.mas_right).offset(10);
            make.right.mas_equalTo(kCurrentWidth(-16));
            make.height.mas_equalTo(kCurrentWidth(100));
            make.centerY.mas_equalTo(self.iconContentView).offset(-30);
        }];
        
        [_labTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentTv);
            make.height.mas_equalTo(kCurrentWidth(17));
            make.top.mas_equalTo(self.contentTv.mas_bottom).offset(1);
            make.bottom.mas_equalTo(-10);
        }];
    }
}

- (void)deleteButtonClick:(UIButton *)sender {
    NSInteger index = sender.tag-self.indexPath.row*100;
    if (self.dataArray.count > index) {
        [self.dataArray removeObjectAtIndex:index];
        
        if (self.indexPath.row == 14) {
            [[LBForProject currentProject].companyInfoArray removeObjectAtIndex:index];
        }
        else if (self.indexPath.row == 15) {
            [[LBForProject currentProject].productServiceArray removeObjectAtIndex:index];
        }
        else if (self.indexPath.row == 16) {
            [[LBForProject currentProject].recruitArray removeObjectAtIndex:index];
        }
        if (_reloadImageSourceBlock) {
            _reloadImageSourceBlock(self.indexPath,self.dataArray,YES);
        }
    }
}

- (void)iconButtonClick {
    
//    if (_editSourceBlock) {
//        _editSourceBlock(self.indexPath);
//    }
}

- (void)nextButtonClick:(UITapGestureRecognizer *)sender {
    if (_editMessageBlock) {
        _editMessageBlock(sender.view.tag-43,_contentLabel.text);
    }
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
