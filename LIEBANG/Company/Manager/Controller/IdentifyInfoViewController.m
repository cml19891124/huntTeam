//
//  IdentifyInfoViewController.m
//  LIEBANG
//
//  Created by caominglei on 2019/10/12.
//  Copyright © 2019  YIQI. All rights reserved.
//

#import "IdentifyInfoViewController.h"

#import "IQTextView.h"

#import "IQKeyboardManager.h"

@interface IdentifyInfoViewController ()<HXCustomCameraViewControllerDelegate,HXAlbumListViewControllerDelegate,HXDatePhotoEditViewControllerDelegate,UITextViewDelegate,HXPhotoViewDelegate>

@property (strong, nonatomic) HXPhotoView *picView;

@property (strong, nonatomic) UIImageView *picImage;

@property (strong, nonatomic) UIButton *deleteButton;

@property (strong, nonatomic) UIView *linv;

@property (strong, nonatomic) NSMutableArray *photoArray;

@property (strong, nonatomic) HXPhotoManager *manager;

@property (strong, nonatomic) NSMutableArray *uploadArray;
/**
 获取到的图片
 */
@property (nonatomic, strong) UIImage *photo;

@property (nonatomic,strong)IQTextView *contentTv;

@property (strong, nonatomic) NSMutableArray *companyInfoArray;
@property (strong, nonatomic) NSMutableArray *productServiceArray;
@property (strong, nonatomic) NSMutableArray *recruitArray;

@end

@implementation IdentifyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
    [self setRightNaviBtnTitle:@"保存"];
    self.photoArray = [NSMutableArray array];
    self.uploadArray = [NSMutableArray array];

    self.companyInfoArray = [NSMutableArray array];
    self.productServiceArray = [NSMutableArray array];
    self.recruitArray = [NSMutableArray array];

    [self.photoArray addObjectsFromArray:self.currentArray];

    if (self.type == CompanyInfo) {
        if (self.currentArray.count < 2) {
            [self.photoArray addObject:@"addimg"];
        }
        self.manager.configuration.photoMaxNum = 2;
    }else if (self.type == ProductsInfo) {
        if (self.currentArray.count < 4) {
            [self.photoArray addObject:@"addimg"];
        }
        self.manager.configuration.photoMaxNum = 4;
    }else if (self.type == Employee) {
        if (self.currentArray.count < 1) {
            [self.photoArray addObject:@"addimg"];
        }
        self.manager.configuration.photoMaxNum = 1;
    }


    [self.rightNaviBtn addTarget:self action:@selector(rightNaviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self setupSubviews];
    [self setupSubviewsMasonry];

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

- (void)rightNaviBtnClick
{
    if (self.contentTv.text.length == 0) {
        if (self.type == CompanyInfo) {
        [self showAlertWithString:@"请输入公司信息"];
            return;
        }else if (self.type == ProductsInfo) {
        [self showAlertWithString:@"请输入产品服务信息"];
            return;
        }else if (self.type == Employee) {
        [self showAlertWithString:@"请输入招聘信息"];
            return;
        }
    }

    if (self.type == CompanyInfo) {
        [LBForProject currentProject].companyInfo = self.contentTv.text;

        [self.companyInfoArray removeAllObjects];
        for (int i = 0; i < self.photoArray.count; i++) {
            id imagestr = self.photoArray[i];
            if ([imagestr isKindOfClass:UIImage.class]) {
                [self.companyInfoArray addObject:self.photoArray[i]];
            }
        }
        if (self.infoBlock) {
            self.infoBlock(self.companyInfoArray,self.contentTv.text);
        }
    }else if (self.type == ProductsInfo){
        [LBForProject currentProject].productInfo = self.contentTv.text;

        [self.productServiceArray removeAllObjects];
        for (int i = 0; i < self.photoArray.count; i++) {
            id imagestr = self.photoArray[i];
            if ([imagestr isKindOfClass:UIImage.class]) {
                [self.productServiceArray addObject:self.photoArray[i]];
            }
        }
        if (self.infoBlock) {
            self.infoBlock(self.productServiceArray,self.contentTv.text);
        }
    }else if (self.type == Employee){
        [LBForProject currentProject].employeeInfo = self.contentTv.text;

        [self.recruitArray removeAllObjects];
        for (int i = 0; i < self.photoArray.count; i++) {
            id imagestr = self.photoArray[i];
            if ([imagestr isKindOfClass:UIImage.class]) {
                [self.recruitArray addObject:self.photoArray[i]];
            }
        }
        if (self.infoBlock) {
            self.infoBlock(self.recruitArray,self.contentTv.text);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupSubviews
{
    _picView = HXPhotoView.new;
    _picView.backgroundColor = UIColor.whiteColor;
    _picView.lineCount = 4;
//    _picView.previewStyle = HXPhotoViewPreViewShowStyleDark;
    _picView.outerCamera = YES;
    _picView.delegate = self;
    [self.view addSubview:_picView];
    
    _linv = UIView.new;
    _linv.backgroundColor = UIColor.groupTableViewBackgroundColor;

    [self.view addSubview:_linv];

    self.contentTv = [[IQTextView alloc] init];
    if (self.type == CompanyInfo) {
        self.contentTv.placeholder = @"公司简介（最多2000字）";
        if (self.currentInfo) {
            self.contentTv.text = self.currentInfo;
        }
    }else if (self.type == ProductsInfo) {
        self.contentTv.placeholder = @"产品服务（最多2000字）";
        if (self.currentInfo) {
            self.contentTv.text = self.currentInfo;
        }
    }else if (self.type == Employee) {
        self.contentTv.placeholder = @"招聘（最多2000字）";
        if (self.currentInfo) {
            self.contentTv.text = self.currentInfo;
        }
    }
        self.contentTv.placeholderTextColor = kLBNineColor;
        self.contentTv.textColor = kLBBlackColor;
        self.contentTv.font = kSystem(13);
        self.contentTv.delegate = self;
        [self.view addSubview:self.contentTv];
}

- (void)setupSubviewsMasonry
{
    CGFloat btnw = (kDeviceWidth - 5 * 2 - 16 * 2)/3;

    [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo((self.photoArray.count <= 3?(btnw + 5):(btnw + 5) * 2));
    }];
    
    [self setUpUploadButton];
    
    [_linv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.picView.mas_bottom).offset(20);
        make.height.mas_equalTo(1);
    }];
    
    [_contentTv mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.mas_equalTo(16);
               make.right.mas_equalTo(-16);
               make.bottom.mas_equalTo(-50);
               make.top.mas_equalTo(self.linv.mas_bottom).offset(20);
           }];
}

