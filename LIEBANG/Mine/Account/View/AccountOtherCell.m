//
//  AccountOtherCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/12.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "AccountOtherCell.h"

static NSString *const kLBBReceiptData = @"1.预约话题：付款后等待72小时内行家确认约见时间地点或通话时间安排；\n2.向TA提问：付款后等待48小时内行家回答；提问被回答后，每当问题被查看，您将获得一部分收入；\n3.虚拟商品原则不予退款，参见使用帮助、用户协议。七日内行家未确认服务，系统将自动退款至原账户。";
static NSString *const kLBUseHelp = @"使用帮助";
static NSString *const kLBUseProtocol = @"用户协议";

@interface AccountOtherCell ()

@property (nonatomic,strong)YYLabel *detailLabel;
@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation AccountOtherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), kCurrentWidth(2), kDeviceWidth-kCurrentWidth(26), kCurrentWidth(40))];
    _titleLabel.font = kSystemBold(15);
    _titleLabel.textColor = kLBBlackColor;
    _titleLabel.text = @"付费须知";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [[YYLabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), _titleLabel.bottom - 5, kDeviceWidth-kCurrentWidth(26), kCurrentWidth(100))];
    _detailLabel.numberOfLines = 0;
    [self.contentView addSubview:_detailLabel];
    
//    NSString *string = @"1.选择行家，预约付款后，等待72小时内行家确认线下约见的时间地点或通话的时间安排；\n2.学员可通过私信与行家沟通确定线下约见或通话细节；\n3.虚拟商品原则不予退款，如有争议，参见猎帮用户协议；\n4.七个工作日内行家如未能确认服务，系统将自动退款至学员付款原账户；\n5.如遇问题，工作日可拨打客服电话：13510019677。";
    NSMutableAttributedString *attri_str = [[NSMutableAttributedString alloc] initWithString:kLBBReceiptData];
    attri_str.yy_font = kSystem(14);
    attri_str.yy_color = kLBBlackColor;
    [attri_str yy_setColor:kLBRedColor range:[kLBBReceiptData rangeOfString:kLBUseProtocol]];
    [attri_str yy_setTextHighlightRange:[kLBBReceiptData rangeOfString:kLBUseProtocol] color:kLBRedColor backgroundColor:kLBRedColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (self.confimButtonBlock) {
            self.confimButtonBlock();
        }
    }];
    [attri_str setYy_lineSpacing:5];
    [attri_str yy_setColor:kLBRedColor range:[kLBBReceiptData rangeOfString:kLBUseHelp]];
    [attri_str yy_setTextHighlightRange:[kLBBReceiptData rangeOfString:kLBUseHelp] color:kLBRedColor backgroundColor:kLBRedColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (self.useHelpBlock) {
            self.useHelpBlock();
        }
    }];
    _detailLabel.attributedText = attri_str;

    CGSize size = [kLBBReceiptData sizeWithFont:kSystem(14) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(26), MAXFLOAT)];

    _detailLabel.height = size.height + 30;
    self.height = _detailLabel.bottom +kCurrentWidth(30);
}

- (CGFloat)getHeight {
    return self.height;
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
