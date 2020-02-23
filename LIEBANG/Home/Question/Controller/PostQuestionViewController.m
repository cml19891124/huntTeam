//
//  PostQuestionViewController.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/25.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "PostQuestionViewController.h"
#import "ExpertListViewController.h"
#import "QuestionService.h"
#import "UserProtocolCell.h"
#import "IQKeyboardManager.h"
#import "IQTextView.h"

@interface PostQuestionViewController ()<UITextViewDelegate>

@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *navLabel;
@property (nonatomic,strong)UIButton *serverButton;
@property (nonatomic,strong)NSString *questionPri;
@property (nonatomic,assign)BOOL isPri;

@property (nonatomic,strong)IQTextView *xmView;

@property (nonatomic,strong)UserProtocolCell *protocolView;

@end

@implementation PostQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
//    self.xmView.frame = CGRectMake(0, _backView.bottom+kCurrentWidth(5), kDeviceWidth, kDeviceHeight-_backView.bottom-kCurrentWidth(25)-kNavBarHeight-kCurrentWidth(30)-keyboardH);
    self.xmView.height = kDeviceHeight-_backView.bottom-kCurrentWidth(25)-kNavBarHeight-kCurrentWidth(30);

    _protocolView.top = kDeviceHeight-kNavBarHeight-kCurrentWidth(25)-keyboardH-kViewHeight;
    for (UILabel *label in self.xmView.subviews) {
            if ([label isKindOfClass:UILabel.class]) {
                label.height = 20;
                label.numberOfLines = 1;
            }
        }
}

- (void)keyboardWillHide:(NSNotification*)noti
{
    if (!IsStrEmpty(self.xmView.text)) {
//        self.xmView.frame = CGRectMake(0, _backView.bottom+kCurrentWidth(5), kDeviceWidth, kDeviceHeight-_backView.bottom-kCurrentWidth(25)-kNavBarHeight-kCurrentWidth(30));
        self.xmView.height = kDeviceHeight-_backView.bottom-kCurrentWidth(25)-kNavBarHeight-kCurrentWidth(25);
    }
//
    _protocolView.top = kDeviceHeight-kNavBarHeight-kCurrentWidth(30)-kViewHeight;
    for (UILabel *label in self.xmView.subviews) {
        if ([label isKindOfClass:UILabel.class]) {
            label.height = 20;

            label.numberOfLines = 1;
        }
    }
}

#pragma mark Event
- (void)gotoUserProtocol {
    [self.xmView resignFirstResponder];
    WebViewController *nextCtr = [[WebViewController alloc] init];
    nextCtr.webViewType = WebViewTypeUserProtocol;
    [self.navigationController pushViewController:nextCtr animated:YES];
}

- (void)nextButtonClick {
    
    [self.xmView resignFirstResponder];
    if (!self.isPri) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addQuestionPriceRequest];
        });
        [self showAlertWithString:@"提问价格获取失败，\n正在重新获取"];
        return;
    }

    if (IsStrEmpty(self.xmView.text)) {
        [self showAlertWithString:@"问题不能为空"];
        return;
    }
    
    if ([InsureValidate deleteWhiteSpaceInStr:self.xmView.text].length < 10) {
        [self showAlertWithString:@"输入的有效字符不能少于10字"];
        return;
    }
    
    if (self.xmView.text.length < 10) {
        [self showAlertWithString:@"问题不能少于10字"];
        return;
    }
    
    if (self.xmView.text.length > 500) {
        [self showAlertWithString:@"问题不能多于500字"];
        return;
    }
    
    if (!_protocolView.isUserProtocol) {
        [self showAlertWithString:@"请阅读并同意猎帮用户协议"];
        return;
    }
    
    if (IsNilOrNull([Config currentConfig].answerid) || IsStrEmpty([Config currentConfig].answerid))
    {
        ExpertListViewController *nextCtr = [[ExpertListViewController alloc] init];
        nextCtr.questionPri = self.questionPri;
        nextCtr.quizcontent = self.xmView.text;
        [self.navigationController pushViewController:nextCtr animated:YES];
    }
    else
    {
        [self displayOverFlowActivityView];
        [QuestionService getUserClassifyWithParameters:[Config currentConfig].answerid success:^(NSString *info) {
            [self removeOverFlowActivityView];
            PayViewController *nextCtr = [[PayViewController alloc] init];
            nextCtr.serviceType = @"在线问答";
            nextCtr.quizcontent = self.xmView.text;
            nextCtr.questionPri = self.questionPri;
            nextCtr.classifyId = info;
            [self.navigationController pushViewController:nextCtr animated:YES];
        } failure:^(NSUInteger code, NSString *errorStr) {
            [self removeOverFlowActivityView];
            [self presentSheet:errorStr];
        }];
    }
}

