//
//  ZJOneChildView.m
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

#import "ZJOneChildView.h"
#import "ZJChooseViewOneLeftCell.h"
#import "ZJChooseOneRightCell.h"

@interface ZJOneChildView ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation ZJOneChildView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpAllView];
//        // 默认第一个cell
//        self.leftSeleIndex  = 0;
//        self.rightSeleIndex = 0;
        
        NSLog(@"Theme classifyIndex111 = %zd  classify2Index = %zd",self.leftSeleIndex,self.rightSeleIndex);
    }
    return self;
}

-(void)setUpAllView{
    [self addSubview:self.topView];
    [self addSubview:self.leftTable];
    [self addSubview:self.rightTable];
}

// 设置左边的tableview 数据
-(void)setLeftDataArray:(NSArray *)leftDataArray{

    _leftDataArray = leftDataArray;

    [self.leftTable reloadData];
    [self.rightTable reloadData];
    
}

// 设置右边的tableview 数据
-(void)setRightDataArray:(NSArray *)rightDataArray{

    _rightDataArray = rightDataArray;
    [self.rightTable reloadData];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTable) {
        return  self.classModel.data.count;
//        return self.leftDataArray.count;
    }else{
        ClassModel *model = [self.classModel.data safeObjectAtIndex:self.leftSeleIndex];
        return model.classifyTwo.count;
//        return self.rightDataArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTable) {
        
        ClassModel *model = [self.classModel.data safeObjectAtIndex:indexPath.row];
        ZJChooseViewOneLeftCell *cell = [ZJChooseViewOneLeftCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 标题
        cell.showLine = NO;
        cell.titleLab.text = model.classify;
        
        if (indexPath.row == self.leftSeleIndex) {
            cell.isSelected = YES;
            cell.contentView.backgroundColor = kWhiteColor;
        }else{
            cell.isSelected = NO;
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"EEF2F5"];
        }
        
        return cell;
    }else{
        ClassModel *model = [self.classModel.data safeObjectAtIndex:self.leftSeleIndex];
        ClassifyTwoModel *dto = [model.classifyTwo safeObjectAtIndex:indexPath.row];
        ZJChooseOneRightCell *cell = [ZJChooseOneRightCell cellWithTableView:tableView];
        cell.titleLab.text = dto.classify;
        if (indexPath.row == self.rightSeleIndex) {
            cell.isSelected = YES;
            
        }else{
            cell.isSelected = NO;
            
        }
        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCurrentWidth(44);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.row);
    
    if (tableView == self.leftTable) {
        
        self.leftSeleIndex = indexPath.row;
        [self.leftTable reloadData];
        self.leftSeleIndex = indexPath.row;
        
        self.rightSeleIndex = 0;
        [self.rightTable reloadData];
        
//        if ([self.delegate respondsToSelector:@selector(oneViewLeftTableviewDidSelectedWithIndex:)]) {
//            [self.delegate oneViewLeftTableviewDidSelectedWithIndex:indexPath.row];
//        }
        
    }else{
        
        self.rightSeleIndex = indexPath.row;
        [self.rightTable reloadData];
        [self.rightTable deselectRowAtIndexPath:indexPath animated:YES];
        if ([self.delegate respondsToSelector:@selector(oneViewRightTableviewDidSelectedWithLeftIndex:rightIndex:)]) {
            [self.delegate oneViewRightTableviewDidSelectedWithLeftIndex:self.leftSeleIndex rightIndex:indexPath.row];
        }
        
    }
    
}


-(UITableView *)leftTable{
    if (!_leftTable) {
        _leftTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCurrentWidth(115), 0) style:UITableViewStylePlain];
        _leftTable.delegate = self;
        _leftTable.dataSource = self;
        _leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTable.showsVerticalScrollIndicator = NO;
        _leftTable.backgroundColor = [UIColor colorWithHexString:@"EEF2F5"];
    }
    return _leftTable;
}
-(UITableView *)rightTable{
    if (!_rightTable) {
        _rightTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth-kCurrentWidth(115), 0) style:UITableViewStylePlain];
        _rightTable.delegate = self;
        _rightTable.dataSource = self;
        _rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTable.showsVerticalScrollIndicator = NO;
    }
    return _rightTable;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
        _topView.backgroundColor = [UIColor colorWithHexString:@"EEF2F5"];
    }
    return _topView;
}

@end
