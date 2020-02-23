//
//  EditExprienceFootView.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/17.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "EditExprienceFootView.h"
#import "IQTextView.h"

@interface EditExprienceFootView ()<UITextViewDelegate>

@property (nonatomic,strong)IQTextView *xmView;
@property (nonatomic,strong)UIView *contentView;

@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,strong)UIButton *saveButton;

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UILabel *numberLabel;

@end

@implementation EditExprienceFootView

- (instancetype)initWithFrame:(CGRect)frame isEdit:(BOOL)isEdit
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createSubViews:isEdit];
    }
    return self;
}

- (void)setExperienceState:(EditExperienceState)experienceState {
    _experienceState = experienceState;
    
    if (experienceState == EditExperienceStateWork) {
        self.xmView.placeholder = @"请添加工作经历描述";
    }
    else if (experienceState == EditExperienceStateEducation) {
        self.xmView.placeholder = @"请添加教育经历描述";
    }
}

- (void)createSubViews:(BOOL)isEdit {
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.height-kCurrentWidth(85))];
    _contentView.backgroundColor = kWhiteColor;
    [self addSubview:_contentView];

    self.xmView = [[IQTextView alloc] initWithFrame:CGRectMake(kCurrentWidth(10), 0, kDeviceWidth-kCurrentWidth(20), self.height-kCurrentWidth(85)-kCurrentWidth(32))];
    self.xmView.placeholderTextColor = kLBNineColor;
    self.xmView.textColor = kLBBlackColor;
    self.xmView.font = kSystem(14);
    self.xmView.delegate = self;
    [self addSubview:self.xmView];

    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _contentView.bottom-kCurrentWidth(32), kDeviceWidth, 0.5)];
    _lineView.backgroundColor = kSepparteLineColor;
    [self addSubview:_lineView];
    
    NSString *selectText = @"0";
    NSString *allSelectText = @"0/2000";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:kLBRedColor
                 range:[allSelectText rangeOfString:selectText]];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _lineView.bottom, kDeviceWidth-kCurrentWidth(22), kCurrentWidth(32))];
    _numberLabel.font = kSystem(13);
    _numberLabel.textColor = kLBNineColor;
    _numberLabel.attributedText = attr;
    _numberLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_numberLabel];
    
    if (isEdit)
    {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(kCurrentWidth(12), _contentView.bottom+kCurrentWidth(30), (kDeviceWidth-kCurrentWidth(36))/2, kCurrentWidth(40));
        [_cancelButton setTitle:@"删除" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _cancelButton.backgroundColor = kLBRedColor;
        _cancelButton.titleLabel.font = kSystem(15);
        _cancelButton.layer.cornerRadius = kCurrentWidth(20);
        _cancelButton.layer.masksToBounds = YES;
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(kDeviceWidth/2+kCurrentWidth(6), _contentView.bottom+kCurrentWidth(30), (kDeviceWidth-kCurrentWidth(36))/2, kCurrentWidth(40));
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.backgroundColor = kLBRedColor;
        _saveButton.titleLabel.font = kSystem(15);
        _saveButton.layer.cornerRadius = kCurrentWidth(20);
        _saveButton.layer.masksToBounds = YES;
        [_saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveButton];
    }
    else
    {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(kCurrentWidth(12), _contentView.bottom+kCurrentWidth(30), kDeviceWidth-kCurrentWidth(24), kCurrentWidth(40));
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.backgroundColor = kLBRedColor;
        _saveButton.titleLabel.font = kSystem(15);
        _saveButton.layer.cornerRadius = kCurrentWidth(20);
        _saveButton.layer.masksToBounds = YES;
        [_saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveButton];
    }
}

#pragma mark Getter
- (NSString *)describeInfo {
    return self.xmView.text;
}

- (void)setDescribeInfo:(NSString *)describeInfo {
    self.xmView.text = describeInfo;
    
    NSString *selectText = [NSString stringWithFormat:@"%zd",self.xmView.text.length];
    NSString *allSelectText = [NSString stringWithFormat:@"%zd/2000",self.xmView.text.length];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:kLBRedColor
                 range:[allSelectText rangeOfString:selectText]];
    _numberLabel.attributedText = attr;
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //不支持系统表情的输入
    if ([[textView textInputMode] primaryLanguage]==nil||[[[textView textInputMode] primaryLanguage]isEqualToString:@"emoji"]) {
        return NO;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange =NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location <MAX_LIMIT_NUMS) {
            return YES;
        }else{
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen =MAX_LIMIT_NUMS - comcatstr.length;
    if (caninputlen >=0){
        return YES;
    }else{
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length >0){
            NSString *s =@"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }else{
                __block NSInteger idx =0;
                __block NSString  *trimString =@"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring,NSRange substringRange,NSRange enclosingRange,BOOL* stop) {
                                          if (idx >= rg.length) {
                                              *stop =YES;//取出所需要就break，提高效率
                                              return ;
                                          }
                                          trimString = [trimString stringByAppendingString:substring];
                                          idx++;
                                      }];
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
//            _numberLabel.text = [NSString stringWithFormat:@"%zd/2000",(long)MAX_LIMIT_NUMS];
            
            NSString *selectText = [NSString stringWithFormat:@"%zd",(long)MAX_LIMIT_NUMS];
            NSString *allSelectText = [NSString stringWithFormat:@"%zd/2000",(long)MAX_LIMIT_NUMS];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
            [attr addAttribute:NSForegroundColorAttributeName
                         value:kLBRedColor
                         range:[allSelectText rangeOfString:selectText]];
            _numberLabel.attributedText = attr;
        }
        return NO;
    }
}

#pragma mark -显示当前可输入字数/总字数
- (void)textViewDidChange:(UITextView *)textView{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum >MAX_LIMIT_NUMS){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        [textView setText:s];
    }
    //不让显示负数
//    _numberLabel.text = [NSString stringWithFormat:@"%zd/2000",existTextNum];
    NSString *selectText = [NSString stringWithFormat:@"%zd",existTextNum];
    NSString *allSelectText = [NSString stringWithFormat:@"%zd/2000",existTextNum];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:kLBRedColor
                 range:[allSelectText rangeOfString:selectText]];
    _numberLabel.attributedText = attr;
}

#pragma mark Event
- (void)cancelButtonClick {
    if (_deleteExperienceBlock) {
        _deleteExperienceBlock();
    }
}

- (void)saveButtonClick {
    if (_saveExperienceBlock) {
        _saveExperienceBlock();
    }
}

@end
