//
//  OrderCommentCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/9/6.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "OrderCommentCell.h"
#import "IQTextView.h"
#import "StarView.h"

@interface OrderCommentCell ()<UITextViewDelegate>

@property (nonatomic,strong)UIView *markView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIView *lineView1;
@property (nonatomic,strong)IQTextView *xmView;

@property (nonatomic,strong)UIView *content;
@property (nonatomic,strong)UILabel *typelabel;
@property (nonatomic,strong)StarView *starView;

@end

@implementation OrderCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kCurrentWidth(10))];
        _markView.backgroundColor = kBackgroundColor;
        [self.contentView  addSubview:_markView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kCurrentWidth(10), kDeviceWidth, kCurrentWidth(44))];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = kSystemBold(15);
        _nameLabel.textColor = kLBBlackColor;
        [self.contentView addSubview:_nameLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _nameLabel.bottom, kDeviceWidth, 0.5)];
        _lineView.backgroundColor = kSepparteLineColor;
        [self.contentView  addSubview:_lineView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), _lineView.bottom, kDeviceWidth-kCurrentWidth(24), kCurrentWidth(44))];
        _titleLabel.font = kSystem(14);
        _titleLabel.textColor = kLBSixColor;
        [self.contentView addSubview:_titleLabel];
        
        _lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom, kDeviceWidth, 0.5)];
        _lineView1.backgroundColor = kSepparteLineColor;
        [self.contentView  addSubview:_lineView1];
        
        self.xmView = [[IQTextView alloc] initWithFrame:CGRectMake(kCurrentWidth(12), _lineView1.bottom, kDeviceWidth - kCurrentWidth(24), kCurrentWidth(116))];
        self.xmView.placeholder = @"你可以从以下几个方面来点评（限500字）:\n1.TA在人品、专长、潜力方面给你的感受或体会\n2.共同经历中TA值得称赞的典型事迹\n3.与TA合作的整体感觉";
        self.xmView.placeholderTextColor = kLBNineColor;
        self.xmView.textColor = kLBBlackColor;
        self.xmView.font = kSystem(14);
        self.xmView.delegate = self;
        [self addSubview:self.xmView];

        _content = [[UIView alloc] initWithFrame:CGRectMake(0, self.xmView.bottom, kDeviceWidth, kCurrentWidth(40))];
        _content.backgroundColor = kBackgroundColor;
        [self addSubview:_content];
        
        NSString *string = @"用户评价：";
        CGSize size = [string sizeWithFont:kSystem(13) maxSize:CGSizeMake(MAXFLOAT, kCurrentWidth(40))];
        
        _typelabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, size.width, kCurrentWidth(40))];
        _typelabel.font = kSystem(13);
        _typelabel.textColor = kLBSixColor;
        _typelabel.text = string;
        [_content addSubview:_typelabel];
        
        _starView = [[StarView alloc] initWithFrame:CGRectMake(_typelabel.right+kCurrentWidth(10), kCurrentWidth(15), kCurrentWidth(78), kCurrentWidth(10))];
        [_content addSubview:_starView];
    }
    return self;
}

- (void)setDetailModel:(ThemeOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
    _nameLabel.text = [NSString stringWithFormat:@"给%@点评",detailModel.userName];
    
    NSString *selectText = detailModel.userName;
    NSString *allSelectText = [NSString stringWithFormat:@"综合评价%@(建议结合具体事例点评)",detailModel.userName];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:kLBRedColor
                 range:[allSelectText rangeOfString:selectText]];
    _titleLabel.attributedText = attr;
    
    _starView.score = [detailModel.startLevel floatValue];
}

#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

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
            if (offsetRange.location >= 500) {
                [Config currentConfig].comment = textView.text;

                return YES;
            }else{
                [Config currentConfig].comment = textView.text;

                return NO;
            }
        }

        NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSInteger caninputlen = 500 - comcatstr.length;
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
    if (existTextNum >= 500){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:500];
        [textView setText:s];
    }
    [Config currentConfig].comment = textView.text;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
