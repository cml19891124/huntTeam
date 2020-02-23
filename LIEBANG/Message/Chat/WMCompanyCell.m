//
//  WMCompanyCell.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/11.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "WMCompanyCell.h"
#import "WMCompanyMessage.h"

@implementation WMCompanyCell

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    return CGSizeMake(collectionViewWidth, kCurrentWidth(227)+extraHeight);
}

- (NSDictionary *)attributeDictionary {
    if (self.messageDirection == MessageDirection_SEND) {
        return @{
                 @(NSTextCheckingTypeLink) : @{NSForegroundColorAttributeName : [UIColor blueColor]},
                 @(NSTextCheckingTypePhoneNumber) : @{NSForegroundColorAttributeName : [UIColor blueColor]}
                 };
    } else {
        return @{
                 @(NSTextCheckingTypeLink) : @{NSForegroundColorAttributeName : [UIColor blueColor]},
                 @(NSTextCheckingTypePhoneNumber) : @{NSForegroundColorAttributeName : [UIColor blueColor]}
                 };
    }
    return nil;
}

- (NSDictionary *)highlightedAttributeDictionary {
    return [self attributeDictionary];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    self.backView = [[UIImageView alloc] initWithFrame:CGRectZero];
    //    self.backView.image = [UIImage imageNamed:@"bck.yinying"];
    self.backView.userInteractionEnabled = YES;
    [self.bubbleBackgroundView addSubview:self.backView];
    
    _companyLogo =[[UIImageView alloc] initWithFrame:CGRectZero];
    _companyLogo.layer.cornerRadius = kCurrentWidth(25);
    _companyLogo.layer.masksToBounds = YES;
    _companyLogo.image = [UIImage imageNamed:@"icon_liebang"];
    [_companyLogo setContentScaleFactor:[[UIScreen mainScreen]scale]];
    _companyLogo.contentMode = UIViewContentModeScaleAspectFill;
    [self.backView addSubview:_companyLogo];
    
    _companyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _companyLabel.text = @"招商银行";
    _companyLabel.textColor = kLBBlackColor;
    _companyLabel.font = kSystem(18);
    [self.backView addSubview:_companyLabel];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.text = @"招商银行股份有限公司";
    _nameLabel.textColor = kLBBlackColor;
    _nameLabel.font = kSystem(16);
    [self.backView addSubview:_nameLabel];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _addressLabel.text = @"深圳市福田区深南大道西侧车公庙路招商银行大夏";
    _addressLabel.textColor = kLBSixColor;
    _addressLabel.font = kSystem(12);
    [self.backView addSubview:_addressLabel];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _numberLabel.text = @"已上市·100-500人";
    _numberLabel.textColor = kLBSixColor;
    _numberLabel.font = kSystem(12);
    [self.backView addSubview:_numberLabel];
    
    _biaoqianLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _biaoqianLabel.text = @"金融 银行 保险";
    _biaoqianLabel.textColor = kLBSixColor;
    _biaoqianLabel.font = kSystem(12);
    [self.backView addSubview:_biaoqianLabel];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _phoneLabel.text = @"电话：0788-88888888-999";
    _phoneLabel.textColor = kLBSixColor;
    _phoneLabel.font = kSystem(12);
    [self.backView addSubview:_phoneLabel];
    
    _webLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _webLabel.text = @"官网：www.liebangapp.com";
    _webLabel.textColor = kLBSixColor;
    _webLabel.font = kSystem(12);
    [self.backView addSubview:_webLabel];
    

    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = kSepparteLineColor;
    [self.backView addSubview:_lineView];
    
//    _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
//    _icon.image = [UIImage imageNamed:@"icon-60"];
//    [self.backView addSubview:_icon];
//
//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    _titleLabel.text = @"猎帮智能Al名片";
//    _titleLabel.textColor = kLBSixColor;
//    _titleLabel.font = kSystem(10);
//    [self.backView addSubview:_titleLabel];
    
    _headIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headIcon.layer.cornerRadius = kCurrentWidth(20);
    _headIcon.layer.masksToBounds = YES;
    [self.backView addSubview:_headIcon];
    
    _nickLabel = [[NameLabel alloc] initWithFrame:CGRectMake(_headIcon.right+kCurrentWidth(5), _headIcon.top+kCurrentWidth(5), kDeviceWidth-_headIcon.right-115-kCurrentWidth(20), kCurrentWidth(20))];
    _nickLabel.labelFont = kSystem(14);
    [self.backView addSubview:_nickLabel];
    
    _postionLabel = [[PostionLabel alloc] initWithFrame:CGRectMake(_nickLabel.right+kCurrentWidth(3), _headIcon.top+kCurrentWidth(5), kDeviceWidth-_headIcon.right-115-kCurrentWidth(20), kCurrentWidth(20))];
    _postionLabel.font = kSystem(10);
    _postionLabel.color = kLBSixColor;
    [self.backView addSubview:_postionLabel];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _tipLabel.font = kSystem(12);
    _tipLabel.textColor = kLBBlackColor;
    [self.backView addSubview:_tipLabel];
    
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *longPress =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    [self setAutoLayout];
}

