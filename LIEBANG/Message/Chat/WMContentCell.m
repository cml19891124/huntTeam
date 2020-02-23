//
//  WMContentCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/11/5.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "WMContentCell.h"
#import "WMContent.h"

@implementation WMContentCell

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    return CGSizeMake(collectionViewWidth, kCurrentWidth(65)+extraHeight);
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

    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.font = kSystem(14);
    _nameLabel.textColor = kLBBlackColor;
    _nameLabel.numberOfLines = 2;
    [self.backView addSubview:_nameLabel];

    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = kSepparteLineColor;
    [self.backView addSubview:_lineView];
    
    _tradeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _tradeLabel.text = @"猎帮";
    _tradeLabel.textColor = kLBSixColor;
    _tradeLabel.font = kSystem(11);
    _tradeLabel.adjustsFontSizeToFitWidth = YES;
    [self.backView addSubview:_tradeLabel];
    
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
    
    WMContent *_videoMessage = (WMContent *)self.model.content;
    if (_videoMessage) {
        _nameLabel.text = _videoMessage.content;
        if ([_videoMessage.detailType intValue] == 1) {
            _tradeLabel.text = @"猎帮问答分享";
        }
        else if ([_videoMessage.detailType intValue] == 2) {
            _tradeLabel.text = @"猎帮话题分享";
        }
    }
    
    CGSize __labelSize = CGSizeMake(kDeviceWidth-150, kCurrentWidth(65));
    CGFloat __bubbleWidth = __labelSize.width+5;
    CGFloat __bubbleHeight = kCurrentWidth(65);
    CGSize __bubbleSize = CGSizeMake(__bubbleWidth, __bubbleHeight);
    CGRect messageContentViewRect = self.messageContentView.frame;
    
    if (MessageDirection_RECEIVE == self.messageDirection) {
        messageContentViewRect.size.width = __bubbleSize.width;
        self.messageContentView.frame = messageContentViewRect;
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, __bubbleSize.width, __bubbleSize.height);
        self.backView.frame=CGRectMake(6, 0, __labelSize.width, __labelSize.height);
        _nameLabel.frame = CGRectMake(kCurrentWidth(10), kCurrentWidth(5), __labelSize.width-20, kCurrentWidth(38));
        _lineView.frame = CGRectMake(0, _nameLabel.bottom+kCurrentWidth(2), __labelSize.width-3, 0.5);
        _tradeLabel.frame = CGRectMake(kCurrentWidth(10), _lineView.bottom+kCurrentWidth(2), __labelSize.width-20, kCurrentWidth(15));
        
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
        _nameLabel.frame = CGRectMake(kCurrentWidth(10), kCurrentWidth(5), __labelSize.width-20, kCurrentWidth(38));
        _lineView.frame = CGRectMake(0, _nameLabel.bottom+kCurrentWidth(2), __labelSize.width-3, 0.5);
        _tradeLabel.frame = CGRectMake(kCurrentWidth(10), _lineView.bottom+kCurrentWidth(2), __labelSize.width-20, kCurrentWidth(15));
       
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
