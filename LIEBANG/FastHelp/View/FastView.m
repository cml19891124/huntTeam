//
//  FastView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/9.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "FastView.h"

@interface FastView ()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *closeButton;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UILabel *tipLabel;
@property (nonatomic,strong)UIButton *questionButton;
@property (nonatomic,strong)UIButton *friendButton;

@end

@implementation FastView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.frame = CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(245));
        self.backgroundColor = kWhiteColor;
        
        [self createSubViews];
    }
    return self;
}

- (void)closeButtonClick {
    if (_backButtonBlock) {
        _backButtonBlock();
    }
}

- (void)questionButtonClick {
    if (_questionButtonBlock) {
        _questionButtonBlock();
    }
}

- (void)friendButtonClick {
    if (_friendButtonBlock) {
        _friendButtonBlock();
    }
}

- (void)createSubViews {
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(kDeviceWidth-kCurrentWidth(54), 0, kCurrentWidth(54), kCurrentWidth(32));
    [_closeButton setImage:[UIImage imageNamed:@"bar_button_close.png"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
    
    _questionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _questionButton.frame = CGRectMake(kDeviceWidth/2-kCurrentWidth(110), kCurrentWidth(42), kCurrentWidth(95), kCurrentWidth(115));
    [_questionButton setImage:[UIImage imageNamed:@"bar_button_tiwen"] forState:UIControlStateNormal];
    [_questionButton setTitle:@"要提问" forState:UIControlStateNormal];
    [_questionButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    [_questionButton setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(65, 65) space:kCurrentWidth(16)];
    _questionButton.titleLabel.font = kSystem(15);
    [_questionButton addTarget:self action:@selector(questionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_questionButton];
    
    _friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _friendButton.frame = CGRectMake(kDeviceWidth/2+kCurrentWidth(15), kCurrentWidth(42), kCurrentWidth(95), kCurrentWidth(115));
    [_friendButton setImage:[UIImage imageNamed:@"bar_button_jiahaoyou"] forState:UIControlStateNormal];
    [_friendButton setTitle:@"加好友" forState:UIControlStateNormal];
    [_friendButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    [_friendButton setImgViewStyle:ButtonImgViewStyleTop imageSize:CGSizeMake(65, 65) space:kCurrentWidth(16)];
    _friendButton.titleLabel.font = kSystem(15);
    [_friendButton addTarget:self action:@selector(friendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_friendButton];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCurrentWidth(200), kDeviceWidth, 0.5)];
    [self addSubview:_lineView];
    
    [self drawDashLine:_lineView lineLength:2 lineSpacing:1 lineColor:kSepparteLineColor];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth-kCurrentWidth(136))/2, kCurrentWidth(190), kCurrentWidth(136), kCurrentWidth(20))];
    _tipLabel.backgroundColor = kWhiteColor;
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.text = @"需求快速通道";
    _tipLabel.textColor = kLBNineColor;
    _tipLabel.font = kSystem(14);
    [self addSubview:_tipLabel];
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    //  设置虚线颜色为
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

@end
