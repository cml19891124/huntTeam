//
//  EditAccountCell.m
//  LIEBANG
//
//  Created by  YIQI on 2018/7/16.
//  Copyright © 2018年  YIQI. All rights reserved.
//

#import "EditAccountCell.h"

@interface EditAccountCell ()<UITextFieldDelegate>
{
    NSInteger newLength;
}
@property (nonatomic,strong)UILabel *titleLabel;
//@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UIImageView *LOGO;
@property (nonatomic,strong)UITextField *detailTextField;

@end

@implementation EditAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createSubViews];
    }
    return self;
}

//预约话题时间
- (void)setThemeDataWith:(NSArray *)titleArray plTitleArray:(NSArray *)plTitleArray indexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    self.editAccountCellState = EditAccountCellAccessory;
    _titleLabel.text = [titleArray safeObjectAtIndex:indexPath.row];
    _detailTextField.placeholder = [plTitleArray safeObjectAtIndex:indexPath.row];
    _detailTextField.tag = indexPath.row+10;
    if (indexPath.row < 2)
    {
        _detailTextField.enabled = NO;
    }
    else
    {
        _detailTextField.enabled = YES;
    }
}

- (void)setDetailModel:(ThemeOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    
    self.accessoryType = UITableViewCellAccessoryNone;
    _detailTextField.right = kDeviceWidth-15 * 2;
    if (self.indexPath.row == 0)
    {
        _detailTextField.text = detailModel.mettingBeginTime;
    }
    else if (self.indexPath.row == 1)
    {
        _detailTextField.text = detailModel.mettingEdnTime;
    }
    else if (self.indexPath.row == 2)
    {
        _detailTextField.text = detailModel.mettingAddress;
    }
    else if (self.indexPath.row == 3)
    {
        _detailTextField.text = detailModel.detailedAddress;
    }
}

- (void)setExperienceDataWith:(NSArray *)titleArray indexPath:(NSIndexPath *)indexPath {
    
    _indexPath = indexPath;
    _detailTextField.tag = 1+indexPath.row;
    _titleLabel.text = [titleArray safeObjectAtIndex:indexPath.row];
    if (indexPath.row == 0)
    {
        self.editAccountCellState = EditAccountCellImage;
    }
    else
    {
        self.editAccountCellState = EditAccountCellAccessory;
    }
    if (indexPath.row >= 3)
    {
        _detailTextField.enabled = NO;
    }
    else
    {
        _detailTextField.enabled = YES;
    }
}

- (void)setEducationModel:(EducationModel *)educationModel {
    
    _educationModel = educationModel;
    
    if (_indexPath.row == 0)
    {
        [_LOGO sd_setImageWithURL:[NSURL URLWithString:educationModel.eduLogo] placeholderImage:[UIImage imageNamed:@""]];
    }
    else if (_indexPath.row == 1)
    {
        _detailTextField.text = educationModel.schoolName;
    }
    else if (_indexPath.row == 2)
    {
        _detailTextField.text = educationModel.subjectName;
    }
    else if (_indexPath.row == 3)
    {
        _detailTextField.text = educationModel.diploma;
    }
    else if (_indexPath.row == 4)
    {
        _detailTextField.text = educationModel.beginTime;
    }
    else if (_indexPath.row == 5)
    {
        _detailTextField.text = educationModel.endTime;
    }
}

- (void)setWorkModel:(WorkModel *)workModel {
    _workModel = workModel;
    
    if (_indexPath.row == 0)
    {
        [_LOGO sd_setImageWithURL:[NSURL URLWithString:workModel.comLogo] placeholderImage:[UIImage imageNamed:@""]];
    }
    else if (_indexPath.row == 1)
    {
        _detailTextField.text = workModel.company;
    }
    else if (_indexPath.row == 2)
    {
        _detailTextField.text = workModel.position;
    }
    else if (_indexPath.row == 3)
    {
        _detailTextField.text = workModel.beginTime;
    }
    else if (_indexPath.row == 4)
    {
        _detailTextField.text = workModel.endTime;
    }
}

