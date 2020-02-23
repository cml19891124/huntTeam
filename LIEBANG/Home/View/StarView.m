//
//  StarView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "StarView.h"
#import "GRStarsView.h"

@interface StarView ()

@property (nonatomic,strong)GRStarsView *starsView1;

@end

@implementation StarView

//list_icon_xingxing
//list_icon_xingxingsmall
//list_icon_huixingxing
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _starsView1 = [[GRStarsView alloc] initWithStarSize:CGSizeMake(kCurrentWidth(10), kCurrentWidth(10)) margin:kCurrentWidth(7) numberOfStars:5];
        _starsView1.allowSelect = NO;//不可点击
        [self addSubview:_starsView1];
    }
    return self;
}

- (void)setScore:(CGFloat)score {
    _score = score;
    
   _starsView1.score = score;
}


@end
