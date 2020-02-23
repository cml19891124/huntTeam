
//
//  ZJChooseControlView.m
//  ZJUIKit
//
//  Created by dzj on 2017/12/7.
//  Copyright © 2017年 kapokcloud. All rights reserved.
//
/**
 *  ZJKitTool
 *
 *  GitHub地址：https://github.com/Dzhijian/ZJKitTool
 *
 *  本库会不断更新工具类，以及添加一些模块案例，请各位大神们多多指教，支持一下。😆
 */


#import "ZJChooseControlView.h"
#import "ZJChooseModel.h"
#import "ZJButton.h"
#import "ZJChooseModel.h"

@interface ZJChooseControlView()

@property(nonatomic ,strong) UIView             *btnBackView;

@end

@implementation ZJChooseControlView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.btnBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(44))];
        [self addSubview:self.btnBackView];
//        UIView *line = [UIView zj_viewWithBackColor:kLightGrayColor supView:self.btnBackView constraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.mas_equalTo(0);
//            make.height.mas_equalTo(0.5);
//        }];
//        [self.btnBackView addSubview:line];
//
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.btnBackView.bottom-0.5, kDeviceWidth, 0.5)];
//        line.backgroundColor = kSepparteLineColor;
//        [self.btnBackView addSubview:line];
    }
    return self;
}


-(void)btnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(chooseControlWithBtnArray:button:)]) {
        [self.delegate chooseControlWithBtnArray:self.btnArr button:sender];
    }
}


-(void)setUpAllViewWithTitleArr:(NSArray *)titleArr{
    
    for (int i = 0; i<titleArr.count; i++) {
        ZJButton *btn = [[ZJButton alloc]init];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"555555"] forState:UIControlStateNormal];
//        [btn setTitleColor:k16RGBColor(0xFF960C) forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"btn_shouqi"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_zhankai"] forState:UIControlStateSelected];
        btn.imageAlignment = ZJImageAlignmentRight;
        btn.spaceBetweenTitleAndImage = 3;
        btn.titleLabel.font = kSystem(14);
        btn.tag = i;
        CGFloat btnW = kDeviceWidth/titleArr.count;
        CGFloat btnX = i*btnW;
        btn.frame = CGRectMake(btnX, 0, btnW, kCurrentWidth(44));
        [self.btnBackView addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnArr addObject:btn];
    }
    
    CGFloat margin = kDeviceWidth/titleArr.count;
    for (int i = 0; i<titleArr.count-1; i++) {
        UIView *line = [[UIView alloc]init];
        
        line.backgroundColor = k16RGBColor(0xDDDDDD);
        
        CGFloat w = 0.5;
        CGFloat h = kCurrentWidth(28);
        CGFloat x = (margin + w) * (i+1);
        CGFloat y = kCurrentWidth(8);
        line.frame = CGRectMake(x, y, w, h);
        [self.btnBackView addSubview:line];
    }
}


-(NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}


@end