- (void)setAccountModel:(AccountModel *)accountModel {
    _accountModel = accountModel;
    
    if (_indexPath.section == 0)
    {
        if (_indexPath.row == 0)
        {
            [_LOGO sd_setImageWithURL:[NSURL URLWithString:accountModel.userHead] placeholderImage:[UIImage imageNamed:@"icon_liebang"]];
            
        }
        else if (_indexPath.row == 1)
        {
            _detailTextField.text = accountModel.userName;
        }
        else if (_indexPath.row == 2)
        {
            _detailTextField.text = accountModel.userIndustry;
        }
        else if (_indexPath.row == 3)
        {
            _detailTextField.text = accountModel.userLabel;
            _detailTextField.enabled = NO;
        }
        else if (_indexPath.row == 4)
        {
            _detailTextField.text = accountModel.userWorkAddress;
            _detailTextField.enabled = NO;
        }
        else if (_indexPath.row == 5)
        {
            _detailTextField.text = accountModel.userDetailAddress;
        }
        
        if (_indexPath.row != 3 && _indexPath.row != 4) {
            _detailTextField.frame = CGRectMake(kCurrentWidth(95), 0, kDeviceWidth-kCurrentWidth(108), kCurrentWidth(44));
        }
    }
    else
    {
        if (_indexPath.row == 0 && accountModel.phone)
        {
            _detailTextField.text = accountModel.phone;
            _detailTextField.userInteractionEnabled = NO;
        }
        else if (_indexPath.row == 1)
        {
            _detailTextField.text = accountModel.userEmail;
        }
        else if (_indexPath.row == 2)
        {
            _detailTextField.text = accountModel.weChatId;
        }
        else if (_indexPath.row == 3)
        {
            _detailTextField.text = accountModel.userCardId;
        }
        _detailTextField.frame = CGRectMake(kCurrentWidth(95), 0, kDeviceWidth-kCurrentWidth(108), kCurrentWidth(44));

    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    NSString *selectGameText = @"*";
    NSString *allSelectGameText = [[[LBForProject currentProject].editCellTitleArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectGameText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithHexString:@"FB3F3F"]
                 range:[allSelectGameText rangeOfString:selectGameText]];
    _titleLabel.attributedText = attr;
    
    _detailTextField.tag = (indexPath.section)*10+indexPath.row+10;
    _detailTextField.delegate = self;
//    _titleLabel.text = [[[LBForProject currentProject].editCellTitleArray safeObjectAtIndex:indexPath.section] safeObjectAtIndex:indexPath.row];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            self.editAccountCellState = EditAccountCellImage;

        }
        else if (indexPath.row == 1)
        {
            self.editAccountCellState = EditAccountCellNormel;
        }
        else
        {
            self.editAccountCellState = EditAccountCellAccessory;
        }
    }
    else
    {
        self.editAccountCellState = EditAccountCellAccessory;
    }
}

- (void)setEditAccountCellState:(EditAccountCellState)editAccountCellState {
    _editAccountCellState = editAccountCellState;
    
    if (editAccountCellState == EditAccountCellNormel)
    {
        _detailTextField.textColor = kLBNineColor;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _LOGO.hidden = YES;
        _detailTextField.hidden = NO;
        _detailTextField.enabled = YES;
        _titleLabel.frame = CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(100), kCurrentWidth(44));
    }
    else if (editAccountCellState == EditAccountCellAccessory)
    {
        _detailTextField.textColor = kLBNineColor;
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _LOGO.hidden = YES;
        _detailTextField.hidden = NO;
        _detailTextField.enabled = YES;
        _titleLabel.frame = CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(100), kCurrentWidth(44));
    }
    else if (editAccountCellState == EditAccountCellImage)
    {
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        _LOGO.hidden = NO;
        _detailTextField.hidden = YES;
        _titleLabel.frame = CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(100), kCurrentWidth(75));
    }
}