- (void)addQuestionPriceRequest {
    
    [self displayOverFlowActivityView];
    [QuestionService getQuestionPriceWithParameters:nil success:^(NSString *info) {
        [self removeOverFlowActivityView];
        self.questionPri = info;
        self.isPri = YES;
        self.navigationItem.title = [NSString stringWithFormat:@"付费%@猎帮币向行家提问",info];
    } failure:^(NSUInteger code, NSString *errorStr) {
        [self removeOverFlowActivityView];
        [self presentSheet:errorStr];
    }];
}

- (void)setQuestionPri:(NSString *)questionPri {
    _questionPri = questionPri;
    
    NSString *selectText = questionPri;
    NSString *allSelectText = [NSString stringWithFormat:@"付费%@猎帮币向行家提问",questionPri];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:kLBRedColor
                 range:[allSelectText rangeOfString:selectText]];
    _navLabel.attributedText = attr;
}

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
        if (offsetRange.location <500) {
            return YES;
        }else{
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen =500 - comcatstr.length;
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
            self.protocolView.number = textView.text.length;
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
    if (existTextNum >500){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:500];
        [textView setText:s];
    }
    //不让显示负数
    self.protocolView.number = textView.text.length;
}


#pragma mark 界面布局
- (void)createSubViews {
    
    [self addQuestionPriceRequest];
    
    _navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
    _navLabel.textColor = kLBBlackColor;
    _navLabel.font = kSystemBold(16);
    _navLabel.textAlignment = NSTextAlignmentCenter;
    self.questionPri = @"0";
    
    self.navigationItem.titleView = _navLabel;
    self.view.backgroundColor = kWhiteColor;
    
    [self setRightNaviBtnTitle:@"下一步"];
    [self.rightNaviBtn addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(40))];
    _backView.backgroundColor = [UIColor colorWithHexString:@"CFD3FF"];
    [self.view addSubview:_backView];
    
    _serverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _serverButton.frame = CGRectMake((kDeviceWidth-kCurrentWidth(170))/2, _backView.bottom+kCurrentWidth(15), kCurrentWidth(170), kCurrentWidth(26));
    _serverButton.layer.borderColor = kLBRedColor.CGColor;
    _serverButton.layer.borderWidth = 0.5;
    _serverButton.layer.cornerRadius = kCurrentWidth(13);
    _serverButton.layer.masksToBounds = YES;
    _serverButton.backgroundColor = kWhiteColor;
    [_serverButton setTitleColor:kLBRedColor forState:UIControlStateNormal];
    [_serverButton setTitle:@"在线问答" forState:UIControlStateNormal];
    _serverButton.titleLabel.font = kSystem(15);
//    [self.view addSubview:_serverButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kDeviceWidth-kCurrentWidth(24), kCurrentWidth(40))];
    _titleLabel.textColor = [UIColor colorWithHexString:@"5A9EFC"];
    _titleLabel.text = @"每当问题被查看，您将获得一部分收入";
    _titleLabel.font = kSystem(14);
    [_backView addSubview:_titleLabel];
    
    self.xmView = [[IQTextView alloc] initWithFrame:CGRectMake(0, _backView.bottom+kCurrentWidth(5), kDeviceWidth, kDeviceHeight-_backView.bottom-kCurrentWidth(25)-kNavBarHeight-kCurrentWidth(30))];
    self.xmView.placeholder = @"描述提问的问题，不得少于10个字";
    self.xmView.placeholderTextColor = kLBNineColor;
    self.xmView.textColor = kLBBlackColor;
    self.xmView.font = kSystem(13);
    self.xmView.delegate = self;
    
    [self.view addSubview:self.xmView];
    
    WeakSelf;
    _protocolView = [[UserProtocolCell alloc] initWithFrame:CGRectMake(0, kDeviceHeight-kNavBarHeight-kCurrentWidth(30)-kViewHeight, kDeviceWidth, kCurrentWidth(30))];
    _protocolView.backgroundColor = kWhiteColor;
    _protocolView.isLabelShow = YES;
    _protocolView.userProtocolBlock = ^{
        [weakSelf gotoUserProtocol];
    };
    [self.view addSubview:_protocolView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