#pragma mark - 删除图片
- (void)deletePhotoView:(UIButton *)button
{
    [self.photoArray removeObjectAtIndex:button.tag - 180];

    for (int i = 0; i < self.photoArray.count; i++) {

        if (![self.photoArray containsObject:@"addimg"]) {
            [self.photoArray addObject:@"addimg"];
        }
    }
    CGFloat btnw = (kDeviceWidth - 5 * 2 - 16 * 2)/3;

    [self.picView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo((self.photoArray.count <= 3?(btnw + 5):(btnw + 5) * 2));
    }];
    [self.picView layoutIfNeeded];
    [self setUpUploadButton];
}

#pragma mark - 创建照片按钮
- (void)setUpUploadButton
{
    [self.picView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.photoArray.count; i++) {
        
        CGFloat col = i%3;
        CGFloat row = i/3;

        UIButton *btn = [UIButton new];
        UIButton *delebtn = [UIButton new];
        [delebtn setBackgroundImage:IMAGE_NAMED(@"clear_normal") forState:UIControlStateNormal];
        delebtn.tag = 180 + i;
        delebtn.hidden = NO;
        [delebtn addTarget:self action:@selector(deletePhotoView:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.photoArray[i] isKindOfClass:UIImage.class]) {
            [btn setBackgroundImage:self.photoArray[i] forState:UIControlStateNormal];
        }else if ([self.photoArray[i] isKindOfClass:NSString.class]){
            
            [btn setImage:IMAGE_NAMED(self.photoArray[i]) forState:UIControlStateNormal];
        }

        btn.backgroundColor = UIColor.whiteColor;
        btn.layer.cornerRadius = 2.f;
        btn.layer.masksToBounds = YES;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.tag = 150 + i;
        [btn addTarget:self action:@selector(showImageSelectController) forControlEvents:UIControlEventTouchUpInside];
        [self.picView addSubview:btn];
        
        CGFloat btnw = (kDeviceWidth - 5 * 2 - 16 * 2)/3;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((btnw + 5)*col);
            make.top.mas_equalTo( 5+ (btnw + 5)*row);
            make.width.height.mas_equalTo(btnw);
        }];
        
        if (i == 0) {
            UILabel *label = UILabel.new;
            label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
            label.text = @"主图";
            label.textColor = kWhiteColor;
            label.font = kSystem(11);
            label.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:label];

            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.mas_equalTo(0);
                make.height.mas_equalTo(20);
            }];
            
            if (i == self.photoArray.count - 1) {
                label.hidden = YES;
            }else{
                label.hidden = NO;
            }
        }
        
        [self.picView addSubview:delebtn];
        [self.picView bringSubviewToFront:delebtn];
        
        [delebtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16 + btnw + (btnw + 5)*col-40);
            make.top.mas_equalTo(btn.mas_top).offset(5);
            make.width.height.mas_equalTo(15);
        }];
        
        if (i == self.photoArray.count - 1 && [self.photoArray[i] isKindOfClass:NSString.class]) {
            delebtn.hidden = YES;
        }else{
            delebtn.hidden = NO;
        }
    }
}
#pragma mark - < HXDatePhotoEditViewControllerDelegate >