- (void)createSubViews {
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(80), kCurrentWidth(44))];
    _titleLabel.textColor = kLBBlackColor;
    _titleLabel.font = kSystem(15);
    [self.contentView addSubview:_titleLabel];

    _detailTextField = [[UITextField alloc] initWithFrame:CGRectMake(kCurrentWidth(95), 0, kDeviceWidth-kCurrentWidth(123), kCurrentWidth(44))];
    _detailTextField.textColor = kLBNineColor;
    _detailTextField.font = kSystem(14);
    _detailTextField.textAlignment = NSTextAlignmentRight;
    _detailTextField.hidden = YES;
    _detailTextField.delegate = self;
    [_detailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_detailTextField];
    
    _LOGO = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-kCurrentWidth(53-15), kCurrentWidth(15), kCurrentWidth(40), kCurrentWidth(40))];
    _LOGO.image = [UIImage imageNamed:@"icon_liebang"];
    _LOGO.layer.cornerRadius = kCurrentWidth(20);
    _LOGO.layer.masksToBounds = YES;
    [_LOGO setContentScaleFactor:[[UIScreen mainScreen]scale]];
    _LOGO.contentMode = UIViewContentModeScaleAspectFill;
    _LOGO.autoresizingMask = UIViewAutoresizingNone;
    _LOGO.hidden = YES;
    [self.contentView addSubview:_LOGO];\
    
    _rowImage = UIImageView.new;
    _rowImage.image = IMAGE_NAMED(@"list_btn_enter");
    [self.contentView addSubview:_rowImage];
    [_rowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kCurrentWidth(-15));
        make.width.mas_equalTo(kCurrentWidth(6));
        make.height.mas_equalTo(kCurrentWidth(10));
        make.centerY.mas_equalTo(self.contentView);
    }];

}

