//
//  ZJThreeChildView.m
//  ZJUIKit
//
//  Created by dzj on 2017/12/8.
//  Copyright © 2017年 kapokcloud. All rights reserved.
//
/**
 *  ZJKitTool
 *
 *  GitHub地址：https://github.com/Dzhijian/ZJKitTool
 *
 *  本库会不断更新工具类，以及添加一些模块案例，请各位大神们多多指教，支持一下。😆
 */

#import "ZJThreeChildView.h"
#import "ZJChooseViewOneLeftCell.h"
@interface ZJThreeChildView()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation ZJThreeChildView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.seleIndex = 0;
        [self setUpAllView];
    }
    return self;
}

-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    [self.mainTable reloadData];
}

-(void)setUpAllView{
    
    self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.rowHeight = kCurrentWidth(44);
    [self addSubview:self.mainTable];
    [self addSubview:self.topView];
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
        _topView.backgroundColor = [UIColor colorWithHexString:@"EEF2F5"];
    }
    return _topView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZJChooseViewOneLeftCell *cell = [ZJChooseViewOneLeftCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showLine = YES;
    cell.titleLab.text = self.titleArray[indexPath.row];
    if (indexPath.row == self.seleIndex) {
        cell.threeIsSelected = YES;
        cell.arrowImgV.hidden = NO;
    }else{
        cell.threeIsSelected = NO;
        cell.arrowImgV.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.seleIndex = indexPath.row;
    [self.mainTable reloadData];
    if ([self.delegate respondsToSelector:@selector(threeViewTableviewDidSelectedWithIndex:)]) {
        [self.delegate threeViewTableviewDidSelectedWithIndex:indexPath.row];
    }
}

@end
