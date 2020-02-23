//
//  ThemeContentCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/8/29.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "ThemeContentCell.h"
#import "IQTextView.h"

@interface ThemeContentCell ()<UITextViewDelegate>

@property (nonatomic,strong)IQTextView *contentTV;
@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation ThemeContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(13), kCurrentWidth(10), kDeviceWidth-kCurrentWidth(26), kCurrentWidth(20))];
        _titleLabel.font = kSystemBold(15);
        _titleLabel.textColor = kLBBlackColor;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_titleLabel];
        
        self.contentTV = [[IQTextView alloc] initWithFrame:CGRectMake(kCurrentWidth(10), kCurrentWidth(30), kDeviceWidth-kCurrentWidth(20), kCurrentWidth(150))];
//        self.contentTV.placeholder = @"【猎帮】职场社交知识问答平台。\n猎帮是一家互联网连接职场【人和知识】的社交交易平台。专注于成为你的【第二职业】平台，为职场人匹配高价值的【实战知识经验】，解决工作和职业问题，加速个人【成长】。猎帮团队主要来自腾讯、华为技术背景，2017年12月，获得深圳科技工业园集团，明德教育基金及天使轮500万融资。";
        self.contentTV.placeholderTextColor = kLBNineColor;
        self.contentTV.textColor = kLBBlackColor;
        self.contentTV.font = kSystem(13);
        self.contentTV.delegate = self;
        [self addSubview:self.contentTV];

    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    NSString *string;
    if (indexPath.section == 1) {
        string = @"告诉行家，要请教的问题(不超过500字)*";
        _contentTV.placeholder = @"详细的问题描述有助于行家有的放矢";
    }
    else if (indexPath.section == 2) {
        string = @"介绍一下自己，可备注时间地点喜好(不超过500字)*";
        _contentTV.placeholder = @"您填写的信息只有行家能看到，不会公开给其他人";
    }
    
    NSString *selectText = @"*";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:kRedColor
                 range:[string rangeOfString:selectText]];
    self.titleLabel.attributedText = attr;
}

- (void)setContent:(NSString *)content {
    _content = content;
    
    if (!IsNilOrNull(content) && !IsStrEmpty(content)) {
        _contentTV.text = content;
    }
}

#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //如果是删除减少字数，都返回允许修改
    if ([text isEqualToString:@""]) {
        return YES;
    }
//    if ([text isEqualToString:@" "]) {
//        return NO;
//    }
    if (range.location >= 500)
    {
        self.contentTV.text= [self.contentTV.text substringToIndex:500];
        if (self.themeContentBlock) {
            self.themeContentBlock(self.indexPath, self.contentTV.text);
        }
        return NO;
    }
    else
    {
        if (self.themeContentBlock) {
            self.themeContentBlock(self.indexPath, self.contentTV.text);
        }
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 500) {
        self.contentTV.text= [self.contentTV.text substringToIndex:500];

        if (self.themeContentBlock) {
            self.themeContentBlock(self.indexPath, self.contentTV.text);
        }
        return;
    }
    if (self.themeContentBlock) {
        self.themeContentBlock(self.indexPath, self.contentTV.text);
    }
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