- (void)customCameraViewController:(HXCustomCameraViewController *)viewController didDone:(HXPhotoModel *)model
{//相机
    
            if (self.type == CompanyInfo) {
                [self.photoArray insertObject:model.thumbPhoto atIndex:0];

                for ( int i = 0; i < _photoArray.count; i++) {
                    id imageS = _photoArray[i];
//                    if ([imageS isKindOfClass:NSString.class]) {
//                        [_photoArray removeObjectAtIndex:i];
//                    }
                    
                    if (i >= 2) {
                        [_photoArray removeObjectAtIndex:i];

                    }
                }

            }else if (self.type == ProductsInfo) {
                [self.photoArray insertObject:model.thumbPhoto atIndex:0];

                for ( int i = 0; i < _photoArray.count; i++) {
                    id imageS = _photoArray[i];
                    if ([imageS isKindOfClass:NSString.class]) {
//                        [_photoArray removeObjectAtIndex:i];
                    }
                    
                    if (i >= 4) {
                        [_photoArray removeObjectAtIndex:i];

                    }
                }
                
            }else if (self.type == Employee) {
                [self.photoArray insertObject:model.thumbPhoto atIndex:0];

                for ( int i = 0; i < _photoArray.count; i++) {
                    id imageS = _photoArray[i];
                    if ([imageS isKindOfClass:NSString.class]) {
//                        [_photoArray removeObjectAtIndex:i];
                    }
                    
                    if (i >= 1) {
                        [_photoArray removeObjectAtIndex:i];

                    }
                }
                
            }
    
    [self.picView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat btnw = (kDeviceWidth - 5 * 2 - 16 * 2)/3;

    if (self.photoArray.count == 4) {//数量达到

        [self.picView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo((self.photoArray.count <= 3?(btnw + 5):(btnw + 5) * 2));
        }];
    }

    [self setUpUploadButton];
    
    [self.view layoutIfNeeded];
    [self.picView layoutIfNeeded];
    _photo = model.previewPhoto;

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)datePhotoEditViewControllerDidClipClick:(HXDatePhotoEditViewController *)datePhotoEditViewController beforeModel:(HXPhotoModel *)beforeModel afterModel:(HXPhotoModel *)afterModel
{

}


