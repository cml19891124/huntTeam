#define NUM @"0123456789-"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/:."

#define ALPHAEMAILNUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@_."

#define ALPHAPHONENUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-."

#import "TextFieldCell.h"

@interface TextFieldCell ()<UITextFieldDelegate>

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UITextField *contentTf;
@property (nonatomic,strong)UIButton *iconButton;

@end

@implementation TextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurrentWidth(12), 0, kCurrentWidth(110), kCurrentWidth(44))];
        _titleLabel.font = kSystem(14);
        _titleLabel.textColor = kLBBlackColor;
        [self.contentView addSubview:_titleLabel];
        
        _contentTf = [[UITextField alloc] initWithFrame:CGRectMake(_titleLabel.right, 0, kDeviceWidth-kCurrentWidth(134), kCurrentWidth(44))];
        _contentTf.placeholder = @"提交过后不能修改";
        _contentTf.textColor = kLBBlackColor;
        _contentTf.font = kSystem(13);
        _contentTf.textAlignment = NSTextAlignmentRight;
        _contentTf.delegate = self;
        [_contentTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.contentView addSubview:_contentTf];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    if (!IsNilOrNull(image)) {
        _image = image;
        [NSObject saveObj:image withKey:kSHENFENGZHENGICON];
        [_iconButton setBackgroundImage:image forState:UIControlStateNormal];
    }
}

- (void)setModel:(MechanismModel *)model {
    _model = model;
    
    switch (_indexPath.row) {
        case 0:
        {
            _contentTf.text = model.mechanismName;
//            _contentTf.enabled = IsStrEmpty(model.mechanismName)?YES:NO;
        }
            break;
        case 1:
        {
            _contentTf.text = model.fullName;
//            _contentTf.enabled = IsStrEmpty(model.fullName)?YES:NO;
        }
            break;
        case 2:
        {
            _contentTf.text = model.contactsName;
//            _contentTf.enabled = IsStrEmpty(model.contactsName)?YES:NO;
        }
            break;
        case 3:
        {
            _contentTf.text = model.contactsPosition;
//            _contentTf.enabled = IsStrEmpty(model.contactsPosition)?YES:NO;
        }
            break;
        case 4:
        {
            _contentTf.text = model.contactsPhone;
//            _contentTf.enabled = IsStrEmpty(model.contactsPhone)?YES:NO;
        }
            break;
        case 5:
        {
            _contentTf.text = model.email;
//            _contentTf.enabled = IsStrEmpty(model.email)?YES:NO;
        }
            break;
        case 6:
        {
            _contentTf.text = model.city;
//            _contentTf.enabled = IsStrEmpty(model.city)?YES:NO;
        }
            break;
        case 7:
        {
            _contentTf.text = model.region;
//            _contentTf.enabled = IsStrEmpty(model.region)?YES:NO;
        }
            break;
        case 8:
        {
            if (IsNilOrNull(self.image)) {
                [_iconButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.businessLicense] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if (error) {
                        [self.iconButton setBackgroundImage:[UIImage imageNamed:@"icon_yingyezhizhao"] forState:UIControlStateNormal];
                    } else {
                        [NSObject saveObj:image withKey:kSHENFENGZHENGICON];
                    }
                }];
            }
        }
            break;
        default:
            break;
    }

}

