//
//  UserCommentViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/24.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "UserCommentViewController.h"
#import "AccountService.h"
#import "IQTextView.h"

@interface UserCommentViewController ()<UITextViewDelegate>

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIButton *postButton;
@property (nonatomic,strong)IQTextView *contentTv;

@end

@implementation UserCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    
    self.navigationItem.title = [NSString stringWithFormat:@"给%@点评",self.accountInfo.userName];
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
    
    self.contentTv.height = _postButton.top-_lineView.bottom-keyboardH;
}

- (void)keyboardWillHide:(NSNotification*)noti
{
    self.contentTv.height = _postButton.top-_lineView.bottom;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark Event
- (void)postButtonClick {
    
    if (IsStrEmpty(self.contentTv.text)) {
        [self showAlertWithString:@"请输入点评内容"];
        return;
    }
    
    if (self.contentTv.text.length < 24) {
        [self showAlertWithString:@"点评内容不得少于24字"];
        return;
    }
    
    if (self.contentTv.text.length > 100) {
        [self showAlertWithString:@"点评内容不得多于100字"];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.accountInfo.userUid forKey:@"commitUserUid"];//目标用户的Uid
    [postDic setValue:self.contentTv.text forKey:@"comment"];
    
    [self displayOverFlowActivityView];
    [AccountService getPostCommentWithParameters:postDic success:^(id model) {
        [self removeOverFlowActivityView];
        [self presentSheet:model];
        [self performBlock:^{
            [self backNavItemTapped];
        } afterDelay:1.5];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)createSubViews {
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kDeviceWidth-kCurrentWidth(24), kCurrentWidth(42))];
    _titleLabel.textColor = kLBSixColor;
    _titleLabel.font = kSystem(13);
    
    NSString *selectText = self.accountInfo.userName;
    NSString *allSelectText = [NSString stringWithFormat:@"综合评价%@(建议结合具体事例点评)",self.accountInfo.userName];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:kLBRedColor
                 range:[allSelectText rangeOfString:selectText]];
    _titleLabel.attributedText = attr;
    [self.view addSubview:_titleLabel];
    
    _lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom, kDeviceWidth, 0.5)];
    _lineView.backgroundColor = kSepparteLineColor;
    [self.view addSubview:_lineView];
    
    _postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _postButton.frame = CGRectMake(0, kDeviceHeight-kNavBarHeight-kCurrentWidth(49)-kViewHeight, kDeviceWidth, kCurrentWidth(49));
    _postButton.backgroundColor = kLBRedColor;
    [_postButton setTitle:@"提交评价" forState:UIControlStateNormal];
    [_postButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _postButton.titleLabel.font = kSystem(15);
    [_postButton addTarget:self action:@selector(postButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_postButton];
    
    self.contentTv = [[IQTextView alloc] initWithFrame:CGRectMake(0, _lineView.bottom, kDeviceWidth, _postButton.top-_lineView.bottom)];
    self.contentTv.placeholder = @"你可以从以下几个方面来点评(限24-100字)\n1.TA在人品、专长、潜力方面给你的感受和体会；\n2.共同经历中TA值得你称赞的典型事迹；\n3.与TA合作的整体感觉。";
    if (self.isComment) {
        self.contentTv.placeholder = @"";
    }
    self.contentTv.placeholderTextColor = kLBNineColor;
    self.contentTv.textColor = kLBBlackColor;
    self.contentTv.font = kSystem(14);
    self.contentTv.delegate = self;
    [self.view addSubview:self.contentTv];
}

#pragma mark UITextViewDelegate
#pragma mark YYTextViewDelegate
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
        if (offsetRange.location <100) {
            return YES;
        }else{
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen =100 - comcatstr.length;
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
//            self.protocolView.number = textView.text.length;
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
    if (existTextNum >100){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:100];
        [textView setText:s];
    }
    //不让显示负数
//    self.protocolView.number = textView.text.length;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
