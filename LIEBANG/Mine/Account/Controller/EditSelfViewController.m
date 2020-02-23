//
//  EditSelfViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "EditSelfViewController.h"
#import "AccountService.h"
#import "IQTextView.h"
#import "IQKeyboardManager.h"

@interface EditSelfViewController ()<UITextViewDelegate>

@property (nonatomic,strong)IQTextView *xmView;

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UILabel *numberLabel;

@end

@implementation EditSelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑自我介绍";
    self.view.backgroundColor = kBackgroundColor;
    
    [self setRightNaviBtnTitle:@"保存"];
    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self createSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - 键盘监听
- (void)keyboardWillShow:(NSNotification*)noti
{
    CGFloat keyboardH = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    self.xmView.height = kDeviceHeight-kNavBarHeight-kCurrentWidth(52)-keyboardH;
    [self reloadNumView];
    
    for (UILabel *label in self.xmView.subviews) {
        if ([label isKindOfClass:UILabel.class]) {
//            label.frame = CGRectMake(10, 10, kDeviceWidth, 20);
            label.height = 20;
            label.numberOfLines = 1;
        }
    }
}

- (void)keyboardWillHide:(NSNotification*)noti
{
    self.xmView.height = kDeviceHeight-kNavBarHeight-kCurrentWidth(52);
    [self reloadNumView];

    for (UILabel *label in self.xmView.subviews) {
            if ([label isKindOfClass:UILabel.class]) {
                label.frame = CGRectMake(10, 10, kDeviceWidth, 20);
                label.numberOfLines = 1;
            }
        }
}

- (void)reloadNumView {
    _lineView.top = self.xmView.bottom;
    _contentView.top = _lineView.bottom;
    _numberLabel.top = _lineView.bottom;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//- (void) viewWillAppear: (BOOL)animated {
//    
//    [super viewWillAppear:animated];
//    //关闭自动键盘功能
//    [IQKeyboardManager sharedManager].enable = NO;
//    
//}
//
//- (void) viewWillDisappear: (BOOL)animated {
//    [super viewWillAppear:animated];
//    //开启自动键盘功能
//    [IQKeyboardManager sharedManager].enable = YES;
//    
//}

#pragma mark Event
- (void)rightNaviBtnClick {
    
    [self.xmView resignFirstResponder];
//    if (IsStrEmpty(self.xmView.text) || IsNilOrNull(self.xmView.text)) {
//        [self presentSheet:@"请输入自我介绍"];
//        return;
//    }
    
//    [self displayOverFlowActivityView];
    [AccountService getEditIntroduceWithParameters:self.xmView.text success:^(id model) {
//        [self removeOverFlowActivityView];
//        [self presentSheet:model];
        [self performBlock:^{
            [self backNavItemTapped];
        } afterDelay:1.5];
    } failure:^(NSUInteger code, NSString *errorStr) {
//        [self removeOverFlowActivityView];
//        [self presentSheet:errorStr];
    }];
}

#pragma mark UI
- (void)createSubViews {
    
    self.xmView = [[IQTextView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavBarHeight-kCurrentWidth(52))];
    self.xmView.placeholderTextColor = kLBNineColor;
    self.xmView.textColor = kLBBlackColor;
    self.xmView.font = kSystem(14);
    self.xmView.delegate = self;
    self.xmView.placeholder = @"请添加自我介绍";
    self.xmView.text = self.userIntroduce;
    [self.view addSubview:self.xmView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.xmView.bottom, kDeviceWidth, 0.5)];
    _lineView.backgroundColor = kSepparteLineColor;
    [self.view addSubview:_lineView];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _lineView.bottom, kDeviceWidth, kCurrentWidth(32))];
    _contentView.backgroundColor = kWhiteColor;
    [self.view addSubview:_contentView];
    
    NSString *selectText = [NSString stringWithFormat:@"%zd",self.xmView.text.length];
    NSString *allSelectText = [NSString stringWithFormat:@"%zd/2000",self.xmView.text.length];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:kLBRedColor
                 range:[allSelectText rangeOfString:selectText]];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _lineView.bottom, kDeviceWidth-kCurrentWidth(22), kCurrentWidth(32))];
    _numberLabel.font = kSystem(13);
    _numberLabel.textColor = kLBNineColor;
    _numberLabel.attributedText = attr;
    _numberLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_numberLabel];
    
    [self performBlock:^{
        [self.xmView becomeFirstResponder];
    } afterDelay:1];
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
            NSString *selectText = [NSString stringWithFormat:@"%zd",textView.text.length];
            NSString *allSelectText = [NSString stringWithFormat:@"%zd/2000",textView.text.length];
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
    NSString *selectText = [NSString stringWithFormat:@"%zd",textView.text.length];
    NSString *allSelectText = [NSString stringWithFormat:@"%zd/2000",textView.text.length];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:kLBRedColor
                 range:[allSelectText rangeOfString:selectText]];
    _numberLabel.attributedText = attr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
