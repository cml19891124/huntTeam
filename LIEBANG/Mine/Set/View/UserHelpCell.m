//
//  UserHelpCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/13.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "UserHelpCell.h"

@interface UserHelpCell ()

@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,strong)UIButton *markButton;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UIView *openView;

@end

@implementation UserHelpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kDeviceWidth-kCurrentWidth(40),kCurrentWidth(42))];
        _contentLabel.font = kSystem(14);
        _contentLabel.textColor = kLBSixColor;
        [self.contentView addSubview:_contentLabel];
        
        _markButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _markButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(23), kCurrentWidth(35)/2, kCurrentWidth(10), kCurrentWidth(7));
        [_markButton setImage:[UIImage imageNamed:@"list_button_unfold"] forState:UIControlStateNormal];
        [_markButton setImage:[UIImage imageNamed:@"list_button_shrink"] forState:UIControlStateSelected];
        [self.contentView addSubview:_markButton];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(42)-0.5, kDeviceWidth, 0.5)];
        _lineView.backgroundColor = kSepparteLineColor;
//        [self.contentView addSubview:_lineView];
        
        _openView = [[UIView alloc] initWithFrame:CGRectMake(0, _lineView.bottom, kDeviceWidth, 0)];
        _openView.backgroundColor = kBackgroundColor;
        [self.contentView addSubview:_openView];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), kCurrentWidth(12), kDeviceWidth-kCurrentWidth(24),0)];
        _detailLabel.font = kSystem(14);
        _detailLabel.textColor = kLBSixColor;
        _detailLabel.numberOfLines = 0;
        [_openView addSubview:_detailLabel];
        
    }
    return self;
}

- (void)setDetailModel:(HelpModel *)detailModel {
    _detailModel = detailModel;
    
    _contentLabel.text = detailModel.helpquestions;
    _markButton.selected = detailModel.isOpen;

    if (detailModel.isOpen)
    {
        
//        CGSize size = [detailModel.helpanswers sizeWithFont:kSystem(14) maxSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), MAXFLOAT)];
//        _detailLabel.height = size.height;
//        _openView.height = size.height+kCurrentWidth(24);
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithData:[detailModel.helpanswers dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            
            [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, attributeStr.length)];//(字体font是自定义的 要求和要显示的label设置的font一定要相同)
//            dispatch_async(dispatch_get_main_queue(), ^{
            
                _detailLabel.attributedText = attributeStr;
                CGRect rect = [attributeStr boundingRectWithSize:CGSizeMake(kDeviceWidth-kCurrentWidth(24), 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
                _detailLabel.height = rect.size.height;
                _openView.height = rect.size.height+kCurrentWidth(24);
//            });
//        });
    }
    else
    {
        _detailLabel.height = 0;
        _openView.height = 0;
    }
    
//    _detailLabel.text = detailModel.helpanswers;
    self.height = _openView.bottom;
}

- (CGFloat)cellHeight {
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