#pragma mark - 相册
- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original {
    HXPhotoModel *model = [photoList safeObjectAtIndex:0];

    for (int i = 0; i < photoList.count; i++) {
        HXPhotoModel *model = photoList[i];
        [self.photoArray addObject:model.thumbPhoto];
    }
     
            if (self.type == CompanyInfo) {
                
                for ( int i = 0; i < _photoArray.count; i++) {
                    id imageS = _photoArray[i];
                    if ([imageS isKindOfClass:NSString.class]) {
                        [_photoArray removeObjectAtIndex:i];
                    }
                    
                    if (i >= 2) {
                        [_photoArray removeObjectAtIndex:i];

                    }
                }

            }else if (self.type == ProductsInfo) {
                for ( int i = 0; i < _photoArray.count; i++) {
                    id imageS = _photoArray[i];
                    if ([imageS isKindOfClass:NSString.class]) {
                        [_photoArray removeObjectAtIndex:i];
                    }
                    
                    if (i >= 4) {
                        [_photoArray removeObjectAtIndex:i];

                    }
                }
                
            }else if (self.type == Employee) {
                for ( int i = 0; i < _photoArray.count; i++) {
                    id imageS = _photoArray[i];
                    if ([imageS isKindOfClass:NSString.class]) {
                        [_photoArray removeObjectAtIndex:i];
                    }
                    
                    if (i >= 1) {
                        [_photoArray removeObjectAtIndex:1];

                    }
                }
                
            }
    
    [self.picView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.photoArray.count >= 4) {//数量达到

        CGFloat btnw = (kDeviceWidth - 5 * 2 - 16 * 2)/3;

        [self.picView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo((self.photoArray.count <= 3?(btnw + 5):(btnw + 5) * 2));
        }];
    }

    [self setUpUploadButton];
    
    [self.view layoutIfNeeded];
    [self.picView layoutIfNeeded];
    _photo = model.previewPhoto;

    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - 相册相机访问
- (void)showImageSelectController {
    for (int i = 0; i < self.photoArray.count; i++) {
        if (![self.photoArray containsObject:@"addimg"]) {
            if (self.type == CompanyInfo && self.photoArray.count == 2) {
                [self showAlertWithString:@"最多添加两张"];
                return;
            }
            if(self.type == ProductsInfo  && self.photoArray.count == 4){
                [self showAlertWithString:@"最多添加四张"];
                return;
            }
            if(self.type == Employee && self.photoArray.count == 1){
                [self showAlertWithString:@"最多添加一张"];
                return;
            }
            
        }else{
            if (self.type == CompanyInfo && self.photoArray.count == 3) {
                [self showAlertWithString:@"最多添加两张"];
                return;
            }
            if(self.type == ProductsInfo  && self.photoArray.count == 5){
                [self showAlertWithString:@"最多添加四张"];
                return;
            }
            if(self.type == Employee && self.photoArray.count == 2){
                [self showAlertWithString:@"最多添加一张"];
                return;
            }
            
        }
    }
    UIAlertController *alert = [CHAlertView showSheetMessageWith:nil list:@[@"相机",@"相册"] confim:^(NSString *returnInfo) {
        if ([returnInfo isEqualToString:@"相机"]) {
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                [self showAlertWithString:@"此设备不支持相机!"];
                return;
            }
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在设置-隐私-相机中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                [alert show];
                return;
            }
            
            [self hx_presentCustomCameraViewControllerWithManager:self.manager delegate:self];
        }
        else if ([returnInfo isEqualToString:@"相册"]) {
            [self hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
        }
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showLisencecImageSelectController:(NSInteger)index {
    if (index == 1) {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self showAlertWithString:@"此设备不支持相机!"];
            return;
        }
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在设置-隐私-相机中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
            return;
        }
        
        [self hx_presentCustomCameraViewControllerWithManager:self.manager delegate:self];
    }
    else if (index == 2) {
        [self hx_presentAlbumListViewControllerWithManager:self.manager delegate:self];
    }
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.openCamera = YES;
        _manager.configuration.saveSystemAblum = NO;
        _manager.configuration.themeColor = [UIColor blackColor];
        _manager.configuration.singleSelected = NO;
        
    }
    return _manager;
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
        if (offsetRange.location <2000) {
            return YES;
        }else{
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen =2000 - comcatstr.length;
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
    if (existTextNum >2000){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:2000];
        [textView setText:s];
    }
    //不让显示负数
    //    _numberLabel.text = [NSString stringWithFormat:@"%zd/2000",existTextNum];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
//    if (_editMessageBlock) {
//        _editMessageBlock(textView.tag-30,IsStrEmpty(textView.text)?nil:textView.text);
//    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.contentTv resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.contentTv resignFirstResponder];

}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame
{
    NSSLog(@"%@",NSStringFromCGRect(frame));
}

@end
