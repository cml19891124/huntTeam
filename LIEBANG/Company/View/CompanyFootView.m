#import "YYLabel.h"

#import "CompanyFootView.h"

@interface CompanyFootView ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong) UILabel *phoneLabel;
@property (nonatomic,strong) UILabel *labSubMess;

@end

@implementation CompanyFootView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *)message subMess:(nonnull NSString *)mess
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGSize titleSize = [title sizeWithFont:kSystemBold(16) maxSize:CGSizeMake(kDeviceWidth, MAXFLOAT)];
        CGSize messageSize = [message sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth, MAXFLOAT)];
        CGSize submessageSize = [mess sizeWithFont:kSystem(15) maxSize:CGSizeMake(kDeviceWidth, MAXFLOAT)];

        CGFloat sizeHeight = titleSize.height + messageSize.height + submessageSize.height;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (frame.size.height-sizeHeight)/2, kDeviceWidth, titleSize.height)];
        self.titleLabel.text = title;
        self.titleLabel.font = kSystemBold(16);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleLabel.bottom + kCurrentWidth(4), kDeviceWidth, messageSize.height)];
        self.phoneLabel.textAlignment = NSTextAlignmentCenter;
        self.phoneLabel.text = message;
        self.phoneLabel.textColor = kLBNineColor;
        self.phoneLabel.font = kSystem(15);
        self.phoneLabel.numberOfLines = 0;
        [self addSubview:self.phoneLabel];
        
        self.labSubMess = [[UILabel alloc] initWithFrame:CGRectMake(0, self.phoneLabel.bottom + kCurrentWidth(4), kDeviceWidth, submessageSize.height)];
        self.labSubMess.textAlignment = NSTextAlignmentCenter;
        self.labSubMess.text = mess;
        self.labSubMess.textColor = kLBNineColor;
        self.labSubMess.font = kSystem(15);
        self.labSubMess.numberOfLines = 0;
        [self addSubview:self.labSubMess];
    }
    return self;
}

@end