- (void)setAutoLayout {
    
    WMCompanyMessage *_videoMessage = (WMCompanyMessage *)self.model.content;
    if (_videoMessage) {
        [self.companyLogo sd_setImageWithURL:[NSURL URLWithString:_videoMessage.companyLogo] placeholderImage:[UIImage imageNamed:@"icon_liebang"]];
        self.companyLabel.text = _videoMessage.companyAbbreviation;
        self.nameLabel.text = _videoMessage.fullName;
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@",_videoMessage.city,_videoMessage.region];
        self.numberLabel.text = _videoMessage.financingStatus;
        self.biaoqianLabel.text = _videoMessage.industry;
        self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@",_videoMessage.contactsPhone];
        self.webLabel.text = [NSString stringWithFormat:@"官网：%@",_videoMessage.officialWebsite];
        
        [self.headIcon sd_setImageWithURL:[NSURL URLWithString:_videoMessage.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
        
        self.tipLabel.text = @"推荐您使用猎帮企业AI智能名片";
    }
    
    CGSize __labelSize = CGSizeMake(kDeviceWidth-80, kCurrentWidth(227));
    CGFloat __bubbleWidth = __labelSize.width+5;
    CGFloat __bubbleHeight = kCurrentWidth(227);
    CGSize __bubbleSize = CGSizeMake(__bubbleWidth, __bubbleHeight);
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    if (MessageDirection_RECEIVE == self.messageDirection) {
        messageContentViewRect.size.width = __bubbleSize.width;
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, __bubbleSize.width, __bubbleSize.height);
        self.backView.frame=CGRectMake(6, 0, __labelSize.width, __labelSize.height);
        self.companyLabel.frame = CGRectMake(kCurrentWidth(15), kCurrentWidth(12), self.backView.width-kCurrentWidth(80), kCurrentWidth(25));
        self.companyLogo.frame = CGRectMake(self.backView.width-kCurrentWidth(62), kCurrentWidth(10), kCurrentWidth(50), kCurrentWidth(50));
        self.nameLabel.frame = CGRectMake(kCurrentWidth(15), self.companyLabel.bottom+kCurrentWidth(5), self.backView.width-kCurrentWidth(80), kCurrentWidth(22));
        self.addressLabel.frame = CGRectMake(kCurrentWidth(15), self.nameLabel.bottom+kCurrentWidth(1), self.backView.width-kCurrentWidth(30), kCurrentWidth(17));
        self.numberLabel.frame = CGRectMake(kCurrentWidth(15), self.addressLabel.bottom, self.backView.width-kCurrentWidth(30), kCurrentWidth(17));
        self.biaoqianLabel.frame = CGRectMake(kCurrentWidth(15), self.numberLabel.bottom, self.backView.width-kCurrentWidth(30), kCurrentWidth(17));
        self.phoneLabel.frame = CGRectMake(kCurrentWidth(15), self.biaoqianLabel.bottom, self.backView.width-kCurrentWidth(30), kCurrentWidth(17));
        self.webLabel.frame = CGRectMake(kCurrentWidth(15), self.phoneLabel.bottom, self.backView.width-kCurrentWidth(30), kCurrentWidth(17));
        self.lineView.frame = CGRectMake(0, kCurrentWidth(160), __labelSize.width-2, 0.5);
        self.headIcon.frame = CGRectMake(kCurrentWidth(15), self.backView.bottom-kCurrentWidth(55), kCurrentWidth(40), kCurrentWidth(40));
        self.nickLabel.frame = CGRectMake(_headIcon.right+kCurrentWidth(5), _headIcon.top+kCurrentWidth(5), kDeviceWidth-_headIcon.right-115-kCurrentWidth(20), kCurrentWidth(20));
        [self.nickLabel setNameString:_videoMessage.userName showIcon:_videoMessage.isBasic];
        [self.postionLabel setCompany:nil postion:_videoMessage.position showIcon:_videoMessage.isOccupation];
        self.nickLabel.width = self.nickLabel.nameWidth;
        self.postionLabel.frame = CGRectMake(_nickLabel.right+kCurrentWidth(3), _headIcon.top+kCurrentWidth(5), kDeviceWidth-_headIcon.right-115-kCurrentWidth(20), kCurrentWidth(20));
        self.tipLabel.frame = CGRectMake(_headIcon.right+kCurrentWidth(5), _nickLabel.bottom, kDeviceWidth-_headIcon.right-kCurrentWidth(60), kCurrentWidth(15));
        
        self.bubbleBackgroundView.image = [self imageNamed:@"chat_from_bg_normal" ofBundle:@"RongCloud.bundle"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8,image.size.height * 0.2, image.size.width * 0.2)];
    } else {
        messageContentViewRect.size.width = __bubbleSize.width;
        messageContentViewRect.origin.x =
        self.baseContentView.bounds.size.width -
        (messageContentViewRect.size.width + 10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 10);
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, __bubbleSize.width, __bubbleSize.height);
        self.backView.frame=CGRectMake(0, 0, __labelSize.width, __labelSize.height);
        self.companyLabel.frame = CGRectMake(kCurrentWidth(15), kCurrentWidth(12), self.backView.width-kCurrentWidth(80), kCurrentWidth(25));
        self.companyLogo.frame = CGRectMake(self.backView.width-kCurrentWidth(62), kCurrentWidth(10), kCurrentWidth(50), kCurrentWidth(50));
        self.nameLabel.frame = CGRectMake(kCurrentWidth(15), self.companyLabel.bottom+kCurrentWidth(5), self.backView.width-kCurrentWidth(80), kCurrentWidth(22));
        self.addressLabel.frame = CGRectMake(kCurrentWidth(15), self.nameLabel.bottom+kCurrentWidth(1), self.backView.width-kCurrentWidth(30), kCurrentWidth(17));
        self.numberLabel.frame = CGRectMake(kCurrentWidth(15), self.addressLabel.bottom, self.backView.width-kCurrentWidth(30), kCurrentWidth(17));
        self.biaoqianLabel.frame = CGRectMake(kCurrentWidth(15), self.numberLabel.bottom, self.backView.width-kCurrentWidth(30), kCurrentWidth(17));
        self.phoneLabel.frame = CGRectMake(kCurrentWidth(15), self.biaoqianLabel.bottom, self.backView.width-kCurrentWidth(30), kCurrentWidth(17));
        self.webLabel.frame = CGRectMake(kCurrentWidth(15), self.phoneLabel.bottom, self.backView.width-kCurrentWidth(30), kCurrentWidth(17));
        self.lineView.frame = CGRectMake(0, kCurrentWidth(160), __labelSize.width-3, 0.5);
        self.headIcon.frame = CGRectMake(kCurrentWidth(15), self.backView.bottom-kCurrentWidth(55), kCurrentWidth(40), kCurrentWidth(40));
        self.nickLabel.frame = CGRectMake(_headIcon.right+kCurrentWidth(5), _headIcon.top+kCurrentWidth(5), kDeviceWidth-_headIcon.right-115-kCurrentWidth(20), kCurrentWidth(20));
        [self.nickLabel setNameString:_videoMessage.userName showIcon:_videoMessage.isBasic];
        [self.postionLabel setCompany:nil postion:_videoMessage.position showIcon:_videoMessage.isOccupation];
        self.nickLabel.width = self.nickLabel.nameWidth;
        self.postionLabel.frame = CGRectMake(_nickLabel.right+kCurrentWidth(3), _headIcon.top+kCurrentWidth(5), kDeviceWidth-_headIcon.right-115-kCurrentWidth(20), kCurrentWidth(20));
        self.tipLabel.frame = CGRectMake(_headIcon.right+kCurrentWidth(5), _nickLabel.bottom, kDeviceWidth-_headIcon.right-kCurrentWidth(60), kCurrentWidth(15));
        
        self.bubbleBackgroundView.image = [self imageNamed:@"chat_to_bg_normal" ofBundle:@"RongCloud.bundle"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image
                                           resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.2,image.size.height * 0.2, image.size.width * 0.8)];
    }
}

- (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName {
    UIImage *image = nil;
    NSString *image_name = [NSString stringWithFormat:@"%@.png", name];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];
    image = [[UIImage alloc] initWithContentsOfFile:image_path];
    
    return image;
}

- (void)longPressed:(id)sender {
    if (self.delegate) {
        [self.delegate didTapMessageCell:self.model];
    }
}

@end