- (void)setIndex:(NSIndexPath *)indexPath companyModel:(CompanyModel *)companyModel{
    _indexPath = indexPath;
    
    _contentTf.tag = indexPath.row+1;
    NSString *selectGameText = @"*";
    NSString *allSelectGameText = [[LBForProject currentProject].comCertiCellTitleArray safeObjectAtIndex:indexPath.row];
    if (!IsStrEmpty(allSelectGameText) && !IsNilOrNull(allSelectGameText)) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectGameText];
        [attr addAttribute:NSForegroundColorAttributeName
                     value:[UIColor colorWithHexString:@"FB3F3F"]
                     range:[allSelectGameText rangeOfString:selectGameText]];
        _titleLabel.attributedText = attr;
    }
    
    _contentTf.placeholder = [NSString stringWithFormat:@"请输入%@",[[[LBForProject currentProject].comCertiCellTitleArray safeObjectAtIndex:indexPath.row] substringFromIndex:2]];
    self.contentTf.keyboardType = UIKeyboardTypeDefault;
    switch (indexPath.row) {
        case 1:
            self.contentTf.text = companyModel.companyAbbreviation;
            break;
        case 2:
            self.contentTf.text = companyModel.fullName;
            break;
        case 3:
            self.contentTf.text = companyModel.financingStatus;
            break;
        case 4:
        {
            self.contentTf.keyboardType = UIKeyboardTypeNumberPad;
            self.contentTf.text = companyModel.personnelScale;
        }
            break;
        case 5:
            self.contentTf.text = companyModel.industry;
            break;
        case 6:
            self.contentTf.text = companyModel.officialWebsite;
            //适用于网址输入
            self.contentTf.keyboardType = UIKeyboardTypeEmailAddress;
//            [self.contentTf setInputAccessoryView:UIView.new];
            break;
        case 7:
            self.contentTf.text = companyModel.email;
            //邮箱键盘
            self.contentTf.keyboardType = UIKeyboardTypeEmailAddress;
            
            break;
        case 8:
            //邮箱键盘的形式，代码限制输入格式
            self.contentTf.keyboardType = UIKeyboardTypeEmailAddress;
            self.contentTf.text = companyModel.companyPelephone;
            
            break;
        case 9:
        {
            self.contentTf.text = companyModel.city;

        }
            break;
        case 10:
            self.contentTf.text = companyModel.region;
            break;
        case 11:
            self.contentTf.text = companyModel.contactsName;
            break;
        case 12:
            self.contentTf.text = companyModel.contactsPosition;
            break;
        case 13:
            self.contentTf.keyboardType = UIKeyboardTypeNumberPad;
            self.contentTf.text = companyModel.contactsPhone;
        break;
        default:
            break;
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    _contentTf.tag = indexPath.row+1;
    NSString *selectGameText = @"*";
    NSString *allSelectGameText = [[LBForProject currentProject].ORCertiCellTitleArray safeObjectAtIndex:indexPath.row];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allSelectGameText];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithHexString:@"FB3F3F"]
                 range:[allSelectGameText rangeOfString:selectGameText]];
    _titleLabel.attributedText = attr;
    
    _contentTf.placeholder = [NSString stringWithFormat:@"请输入%@",[[[LBForProject currentProject].ORCertiCellTitleArray safeObjectAtIndex:indexPath.row] substringFromIndex:2]];
//    _titleLabel.text = [[LBForProject currentProject].ORCertiCellTitleArray safeObjectAtIndex:indexPath.row];
    if (indexPath.row == 8)
    {
        _contentTf.hidden = YES;
        _iconButton.hidden = NO;
    }
    else
    {
        _contentTf.hidden = NO;
        _iconButton.hidden = YES;
    }
}

#pragma mark Event
- (void)iconButtonClick {
    if (_editSourceBlock) {
        _editSourceBlock();
    }
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
    
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    if (textField.tag == 5 || textField.tag == 10)
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
//        if (textField.text.length >= 20 && ![string isEqualToString:@""]) { //添加这半行代码
//            return NO;
//        }
//    }
    if (textField.tag == 7) {//官网输入
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else if (textField.tag == 8) {//邮箱输入
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHAEMAILNUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else if (textField.tag == 9) {//公司电话输入
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    int max_name = 0;
    if (textField.tag == 2 || textField.tag == 4 || textField.tag == 5)
    {//公司简称|融资|人员规模|行业
        max_name = 15;
    }else if (textField.tag == 3)
    {//公司全称
        max_name = 18;
    }else if (textField.tag == 6) {
        //公司全称
        max_name = 10;
    }
    else if (textField.tag == 7 || textField.tag == 8)
    {//官网、邮箱
        max_name = 25;
    }
    else if (textField.tag == 14)
    {//手机号
        max_name = 11;
    }else if (textField.tag == 13 || textField.tag == 12)
    {//职位\姓名
        max_name = 10;
    }
    else if (textField.tag == 11)
    {//地址30
        max_name = 30;
    }else
    {// 含 公司电话
        max_name = 20;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
