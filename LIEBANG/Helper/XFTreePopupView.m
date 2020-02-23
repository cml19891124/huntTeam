//
//  XFTreePopupView.m
//  IntoSaler
//
//  Created by weihongfang on 2017/9/9.
//  Copyright © 2017年 Leven Wei. All rights reserved.
//

#import "XFTreePopupView.h"

@interface XFTreePopupView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, retain) NSArray *dataSource;



@property (strong, nonatomic) UIView *backgroundView;

@property (nonatomic, strong)UIPickerView *pickerView;

@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIButton *btnCancel;
@property (nonatomic, strong)UIButton *btnOK;

@property (nonatomic, assign) CGFloat height;


@property (nonatomic, assign) NSInteger cloumns;


@property (nonatomic, retain)NSMutableDictionary *arrayOfComponent;




@end


@implementation XFTreePopupView


- (instancetype)initWithDataSource:(id)dataSource Commit:(void(^)(NSArray *))selectItems;
{
    if ([super init])
    {
        _commitBlock = selectItems;
        
        _dataSource = dataSource;
        
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _isHidden = YES;
    
    _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _backgroundView.layer.masksToBounds = YES;
    
    _height = 240;
    
    self.frame = CGRectMake(0, _backgroundView.frame.size.height, _backgroundView.frame.size.width, _height);
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_backgroundView addSubview:self];
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _backgroundView.frame.size.width, 40)];
    [self addSubview:_topView];
    _topView.backgroundColor = [UIColor whiteColor];
    
    _btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, _topView.frame.size.height)];
    _btnCancel.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_btnCancel];
    
    _btnOK = [[UIButton alloc]initWithFrame:CGRectMake(_topView.frame.size.width - 60, 0, 60, _topView.frame.size.height)];
    _btnOK.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [_btnOK setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [_btnOK addTarget:self action:@selector(clickOK) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_btnOK];
    
    _lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_btnCancel.frame), 0, _topView.frame.size.width - 120, _topView.frame.size.height)];
    _lblTitle.text = @" ";
    _lblTitle.font = [UIFont systemFontOfSize:14];
    _lblTitle.textColor = [UIColor grayColor];
    _lblTitle.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_lblTitle];
    
    [self initDataSource];
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,
                                                                CGRectGetMaxY(_topView.frame) + 1,
                                                                self.frame.size.width,
                                                                self.frame.size.height - (CGRectGetMaxY(_topView.frame) + 1))];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];
}

- (NSMutableDictionary *)arrayOfComponent
{
    if (_arrayOfComponent == nil)
    {
        _arrayOfComponent = [NSMutableDictionary dictionaryWithCapacity:3];
        [_arrayOfComponent setObject:_dataSource forKey:@"0"];
    }
    return _arrayOfComponent;
}

//初始化数据
- (void)initDataSource
{
    _cloumns = 1;
    
    NSArray *currentArray = [self.arrayOfComponent objectForKey:@"0"];
    NSDictionary *currentNode = [currentArray objectAtIndex:0];
    
    NSArray *c = [currentNode objectForKey:@"city"];
    NSInteger col = 0;
    while (c != nil && c.count != 0)
    {
        col++;
        
        NSString *strCol = [NSString stringWithFormat:@"%ld", (long)col];
        
        [self.arrayOfComponent setObject:c forKey:strCol];
        
        NSDictionary *firstColNode = [c objectAtIndex:0];
        c = [firstColNode objectForKey:@"city"];
    }
    
    _cloumns = col + 1;
}

#pragma mark - click

- (void)clickCancel
{
    self.isHidden = YES;
}

- (void)clickOK
{
    self.isHidden = YES;
    
    if (self.commitBlock != nil)
    {
        NSMutableArray *selectedItems = [NSMutableArray arrayWithCapacity:2];
        
        for (NSInteger i = 0; i < [self.pickerView numberOfComponents]; i++)
        {
            if ([self pickerView:self.pickerView numberOfRowsInComponent:i] > 0)
            {
                NSInteger row = [self.pickerView selectedRowInComponent:i];
                
                NSArray *array = [self.arrayOfComponent objectForKey:[NSString stringWithFormat:@"%ld", (long)i]];
                
                [selectedItems addObject:[array objectAtIndex:row]];
                
                
//                NSString *title = [self pickerView:self.pickerView titleForRow:row forComponent:i];
                
//                [selectedItems addObject:title];
            }
        }
        
        self.commitBlock(selectedItems);
    }
}

#pragma mark - public method

- (void)setIsHidden:(BOOL)isHidden
{
    if (_isHidden != isHidden)
    {
        _isHidden = isHidden;
        
        if (!_isHidden)
        {
            [[UIApplication sharedApplication].delegate.window addSubview:self.backgroundView];
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - _height, [UIScreen mainScreen].bounds.size.width, _height);
                
                _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.2 animations:^{
                
                self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, _height);
                
                _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
                
            } completion:^(BOOL finished) {
                
                [self.backgroundView removeFromSuperview];
            }];
        }
    }
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.numberOfLines = 0;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    ((UILabel *)[_pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    ((UILabel *)[_pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _cloumns;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSString *strComponent = [NSString stringWithFormat:@"%ld", (long)component];
    
    NSObject *object = [self.arrayOfComponent objectForKey:strComponent];
    if ( [object isKindOfClass:[NSString class]])
    {
        return 0;
    }
    
    NSArray *c = (NSArray *)object;
    
    return c.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strComponent = [NSString stringWithFormat:@"%ld", (long)component];
    NSArray *c = [self.arrayOfComponent objectForKey:strComponent];
    
    NSDictionary *node = [c objectAtIndex:row];
    NSString *nodeName = [node objectForKey:@"name"];
    
    return nodeName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //1.找出当前选中的节点，和列
    NSString *strComponent = [NSString stringWithFormat:@"%ld", (long)component];
    
    NSArray *currentArray = [self.arrayOfComponent objectForKey:strComponent];
    NSDictionary *currentNode = [currentArray objectAtIndex:row];
    
    //2.判断选中该节点后是否有子节点列表，如果有，则默认选中第一个子节点，循环，知道没有子节点为止
    NSArray *c = [currentNode objectForKey:@"city"];
    NSInteger col = component;
    while (c != nil && c.count != 0)
    {
        col++;
        
        NSString *strCol = [NSString stringWithFormat:@"%ld", (long)col];
        
        [self.arrayOfComponent setObject:c forKey:strCol];
        
        NSDictionary *firstColNode = [c objectAtIndex:0];
        c = [firstColNode objectForKey:@"city"];
    }
    
    //3. 如果当前节点的子节点深度小于这棵树的最大深度，就把多余的深度设置为空
    if (col < _cloumns - 1)
    {
        for (NSInteger i = col + 1; i < _cloumns; i++)
        {
            NSString *strI = [NSString stringWithFormat:@"%ld", (long)i];
            [self.arrayOfComponent setObject:@"" forKey:strI];
        }
    }
    
    //4. 重新加载数据，如果最大深度变大，则全部reload，如果最大深度不变，则reload对应的列，并且默认选中第一个节点
    if (_cloumns < col + 1)
    {
        _cloumns = col + 1;
        NSLog(@"self.pickerView reloadAllComponents");
        [self.pickerView reloadAllComponents];
    }
    else
    {
        for (NSInteger n = component + 1; n < _cloumns; n++)
        {
            [self.pickerView reloadComponent:n];
            [self.pickerView selectRow:0 inComponent:n animated:YES];
        }
    }
}

@end
