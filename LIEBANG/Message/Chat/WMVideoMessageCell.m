


//
//  WMVideoMessageCell.m
//  RCIM
//
//  Created by 郑文明 on 16/4/20.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import "WMVideoMessageCell.h"
#import "WMCardMessage.h"

@implementation WMVideoMessageCell

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    return CGSizeMake(collectionViewWidth, kCurrentWidth(160)+extraHeight);
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
    
    _headIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headIcon.image = [UIImage imageNamed:@"no_headIcon"];
    _headIcon.layer.cornerRadius = kCurrentWidth(28);
    _headIcon.layer.masksToBounds = YES;
    [_headIcon setContentScaleFactor:[[UIScreen mainScreen]scale]];
    _headIcon.contentMode = UIViewContentModeScaleAspectFill;
    _headIcon.autoresizingMask = UIViewAutoresizingNone;
    [self.backView addSubview:_headIcon];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.font = kSystem(15);
    _nameLabel.textColor = kLBBlackColor;
    [self.backView addSubview:_nameLabel];
    
    self.nameImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.nameImageView.image = [UIImage imageNamed:@"btn.shiming"];
    self.nameImageView.userInteractionEnabled = YES;
    self.nameImageView.contentMode = UIViewContentModeCenter;
    [self.backView addSubview:self.nameImageView];
    
    _careerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _careerLabel.textColor = kLBSixColor;
    _careerLabel.font = kSystem(13);
    _careerLabel.adjustsFontSizeToFitWidth = YES;
    [self.backView addSubview:_careerLabel];
    
    self.careerImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.careerImageView.image = [UIImage imageNamed:@"icon_bianqian"];
    self.careerImageView.userInteractionEnabled = YES;
    self.careerImageView.contentMode = UIViewContentModeCenter;
    [self.backView addSubview:self.careerImageView];
    
    _tradeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _tradeLabel.text = @"影响力 0";
    _tradeLabel.textColor = kLBSixColor;
    _tradeLabel.font = kSystem(12);
    [self.backView addSubview:_tradeLabel];
    
    _jobImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _jobImageView.image = [UIImage imageNamed:@"icon_liebang"];
    _jobImageView.layer.cornerRadius = 8;
    _jobImageView.layer.masksToBounds = YES;
    [self.backView addSubview:_jobImageView];
    
    _emailLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _emailLabel.frame = CGRectZero;
    _emailLabel.titleLabel.font = kSystem(12);
    [_emailLabel setTitle:@"未编辑" forState:UIControlStateNormal];
    [_emailLabel setTitleColor:kLBSixColor forState:UIControlStateNormal];
    [_emailLabel setImage:[UIImage imageNamed:@"icon_email"] forState:UIControlStateNormal];
    _emailLabel.adjustsImageWhenHighlighted = NO;
    _emailLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _emailLabel.titleEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(10), 0, 0);
    [self.backView addSubview:_emailLabel];
    
    _phoneLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneLabel.frame = CGRectZero;
    _phoneLabel.titleLabel.font = kSystem(12);
    [_phoneLabel setTitle:@"未编辑" forState:UIControlStateNormal];
    [_phoneLabel setTitleColor:kLBSixColor forState:UIControlStateNormal];
    [_phoneLabel setImage:[UIImage imageNamed:@"icon_call_normal"] forState:UIControlStateNormal];
    _phoneLabel.adjustsImageWhenHighlighted = NO;
    _phoneLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _phoneLabel.titleEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(10), 0, 0);
    [self.backView addSubview:_phoneLabel];
    
    _addressLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _addressLabel.frame = CGRectZero;
    _addressLabel.titleLabel.font = kSystem(12);
    [_addressLabel setTitle:@"未编辑" forState:UIControlStateNormal];
    [_addressLabel setTitleColor:kLBSixColor forState:UIControlStateNormal];
    [_addressLabel setImage:[UIImage imageNamed:@"icon_dizhi"] forState:UIControlStateNormal];
    _addressLabel.adjustsImageWhenHighlighted = NO;
    _addressLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _addressLabel.titleEdgeInsets = UIEdgeInsetsMake(0, kCurrentWidth(10), 0, 0);
    [self.backView addSubview:_addressLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = kSepparteLineColor;
    [self.backView addSubview:_lineView];
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _icon.image = [UIImage imageNamed:@"icon-60"];
    [self.backView addSubview:_icon];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.text = @"猎帮智能Al名片";
    _titleLabel.textColor = kLBSixColor;
    _titleLabel.font = kSystem(10);
    [self.backView addSubview:_titleLabel];
    
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
    
    WMCardMessage *_videoMessage = (WMCardMessage *)self.model.content;
    if (_videoMessage) {
        
        [_headIcon sd_setImageWithURL:[NSURL URLWithString:_videoMessage.userHead] placeholderImage:[UIImage imageNamed:@"no_headIcon"]];
        [_jobImageView sd_setImageWithURL:[NSURL URLWithString:_videoMessage.comLogo] placeholderImage:[UIImage imageNamed:@"icon_liebang"]];
        if (IsStrEmpty(_videoMessage.userWorkAddress) || IsNilOrNull(_videoMessage.userWorkAddress)) {
            [_addressLabel setTitle:@"未编辑" forState:UIControlStateNormal];
        } else {
            [_addressLabel setTitle:_videoMessage.userWorkAddress forState:UIControlStateNormal];
        }
        if (IsStrEmpty(_videoMessage.userEmail) || IsNilOrNull(_videoMessage.userEmail)) {
            [_emailLabel setTitle:@"未编辑" forState:UIControlStateNormal];
        } else {
            [_emailLabel setTitle:_videoMessage.userEmail forState:UIControlStateNormal];
        }
        if (IsStrEmpty(_videoMessage.userClassify) || IsNilOrNull(_videoMessage.userClassify)) {
            _tradeLabel.text = [NSString stringWithFormat:@"影响力 %d",[_videoMessage.effectSocre intValue]];
        } else {
            _tradeLabel.text = [NSString stringWithFormat:@"%@ 影响力 %d",_videoMessage.userClassify,[_videoMessage.effectSocre intValue]];
        }
        
        if ([_videoMessage.phonePrivacy integerValue] == 1) {
            if (IsStrEmpty(_videoMessage.userPhone)) {
                _phoneLabel.hidden = YES;
            }
            else {
                _phoneLabel.hidden = NO;
            }
            [_phoneLabel setTitle:[NSString stringWithFormat:@"%@",IsStrEmpty(_videoMessage.userPhone)?@"未编辑":_videoMessage.userPhone] forState:UIControlStateNormal];
        }
        else {
            _phoneLabel.hidden = YES;
        }
        
        if (IsStrEmpty(_videoMessage.userName) || IsNilOrNull(_videoMessage.userName)) {
            _nameLabel.text = @"猎帮";
            _nameImageView.hidden = YES;
        } else {
            _nameLabel.text = _videoMessage.userName;
            if ([_videoMessage.isBasic intValue] == 0) {
                _nameImageView.hidden = YES;
            } else {
                _nameImageView.hidden = NO;
            }
        }
        if (IsStrEmpty(_videoMessage.position) || IsNilOrNull(_videoMessage.position)) {
            _careerLabel.text = @"未编辑";
            _careerImageView.hidden = YES;
        } else {
            if (IsStrEmpty(_videoMessage.company) || IsNilOrNull(_videoMessage.company)) {
                _careerLabel.text = [NSString stringWithFormat:@"%@",_videoMessage.position];
            }
            else {
                _careerLabel.text = [NSString stringWithFormat:@"%@%@",_videoMessage.company,_videoMessage.position];
            }
            
            if ([_videoMessage.isOccupation intValue] == 0) {
                _careerImageView.hidden = YES;
            } else {
                _careerImageView.hidden = NO;
            }
        }
    }
    
    CGSize __labelSize = CGSizeMake(kDeviceWidth-80, kCurrentWidth(160));
    CGFloat __bubbleWidth = __labelSize.width+5;
    CGFloat __bubbleHeight = kCurrentWidth(160);
    CGSize __bubbleSize = CGSizeMake(__bubbleWidth, __bubbleHeight);
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    if (MessageDirection_RECEIVE == self.messageDirection) {
        messageContentViewRect.size.width = __bubbleSize.width;
        self.messageContentView.frame = messageContentViewRect;
        
        CGSize nameSize = [_nameLabel.text sizeWithFont:kSystem(15) maxSize:CGSizeMake(MAXFLOAT, kCurrentWidth(19))];
        CGSize careerSize = [_careerLabel.text sizeWithFont:kSystem(13) maxSize:CGSizeMake(kDeviceWidth-120-_headIcon.right, kCurrentWidth(17))];
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, __bubbleSize.width, __bubbleSize.height);
        self.backView.frame=CGRectMake(6, 0, __labelSize.width, __labelSize.height);
        _headIcon.frame = CGRectMake(kCurrentWidth(10), kCurrentWidth(11), kCurrentWidth(56), kCurrentWidth(56));
        
        if (nameSize.width > kDeviceWidth-120-_headIcon.right) {
            _nameLabel.frame = CGRectMake(_headIcon.right+kCurrentWidth(10), _headIcon.top+kCurrentWidth(2), kDeviceWidth-120-_headIcon.right, kCurrentWidth(19));
        }
        else {
            _nameLabel.frame = CGRectMake(_headIcon.right+kCurrentWidth(10), _headIcon.top+kCurrentWidth(2), nameSize.width, kCurrentWidth(19));
        }
        
        if (careerSize.width > kDeviceWidth-120-_headIcon.right) {
            _careerLabel.frame = CGRectMake(_headIcon.right+kCurrentWidth(10), _nameLabel.bottom, kDeviceWidth-120-_headIcon.right, kCurrentWidth(17));
        }
        else {
            _careerLabel.frame = CGRectMake(_headIcon.right+kCurrentWidth(10), _nameLabel.bottom, careerSize.width, kCurrentWidth(17));
        }
        _nameImageView.frame = CGRectMake(_nameLabel.right+kCurrentWidth(2), _nameLabel.top, 13, kCurrentWidth(19));
        
        _careerImageView.frame = CGRectMake(_careerLabel.right+kCurrentWidth(2), _careerLabel.top, 21, kCurrentWidth(17));
        _tradeLabel.frame = CGRectMake(_headIcon.right+kCurrentWidth(10), _careerLabel.bottom, kDeviceWidth-120-_headIcon.right, kCurrentWidth(21));
        _jobImageView.frame = CGRectMake(self.backView.width-kCurrentWidth(53)-5, self.backView.height-kCurrentWidth(73), kCurrentWidth(44), kCurrentWidth(44));
        _emailLabel.frame = CGRectMake(kCurrentWidth(10), _jobImageView.top+kCurrentWidth(5), _jobImageView.left-kCurrentWidth(30), kCurrentWidth(18));
        _addressLabel.frame = CGRectMake(kCurrentWidth(10), _emailLabel.bottom, _jobImageView.left-kCurrentWidth(30), kCurrentWidth(18));
        _phoneLabel.frame = CGRectMake(kCurrentWidth(10), _emailLabel.top-kCurrentWidth(18), _jobImageView.left-kCurrentWidth(30), kCurrentWidth(18));
        _lineView.frame = CGRectMake(1, _jobImageView.bottom+kCurrentWidth(5), __labelSize.width-3, 0.5);
        _titleLabel.frame = CGRectMake(10, _lineView.bottom, 100, kCurrentWidth(22));
        
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
        
        CGSize nameSize = [_nameLabel.text sizeWithFont:kSystem(15) maxSize:CGSizeMake(MAXFLOAT, kCurrentWidth(19))];
        CGSize careerSize = [_careerLabel.text sizeWithFont:kSystem(13) maxSize:CGSizeMake(kDeviceWidth-120-_headIcon.right, kCurrentWidth(17))];
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, __bubbleSize.width, __bubbleSize.height);
        self.backView.frame=CGRectMake(0, 0, __labelSize.width, __labelSize.height);
        _headIcon.frame = CGRectMake(kCurrentWidth(10), kCurrentWidth(11), kCurrentWidth(56), kCurrentWidth(56));
        
        if (nameSize.width > kDeviceWidth-120-_headIcon.right) {
            _nameLabel.frame = CGRectMake(_headIcon.right+kCurrentWidth(10), _headIcon.top+kCurrentWidth(2), kDeviceWidth-120-_headIcon.right, kCurrentWidth(19));
        }
        else {
            _nameLabel.frame = CGRectMake(_headIcon.right+kCurrentWidth(10), _headIcon.top+kCurrentWidth(2), nameSize.width, kCurrentWidth(19));
        }
        
        if (careerSize.width > kDeviceWidth-120-_headIcon.right) {
            _careerLabel.frame = CGRectMake(_headIcon.right+kCurrentWidth(10), _nameLabel.bottom, kDeviceWidth-120-_headIcon.right, kCurrentWidth(17));
        }
        else {
            _careerLabel.frame = CGRectMake(_headIcon.right+kCurrentWidth(10), _nameLabel.bottom, careerSize.width, kCurrentWidth(17));
        }
        
        _nameImageView.frame = CGRectMake(_nameLabel.right+kCurrentWidth(2), _nameLabel.top, 13, kCurrentWidth(19));
        
        _careerImageView.frame = CGRectMake(_careerLabel.right+kCurrentWidth(2), _careerLabel.top, 21, kCurrentWidth(17));
        _tradeLabel.frame = CGRectMake(_headIcon.right+kCurrentWidth(10), _careerLabel.bottom, kDeviceWidth-120-_headIcon.right, kCurrentWidth(21));
        _jobImageView.frame = CGRectMake(self.backView.width-kCurrentWidth(53)-5, self.backView.height-kCurrentWidth(73), kCurrentWidth(44), kCurrentWidth(44));
        _emailLabel.frame = CGRectMake(kCurrentWidth(10), _jobImageView.top+kCurrentWidth(5), _jobImageView.left-kCurrentWidth(30), kCurrentWidth(18));
        _addressLabel.frame = CGRectMake(kCurrentWidth(10), _emailLabel.bottom, _jobImageView.left-kCurrentWidth(30), kCurrentWidth(18));
        _phoneLabel.frame = CGRectMake(kCurrentWidth(10), _emailLabel.top-kCurrentWidth(18), _jobImageView.left-kCurrentWidth(30), kCurrentWidth(18));
        _lineView.frame = CGRectMake(0, _jobImageView.bottom+kCurrentWidth(5), __labelSize.width-3, 0.5);
        _titleLabel.frame = CGRectMake(10, _lineView.bottom, 100, kCurrentWidth(22));
        
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
