

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 实现了输入时常用的基本交互逻辑，含有输入框（UITextField, UITextView）的 Controller 应继承该类。
 */
@interface SDBaseTextInputController : CommonViewController <UITextFieldDelegate, UITextViewDelegate>

@end

NS_ASSUME_NONNULL_END