- (void)textFieldDidChange:(UITextField *)textField
{
    int max_name = 0;
    if(textField.tag == 23)
    {
        max_name = 18;
    }
    else if (textField.tag == 20)
    {
        max_name = 11;
    }
    else if (textField.tag == 11)
    {
        max_name = 10;
    }
    else if (textField.tag == 15)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"headViewHeight" object:nil userInfo:@{@"address":self.detailTextField.text}];
        max_name = 30;
    }
    else if (textField.tag == 12)
    {//行业最多10位
        max_name = 10;
    }else if (textField.tag == 2)
    {//公司名称最多15位
        if ([self.titleLabel.text isEqualToString:@"学校"]) {
            max_name = 10;
        }else{
            max_name = 15;
        }
    }else if (textField.tag == 3)
    {//职位最多8位
        if ([self.titleLabel.text isEqualToString:@"专业"]) {
            max_name = 10;
        }else{
            max_name = 8;
        }
        
    }else if (textField.tag == 21)
    {//邮箱号最多25位
        max_name = 25;
    }else if (textField.tag == 22)
    {//微信号最多20位
        max_name = 20;
    }else if (textField.tag == 13)
    {//预约时间地点最多50
        max_name = 50;
    }else{
        max_name = 30;
    }


    NSString *toBeString = textField.text;// [Util trim:textField.text];

    NSLog(@"- --------- --%@",toBeString);
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];

    if ([current.primaryLanguage isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > max_name) {
                textField.text = [toBeString substringToIndex:max_name];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{

        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{

        if (toBeString.length > max_name) {
            //            NSLog(@"- change to --%@",textField.text);

            textField.text = [toBeString substringToIndex:max_name];
        }
    }
    //    _oldInputStr = textField.text;
    NSLog(@"- change to --%@",textField.text);
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (_editMessageBlock) {
        _editMessageBlock(textField.tag,IsStrEmpty(textField.text)?nil:textField.text);
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSLog(@"%@",string);

//    int max_name = 0;
//    if(textField.tag == 23)
//    {
//        max_name = 18;
//    }
//    else if (textField.tag == 20)
//    {
//        max_name = 11;
//    }
//    else if (textField.tag == 11)
//    {
//        max_name = 10;
//    }
//    else if (textField.tag == 15)
//    {
//        max_name = 30;
//    }
//    else
//    {
//        max_name = 15;
//    }
    
    
//    if ([string isEqualToString:@" "]) {
//        return NO;
//    }
//    if(textField.tag == 23)
//    {
//        if (textField.text.length >= 18 && ![string isEqualToString:@""]) { //添加这半行代码
//            return NO;
//        }
//        return YES;
//    }
//    else
        if (textField.tag == 20)
    {
        if ([string isEqualToString:@""]) {
            return YES;
        }
//        if (textField.text.length >= 11) {
//            return NO;
//        }

        NSString *validRegEx =@"^[0-9]$";
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        if (myStringMatchesRegEx) {
            return YES;
        }
        return NO;
    }
    
//    else
//    {
//
//        //不支持系统表情的输入
//        if ([[textField textInputMode] primaryLanguage]==nil||[[[textField textInputMode] primaryLanguage]isEqualToString:@"emoji"]) {
//            return NO;
//        }
//        UITextRange *selectedRange = [textField markedTextRange];
//        //获取高亮部分
//        UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
//        //获取高亮部分内容
//        //NSString * selectedtext = [textView textInRange:selectedRange];
//        //如果有高亮且当前字数开始位置小于最大限制时允许输入
//        if (selectedRange && pos) {
//            NSInteger startOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.start];
//            NSInteger endOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.end];
//            NSRange offsetRange =NSMakeRange(startOffset, endOffset - startOffset);
//            if (offsetRange.location <max_name) {
//                return YES;
//            }else{
//                return NO;
//            }
//        }
//        NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        NSInteger caninputlen =max_name - comcatstr.length;
//        if (caninputlen >=0){
//            return YES;
//        }else{
//            NSInteger len = string.length + caninputlen;
//            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
//            NSRange rg = {0,MAX(len,0)};
//            if (rg.length >0){
//                NSString *s =@"";
//                //判断是否只普通的字符或asc码(对于中文和表情返回NO)
//                BOOL asc = [string canBeConvertedToEncoding:NSASCIIStringEncoding];
//                if (asc) {
//                    s = [string substringWithRange:rg];//因为是ascii码直接取就可以了不会错
//                }else{
//                    __block NSInteger idx =0;
//                    __block NSString  *trimString =@"";//截取出的字串
//                    //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
//                    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
//                                             options:NSStringEnumerationByComposedCharacterSequences
//                                          usingBlock: ^(NSString* substring,NSRange substringRange,NSRange enclosingRange,BOOL* stop) {
//                                              if (idx >= rg.length) {
//                                                  *stop =YES;//取出所需要就break，提高效率
//                                                  return ;
//                                              }
//                                              trimString = [trimString stringByAppendingString:substring];
//                                              idx++;
//                                          }];
//                    s = trimString;
//                }
//                //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
//                [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
//                //既然是超出部分截取了，哪一定是最大限制了。
//            }
//            return NO;
//        }
//    }
    
//    else if (textField.tag == 11)
//    {
//        if (textField.text.length >=6 && ![string isEqualToString:@""]) { //添加这半行代码
//            return NO;
//        }
//        return YES;
//    }
//    else
//    {
//        if (textField.text.length >= 15 && ![string isEqualToString:@""]) { //添加这半行代码
//            return NO;
//        }
//    }
    return YES;
}

- (void)setImage:(UIImage *)image {
    
    if (!IsNilOrNull(image)) {
        _image = image;
        
        _LOGO.image = image;
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
