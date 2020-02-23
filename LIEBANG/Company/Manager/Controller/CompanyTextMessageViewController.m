//
//  CompanyMessageViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2019/1/31.
//  Copyright © 2019年  YIQI. All rights reserved.
//

#import "CompanyTextMessageViewController.h"
#import "IQTextView.h"

@interface CompanyTextMessageViewController ()<UITextViewDelegate>

@property (nonatomic,strong)IQTextView *contentTv;

@end

@implementation CompanyTextMessageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.titleString;
    self.view.backgroundColor = kWhiteColor;
    
    [self setRightNaviBtnTitle:@"保存"];
    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentTv = [[IQTextView alloc] initWithFrame:CGRectMake(0, 5, kDeviceWidth,kDeviceHeight-kNavBarHeight-kViewHeight-5)];
    self.contentTv.placeholder = @"请输入内容";
    self.contentTv.placeholderTextColor = kLBNineColor;
    self.contentTv.textColor = kLBBlackColor;
    self.contentTv.font = kSystem(13);
    self.contentTv.text = self.contentString;
    self.contentTv.delegate = self;
    [self.view addSubview:self.contentTv];
    
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
    self.contentTv.frame = CGRectMake(0, 5, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight-5-keyboardH);
}

- (void)keyboardWillHide:(NSNotification*)noti
{
    if (!IsStrEmpty(self.contentTv.text)) {
        self.contentTv.frame = CGRectMake(0, 5, kDeviceWidth, kDeviceHeight-kNavBarHeight-kViewHeight-5);
    }
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
        if (offsetRange.location <5000) {
            return YES;
        }else{
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen =5000 - comcatstr.length;
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
    if (existTextNum >5000){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:5000];
        [textView setText:s];
    }
    //不让显示负数
    //    _numberLabel.text = [NSString stringWithFormat:@"%zd/2000",existTextNum];
}

//- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
//    if (_editMessageBlock) {
//        _editMessageBlock(textView.tag-30,IsStrEmpty(textView.text)?nil:textView.text);
//    }
//    return YES;
//}

- (void)rightNaviBtnClick {
    
    if (IsNilOrNull(self.contentTv.text) || IsStrEmpty(self.contentTv.text)) {
        [self showAlertWithString:@"请输入内容"];
        return;
    }
    
    if (_editMessageBlock) {
        _editMessageBlock(self.contentTv.tag-30,self.contentTv.text);
    }
    [super backNavItemTapped];
}

@end
