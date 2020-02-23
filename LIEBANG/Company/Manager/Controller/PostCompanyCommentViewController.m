//
//  PostCompanyCommentViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/12/29.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PostCompanyCommentViewController.h"
#import "CompanyService.h"
#import "IQTextView.h"
#import "IQKeyboardManager.h"

@interface PostCompanyCommentViewController ()<UITextViewDelegate>

@property (nonatomic,strong)UIButton *saveButton;
@property (nonatomic,strong)IQTextView *commentTv;

@end

@implementation PostCompanyCommentViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"给%@点评",self.enterpriseName];
    self.view.backgroundColor = kWhiteColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self createSubViews];
}

- (void) viewWillAppear: (BOOL)animated {
    
    [super viewWillAppear:animated];
    //关闭自动键盘功能
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void) viewWillDisappear: (BOOL)animated {
    [super viewWillAppear:animated];
    //开启自动键盘功能
    [IQKeyboardManager sharedManager].enable = YES;
    
}

#pragma mark - 键盘监听
- (void)keyboardWillShow:(NSNotification*)noti
{
    CGFloat keyboardH = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.commentTv.frame = CGRectMake(kCurrentWidth(14), kCurrentWidth(63)+0.5, kDeviceWidth-kCurrentWidth(28), _saveButton.top-(kCurrentWidth(43)+0.5)-kCurrentWidth(40)-keyboardH);
}

- (void)keyboardWillHide:(NSNotification*)noti
{
    if (!IsStrEmpty(self.commentTv.text)) {
        self.commentTv.frame = CGRectMake(kCurrentWidth(14), kCurrentWidth(63)+0.5, kDeviceWidth-kCurrentWidth(28), _saveButton.top-(kCurrentWidth(43)+0.5)-kCurrentWidth(40));
    }
}

#pragma mark
#pragma mark Event
- (void)postCompanyCommentRequest {
    
    if (self.commentTv.text.length < 10) {
        [self showAlertWithString:@"至少输入10个字"];
        return;
    }
    
    if (self.commentTv.text.length > 2000) {
        [self showAlertWithString:@"最多输入2000个字"];
        return;
    }
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setValue:self.commentTv.text forKey:@"comment"];
    [postDic setValue:self.enterpriseId forKey:@"enterpriseId"];
    
    [self displayOverFlowActivityView];
    [CompanyService postCommentCompanyWithParameters:postDic success:^(NSString * _Nonnull data) {
        [self removeOverFlowActivityView];
        [self showAlertWithString:@"点评成功"];

        [self backNavItemTapped];
    } failure:^(NSUInteger code, NSString * _Nonnull errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

#pragma mark
#pragma mark UI
- (void)createSubViews {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), 0, kDeviceWidth-kCurrentWidth(13), kCurrentWidth(43))];
    titleLabel.text = [NSString stringWithFormat:@"综合评价%@",self.enterpriseName];
    titleLabel.textColor = kLBNineColor;
    titleLabel.font = kSystemBold(15);
    [self.view addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, kDeviceWidth, 0.5)];
    lineView.backgroundColor = kSepparteLineColor;
    [self.view addSubview:lineView];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveButton.frame = CGRectMake(kCurrentWidth(12), kDeviceHeight-kNavBarHeight-kViewHeight-kCurrentWidth(84), kDeviceWidth-kCurrentWidth(24), kCurrentWidth(49));
    _saveButton.titleLabel.font = kSystemBold(16);
    [_saveButton setTitle:@"提交评价" forState:UIControlStateNormal];
    [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _saveButton.layer.cornerRadius = 3;
    _saveButton.layer.masksToBounds = YES;
    _saveButton.backgroundColor = kLBRedColor;
    [_saveButton addTarget:self action:@selector(postCompanyCommentRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    
    self.commentTv = [[IQTextView alloc] initWithFrame:CGRectMake(kCurrentWidth(14), lineView.bottom+kCurrentWidth(20), kDeviceWidth-kCurrentWidth(28), _saveButton.top-lineView.bottom-kCurrentWidth(40))];
    self.commentTv.placeholder = @"你可以从一下几个方面来点评（限制10-2000字体）\n\n1.结合公司具体事例点评\n\n2.商业合作中整体感觉点评";
    self.commentTv.placeholderTextColor = kLBNineColor;
    self.commentTv.textColor = kLBBlackColor;
    self.commentTv.font = kSystem(13);
    self.commentTv.delegate = self;
    [self.view addSubview:self.commentTv];
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
}

@end
